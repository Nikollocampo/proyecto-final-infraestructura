# Documentación Técnica - Implementación de Servicios 

**Proyecto:** Infraestructura de TI - Hospital San Juan de Dios de Armenia  
**Servidor:** Ubuntu Server 24.04 LTS (Máquina Virtual)  


---

## 1. Contexto de la Implementación

Como parte de la infraestructura tecnológica propuesta para el Hospital San Juan de Dios de Armenia, se llevó a cabo la instalación y configuración de los servicios.

Estos servicios se implementaron sobre un servidor Ubuntu Server 24.04 LTS, alojado en una máquina virtual permitiendo la comunicación con otros equipos de la red local.

---

## 2. Implementación y Configuración de los Servicios

### A. Servicio NTP

**Objetivo:** Proporcionar sincronización de tiempo a los equipos de la red del hospital, garantizando la precisión de los registros y eventos del sistema.

#### 2.1. Procedimiento de Instalación

Se instaló el paquete `chrony`, una herramienta utilizada en Ubuntu para la sincronización de tiempo. Primero se actualizaron los repositorios del sistema y posteriormente se ejecutó la instalación:

```bash
sudo apt update
sudo apt install chrony -y
```
![Actualización del sistema](capturas/ntp/01_actualizacion_sistema.png)

#### 2.2. Configuración del Servidor

Para permitir que el servidor no solo sincronice su hora con internet, sino que también pueda atender las solicitudes de los demás equipos del hospital, se editó el archivo de configuración principal:

```bash
sudo nano /etc/chrony/chrony.conf
```
Se agregó la directiva `allow` al final del archivo, autorizando a los dispositivos pertenecientes a la subred local `192.168.1.0/24` a consultar la hora del servidor:

```bash
allow 192.168.1.0/24
```
![Configuración de Chrony](capturas/ntp/02_configuracion_chrony.png)

#### 2.3. Verificación y Pruebas

Después de realizar la configuración, se reinició el servicio para aplicar los cambios y se habilitó su inicio automático con el sistema operativo:

```bash
sudo systemctl restart chrony
sudo systemctl enable chrony
```
![Estado del servicio Chrony](capturas/ntp/03_estado_servicio_chrony.png)

Finalmente, se consultaron las fuentes de sincronización mediante el siguiente comando:

```bash
chronyc sources
```
![Verificación de sincronización](capturas/ntp/04_verificacion_sincronizacion.png)

**Resultado:** El comando mostró un asterisco (`*`) junto a uno de los servidores de tiempo de internet. Este símbolo indica que Chrony seleccionó dicha fuente como referencia de sincronización, confirmando que el servidor logró sincronizar su reloj correctamente.

---

### B. Servicio CUPS 

**Objetivo:** Centralizar la administración de impresoras y permitir que los equipos autorizados de la red del hospital puedan acceder al servicio de impresión.

#### 2.4. Procedimiento de Instalación

Se instaló el servidor de impresión CUPS y se agregó el usuario administrador `nikoll` al grupo `lpadmin`, encargado de gestionar las impresoras y administrar el servicio:

```bash
sudo apt install cups -y
sudo usermod -aG lpadmin $USER
```
![Instalación de CUPS](capturas/cups/01_instalacion_cups.png)

![Permisos del usuario](capturas/cups/02_permisos_usuario.png)

Para aplicar los cambios relacionados con los permisos del grupo, se reinició la máquina virtual.

#### 2.5. Configuración para Acceso Remoto

Se editó el archivo principal de configuración de CUPS para permitir conexiones desde otros equipos de la red local:

```bash
sudo nano /etc/cups/cupsd.conf
```
Se realizaron los siguientes cambios:

1. Se reemplazó `Listen localhost:631` por `Listen 0.0.0.0:631`, permitiendo que el servicio escuche conexiones desde las interfaces de red del servidor.

