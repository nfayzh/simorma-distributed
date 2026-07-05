#!/bin/bash

# init.sh - Inisialisasi seluruh sistem DOMS dari nol


set -e

echo "===================================================="
echo " DOMS - Distributed Organization Management System"
echo " Inisialisasi Sistem"
echo "===================================================="

# Load environment variables
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "File .env tidak ditemukan. Salin dari .env terlebih dahulu."
    exit 1
fi

echo ""
echo "[1/8] Menghentikan container lama (jika ada)..."
docker compose down -v 2>/dev/null || true

echo ""
echo "[2/8] Membangun & menjalankan container..."
docker compose up -d

echo ""
echo "[3/8] Menunggu PostgreSQL siap di semua node..."

wait_for_pg () {
    local CONTAINER=$1
    local USER=$2
    local RETRIES=30
    until docker exec "$CONTAINER" pg_isready -U "$USER" > /dev/null 2>&1; do
        RETRIES=$((RETRIES - 1))
        if [ "$RETRIES" -le 0 ]; then
            echo "   -> GAGAL: $CONTAINER tidak siap setelah 30 percobaan"
            exit 1
        fi
        echo "   -> Menunggu $CONTAINER siap... ($RETRIES percobaan tersisa)"
        sleep 2
    done
    echo "   -> $CONTAINER siap!"
}

wait_for_pg doms-node1-kemahasiswaan "${PG_NODE1_USER}"
wait_for_pg doms-node2-bem "${PG_NODE2_USER}"
wait_for_pg doms-node3-hima "${PG_NODE3_USER}"
wait_for_pg doms-node4-ukm "${PG_NODE4_USER}"

#  Fungsi bantu untuk eksekusi SQL ke node tertentu 
run_sql () {
    local CONTAINER=$1
    local DB=$2
    local USER=$3
    local FILE=$4
    echo "   -> Menjalankan $FILE di $CONTAINER"
    docker exec -i "$CONTAINER" psql -U "$USER" -d "$DB" < "$FILE"
}

echo ""
echo "[4/8] Menjalankan common SQL (extension, enum, role, function) di semua node..."
for NODE in "doms-node1-kemahasiswaan:${PG_NODE1_DB}:${PG_NODE1_USER}" \
            "doms-node2-bem:${PG_NODE2_DB}:${PG_NODE2_USER}" \
            "doms-node3-hima:${PG_NODE3_DB}:${PG_NODE3_USER}" \
            "doms-node4-ukm:${PG_NODE4_DB}:${PG_NODE4_USER}"; do
    IFS=":" read -r CONTAINER DB USER <<< "$NODE"
    run_sql "$CONTAINER" "$DB" "$USER" database/common/extension.sql
    run_sql "$CONTAINER" "$DB" "$USER" database/common/enum.sql
    run_sql "$CONTAINER" "$DB" "$USER" database/common/role.sql
    run_sql "$CONTAINER" "$DB" "$USER" database/common/function.sql
done

echo ""
echo "[5/8] Menjalankan schema, seed, view, trigger per node..."

# Node 1 - Kemahasiswaan
run_sql doms-node1-kemahasiswaan "${PG_NODE1_DB}" "${PG_NODE1_USER}" database/campus/schema.sql
run_sql doms-node1-kemahasiswaan "${PG_NODE1_DB}" "${PG_NODE1_USER}" database/campus/seed.sql
run_sql doms-node1-kemahasiswaan "${PG_NODE1_DB}" "${PG_NODE1_USER}" database/campus/view.sql
run_sql doms-node1-kemahasiswaan "${PG_NODE1_DB}" "${PG_NODE1_USER}" database/campus/trigger.sql

# Node 2 - BEM
run_sql doms-node2-bem "${PG_NODE2_DB}" "${PG_NODE2_USER}" database/bem/schema.sql
run_sql doms-node2-bem "${PG_NODE2_DB}" "${PG_NODE2_USER}" database/bem/seed.sql
run_sql doms-node2-bem "${PG_NODE2_DB}" "${PG_NODE2_USER}" database/bem/view.sql
run_sql doms-node2-bem "${PG_NODE2_DB}" "${PG_NODE2_USER}" database/bem/trigger.sql

# Node 3 - HIMA
run_sql doms-node3-hima "${PG_NODE3_DB}" "${PG_NODE3_USER}" database/hima/schema.sql
run_sql doms-node3-hima "${PG_NODE3_DB}" "${PG_NODE3_USER}" database/hima/seed.sql
run_sql doms-node3-hima "${PG_NODE3_DB}" "${PG_NODE3_USER}" database/hima/view.sql
run_sql doms-node3-hima "${PG_NODE3_DB}" "${PG_NODE3_USER}" database/hima/trigger.sql

