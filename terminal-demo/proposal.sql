
-- DEMO: PEMBUATAN PROPOSAL
-- Alur: Proposal TIDAK melalui BEM, langsung ke Kemahasiswaan


--  Jalankan di NODE 3 (HIMA): buat draft proposal 
INSERT INTO draft_proposal_hima (proposal_id, organization_id, title, activity_date, location, status)
VALUES (
    gen_random_uuid(),
    'aaaaaaaa-0000-0000-0000-000000000002',
    'Seminar Teknologi Informasi 2026',
    '2026-08-15',
    'Aula Kampus STT Cipasung',
    'DIAJUKAN'
);

SELECT * FROM v_proposal_hima_status;

--  Jalankan di NODE 4 (UKM): buat draft proposal 
INSERT INTO draft_proposal_ukm (proposal_id, organization_id, title, activity_date, location, status)
VALUES (
    gen_random_uuid(),
    'aaaaaaaa-0000-0000-0000-000000000003',
    'Turnamen Basket Antar Fakultas',
    '2026-09-01',
    'Lapangan Basket Kampus',
    'DIAJUKAN'
);

SELECT * FROM v_proposal_ukm_status;

--  Jalankan di NODE 1 (KEMAHASISWAAN): monitoring semua draft via FDW 
SELECT * FROM v_monitoring_semua_proposal_draft;

--  Jalankan di NODE 1 (KEMAHASISWAAN): setujui & simpan proposal final 
INSERT INTO proposal (proposal_id, organization_id, title, activity_date, location, status)
VALUES (
    gen_random_uuid(),
    'aaaaaaaa-0000-0000-0000-000000000002',
    'Seminar Teknologi Informasi 2026',
    '2026-08-15',
    'Aula Kampus STT Cipasung',
    'DISETUJUI'
);

SELECT * FROM v_proposal_summary;