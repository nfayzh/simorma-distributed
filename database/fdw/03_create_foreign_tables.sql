
-- FOREIGN TABLES - dijalankan di NODE 1 (KEMAHASISWAAN)


-- FOREIGN TABLE: Surat BEM 
CREATE FOREIGN TABLE IF NOT EXISTS foreign_letter_bem (
    letter_id        UUID,
    organization_id  UUID,
    letter_type_id   UUID,
    title            VARCHAR(200),
    description      TEXT,
    status           TEXT,
    created_at       TIMESTAMP,
    updated_at       TIMESTAMP
) SERVER server_bem
  OPTIONS (schema_name 'public', table_name 'letter_bem');

-- FOREIGN TABLE: Surat HIMA (via Node HIMA langsung) 
CREATE FOREIGN TABLE IF NOT EXISTS foreign_letter_hima (
    letter_id        UUID,
    organization_id  UUID,
    letter_type_id   UUID,
    title            VARCHAR(200),
    description      TEXT,
    status           TEXT,
    created_at       TIMESTAMP,
    updated_at       TIMESTAMP
) SERVER server_hima
  OPTIONS (schema_name 'public', table_name 'letter_hima');

-- FOREIGN TABLE: Surat UKM (via Node UKM langsung) 
CREATE FOREIGN TABLE IF NOT EXISTS foreign_letter_ukm (
    letter_id        UUID,
    organization_id  UUID,
    letter_type_id   UUID,
    title            VARCHAR(200),
    description      TEXT,
    status           TEXT,
    created_at       TIMESTAMP,
    updated_at       TIMESTAMP
) SERVER server_ukm
  OPTIONS (schema_name 'public', table_name 'letter_ukm');

-- FOREIGN TABLE: Draft Proposal HIMA 
CREATE FOREIGN TABLE IF NOT EXISTS foreign_draft_proposal_hima (
    proposal_id      UUID,
    organization_id  UUID,
    title            VARCHAR(200),
    activity_date    DATE,
    location         VARCHAR(150),
    status           TEXT,
    created_at       TIMESTAMP,
    updated_at       TIMESTAMP
) SERVER server_hima
  OPTIONS (schema_name 'public', table_name 'draft_proposal_hima');

-- FOREIGN TABLE: Draft Proposal UKM 
CREATE FOREIGN TABLE IF NOT EXISTS foreign_draft_proposal_ukm (
    proposal_id      UUID,
    organization_id  UUID,
    title            VARCHAR(200),
    activity_date    DATE,
    location         VARCHAR(150),
    status           TEXT,
    created_at       TIMESTAMP,
    updated_at       TIMESTAMP
) SERVER server_ukm
  OPTIONS (schema_name 'public', table_name 'draft_proposal_ukm');