# Node 4 - UKM
run_sql doms-node4-ukm "${PG_NODE4_DB}" "${PG_NODE4_USER}" database/ukm/schema.sql
run_sql doms-node4-ukm "${PG_NODE4_DB}" "${PG_NODE4_USER}" database/ukm/seed.sql
run_sql doms-node4-ukm "${PG_NODE4_DB}" "${PG_NODE4_USER}" database/ukm/view.sql
run_sql doms-node4-ukm "${PG_NODE4_DB}" "${PG_NODE4_USER}" database/ukm/trigger.sql

echo ""
echo "[6/8] Setup replication (grant, publication, subscription)..."
run_sql doms-node1-kemahasiswaan "${PG_NODE1_DB}" "${PG_NODE1_USER}" database/replication/05_grant_replication.sql
run_sql doms-node1-kemahasiswaan "${PG_NODE1_DB}" "${PG_NODE1_USER}" database/replication/01_publication_node1.sql
sleep 2
run_sql doms-node2-bem "${PG_NODE2_DB}" "${PG_NODE2_USER}" database/replication/02_subscription_node2_bem.sql
run_sql doms-node3-hima "${PG_NODE3_DB}" "${PG_NODE3_USER}" database/replication/03_subscription_node3_hima.sql
run_sql doms-node4-ukm "${PG_NODE4_DB}" "${PG_NODE4_USER}" database/replication/04_subscription_node4_ukm.sql
echo ""
echo "[6b] Backfill data organisasi awal ke semua node (karena copy_data=false)..."
run_sql doms-node2-bem "${PG_NODE2_DB}" "${PG_NODE2_USER}" database/replication/07_backfill_organization.sql
run_sql doms-node3-hima "${PG_NODE3_DB}" "${PG_NODE3_USER}" database/replication/07_backfill_organization.sql
run_sql doms-node4-ukm "${PG_NODE4_DB}" "${PG_NODE4_USER}" database/replication/07_backfill_organization.sql


echo ""
echo "[7/8] Setup FDW (server, user mapping, grant, foreign table) di Node 1..."
run_sql doms-node2-bem "${PG_NODE2_DB}" "${PG_NODE2_USER}" database/fdw/02_grant_fdw_reader.sql
run_sql doms-node1-kemahasiswaan "${PG_NODE1_DB}" "${PG_NODE1_USER}" database/fdw/01_setup_fdw_server.sql
run_sql doms-node1-kemahasiswaan "${PG_NODE1_DB}" "${PG_NODE1_USER}" database/fdw/03_create_foreign_tables.sql
run_sql doms-node1-kemahasiswaan "${PG_NODE1_DB}" "${PG_NODE1_USER}" database/fdw/04_view_monitoring.sql
echo ""
echo "[7b] Setup FDW tambahan: BEM -> HIMA & UKM (real-time perantara)..."
run_sql doms-node3-hima "${PG_NODE3_DB}" "${PG_NODE3_USER}" database/fdw/05_grant_fdw_reader_hima.sql
run_sql doms-node4-ukm "${PG_NODE4_DB}" "${PG_NODE4_USER}" database/fdw/06_grant_fdw_reader_ukm.sql
run_sql doms-node2-bem "${PG_NODE2_DB}" "${PG_NODE2_USER}" database/fdw/07_setup_bem_fdw_server.sql
run_sql doms-node2-bem "${PG_NODE2_DB}" "${PG_NODE2_USER}" database/fdw/08_grant_fdw_reader_bem_proposal.sql
run_sql doms-node1-kemahasiswaan "${PG_NODE1_DB}" "${PG_NODE1_USER}" database/fdw/09_create_foreign_table_proposal_bem.sql


echo ""
echo "[8/8] Setup fragmentasi (opsional demo)..."
run_sql doms-node1-kemahasiswaan "${PG_NODE1_DB}" "${PG_NODE1_USER}" database/fragmentation/01_horizontal_fragmentation.sql
run_sql doms-node1-kemahasiswaan "${PG_NODE1_DB}" "${PG_NODE1_USER}" database/fragmentation/02_vertical_fragmentation.sql

echo ""
echo "===================================================="
echo " Inisialisasi selesai!"
echo " Node 1 (Kemahasiswaan) : localhost:${PG_NODE1_PORT}"
echo " Node 2 (BEM)           : localhost:${PG_NODE2_PORT}"
echo " Node 3 (HIMA)          : localhost:${PG_NODE3_PORT}"
echo " Node 4 (UKM)           : localhost:${PG_NODE4_PORT}"
echo " Redis                  : localhost:${REDIS_PORT}"
echo " MongoDB                : localhost:${MONGO_PORT}"
echo "===================================================="