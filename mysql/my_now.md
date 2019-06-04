```
DELIMITER $$
CREATE FUNCTION my_now()
RETURNS datetime
DETERMINISTIC
BEGIN
	RETURN CONVERT_TZ(from_unixtime(unix_timestamp()),'+00:00','+08:00');
END$$
DELIMITER ;
```
