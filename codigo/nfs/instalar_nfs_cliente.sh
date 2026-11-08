#!/bin/bash
# =====================================================================
# Script de instalación: Cliente NFS
# Proyecto: Infraestructura TI - Hospital San Juan de Dios de Armenia
# Uso: sudo bash instalar_nfs_cliente.sh <IP_SERVIDOR_NFS>
# Ejemplo: sudo bash instalar_nfs_cliente.sh 192.168.33.14
# =====================================================================
set -e

IP_SERVIDOR="$1"
if [ -z "$IP_SERVIDOR" ]; then
  echo "Uso: sudo bash $0 <IP_SERVIDOR_NFS>"
  exit 1
fi

GRUPO="personal_hospital"
GID_GRUPO=3000

# 1. Instalación del paquete cliente
apt update
apt install -y nfs-common

# 2. Usuarios de prueba con los mismos UID/GID del servidor
getent group "$GRUPO" >/dev/null || groupadd -g "$GID_GRUPO" "$GRUPO"
id medico1   >/dev/null 2>&1 || useradd -m -u 3001 -G "$GRUPO" -s /bin/bash medico1
id visitante >/dev/null 2>&1 || useradd -m -u 3002 -s /bin/bash visitante   # NO pertenece al grupo

# 3. Consultar las exportaciones del servidor
showmount -e "$IP_SERVIDOR"

# 4. Puntos de montaje
mkdir -p /mnt/hospital/compartido /mnt/hospital/protocolos

# 5. Montaje permanente en /etc/fstab (solo si no existe)
grep -q "/srv/nfs/hospital/compartido" /etc/fstab || \
  echo "$IP_SERVIDOR:/srv/nfs/hospital/compartido  /mnt/hospital/compartido  nfs  defaults,_netdev,nofail  0  0" >> /etc/fstab
grep -q "/srv/nfs/hospital/protocolos" /etc/fstab || \
  echo "$IP_SERVIDOR:/srv/nfs/hospital/protocolos  /mnt/hospital/protocolos  nfs  ro,defaults,_netdev,nofail  0  0" >> /etc/fstab

systemctl daemon-reload
mount -a

# 6. Verificación
df -hT | grep nfs