![Configuración de cupsd](capturas/cups/04_configuracion_cupsd.png)

2. Se agregó la regla `Allow 192.168.1.*` dentro de los bloques `<Location />` y `<Location /admin>`, autorizando el acceso desde los equipos pertenecientes a la red local.

![Configuración de cupsd](capturas/cups/03_configuracion_cupsd.png)

Posteriormente, se reinició el servicio para aplicar la configuración y se habilitó su inicio automático:

```bash
sudo systemctl restart cups
sudo systemctl enable cups
```
![Reinicio del servicio CUPS](capturas/cups/05_reinicio_servicio.png)

#### 2.6. Verificación y Pruebas

Se realizó una prueba de acceso desde un equipo Windows conectado a la red local, ingresando a la interfaz web de administración de CUPS mediante la siguiente dirección:

`https://192.168.1.9:631`

Durante el acceso, el navegador presentó una advertencia de conexión no privada debido al uso de un certificado autofirmado. Se seleccionó la opción **Avanzado** y posteriormente **Continuar** para ingresar a la interfaz.

#### 2.7. Creación de la Impresora Compartida

Desde la interfaz web de CUPS se realizó el procedimiento para agregar una impresora:

1. Se ingresó a la pestaña **Administración** y se seleccionó la opción **Añadir impresora**.
3. Se seleccionó el tipo de conexión **AppSocket/HP JetDirect**, utilizando la dirección `socket://192.168.1.100:9100`.
4. Se asignó el nombre `Impresora_Hospital` y se habilitó la opción **Compartir esta impresora**.
5. Se seleccionó el controlador genérico **Generic PostScript** y se finalizó el proceso de creación.

![Acceso a la interfaz web de CUPS](capturas/cups/06_acceso_web_cups.png)

![Creación de impresora](capturas/cups/07_creacion_impresora.png)

Como resultado, se configuró una impresora denominada `Impresora_Hospital` dentro del servidor CUPS, habilitando su opción de compartición.

![Impresora compartida](capturas/cups/08_impresora_compartida.png)

---

### C. Servicio NIS

**Objetivo:** Centralizar la administración de usuarios y grupos de la red del hospital, permitiendo que diferentes equipos consulten una misma fuente de información para identificar y autenticar a los usuarios.

#### 2.8. Creación y Preparación de las instancias

Se crearon dos instancias de Ubuntu mediante Multipass, utilizando una para funcionar como servidor maestro NIS y otra como cliente.

![Crear el servidor NIS y Cliente NIS](capturas/nis/01.%20Crear%20el%20servidor%20NIS%20y%20Cliente%20NIS.png)

Se identificaron las máquinas virtuales y se verificó que ambas estuvieran en funcionamiento antes de iniciar la configuración del servicio.

![Verificación de ambas instancias](capturas/nis/02.%20Verificaci%C3%B3n%20de%20ambas%20instancias.png)

#### 2.9. Actualización e Instalación de los Paquetes

Primero se actualizaron los repositorios y paquetes del servidor para preparar el entorno de instalación

```bash
sudo apt update
sudo apt upgrade -y
```
![Actualización de Ubuntu para el servidor NIS](capturas/nis/03.%20Actualizaci%C3%B3n%20de%20Ubuntu%20para%20el%20servidor%20NIS.png)

Posteriormente se instalaron los paquetes necesarios para proporcional el servicio NIS

```bash
sudo apt install ypserv yp-tools rpcbind -y
```
![Instalación de los paquetes necesarios](capturas/nis/04.%20Instalaci%C3%B3n%20de%20los%20paquetes%20necesarios.png)

#### 2.10. Definición del Dominio NIS

Se estableció el dominio hospital.local, que identifica el entorno NIS al que pertenecerán el servidor y sus clientes

```bash
sudo domainname hospital.local
```
![Definición del dominio](capturas/nis/05.%20Definici%C3%B3n%20del%20dominio.png)

