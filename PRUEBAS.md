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
