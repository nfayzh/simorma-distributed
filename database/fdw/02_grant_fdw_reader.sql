
-- GRANT AKSES FDW READER
-- Jalankan di NODE 2 (BEM), NODE 3 (HIMA), NODE 4 (UKM)



GRANT USAGE ON SCHEMA public TO fdw_reader;

-- Node 2 (BEM)
GRANT SELECT ON letter_bem, letter_hima, letter_ukm TO fdw_reader;

CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER IF NOT EXISTS server_hima_remote
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'node3-hima', port '5432', dbname 'db_hima');

CREATE SERVER IF NOT EXISTS server_ukm_remote
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'node4-ukm', port '5432', dbname 'db_ukm');

CREATE USER MAPPING IF NOT EXISTS FOR CURRENT_USER
    SERVER server_hima_remote
    OPTIONS (user 'fdw_reader', password 'fdw_pass123');

CREATE USER MAPPING IF NOT EXISTS FOR CURRENT_USER
    SERVER server_ukm_remote
    OPTIONS (user 'fdw_reader', password 'fdw_pass123');

CREATE FOREIGN TABLE IF NOT EXISTS foreign_letter_hima (
    letter_id        UUID,
    organization_id  UUID,
    letter_type_id   UUID,
    title            VARCHAR(200),
    description      TEXT,
    status           TEXT,
    created_at       TIMESTAMP,
    updated_at       TIMESTAMP
) SERVER server_hima_remote OPTIONS (schema_name 'public', table_name 'letter_hima');

CREATE FOREIGN TABLE IF NOT EXISTS foreign_letter_ukm (
    letter_id        UUID,
    organization_id  UUID,
    letter_type_id   UUID,
    title            VARCHAR(200),
    description      TEXT,
    status           TEXT,
    created_at       TIMESTAMP,
    updated_at       TIMESTAMP
) SERVER server_ukm_remote OPTIONS (schema_name 'public', table_name 'letter_ukm');

-- Node 3 (HIMA) -- jalankan bagian ini hanya di db_hima
GRANT SELECT ON letter_hima, draft_proposal_hima TO fdw_reader;
GRANT USAGE ON SCHEMA public TO fdw_reader;
GRANT SELECT, UPDATE ON letter_hima TO fdw_reader;
GRANT SELECT ON draft_proposal_hima TO fdw_reader;
-- Node 4 (UKM) -- jalankan bagian ini hanya di db_ukm
GRANT SELECT ON letter_ukm, draft_proposal_ukm TO fdw_reader;
GRANT USAGE ON SCHEMA public TO fdw_reader;
GRANT SELECT, UPDATE ON letter_ukm TO fdw_reader;
GRANT SELECT ON draft_proposal_ukm TO fdw_reader;