#### 2.11. Configuración de las Direcciones IP

Se asignaron direcciones IP a las dos máquinas virtuales para garantizar su comunicación dentro de la red local.

![Configuración de las direcciones IP para cada instancia](capturas/nis/06.%20Configuraci%C3%B3n%20de%20las%20direcciones%20IP%20para%20cada%20instancia.png)

Se verificaron las direcciones asignadas:

![Verificación de las direcciones IP](capturas/nis/07.%20Verificaci%C3%B3n%20de%20las%20direcciones%20IP.png)

También se configuró la resolución de los nombres de las máquinas para facilitar su identificación dentro del entorno NIS

![Configuración de las direcciones IP con el dominio de NIS](capturas/nis/08.%20Configuraci%C3%B3n%20de%20las%20direcciones%20IP%20con%20el%20dominio%20de%20NIS.png)

Para conservar el dominio NIS después de reiniciar el servidor, se configuró su establecimiento permanente mediante el mecanismo de inicio del sistema

![Configuración del dominio permanentemente](capturas/nis/09.%20Configuraci%C3%B3n%20del%20dominio%20permanentemente.png)

#### 2.12. Creación del Usuario de Prueba e Inicialización del Servidor

Se creó una cuenta local denominada *usuario_nis*, que posteriormente sería publicada mediante los mapas NIS para permitir su consulta desde el cliente

![Creación de un usuario de prueba](capturas/nis/10.%20Creaci%C3%B3n%20de%20un%20usuario%20de%20prueba.png)

Después de preparar el dominio y el usuario, se inicializó el servidor maestro mediante la herramienta *ypinit*:

![Inicialización de los servicios NIS](capturas/nis/11.%20Inicializaci%C3%B3n%20de%20los%20servicios%20NIS.png)

#### 2.13. Habilitación de los Servicios y Verificación del Servidor

Se habilitaron los servicios necesarios para que el servidor NIS pudiera atender las solicitudes de los clientes y mantener su funcionamiento después de reiniciar la máquina:

![Habilitación e iniciación de ypbind](capturas/nis/12.%20Habilitaci%C3%B3n%20e%20iniciaci%C3%B3n%20de%20ypbind.png)

Posteriormente, se verificó la comunicación con el servicio y se consultó el usuario de prueba mediante las herramientas de NIS

![Enlace del servidor NIS y consulta del usuario](capturas/nis/13.%20Enlace%20del%20servidor%20NIS%20y%20consulta%20del%20usuario.png)

#### 2.14. Configuración del Cliente NIS

Una vez preparado el servidor maestro, se procedió a configurar la segunda máquina virtual para que pudiera integrarse al dominio hospital.local. Primeramente se establece el dominio NIS en el cliente:

![Configurar el dominio para el NIS en el Cliente](capturas/nis/14.%20Configurar%20el%20dominio%20para%20el%20NIS%20en%20el%20Cliente.png)

Posteriormente, se instalaron los paquetes necesarios para que la máquina pudiera funcionar como cliente NIS:

![Actualización de Ubuntu para el cliente](capturas/nis/15.%20Actualiaci%C3%B3n%20de%20Ubuntu%20para%20el%20servidor%20del%20cliente.png)

Ahora bien, se configuró el archivo /etc/yp.conf para indicar la dirección del servidor maestro:

![Configuración del servidor NIS](capturas/nis/16.%20Configuraci%C3%B3n%20del%20servidor%20NIS.png)

#### 2.15. Habilitación de los Servicios y Comprobación de la Conexión

Se habilitaron los servicios necesarios para que el cliente pudiera localizar y consultar al servidor NIS

![Habilitar los servicios del NIS](capturas/nis/17.%20Habilitar%20los%20servicios%20del%20NIS.png)

Después se verificó que el cliente estuviera conectado correctamente al servidor maestro

