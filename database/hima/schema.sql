
-- NODE 3: HIMA
-- Menyimpan: User HIMA, Surat HIMA, Draft Proposal HIMA


CREATE TABLE IF NOT EXISTS role (
    role_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_name   VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS organization (
    organization_id     UUID PRIMARY KEY,
    organization_name   VARCHAR(100) NOT NULL,
    organization_type   organization_type_enum NOT NULL,
    node_location        VARCHAR(50) NOT NULL,
    created_at           TIMESTAMP NOT NULL DEFAULT now(),
    updated_at           TIMESTAMP NOT NULL DEFAULT now()
);

-- Mirror tabel untuk logical replication dari Node Kemahasiswaan
CREATE TABLE IF NOT EXISTS calendar_event (
    event_id      UUID PRIMARY KEY,
    proposal_id   UUID,
    letter_id     UUID,
    event_name    VARCHAR(200) NOT NULL,
    event_date    DATE NOT NULL,
    location      VARCHAR(150),
    created_at    TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS letter_approval (
    approval_id      UUID PRIMARY KEY,
    letter_id        UUID,
    approved_by      UUID,
    approval_level   VARCHAR(30),
    status           approval_status_enum,
    approval_date    TIMESTAMP
);

CREATE TABLE IF NOT EXISTS proposal_approval (
    proposal_approval_id  UUID PRIMARY KEY,
    proposal_id           UUID,
    approved_by           UUID,
    status                approval_status_enum,
    approval_date         TIMESTAMP
);

CREATE TABLE IF NOT EXISTS app_user (
    user_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id           UUID NOT NULL REFERENCES role(role_id),
    organization_id   UUID REFERENCES organization(organization_id),
    username          VARCHAR(50) NOT NULL UNIQUE,
    password          TEXT NOT NULL,
    status            user_status_enum NOT NULL DEFAULT 'ACTIVE',
    created_at        TIMESTAMP NOT NULL DEFAULT now(),
    updated_at        TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS letter_type (
    letter_type_id  UUID PRIMARY KEY,
    type_name       VARCHAR(100) NOT NULL
);

-- SURAT HIMA (data asli/master ada di sini, mirror-nya dikirim ke BEM)
CREATE TABLE IF NOT EXISTS letter_hima (
    letter_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id  UUID NOT NULL REFERENCES organization(organization_id),
    letter_type_id   UUID REFERENCES letter_type(letter_type_id),
    title            VARCHAR(200) NOT NULL,
    description      TEXT,
    status           letter_status_enum NOT NULL DEFAULT 'DRAFT',
    created_at       TIMESTAMP NOT NULL DEFAULT now(),
    updated_at       TIMESTAMP NOT NULL DEFAULT now()
);

-- DRAFT PROPOSAL HIMA
CREATE TABLE IF NOT EXISTS draft_proposal_hima (
    proposal_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id  UUID NOT NULL REFERENCES organization(organization_id),
    title            VARCHAR(200) NOT NULL,
    activity_date    DATE NOT NULL,
    location         VARCHAR(150),
    status           proposal_status_enum NOT NULL DEFAULT 'DRAFT',
    created_at       TIMESTAMP NOT NULL DEFAULT now(),
    updated_at       TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS audit_log (
    log_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID,
    activity    TEXT NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS login_session (
    session_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES app_user(user_id),
    redis_key   VARCHAR(200) NOT NULL,
    expired_at  TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_letter_hima_org ON letter_hima(organization_id);
CREATE INDEX IF NOT EXISTS idx_draft_proposal_hima_org ON draft_proposal_hima(organization_id);