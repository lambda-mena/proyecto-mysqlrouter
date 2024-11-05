# Pruebas al MySQLRouter

Se utilizo la herramienta sysbench para realizar pruebas de carga en el enrutador
y las instancias de mysql. El objetivo de estas pruebas fue ver las estadisticas que
arrojaban en cuanto a la latencia frente a una cantidad variable de hilos y queries
tanto de operaciones write como read.

Por otro lado algo que también se realizo fue crear un aplicativo Django que demuestra
cómo en el entorno de una API Rest se puede usar fácilmente este balanceador para aumentar
la velocidad de las aplicaciones desplegadas y la separación de operaciones, permitiendo
el escalamiento horizontal o vertical adecuado dependiendo que tipo de trafico es el que
ocurra más en el sistema.

---

### Prerrequisitos
- Tener un usuario de prueba creado en las instancias y definir sus credenciales en el archivo "environment"
    ```sql
    CREATE USER 'sysbench'@'localhost' IDENTIFIED by '<3|2W1eZbCa+';

    GRANT ALL PRIVILEGES ON *.* TO 'sysbench'@'localhost';

    GRANT ALL PRIVILEGES ON *.* TO 'sysbench'@'localhost' WITH GRANT OPTION;

    CREATE USER 'sysbench'@'%' IDENTIFIED BY '<3|2W1eZbCa+';

    GRANT ALL PRIVILEGES ON *.* TO 'sysbench'@'%' WITH GRANT OPTION;

    ```
    Este es un usuario de prueba que esta en el archivo create_test_usql.sql de esta carpeta, el cual se recomienda usar para las pruebas.
---

## Pruebas sysbench
La primera prueba se baso en crear 3 tablas y añadir 10.000 filas por tabla
con este primer paso crearemos la información necesaria para posteriormente
probar

* Hay que tener en cuenta que se debe crear la base de datos en la instancia antes de llevar a cabo la prueba
```bash
sysbench  \
    --mysql-host=$ENDPOINT_ROUTER \
    --mysql-port=$ENDPOINT_WRITE_PORT \
    --mysql-db=$ENDPOINT_DB \
    --mysql-user=$TEST_USER \
    --mysql-password=$TEST_USER_PASSWORD \
    --tables=3 \
    --table_size=10000 \
    oltp_common prepare
```

Posteriormente podríamos realizar una prueba para la instancia maestra
que lleva las operaciones WRITE, para esto realizaremos el siguiente
comando con la herramienta
```bash
sysbench  \
    --mysql-host=$ENDPOINT_ROUTER \
    --mysql-port=$ENDPOINT_WRITE_PORT \
    --mysql-db=$ENDPOINT_DB \
    --mysql-user=$TEST_USER \
    --mysql-password=$TEST_USER_PASSWORD \
    --tables=3 \
    --table_size=10000 \
    --threads=3 \
    --time=10 \
    oltp_write_only run
```

Ahora para probar las instancias que manejan las operaciones de READ
realizaremos otro comando que sería oltp_read_only
```bash
sysbench  \
    --mysql-host=$ENDPOINT_ROUTER \
    --mysql-port=$ENDPOINT_READ_PORT \
    --mysql-db=$ENDPOINT_DB \
    --mysql-user=$TEST_USER \
    --mysql-password=$TEST_USER_PASSWORD \
    --tables=3 \
    --table_size=10000 \
    --threads=3 \
    --time=10 \
    oltp_read_only run
```
