
-- TEST: ALUR SURAT HIMA -> BEM -> KEMAHASISWAAN


-- 1) Jalankan di NODE 3 (HIMA): buat surat baru
INSERT INTO letter_hima (letter_id, organization_id, letter_type_id, title, description, status)
VALUES (gen_random_uuid(), 'aaaaaaaa-0000-0000-0000-000000000002',
        'cccccccc-0000-0000-0000-000000000001',
        'Surat Pemberitahuan Seminar TI', 'Kegiatan seminar teknologi informasi', 'DRAFT');

-- 2) Update status jadi DIKIRIM (trigger fn_log_letter_hima_sent aktif)
UPDATE letter_hima SET status = 'DIKIRIM'
WHERE title = 'Surat Pemberitahuan Seminar TI';

-- 3) Jalankan di NODE 2 (BEM): cek surat masuk dari HIMA
SELECT * FROM v_letter_masuk_bem WHERE asal = 'HIMA';

-- 4) BEM approve surat tersebut
-- (ganti :letter_id dengan hasil SELECT di atas)
INSERT INTO approval_bem (approval_id, source_table, letter_id, approved_by, status, approval_date)
VALUES (gen_random_uuid(), 'letter_hima', '<letter_id_dari_step_3>',
        'dddddddd-0000-0000-0000-000000000001', 'APPROVED', now());

-- 5) Cek status letter_hima berubah jadi DISETUJUI_BEM (via trigger BEM)
SELECT * FROM letter_hima WHERE title = 'Surat Pemberitahuan Seminar TI';

-- 6) Jalankan di NODE 1 (KEMAHASISWAAN): monitoring via FDW
SELECT * FROM v_monitoring_semua_surat WHERE asal_node = 'HIMA';

-- 7) Kemahasiswaan setujui final (insert manual ke tabel letter + letter_approval)
INSERT INTO letter (letter_id, organization_id, letter_type_id, title, description, status)
VALUES (gen_random_uuid(), 'aaaaaaaa-0000-0000-0000-000000000002',
        'cccccccc-0000-0000-0000-000000000001',
        'Surat Pemberitahuan Seminar TI', 'Kegiatan seminar teknologi informasi', 'DISETUJUI');