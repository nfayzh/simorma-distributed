
-- TEST: LOGICAL REPLICATION


-- 1) Jalankan di NODE 1 (KEMAHASISWAAN): tambah organisasi baru
INSERT INTO organization (organization_id, organization_name, organization_type, node_location)
VALUES (gen_random_uuid(), 'UKM Futsal', 'UKM', 'ukm');

-- 2) Tunggu beberapa detik, lalu cek di NODE 2/3/4 apakah data sudah masuk
SELECT * FROM organization WHERE organization_name = 'UKM Futsal';

-- 3) Cek status replikasi
SELECT * FROM pg_stat_subscription; -- di node subscriber