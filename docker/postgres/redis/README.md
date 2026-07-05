# Redis Config untuk DOMS

Konfigurasi utama Redis ada di `redis/redis.conf` (root folder proyek),
di-mount langsung ke container `doms-redis` lewat `docker-compose.yml`.

Digunakan untuk:
- Cache sesi login (`session:<user_id>`)
- Cache kalender kegiatan (`calendar:cache`)
- Cache daftar organisasi aktif (`organization:active`)