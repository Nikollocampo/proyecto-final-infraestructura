
# Análisis de Necesidades y Diseño - Hospital San Juan de Dios de Armenia

## 1. Contexto de la Organización

El Hospital San Juan de Dios de Armenia es una institución prestadora de servicios de salud que maneja información crítica de pacientes, historias clínicas y procesos administrativos. Para garantizar la operación eficiente y segura, requiere una infraestructura de TI centralizada que permita a sus equipos (médicos, laboratorio, enfermería y administración) trabajar de forma sincronizada y compartir recursos.

Como equipo de infraestructura TI, se propone el diseño e implementación de un ecosistema de servicios centralizados alojados en un servidor Linux (Ubuntu Server). Para cubrir todas las necesidades operativas del hospital, la solución integral incluye la plataforma PaaS (Dokploy) con el servicio Web, el servicio de autenticación centralizada (NIS), la compartición de archivos para Linux (NFS) y para Windows/Mac (Samba), la gestión de bases de datos, el servicio de sincronización de tiempo (NTP), el servidor de impresión centralizada (CUPS) y los servicios de infraestructura base.

---

## 2. Justificación de los Servicios Implementados

### A. Servicio NTP
*   **Necesidad:** En el sector salud, el registro exacto de la hora es vital. Las historias clínicas, la administración de medicamentos, los resultados de laboratorio y los logs de auditoría deben estar perfectamente sincronizados.
*   **Justificación:** Implementar un servidor NTP local garantiza que todos los equipos del hospital (computadores de escritorio, servidores y equipos médicos) tengan la misma hora exacta, incluso si la conexión a internet falla. Esto evita errores en los registros cronológicos y cumple con las normativas de trazabilidad en salud.

### B. Servicio CUPS
*   **Necesidad:** El hospital maneja una gran cantidad de documentación física diaria (fórmulas médicas, resultados de exámenes, facturación, admisiones).
*   **Justificación:** Centralizar la impresión mediante CUPS permite que cualquier equipo autorizado en la red del hospital pueda enviar documentos a una cola de impresión compartida. Esto reduce costos (al no necesitar una impresora por cada computador), facilita el mantenimiento y permite a los administradores gestionar los trabajos de impresión de forma remota a través de una interfaz web segura.

### C. Servicio NIS
*   **Necesidad:** El hospital cuenta con diferentes equipos utilizados por médicos, personal de enfermería, laboratorio y administración. Administrar las cuentas de usuario individualmente en cada equipo dificulta el control de acceso y aumenta el trabajo.
*   **Justificación:** Implementar un servidor NIS el cual permite centralizar la administración de usuarios y grupos, facilitando que los equipos consulten una base de datos compartida para identificar a los usuarios y validar sus credenciales. De esta manera, se simplifica la gestión de cuentas y se evita tener que crear los mismos usuarios de forma independiente.

### D. Servicio Dokploy
*   **Necesidad:** El hospital requiere una plataforma que facilite el despliegue y la administración de aplicaciones web, así como su comunicación con una base de datos.
*   **Justificación:** Dokploy permite gestionar aplicaciones mediante contenedores Docker desde una interfaz web. Para el proyecto se desplegó una página institucional de demostración desarrollada con Node.js y Express.js, conectada a MySQL. Esto facilita la organización de los servicios, su actualización y la verificación de su funcionamiento.

### E. Servicio NFS
*   **Necesidad:** Las áreas del hospital (urgencias, laboratorio, enfermería y administración) generan documentos que deben consultar varios equipos: turnos, reportes de laboratorio y protocolos clínicos. Guardarlos en cada computador provoca versiones duplicadas y dificulta el control de acceso.
*   **Justificación:** NFS permite que los equipos Linux monten carpetas ubicadas en un servidor central como si fueran locales. Se definió una carpeta de trabajo con lectura y escritura solo para el grupo `personal_hospital` y una carpeta de protocolos de solo lectura, para que el personal consulte la versión oficial sin poder modificarla. Con la opción `root_squash`, ni siquiera el administrador de un equipo cliente puede saltarse estos permisos, algo importante cuando se maneja información sensible.

---

## 3. Tabla de Requisitos de Infraestructura

A continuación, se detallan los parámetros técnicos para los servicios implementados en el servidor Linux:

| Servicio | IP del Servidor | Puerto | Protocolo | Tipo de Servicio | Descripción / Acceso |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **NTP (chrony)** | 192.168.1.9 | 123 | UDP | Sincronización de tiempo | Servidor maestro de hora para la red local. |
| **CUPS** | 192.168.1.9 | 631 | TCP | Servidor de Impresión | Administración web vía `https://192.168.1.9:631` y cola compartida. |
| **NIS (ypserv)** | 192.168.1.18 | 111 y 871 | TCP/UDP | Autenticación centralizada | Servidor maestro NIS para el dominio hospital.local. |
| **Dokploy** | 192.168.13.40 | 3000 | TCP/HTTP | Plataforma de despliegue | Panel de administración en `http://192.168.13.40:3000`. |
| **Aplicación web (Express.js)** | 192.168.13.40 | 80 (acceso web), 3000 (interno) | TCP/HTTP | Servidor web | Sitio institucional de demostración en `http://hospital.192.168.13.40.sslip.io`. |
| **MySQL** | 192.168.13.40 | 3306 (interno) | TCP | Base de datos | Base de datos `hospital_db`, conectada con la aplicación Express.js. |
| **NFS (nfs-kernel-server)** | 192.168.33.14 | 2049 (y 111 rpcbind) | TCP/UDP | Compartición de archivos Linux | Recursos `compartido` (lectura/escritura) y `protocolos` (solo lectura) para la subred `192.168.33.0/24`. |

---

## 4. Diseño de la Arquitectura

El servidor Linux se despliega en una máquina virtual con Ubuntu Server 24.04 LTS, configurada en modo **Adaptador Puente** para tener visibilidad directa en la red local del hospital (IP 192.168.1.9).

*   El servicio NTP se configura con la directiva `allow` para servir la hora a la subred `192.168.1.0/24`.
*   El servicio CUPS se configura escuchando en `0.0.0.0:631` y con reglas de acceso `Allow 192.168.1.*` para permitir la administración desde los equipos de los funcionarios.
*   El servicio NIS se configura mediante un servidor maestro (ypserv) con el dominio hospital.local, encargado de mantener y distribuir los mapas de usuarios y grupos. Los equipos utilizan ypbind para establecer conexión con el servidor y consultar la información centralizada mediante NSS, mientras que PAM permite realizar la autenticación de usuarios.
*   El servicio Dokploy se implementa en una máquina virtual Ubuntu con IP `192.168.13.40`, utilizando Docker para administrar los servicios `web-hospital` y `db-hospital`. La aplicación Express.js recibe las solicitudes web mediante Traefik y se conecta a MySQL por la red interna de Docker, utilizando variables de entorno para las credenciales. Adicionalmente, se verificó el acceso HTTPS temporal mediante Cloudflare Tunnel.
*   El servicio NFS se configura con `nfs-kernel-server`, exportando `/srv/nfs/hospital/compartido` (lectura/escritura, grupo `personal_hospital`) y `/srv/nfs/hospital/protocolos` (solo lectura) a la subred `192.168.33.0/24` con la opción `root_squash`. Los clientes Linux montan los recursos en `/mnt/hospital/` de forma permanente mediante `/etc/fstab`. Los usuarios utilizan los mismos UID/GID en servidor y clientes, lo que se complementa con la administración centralizada de NIS.
*   *(El diagrama visual de esta arquitectura se encuentra en el archivo `diagrama.mmd`)*.

