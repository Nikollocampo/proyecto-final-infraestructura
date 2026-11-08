#!/bin/bash
# =====================================================================
# Script de instalación: Servidor NFS
# Proyecto: Infraestructura TI - Hospital San Juan de Dios de Armenia
# Uso: sudo bash instalar_nfs_servidor.sh <SUBRED>
# Ejemplo: sudo bash instalar_nfs_servidor.sh 192.168.33.0/24
# =====================================================================
set -e

SUBRED="${1:-192.168.33.0/24}"
BASE="/srv/nfs/hospital"
GRUPO="personal_hospital"
GID_GRUPO=3000

echo "=================================================="
echo "Instalando servidor NFS para la subred $SUBRED"
echo "=================================================="

# 1. Instalación del paquete
apt update
apt install -y nfs-kernel-server

# 2. Grupo y usuario del hospital (mismos UID/GID que en los clientes)
getent group "$GRUPO" >/dev/null || groupadd -g "$GID_GRUPO" "$GRUPO"
id medico1 >/dev/null 2>&1 || useradd -m -u 3001 -G "$GRUPO" -s /bin/bash medico1

# 3. Directorios exportados y permisos
mkdir -p "$BASE/compartido" "$BASE/protocolos"

# compartido: solo el grupo personal_hospital puede leer/escribir.
# El bit setgid (2) hace que los archivos nuevos hereden el grupo.
chown root:"$GRUPO" "$BASE/compartido"
chmod 2770 "$BASE/compartido"

# protocolos: lectura para todos, escritura solo para root del servidor
chown root:root "$BASE/protocolos"
chmod 755 "$BASE/protocolos"
echo "Protocolo de lavado de manos - Hospital San Juan de Dios de Armenia" > "$BASE/protocolos/protocolo_lavado_manos.txt"
chmod 644 "$BASE/protocolos/protocolo_lavado_manos.txt"

# 4. Archivo /etc/exports (se guarda copia del original)
[ -f /etc/exports.bak ] || cp /etc/exports /etc/exports.bak
cat > /etc/exports <<EXPORTS
/srv/nfs/hospital/compartido  $SUBRED(rw,sync,no_subtree_check,root_squash)
/srv/nfs/hospital/protocolos  $SUBRED(ro,sync,no_subtree_check,root_squash)
EXPORTS

# 5. Aplicar exportaciones e iniciar el servicio
exportfs -ra
systemctl enable --now nfs-kernel-server
systemctl restart nfs-kernel-server

# 6. Verificación
echo "--> Exportaciones activas:"
exportfs -v
echo "--> Estado del servicio:"
systemctl is-active nfs-kernel-server
