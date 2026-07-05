
-- SEED DATA - NODE 4: UKM


INSERT INTO role (role_id, role_name) VALUES
    ('44444444-4444-4444-4444-444444444444', 'UKM')
ON CONFLICT (role_id) DO NOTHING;

INSERT INTO organization (organization_id, organization_name, organization_type, node_location) VALUES
    ('aaaaaaaa-0000-0000-0000-000000000003', 'UKM Basket', 'UKM', 'ukm')
ON CONFLICT (organization_id) DO NOTHING;

INSERT INTO app_user (user_id, role_id, organization_id, username, password, status) VALUES
    ('ffffffff-0000-0000-0000-000000000001',
     '44444444-4444-4444-4444-444444444444',
     'aaaaaaaa-0000-0000-0000-000000000003',
     'admin_ukm',
     crypt('ukm123', gen_salt('bf')),
     'ACTIVE')
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO letter_type (letter_type_id, type_name) VALUES
    ('cccccccc-0000-0000-0000-000000000001', 'Surat Pemberitahuan Kegiatan'),
    ('cccccccc-0000-0000-0000-000000000002', 'Surat Permohonan Izin Kegiatan')
ON CONFLICT (letter_type_id) DO NOTHING;