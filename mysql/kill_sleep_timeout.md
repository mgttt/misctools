
```
select @to_kill_proc_list:=GROUP_CONCAT(CONCAT('KILL ',ID) SEPARATOR ';') q FROM information_schema.processlist WHERE Command='Sleep' and Time>5;PREPARE stmt FROM @to_kill_proc_list;EXECUTE stmt;DEALLOCATE PREPARE stmt;
```
