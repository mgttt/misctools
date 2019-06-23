# 分布式数据库

最重要两点：

* 数据唯一性。目前用 duid 算法解决（见下方章节）
* 数据同步策略

# 数据同步策略

* 简单操作是使用 mysqldump 管道 mysql 结合 lmt 来对数据进行 UPSERT操作 （基于 duid然后 lmt大者胜）
在弱一致性需求下，非常可靠，而且并不需要依赖于 binlog来执行。（binlog式的同步，其实在出事之后的恢复真是天价成本，建议只用于主丛，不要用于“主主”）。所以结论就是多主多丛下，多主间用增量同步，主丛间用binlog同步
* 高端操作是数据库内置scheduler触发驱动，把远端表映射为 Federated引擎并进行增量同步【还没试验成功】，好处是不需要外部脚本触发。
* 后续对【强一致性】的思路，考虑配合ndb引擎表进行强一致性思考，不过ndb引擎走一圈速度确实慢，目前可能只能用于“对表”；

# duid algo

innodb table for uniq-seq on one server

* BIGINT is an eight-byte signed integer. 2^64 能覆盖 10^20；
* 长度 = datetime数字 (12位YYMMDDHHMMSS） + server_id(2位） + 秒内时序（5位）= 19 位；
* 分库或许会有时针回拔问题，观察；（后续可用ndb表进行【对表】）

```
DROP TABLE IF EXISTS g_tick2;
CREATE TABLE `g_tick2` (
  `id` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'stub',
	`ts` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'yymmddhhiiss time',
	`seq` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

drop FUNCTION IF EXISTS getDUID;
DELIMITER $$
CREATE FUNCTION getDUID()
RETURNS bigint(20)
DETERMINISTIC
BEGIN
DECLARE rt_ts bigint;
DECLARE rt_seq int;
SET @rt_ts := 0+date_format(now(),'%y%m%d%H%i%s');
INSERT INTO g_tick2(id,ts,seq) VALUES(1,@rt_ts,1) ON DUPLICATE KEY UPDATE seq = @rt_seq := IF(ts<>@rt_ts,1,seq+1), ts = @rt_ts;
RETURN concat(@rt_ts,LPAD(@@server_id,2,'0'),LPAD(@rt_seq,5,'0'));
END$$
DELIMITER ;
select getDUID();select getDUID();select getDUID();select getDUID();select getDUID();select getDUID();select getDUID();

```

## 例子

```
CREATE TABLE `uch_user` (
  `duid` bigint(20) NOT NULL DEFAULT '0',
  `user_login` varchar(40) NOT NULL,
  `user_pin` varchar(40) DEFAULT NULL,
  `user_pass` varchar(40) DEFAULT NULL,
  `lmt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`duid`),
  KEY `idx_lmt` (`lmt`),
  KEY `idx_login` (`user_login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;

DELIMITER $$
CREATE TRIGGER before_user_insert
BEFORE INSERT ON uch_user
FOR EACH ROW 
BEGIN
IF NEW.duid IS NULL OR NEW.duid=0 THEN
SET NEW.duid=getDUID();
END IF;
END$$
DELIMITER ;
```

## old codes for DUID()


```
--drop table g_tick;
CREATE TABLE `g_tick` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `stub` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=InnoDB;

--drop FUNCTION IF EXISTS g_seq;
DELIMITER $$
CREATE FUNCTION g_seq()
RETURNS bigint
DETERMINISTIC
BEGIN
REPLACE INTO g_tick(stub) VALUES(1);RETURN last_insert_id();
END$$
DELIMITER ;

--drop FUNCTION IF EXISTS getDUID;
DELIMITER $$
CREATE FUNCTION getDUID()
RETURNS bigint(20)
DETERMINISTIC
RETURN concat(0+now(),(@@server_id)*10000+(g_seq()%10000));
$$
DELIMITER ;
select getDUID();


select getDUID();
```

```
DELIMITER $$
CREATE FUNCTION getDUID()
RETURNS bigint
DETERMINISTIC
BEGIN
RETURN concat(unix_timestamp(),(10+@@server_id)*10000+(getDSEQ('DUID')%10000));
END$$
DELIMITER ;

```

```
CREATE TABLE `t_dseq`
( `seq_name` varchar(64) NOT NULL ,
	`value` bigint NOT NULL DEFAULT 0,
	PRIMARY KEY (`seq_name`) )
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

//可能并发还有问题，应该用乐观锁重试算法：

```
DELIMITER $$
CREATE FUNCTION getDSEQ(sequence_name VARCHAR(64))
RETURNS bigint
DETERMINISTIC
BEGIN
DECLARE current_val bigint;
INSERT INTO t_dseq (seq_name,value)
SELECT sequence_name, @current_val:=IFNULL((SELECT value FROM t_dseq WHERE seq_name=sequence_name),0)+1 value
ON DUPLICATE KEY UPDATE value=VALUES(value);
RETURN @current_val;
END$$
DELIMITER ;
```

```
DELIMITER $$
CREATE FUNCTION getDUID()
RETURNS bigint
DETERMINISTIC
BEGIN
RETURN concat(unix_timestamp(),(10+@@server_id)*10000+(g_seq()%10000));
END$$
DELIMITER ;
```

# mysqldump 管道 mysql的例子

```
while true; do

$SVRT_SOFT/usr/bin/mysqldump -u $USERNAME --password=$PASSWORD -h $HOSTNAME -P 9395 --skip-add-locks --no-create-info --replace --skip-triggers --compact --replace --databases $DBNAME --tables $TABLENAME --where=" lmt>='`$SVRT_SOFT/usr/bin/mysql -u USERNAME --password=PASSWORD -h $TGTHOSTNAME -P 9395 $DBNAME -e "SELECT (max(lmt)) mx FROM $TABLENAME" --column-names=0 -B`'" | $SVRT_SOFT/usr/bin/mysql -u altersuper --password=PASSWORD -h $TGTHOSTNAME -P 9395 $DBNAME -vvv

sleep 1
done
```
