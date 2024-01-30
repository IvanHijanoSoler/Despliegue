# Despliegue de aplicaciones web

## Iván Hijano Soler

### 2º Trimestre

[x] ***Introduccíon***

Este es un repositorio donde se subiran los distintos scripts para el montaje rapido de un entorno de aplicaciones web en AWS para la asignatura Despliegue de aplicaciónes web de 2º de DAW. Cada script contiene los comandos necesarios para que una sencilla ejecución desde la consola de EC2 o el openshell de Amazon CLI segun el caso permitan el montaje de todos los servicios e infraestructuras necesarias para el funcionamiento de aplicaciones web.

[x] ***script.sh***

Script en bash para su ejecución en un entorno ubuntu que instala y prepara Tomcat para la ejecución de codigo Java en web. No requiere de argumentos y genera usuarios con configuraciones de seguridad adecuadas requeridas para el funcionamiento de Tomcat.

[x] ***main.yml***

Plantilla en formato YAML para ser leida por la consola de AWS, para crear una pila con un grupo de seguridad y una instancia EC2. Cuenta con todos los parametros de configuración fundamental para el uso de esta instancia EC2. No modificar este archivo a menos que se requiera cambiar caracteristicas del grupo de seguridad o de la instancia a generar.

[x] ***stackcreate.sh***

Sintaxis: sudo bash stackcreate <nombrePila>

Usando comandos de AWS CLI, crea una pila con el nombre introducido por argumentos, usando de plantilla main.yml.

[x] ***stackdelete.sh***

Sintaxis: sudo bash stackdelete <nombrePila>

Elimina una pila de nombre <nombrePila> introducido por argumentos usando comandos de AWS CLI
