
-- FDW SETUP - dijalankan di NODE 2 (BEM)
-- Tujuan: BEM membaca & mengupdate status surat HIMA/UKM secara
-- real-time tanpa menyalin data (BEM sebagai perantara approval)


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
    status           letter_status_enum,
    created_at       TIMESTAMP,
    updated_at       TIMESTAMP
) SERVER server_hima_remote OPTIONS (schema_name 'public', table_name 'letter_hima');

CREATE FOREIGN TABLE IF NOT EXISTS foreign_letter_ukm (
    letter_id        UUID,
    organization_id  UUID,
    letter_type_id   UUID,
    title            VARCHAR(200),
    description      TEXT,
    status           letter_status_enum,
    created_at       TIMESTAMP,
    updated_at       TIMESTAMP
) SERVER server_ukm_remote OPTIONS (schema_name 'public', table_name 'letter_ukm');