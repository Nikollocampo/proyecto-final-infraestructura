#!/bin/bash

# =====================================================================
# Script de instalación: Servicios NTP y CUPS
# Proyecto: Infraestructura TI - Hospital San Juan de Dios de Armenia
# =====================================================================

echo "=================================================="
echo "Iniciando instalación de servicios NTP y CUPS..."
echo "=================================================="

# ---------------------------------------------------------------------
# 1. INSTALACIÓN Y CONFIGURACIÓN DEL SERVICIO NTP (chrony)
# ---------------------------------------------------------------------
echo "--> Instalando Chrony (Servidor NTP)..."
sudo apt update
sudo apt install chrony -y

# NOTA: Para que funcione como servidor, se debe editar manualmente
# el archivo /etc/chrony/chrony.conf y agregar al final la línea:
# allow 192.168.1.0/24
# (El archivo de configuración modificado ya se encuentra en esta carpeta)

sudo systemctl restart chrony
sudo systemctl enable chrony
echo "--> NTP (chrony) instalado y configurado."

# ---------------------------------------------------------------------
# 2. INSTALACIÓN Y CONFIGURACIÓN DEL SERVICIO CUPS
# ---------------------------------------------------------------------
echo "--> Instalando CUPS (Servidor de Impresión)..."
sudo apt install cups -y

# Se agrega el usuario actual al grupo de administradores de CUPS
sudo usermod -aG lpadmin $USER

# NOTA: Para permitir el acceso remoto, se debe editar manualmente
# el archivo /etc/cups/cupsd.conf y cambiar:
# Listen localhost:631  ->  Listen 0.0.0.0:631
# Y añadir la regla Allow 192.168.1.* en los bloques <Location>
# (El archivo de configuración modificado ya se encuentra en esta carpeta)

sudo systemctl restart cups
sudo systemctl enable cups
echo "--> CUPS instalado y configurado."

echo "=================================================="
echo "¡Instalación base de NTP y CUPS completada!"
echo "Recuerda verificar los archivos de configuración en /etc/"
echo "=================================================="
