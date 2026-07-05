FROM postgres:15

# Install ekstensi tambahan jika diperlukan
RUN apt-get update && apt-get install -y \
    postgresql-15-cron \
    && rm -rf /var/lib/apt/lists/*

# Copy default init scripts jika ada (opsional, karena kita jalankan manual via scripts/init.sh)
# COPY init-scripts/ /docker-entrypoint-initdb.d/