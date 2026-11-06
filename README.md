# README - Proyecto de Infraestructura TI
## Hospital San Juan de Dios de Armenia

## 1. Descripción del Proyecto

El presente proyecto tiene como finalidad diseñar e implementar una infraestructura de servicios tecnológicos para el Hospital San Juan de Dios de Armenia, utilizando Ubuntu Server 24.04 LTS como sistema operativo principal.

La solución contempla la implementación de servicios centralizados que permitan mejorar la administración de los recursos tecnológicos, facilitar la comunicación entre los equipos de la organización y optimizar los procesos operativos.

## 2. Información del Servidor

El servidor se encuentra desplegado en una máquina virtual con Ubuntu Server 24.04 LTS.

| Parámetro | Descripción |
| :--- | :--- |
| **Sistema Operativo** | Ubuntu Server 24.04 LTS |
| **Entorno** | Máquina Virtual |

## 3. Servicios Implementados

Para atender las necesidades identificadas en el hospital, se implementaron los siguientes servicios:

### A. Servicio NTP 

Permite sincronizar la hora del servidor con fuentes de tiempo externas y autorizar a los equipos de la red local a consultar la hora, contribuyendo a la precisión de los registros y eventos institucionales.

### B. Servicio CUPS

Permite centralizar la administración de impresoras mediante un servidor Linux, facilitando la gestión de los trabajos de impresión y el acceso a una impresora compartida desde la red local.

### C. Servicio NIS

Permite centralizar la administración y autenticación de usuarios de la red, facilitando la consulta de las cuentas de usuario y validando sus credenciales utilizando una base de datos compartida.

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

