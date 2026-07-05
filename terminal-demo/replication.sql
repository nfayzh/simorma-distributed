
-- DEMO: LOGICAL REPLICATION
-- Data yang direplikasi: organization, calendar_event,
-- letter_approval, proposal_approval


--  Jalankan di NODE 1 (KEMAHASISWAAN / PUBLISHER) 
-- Tambah organisasi baru untuk mendemokan replikasi real-time
INSERT INTO organization (organization_id, organization_name, organization_type, node_location)
VALUES (gen_random_uuid(), 'UKM Futsal', 'UKM', 'ukm');

SELECT * FROM organization ORDER BY created_at DESC LIMIT 1;

--  Tunggu 2-3 detik, lalu jalankan di NODE 2, 3, 4 (SUBSCRIBER) 
SELECT * FROM organization WHERE organization_name = 'UKM Futsal';
-- Jika muncul di ketiga node -> replikasi berhasil

--  Cek status kesehatan replikasi 
-- Di Node 1 (Publisher):
SELECT application_name, state, sync_state FROM pg_stat_replication;

-- Di Node 2/3/4 (Subscriber):
SELECT subname, received_lsn, latest_end_lsn, latest_end_time
FROM pg_stat_subscription;