# Configuración de MySQL Router

- El primer paso para activar mysql router será instalarlo en la maquina virtual para esto, podemos correr el siguiente comando en la maquina ubuntu.
    ```bash
    sudo apt install mysqlrouter
    ```

- Posterior a esto modificaremos el archivo de configuración dejado en esta misma carpeta a nuestras necesidades y lo copiaremos en la ruta ```/etc/mysqlrouter/```
    ```bash
    cp mysqlrouter.conf /etc/mysqlrouter/mysqlrouter.conf
    ```

- Nos aseguraremos de que el servicio de mysqlrouter tiene un ususuario con permisos para manipular sus carpetas en /etc
    ```bash
    sudo useradd -r -s /bin/false mysqlrouter
    ```

    ```bash
    sudo chown -R mysqlrouter /etc/mysqlrouter
    sudo chown -R mysqlrouter /var/log/mysqlrouter
    ```

- Si no tiene posee el mysqlrouter.service en la maquina, creelo.
    ```
    [Unit]
    Description=MySQLRouter Service
    After=network.target
    StartLimitIntervalSec=0
    
    [Service]
    Type=simple
    Restart=always
    RestartSec=1
    User=mysqlrouter
    ExecStart=/usr/bin/mysqlrouter

    [Install]
    WantedBy=multi-user.target
    ```

    Con esto podremos hacer que el servicio se levante al iniciar la maquina y recargarlo cuantas veces necesitemos sin necesidad de depende de un comando con nohup u otras variantes.
