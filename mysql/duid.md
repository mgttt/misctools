innodb table for uniq-seq on one server

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
RETURN concat(unix_timestamp(),(10+@@server_id)*10000+(getDSEQ('DUID')%10000));
END$$
DELIMITER ;

```
