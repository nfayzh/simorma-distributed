# DEMO: REDIS CACHE
# Jalankan lewat: docker exec -it doms-redis redis-cli -a redis_pass123


#  Cache sesi login 
SET session:bbbbbbbb-0000-0000-0000-000000000001 "{\"username\":\"admin_kemahasiswaan\",\"role\":\"KEMAHASISWAAN\"}" EX 3600
GET session:bbbbbbbb-0000-0000-0000-000000000001
TTL session:bbbbbbbb-0000-0000-0000-000000000001

#  Cache kalender kegiatan 
SET calendar:cache "[{\"event_name\":\"Seminar Teknologi Informasi 2026\",\"event_date\":\"2026-08-15\"}]" EX 300
GET calendar:cache

#  Cache daftar organisasi aktif 
SET organization:active "[\"BEM STT Cipasung\",\"HIMA Informatika\",\"UKM Basket\"]" EX 600
GET organization:active

#  Hapus cache (contoh saat logout) 
DEL session:bbbbbbbb-0000-0000-0000-000000000001

#  Lihat semua key yang aktif 
KEYS *