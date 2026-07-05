
-- SEED DATA - NODE 3: HIMA


INSERT INTO role (role_id, role_name) VALUES
    ('33333333-3333-3333-3333-333333333333', 'HIMA')
ON CONFLICT (role_id) DO NOTHING;

INSERT INTO organization (organization_id, organization_name, organization_type, node_location) VALUES
    ('aaaaaaaa-0000-0000-0000-000000000002', 'HIMA Informatika', 'HIMA', 'hima')
ON CONFLICT (organization_id) DO NOTHING;

INSERT INTO app_user (user_id, role_id, organization_id, username, password, status) VALUES
    ('eeeeeeee-0000-0000-0000-000000000001',
     '33333333-3333-3333-3333-333333333333',
     'aaaaaaaa-0000-0000-0000-000000000002',
     'admin_hima',
     crypt('hima123', gen_salt('bf')),
     'ACTIVE')
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO letter_type (letter_type_id, type_name) VALUES
    ('cccccccc-0000-0000-0000-000000000001', 'Surat Pemberitahuan Kegiatan'),
    ('cccccccc-0000-0000-0000-000000000002', 'Surat Permohonan Izin Kegiatan')
ON CONFLICT (letter_type_id) DO NOTHING;