#!/bin/bash

# Script de instalación automática para los servicios NTP y CUPS
# Proyecto: Infraestructura TI - Hospital San Juan de Dios

echo "Iniciando instalación de servicios..."

# 1. Instalar y configurar NTP (chrony)
echo "Instalando Chrony (NTP)..."
sudo apt update
sudo apt install chrony -y
# Nota: Se debe agregar manualmente 'allow 192.168.1.0/24' en /etc/chrony/chrony.conf
sudo systemctl restart chrony
sudo systemctl enable chrony

# 2. Instalar y configurar CUPS
echo "Instalando CUPS..."
sudo apt install cups -y
sudo usermod -aG lpadmin $USER
# Nota: Se debe configurar 'Listen 0.0.0.0:631' y los permisos en /etc/cups/cupsd.conf
sudo systemctl restart cups
sudo systemctl enable cups

echo "¡Instalación base completada!"
echo "Recuerda verificar los archivos de configuración en /etc/"
