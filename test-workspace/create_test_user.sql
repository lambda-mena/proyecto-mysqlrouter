CREATE USER 'sysbench'@'localhost' IDENTIFIED by '<3|2W1eZbCa+';

GRANT ALL PRIVILEGES ON *.* TO 'sysbench'@'localhost';

GRANT ALL PRIVILEGES ON *.* TO 'sysbench'@'localhost' WITH GRANT OPTION;

CREATE USER 'sysbench'@'%' IDENTIFIED BY '<3|2W1eZbCa+';

GRANT ALL PRIVILEGES ON *.* TO 'sysbench'@'%' WITH GRANT OPTION;
