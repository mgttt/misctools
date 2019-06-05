innodb table for uniq-seq on one server

* BIGINT is an eight-byte signed integer. 2^64 能覆盖 10^20；
* timestamp (10倍，稍后换 14位YYYYMMDDHHMMSS） + server_id(2位） + 秒内4位时序
* 分库或许会有时针回拔问题，应予观察；

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

## 例子表

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

## old colds for DUID()



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
