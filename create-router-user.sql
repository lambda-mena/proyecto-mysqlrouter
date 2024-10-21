CREATE USER 'router'@'localhost' IDENTIFIED by 'G2fQoeexRpsEFxvc';

GRANT ALL PRIVILEGES ON *.* TO 'router'@'localhost';

GRANT ALL PRIVILEGES ON *.* TO 'router'@'localhost' WITH GRANT OPTION;

CREATE USER 'router'@'%' IDENTIFIED BY 'G2fQoeexRpsEFxvc';

GRANT ALL PRIVILEGES ON *.* TO 'router'@'%' WITH GRANT OPTION;
