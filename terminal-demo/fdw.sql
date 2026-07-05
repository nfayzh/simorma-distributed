
-- DEMO: FOREIGN DATA WRAPPER (FDW)
-- Node Kemahasiswaan membaca data surat dari Node BEM/HIMA/UKM
-- TANPA menyalin data (query real-time lintas node)


--  Jalankan di NODE 1 (KEMAHASISWAAN) 

-- Query langsung ke tabel surat di Node HIMA lewat FDW
SELECT * FROM foreign_letter_hima ORDER BY created_at DESC;

-- Query langsung ke tabel surat di Node UKM lewat FDW
SELECT * FROM foreign_letter_ukm ORDER BY created_at DESC;

-- Query langsung ke tabel surat di Node BEM lewat FDW
SELECT * FROM foreign_letter_bem ORDER BY created_at DESC;

-- Monitoring gabungan seluruh surat lintas node (view yang memakai FDW)
SELECT * FROM v_monitoring_semua_surat;

-- Buktikan ini query real-time: insert surat baru di Node HIMA,
-- lalu langsung SELECT ulang view ini dari Node 1 tanpa delay/sync manual