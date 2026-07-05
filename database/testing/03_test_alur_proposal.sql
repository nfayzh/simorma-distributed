
-- TEST: ALUR PROPOSAL (HIMA/UKM/BEM -> KEMAHASISWAAN, tanpa lewat BEM)


-- 1) Jalankan di NODE 3 (HIMA): buat draft proposal
INSERT INTO draft_proposal_hima (proposal_id, organization_id, title, activity_date, location, status)
VALUES (gen_random_uuid(), 'aaaaaaaa-0000-0000-0000-000000000002',
        'Seminar Teknologi Informasi 2026', '2026-08-15', 'Aula Kampus', 'DIAJUKAN');

-- 2) Jalankan di NODE 1 (KEMAHASISWAAN): monitoring via FDW
SELECT * FROM v_monitoring_semua_proposal_draft WHERE asal_node = 'HIMA';

-- 3) Kemahasiswaan approve (insert ke tabel proposal pusat)
INSERT INTO proposal (proposal_id, organization_id, title, activity_date, location, status)
VALUES (gen_random_uuid(), 'aaaaaaaa-0000-0000-0000-000000000002',
        'Seminar Teknologi Informasi 2026', '2026-08-15', 'Aula Kampus', 'DISETUJUI');

-- 4) Insert proposal_approval untuk memicu trigger kalender otomatis
INSERT INTO proposal_approval (proposal_approval_id, proposal_id, approved_by, status, approval_date)
SELECT gen_random_uuid(), proposal_id, 'bbbbbbbb-0000-0000-0000-000000000001', 'APPROVED', now()
FROM proposal WHERE title = 'Seminar Teknologi Informasi 2026';

-- 5) Cek kalender otomatis (butuh surat + proposal sama-sama APPROVED)
SELECT * FROM v_calendar_full;