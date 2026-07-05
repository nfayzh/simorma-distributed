#!/bin/bash

# reset.sh - Reset total sistem DOMS (hapus semua data & container)


set -e

echo "===================================================="
echo " DOMS - Reset Sistem"
echo "===================================================="
read -p "Yakin ingin menghapus SEMUA data & container? (y/n): " confirm

if [ "$confirm" != "y" ]; then
    echo "Dibatalkan."
    exit 0
fi

echo "[1/2] Menghentikan & menghapus container beserta volume..."
docker compose down -v

echo "[2/2] Membersihkan dangling volumes..."
docker volume prune -f

echo ""
echo "Reset selesai. Jalankan ./scripts/init.sh untuk inisialisasi ulang."