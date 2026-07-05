#!/bin/bash

# backup.sh - Backup seluruh database DOMS (4 node Postgres + Mongo)


set -e

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "File .env tidak ditemukan."
    exit 1
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="backup/${TIMESTAMP}"
mkdir -p "$BACKUP_DIR"

echo "===================================================="
echo " DOMS - Backup Database"
echo " Lokasi: $BACKUP_DIR"
echo "===================================================="

echo "[1/5] Backup Node 1 - Kemahasiswaan..."
docker exec doms-node1-kemahasiswaan pg_dump -U "${PG_NODE1_USER}" "${PG_NODE1_DB}" > "${BACKUP_DIR}/node1_kemahasiswaan.sql"

echo "[2/5] Backup Node 2 - BEM..."
docker exec doms-node2-bem pg_dump -U "${PG_NODE2_USER}" "${PG_NODE2_DB}" > "${BACKUP_DIR}/node2_bem.sql"

echo "[3/5] Backup Node 3 - HIMA..."
docker exec doms-node3-hima pg_dump -U "${PG_NODE3_USER}" "${PG_NODE3_DB}" > "${BACKUP_DIR}/node3_hima.sql"

echo "[4/5] Backup Node 4 - UKM..."
docker exec doms-node4-ukm pg_dump -U "${PG_NODE4_USER}" "${PG_NODE4_DB}" > "${BACKUP_DIR}/node4_ukm.sql"

echo "[5/5] Backup MongoDB..."
docker exec doms-mongo mongodump \
    --username "${MONGO_INITDB_ROOT_USERNAME}" \
    --password "${MONGO_INITDB_ROOT_PASSWORD}" \
    --authenticationDatabase admin \
    --db "${MONGO_DB}" \
    --archive > "${BACKUP_DIR}/mongo_audit.archive"

echo ""
echo "===================================================="
echo " Backup selesai: $BACKUP_DIR"
echo "===================================================="