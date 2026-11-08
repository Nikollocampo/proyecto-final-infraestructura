
# README - Proyecto de Infraestructura TI

## Hospital San Juan de Dios de Armenia

## 1. Descripción del Proyecto

El presente proyecto tiene como finalidad diseñar e implementar una infraestructura de servicios tecnológicos para el Hospital San Juan de Dios de Armenia, utilizando Ubuntu Server 24.04 LTS como sistema operativo principal.

La solución contempla la implementación de servicios centralizados que permitan mejorar la administración de los recursos tecnológicos, facilitar la comunicación entre los equipos de la organización y optimizar los procesos operativos.

Además, se implementó una plataforma de despliegue de aplicaciones web mediante Dokploy, permitiendo administrar una aplicación institucional de demostración y su conexión con una base de datos MySQL.

## 2. Información del Servidor

El servidor se encuentra desplegado en una máquina virtual con Ubuntu Server 24.04 LTS.

| Parámetro | Descripción |
| :--- | :--- |
| **Sistema Operativo** | Ubuntu Server 24.04 LTS |
| **Entorno** | Máquina Virtual |
| **Servidor Dokploy** | 192.168.13.40 |
| **Puerto de administración de Dokploy** | 3000 |
| **Tecnologías utilizadas en Dokploy** | Docker, Node.js, Express.js, MySQL y Nixpacks |

## 3. Servicios Implementados

Para atender las necesidades identificadas en el hospital, se implementaron los siguientes servicios:

### A. Servicio NTP

Permite sincronizar la hora del servidor con fuentes de tiempo externas y autorizar a los equipos de la red local a consultar la hora, contribuyendo a la precisión de los registros y eventos institucionales.

### B. Servicio CUPS

Permite centralizar la administración de impresoras mediante un servidor Linux, facilitando la gestión de los trabajos de impresión y el acceso a una impresora compartida desde la red local.

### C. Servicio NIS

Permite centralizar la administración y autenticación de usuarios de la red, facilitando la consulta de las cuentas de usuario y validando sus credenciales utilizando una base de datos compartida.

### D. Servicio Dokploy

Se implementó Dokploy para administrar y desplegar aplicaciones mediante contenedores Docker. Se creó el proyecto `hospital-san-juan-de-dios`, con una página web desarrollada en Node.js y Express.js (`web-hospital`) y una base de datos MySQL (`db-hospital`).

La aplicación se desplegó desde GitHub utilizando Nixpacks y se verificó su funcionamiento mediante `http://hospital.192.168.13.40.sslip.io`. También se comprobó la conexión exitosa con la base de datos `hospital_db` mediante la ruta `/db-test` y se habilitó acceso HTTPS temporal utilizando Cloudflare Tunnel.

### E. Servicio NFS
 
Permite compartir carpetas desde un servidor Linux central con los demás equipos Linux de la red. Se configuró una carpeta de trabajo con lectura y escritura restringida al grupo `personal_hospital` y una carpeta de protocolos institucionales de solo lectura, montadas automáticamente en los clientes.

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
