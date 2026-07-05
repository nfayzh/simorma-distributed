
-- FOREIGN TABLE: Draft Proposal BEM - dijalankan di NODE 1 (KEMAHASISWAAN)


CREATE FOREIGN TABLE IF NOT EXISTS foreign_draft_proposal_bem (
    proposal_id      UUID,
    organization_id  UUID,
    title            VARCHAR(200),
    activity_date    DATE,
    location         VARCHAR(150),
    status           TEXT,
    created_at       TIMESTAMP,
    updated_at       TIMESTAMP
) SERVER server_bem
  OPTIONS (schema_name 'public', table_name 'draft_proposal_bem');