
-- DEMO: PEMBUATAN SURAT
-- Alur: HIMA membuat surat -> status DRAFT -> DIKIRIM ke BEM


--  Jalankan di NODE 3 (HIMA) 
INSERT INTO letter_hima (letter_id, organization_id, letter_type_id, title, description, status)
VALUES (
    gen_random_uuid(),
    'aaaaaaaa-0000-0000-0000-000000000002',
    'cccccccc-0000-0000-0000-000000000001',
    'Surat Pemberitahuan Seminar Teknologi Informasi',
    'Kegiatan seminar TI dalam rangka Dies Natalis kampus',
    'DRAFT'
);

SELECT * FROM letter_hima ORDER BY created_at DESC LIMIT 1;

-- Kirim ke BEM
UPDATE letter_hima
SET status = 'DIKIRIM'
WHERE title = 'Surat Pemberitahuan Seminar Teknologi Informasi';

-- Cek trigger audit lokal tercatat
SELECT * FROM audit_log ORDER BY created_at DESC LIMIT 1;

--  Jalankan di NODE 4 (UKM), contoh serupa 
INSERT INTO letter_ukm (letter_id, organization_id, letter_type_id, title, description, status)
VALUES (
    gen_random_uuid(),
    'aaaaaaaa-0000-0000-0000-000000000003',
    'cccccccc-0000-0000-0000-000000000002',
    'Surat Permohonan Izin Latihan Basket',
    'Izin penggunaan lapangan basket setiap Jumat sore',
    'DRAFT'
);

UPDATE letter_ukm
SET status = 'DIKIRIM'
WHERE title = 'Surat Permohonan Izin Latihan Basket';

--  Jalankan di NODE 2 (BEM): melihat surat masuk dari HIMA & UKM 
SELECT * FROM v_letter_masuk_bem;

--  Jalankan di NODE 2 (BEM): membuat surat sendiri 
INSERT INTO letter_bem (letter_id, organization_id, letter_type_id, title, description, status)
VALUES (
    gen_random_uuid(),
    'aaaaaaaa-0000-0000-0000-000000000001',
    'cccccccc-0000-0000-0000-000000000003',
    'Surat Peminjaman Aula Serbaguna',
    'Peminjaman aula untuk rapat koordinasi BEM',
    'DIKIRIM'
);