-- 
-- SEED DATA - NODE 2: BEM
-- 

INSERT INTO role (role_id, role_name) VALUES
    ('22222222-2222-2222-2222-222222222222', 'BEM')
ON CONFLICT (role_id) DO NOTHING;

-- Organisasi (disamakan UUID dengan Node Kemahasiswaan agar konsisten via replikasi)
INSERT INTO organization (organization_id, organization_name, organization_type, node_location) VALUES
    ('aaaaaaaa-0000-0000-0000-000000000001', 'BEM STT Cipasung', 'BEM', 'bem'),
    ('aaaaaaaa-0000-0000-0000-000000000002', 'HIMA Informatika', 'HIMA', 'hima'),
    ('aaaaaaaa-0000-0000-0000-000000000003', 'UKM Basket', 'UKM', 'ukm')
ON CONFLICT (organization_id) DO NOTHING;

INSERT INTO app_user (user_id, role_id, organization_id, username, password, status) VALUES
    ('dddddddd-0000-0000-0000-000000000001',
     '22222222-2222-2222-2222-222222222222',
     'aaaaaaaa-0000-0000-0000-000000000001',
     'admin_bem',
     crypt('bem123', gen_salt('bf')),
     'ACTIVE')
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO letter_type (letter_type_id, type_name) VALUES
    ('cccccccc-0000-0000-0000-000000000001', 'Surat Pemberitahuan Kegiatan'),
    ('cccccccc-0000-0000-0000-000000000002', 'Surat Permohonan Izin Kegiatan'),
    ('cccccccc-0000-0000-0000-000000000003', 'Surat Peminjaman Tempat')
ON CONFLICT (letter_type_id) DO NOTHING;