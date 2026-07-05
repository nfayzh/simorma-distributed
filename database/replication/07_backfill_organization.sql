
-- BACKFILL DATA ORGANISASI AWAL
-- Diperlukan karena subscription dibuat dengan copy_data = false
-- untuk menghindari konflik primary key dengan data seed lokal.
-- Jalankan di NODE 2 (BEM), NODE 3 (HIMA), NODE 4 (UKM)


INSERT INTO organization (organization_id, organization_name, organization_type, node_location) VALUES
    ('aaaaaaaa-0000-0000-0000-000000000001', 'BEM STT Cipasung', 'BEM', 'bem'),
    ('aaaaaaaa-0000-0000-0000-000000000002', 'HIMA Informatika', 'HIMA', 'hima'),
    ('aaaaaaaa-0000-0000-0000-000000000003', 'UKM Basket', 'UKM', 'ukm')
ON CONFLICT (organization_id) DO NOTHING;