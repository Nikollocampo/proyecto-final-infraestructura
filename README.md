README - Proyecto de Infraestructura TI

Hospital San Juan de Dios de Armenia

1. Descripción del Proyecto

El presente proyecto tiene como finalidad diseñar e implementar una infraestructura de servicios tecnológicos para el Hospital San Juan de Dios de Armenia, utilizando Ubuntu Server 24.04 LTS como sistema operativo principal.

La solución contempla la implementación de servicios centralizados que permitan mejorar la administración de los recursos tecnológicos, facilitar la comunicación entre los equipos de la organización y optimizar los procesos operativos.

Además, se implementó una plataforma de despliegue de aplicaciones web mediante Dokploy, permitiendo administrar una aplicación institucional de demostración y su conexión con una base de datos MySQL.

2. Información del Servidor

El servidor se encuentra desplegado en una máquina virtual con Ubuntu Server 24.04 LTS.

Parámetro

Descripción

Sistema Operativo

Ubuntu Server 24.04 LTS

Entorno

Máquina Virtual

Servidor Dokploy

192.168.13.40

Puerto de administración de Dokploy

3000

Tecnologías utilizadas en Dokploy

Docker, Node.js, Express.js, MySQL y Nixpacks

3. Servicios Implementados

Para atender las necesidades identificadas en el hospital, se implementaron los siguientes servicios:

A. Servicio NTP

Permite sincronizar la hora del servidor con fuentes de tiempo externas y autorizar a los equipos de la red local a consultar la hora, contribuyendo a la precisión de los registros y eventos institucionales.

B. Servicio CUPS

Permite centralizar la administración de impresoras mediante un servidor Linux, facilitando la gestión de los trabajos de impresión y el acceso a una impresora compartida desde la red local.

C. Servicio NIS

Permite centralizar la administración y autenticación de usuarios de la red, facilitando la consulta de las cuentas de usuario y validando sus credenciales utilizando una base de datos compartida.

D. Servicio Dokploy

Se implementó Dokploy en una máquina virtual Ubuntu para administrar y desplegar aplicaciones mediante contenedores Docker.

Dentro de Dokploy se creó el proyecto hospital-san-juan-de-dios, en el entorno production, con los siguientes servicios:

web-hospital: aplicación web institucional de demostración desarrollada con Node.js y Express.js. Presenta información general del hospital y una sección ilustrativa de sus servicios. Se desplegó utilizando el código almacenado en GitHub y Nixpacks como sistema de construcción.

db-hospital: servicio MySQL que contiene la base de datos hospital_db y permite establecer una conexión desde la aplicación web utilizando variables de entorno.

La aplicación web se encuentra disponible en la red local mediante la dirección:

http://hospital.192.168.13.40.sslip.io

Para comprobar la comunicación entre la aplicación y MySQL, se implementó la ruta:

http://hospital.192.168.13.40.sslip.io/db-test

Esta ruta ejecuta una consulta a la base de datos y devuelve el estado de la conexión, el nombre de la base de datos y la versión de MySQL. Durante las pruebas se obtuvo una conexión exitosa con hospital_db mediante MySQL 8.4.13.

Adicionalmente, se utilizó Cloudflare Tunnel para habilitar temporalmente el acceso HTTPS a la aplicación web. Este acceso depende de que el túnel permanezca activo y no corresponde a un certificado SSL permanente configurado directamente en Dokploy.

## 4. Estructura del Proyecto

El proyecto se encuentra organizado en los siguientes archivos y directorios:

| Archivo o Directorio | Descripción |
| :--- | :--- |
| `analisis.md` | Contiene el análisis de necesidades, la justificación de los servicios y el diseño de la arquitectura. |
| `diagrama.mmd` | Contiene el diagrama visual de la arquitectura de infraestructura. |
| `documentacion.md` | Describe los procedimientos de instalación, configuración y verificación de los servicios. |
| `README.md` | Presenta la información general y la organización del proyecto. |
| `capturas/` | Almacena las evidencias gráficas de la instalación y configuración de los servicios. |
| `codigo/` | Contiene los archivos de configuración utilizados para los servicios implementados. |