![Comprobar la conexión con el servidor NIS](capturas/nis/18.%20Comprobar%20la%20conexi%C3%B3n%20con%20el%20servidor%20NIS.png)

#### 2.16. Integración con el Sistema de Identificación de Ubuntu

Para que Ubuntu pudiera utilizar los usuarios y grupos proporcionados por NIS, se modificó el archivo /etc/nsswitch.conf. Además, se ajustan las entradas correspondientes a usuarios, grupos y contraseñas para incluir la consulta al servicio NIS:

![Integración de usuarios NIS con el sistema de identificación](capturas/nis/19.%20Integraci%C3%B3n%20de%20usuarios%20NIS%20con%20Sistema%20de%20identificaci%C3%B3n.png)

Con esta configuración, el sistema consulta primero sus archivos locales y mecanismos de identificación, y también puede recurrir a NIS para obtener la información centralizada

#### 2.17. Prueba de Autenticación y Creación del Directorio Personal

Finalmente, se realizó una prueba de autenticación desde el cliente utilizando la cuenta usuario_nis, creada originalmente en el servidor maestro.
El sistema solicita la contraseña de la cuenta y permite iniciar sesión correctamente, demostrando que el cliente puede utilizar sus credenciales administradas desde el servidor NIS

![Prueba de autenticación de un usuario](capturas/nis/20.%20Prueba%20de%20autenticaci%C3%B3n%20de%20un%20usuario.png)

Adicionalmente, se habilitó el módulo pam_mkhomedir mediante la herramienta de configuración de PAM, permitiendo crear automáticamente el directorio personal del usuario cuando inicia sesión por primera vez en el cliente.
Se comprobó que el usuario había iniciado sesión correctamente y que su directorio personal correspondía a /home/usuario_nis.

![Verificación del usuario después de la prueba](capturas/nis/21.%20Verificaci%C3%B3n%20del%20usuario%20despu%C3%A9s%20de%20la%20prueba.png)

---

## 3. Parámetros Técnicos de los Servicios

Los servicios implementados utilizan los siguientes parámetros de red:

| Servicio | IP del servidor | Puerto | Protocolo | Tipo de servicio | Descripción / Acceso |
|---|---|---|---|---|---|
| **NTP (Chrony)** | 192.168.1.9 | 123 | UDP | Sincronización de tiempo | Servidor de hora para la red local. |
| **CUPS** | 192.168.1.9 | 631 | TCP | Servidor de impresión | Administración web mediante `https://192.168.1.9:631`. |
| **NIS (ypserv)** | 192.168.1.18 | 111 y 871 | TCP/UDP | Autenticación centralizada | Servidor maestro NIS del dominio hospital.local. El puerto 111 corresponde a rpcbind y el 871 al servicio ypserv |

---

## 4. Resultados de la Implementación

La implementación de los servicios NTP y CUPS permitió establecer dos componentes centralizados dentro de la infraestructura tecnológica propuesta para el Hospital San Juan de Dios de Armenia.

Por una parte, Chrony permitió sincronizar el reloj del servidor con fuentes de tiempo externas y configurar el acceso para los dispositivos pertenecientes a la subred local. Por otra parte, CUPS permitió habilitar la administración remota del servicio de impresión y configurar una impresora compartida denominada `Impresora_Hospital`.

De esta manera, se establecieron las configuraciones necesarias para apoyar la sincronización horaria y la gestión centralizada de impresión dentro de la infraestructura del hospital.

Ahora bien, NIS permitió centralizar la administración de usuarios y grupos mediante una arquitectura cliente-servidor. Se configuró un servidor maestro para el dominio hospital.local y se integró una máquina cliente que pudo consultar los usuarios publicados e iniciar sesión utilizando una cuenta creada en el servidor. También se habilitó la creación automática del directorio personal para los usuarios que iniciaran sesión por primera vez. Gracias a esto se puede administrar las identidades dentro del entorno de red implementado para el hospital.
