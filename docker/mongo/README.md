# MongoDB Config untuk DOMS

File inisialisasi utama ada di `mongodb/init.js` (root folder proyek),
di-mount ke `/docker-entrypoint-initdb.d/init.js` agar otomatis dijalankan
saat container MongoDB pertama kali dibuat.

Digunakan untuk:
- Audit log seluruh aktivitas pengguna (login, buat surat, approval, sinkronisasi)