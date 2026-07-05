
-- TEST: FOREIGN DATA WRAPPER (FDW)


-- Jalankan di NODE 1 (KEMAHASISWAAN)

-- Test koneksi ke Node BEM
SELECT * FROM foreign_letter_bem LIMIT 5;

-- Test koneksi ke Node HIMA
SELECT * FROM foreign_letter_hima LIMIT 5;

-- Test koneksi ke Node UKM
SELECT * FROM foreign_letter_ukm LIMIT 5;

-- Test view gabungan monitoring
SELECT * FROM v_monitoring_semua_surat;