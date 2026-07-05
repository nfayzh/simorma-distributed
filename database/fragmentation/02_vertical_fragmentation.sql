
-- FRAGMENTASI VERTIKAL
-- Data autentikasi (username, password) disimpan LOKAL di tiap node.
-- Data profil organisasi disimpan di NODE PUSAT (Kemahasiswaan) dan
-- direplikasi (lihat database/replication/).


-- Ilustrasi: app_user di tiap node HANYA menyimpan kolom otentikasi
-- + referensi organization_id (yang di-mirror via replication),
-- TANPA menyimpan detail lengkap organisasi (nama, tipe, dsb berulang).
-- Ini sudah diterapkan di schema.sql masing-masing node:
--
--   Node 1 (Kemahasiswaan): app_user + organization (lengkap, sumber utama)
--   Node 2 (BEM)          : app_user (lokal) + organization (mirror, read-only)
--   Node 3 (HIMA)         : app_user (lokal) + organization (mirror, read-only)
--   Node 4 (UKM)          : app_user (lokal) + organization (mirror, read-only)
--
-- Verifikasi: pastikan tabel organization di Node 2/3/4 TIDAK menerima
-- INSERT/UPDATE manual, karena data tersebut seharusnya hanya masuk
-- lewat subscription replication dari Node 1.

REVOKE INSERT, UPDATE, DELETE ON organization FROM fdw_reader;