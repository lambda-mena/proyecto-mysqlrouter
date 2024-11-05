
# Configuración de Replicación Maestro-Esclavo en MySQL


## 1. Prerrequisitos

- **Instancias AWS EC2**: Mínimo dos instancias ejecutando Ubuntu y MySQL .
- **Conexión de Red**: Las instancias deben poder comunicarse entre sí a través de la red. Asegúrandonos de que los grupos de seguridad permitan el tráfico en el puerto 3306 (MySQL).

---

## 2. Configuración del Servidor Maestro

### 2.1. Editar la Configuración de MySQL

Editar el archivo de configuración de MySQL para permitir conexiones remotas y habilitar el registro binario.

```bash
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

Modificar o agregar las siguientes líneas bajo la sección `[mysqld]`:

```ini
[mysqld]
bind-address = 0.0.0.0
server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
```

### 2.2. Crear el Usuario de Replicación

Iniciar sesión en MySQL y crear un usuario para la replicación con los privilegios necesarios.

```bash
mysql -u root -p
```

Dentro de la consola de MySQL:

```sql
CREATE USER 'repl'@'ip-172-31-38-216.ec2.internal' IDENTIFIED WITH mysql_native_password BY 's3rv1c10st3l3m4t1c0s';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'repl'@'ip-172-31-38-216.ec2.internal';

CREATE USER 'repl'@'ip-172-31-37-117-ec2.internal' IDENTIFIED WITH mysql_native_password BY 's3rv1c10st3l3m4t1c0s';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'repl'@'ip-172-31-37-117-ec2.internal';

FLUSH PRIVILEGES;
```

### 2.3. Reiniciar el Servicio MySQL

Después de realizar los cambios, reinicia el servicio MySQL.

```bash
sudo systemctl restart mysql
```

### 2.4. Obtener el Estado del Maestro

Obtener el nombre de archivo y la posición del registro binario, que serán necesarios para configurar los esclavos.

```sql
SHOW MASTER STATUS;
```

---

## 3. Configuración de los Servidores Esclavos

Repite los siguientes pasos en cada servidor esclavo que desees configurar.

### 3.1. Editar la Configuración de MySQL

Editar el archivo de configuración de MySQL en el esclavo.

```bash
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

Agregar o modificar las siguientes líneas:

```ini
[mysqld]
server-id = N -- Numero de Id asignar ala maquina 
relay-log = /var/log/mysql/mysql-relay-bin.log
```

### 3.2. Reiniciar el Servicio MySQL

```bash
sudo systemctl restart mysql
```

### 3.3. Configurar la Replicación en el Esclavo

Conectar al servidor MySQL en el esclavo.

```bash
mysql -u root -p
```

**a. Detener y Resetear la Configuración de Esclavo**

```sql
STOP SLAVE;
RESET SLAVE ALL;
```

**b. Configurar la Conexión al Maestro**

```sql
CHANGE MASTER TO
  MASTER_HOST='172.31.46.96', -- Ip Maestro
  MASTER_USER='repl',
  MASTER_PASSWORD='s3rv1c10st3l3m4t1c0s',
  MASTER_LOG_FILE='mysql-bin.XXXXXX',  -- Reemplaza con el valor de 'File' del maestro
  MASTER_LOG_POS=XXXX;                 -- Reemplaza con el valor de 'Position' del maestro
```

**c. Iniciar la Replicación**

```sql
START SLAVE;
```

**d. Verificar el Estado del Esclavo**

```sql
SHOW SLAVE STATUS\G
```

---

## 4. Verificación de la Replicación

Para confirmar que la replicación funciona correctamente:

1. **Crear una Tabla o Insertar Datos en el Maestro**
2. **Verificar los Datos en el Esclavo**

---

## 5. Creación de usuarios para el router

Para permitir que un cliente de MySQL pueda conectarse mediante el SQL Router crearemos un usuario que logrará conectarse a todas las instancias gracias a la replicación que tienen las instancias esclavo del maestro.

```sql
CREATE USER 'router'@'localhost' IDENTIFIED by 'G2fQoeexRpsEFxvc';

GRANT ALL PRIVILEGES ON *.* TO 'router'@'localhost';

GRANT ALL PRIVILEGES ON *.* TO 'router'@'localhost' WITH GRANT OPTION;

CREATE USER 'router'@'%' IDENTIFIED BY 'G2fQoeexRpsEFxvc';

GRANT ALL PRIVILEGES ON *.* TO 'router'@'%' WITH GRANT OPTION;

```

---
## 7. Referencias

- [Documentación Oficial de MySQL sobre Replicación](https://dev.mysql.com/doc/refman/8.0/en/replication.html)
- [Guía de Replicación de MySQL en Ubuntu](https://help.ubuntu.com/lts/serverguide/mysql-replication.html)
