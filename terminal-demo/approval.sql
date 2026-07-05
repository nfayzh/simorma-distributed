
-- DEMO: PROSES APPROVAL BERTINGKAT
-- Surat: HIMA/UKM -> BEM -> Kemahasiswaan
-- Proposal: langsung ke Kemahasiswaan


--  Jalankan di NODE 2 (BEM): approve surat dari HIMA 
-- (ambil letter_id dari hasil v_letter_masuk_bem)
INSERT INTO approval_bem (approval_id, source_table, letter_id, approved_by, status, approval_date)
SELECT gen_random_uuid(), 'letter_hima', letter_id,
       'dddddddd-0000-0000-0000-000000000001', 'APPROVED', now()
FROM letter_hima
WHERE title = 'Surat Pemberitahuan Seminar Teknologi Informasi';

-- Cek status letter_hima otomatis berubah jadi DISETUJUI_BEM
SELECT * FROM v_letter_hima_status;

--  Jalankan di NODE 1 (KEMAHASISWAAN): approve final surat 
INSERT INTO letter (letter_id, organization_id, letter_type_id, title, description, status)
VALUES (
    gen_random_uuid(),
    'aaaaaaaa-0000-0000-0000-000000000002',
    'cccccccc-0000-0000-0000-000000000001',
    'Surat Pemberitahuan Seminar Teknologi Informasi',
    'Kegiatan seminar TI dalam rangka Dies Natalis kampus',
    'DISETUJUI'
);

INSERT INTO letter_approval (approval_id, letter_id, approved_by, approval_level, status, approval_date)
SELECT gen_random_uuid(), letter_id, 'bbbbbbbb-0000-0000-0000-000000000001',
       'KEMAHASISWAAN', 'APPROVED', now()
FROM letter
WHERE title = 'Surat Pemberitahuan Seminar Teknologi Informasi';

--  Jalankan di NODE 1 (KEMAHASISWAAN): approve proposal 
INSERT INTO proposal_approval (proposal_approval_id, proposal_id, approved_by, status, approval_date)
SELECT gen_random_uuid(), proposal_id, 'bbbbbbbb-0000-0000-0000-000000000001',
       'APPROVED', now()
FROM proposal
WHERE title = 'Seminar Teknologi Informasi 2026';

-- Trigger fn_generate_calendar_event otomatis membuat entri kalender
-- karena Surat APPROVED AND Proposal APPROVED terpenuhi

--  Cek hasil monitoring approval 
SELECT * FROM v_pending_approval;   -- harus kosong untuk item yang sudah selesai
SELECT * FROM v_letter_summary;