#!/bin/bash

# restore.sh - Restore database DOMS dari folder backup
# Penggunaan: ./scripts/restore.sh backup/20260705_120000


set -e

if [ -z "$1" ]; then
    echo "Penggunaan: ./scripts/restore.sh <folder_backup>"
    echo "Contoh: ./scripts/restore.sh backup/20260705_120000"
    exit 1
fi

BACKUP_DIR="$1"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Folder backup tidak ditemukan: $BACKUP_DIR"
    exit 1
fi

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "File .env tidak ditemukan."
    exit 1
fi

echo "===================================================="
echo " DOMS - Restore Database"
echo " Sumber: $BACKUP_DIR"
echo "===================================================="
read -p "Restore akan menimpa data yang ada. Lanjutkan? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "Dibatalkan."
    exit 0
fi

echo "[1/5] Restore Node 1 - Kemahasiswaan..."
cat "${BACKUP_DIR}/node1_kemahasiswaan.sql" | docker exec -i doms-node1-kemahasiswaan psql -U "${PG_NODE1_USER}" -d "${PG_NODE1_DB}"

echo "[2/5] Restore Node 2 - BEM..."
cat "${BACKUP_DIR}/node2_bem.sql" | docker exec -i doms-node2-bem psql -U "${PG_NODE2_USER}" -d "${PG_NODE2_DB}"

echo "[3/5] Restore Node 3 - HIMA..."
cat "${BACKUP_DIR}/node3_hima.sql" | docker exec -i doms-node3-hima psql -U "${PG_NODE3_USER}" -d "${PG_NODE3_DB}"

echo "[4/5] Restore Node 4 - UKM..."
cat "${BACKUP_DIR}/node4_ukm.sql" | docker exec -i doms-node4-ukm psql -U "${PG_NODE4_USER}" -d "${PG_NODE4_DB}"

echo "[5/5] Restore MongoDB..."
cat "${BACKUP_DIR}/mongo_audit.archive" | docker exec -i doms-mongo mongorestore \
    --username "${MONGO_INITDB_ROOT_USERNAME}" \
    --password "${MONGO_INITDB_ROOT_PASSWORD}" \
    --authenticationDatabase admin \
    --archive

echo ""
echo "===================================================="
echo " Restore selesai."
echo "===================================================="