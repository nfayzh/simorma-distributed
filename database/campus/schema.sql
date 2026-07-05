
-- NODE 1: KEMAHASISWAAN (MASTER NODE)
-- Menyimpan: User Kemahasiswaan, Organisasi, Proposal, Approval Final,
--            Kalender, Master Surat, Jenis Surat


--  ROLE 
CREATE TABLE IF NOT EXISTS role (
    role_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_name   VARCHAR(50) NOT NULL UNIQUE
);

--  ORGANIZATION 
CREATE TABLE IF NOT EXISTS organization (
    organization_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_name   VARCHAR(100) NOT NULL,
    organization_type   organization_type_enum NOT NULL,
    node_location        VARCHAR(50) NOT NULL, -- 'bem' | 'hima' | 'ukm'
    created_at           TIMESTAMP NOT NULL DEFAULT now(),
    updated_at           TIMESTAMP NOT NULL DEFAULT now()
);

--  USER (Kemahasiswaan) 
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

--  LETTER_TYPE (Master Jenis Surat) 
CREATE TABLE IF NOT EXISTS letter_type (
    letter_type_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type_name       VARCHAR(100) NOT NULL UNIQUE
);

--  LETTER (Master Surat - hasil agregasi via FDW/replication) 
-- Tabel ini menampung surat yang SUDAH final disetujui Kemahasiswaan.
-- Data mentah surat per-organisasi tetap tersimpan di node masing-masing (BEM/HIMA/UKM).
CREATE TABLE IF NOT EXISTS letter (
    letter_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id  UUID NOT NULL REFERENCES organization(organization_id),
    letter_type_id   UUID NOT NULL REFERENCES letter_type(letter_type_id),
    title            VARCHAR(200) NOT NULL,
    description      TEXT,
    status           letter_status_enum NOT NULL DEFAULT 'DRAFT',
    created_at       TIMESTAMP NOT NULL DEFAULT now(),
    updated_at       TIMESTAMP NOT NULL DEFAULT now()
);

--  LETTER_APPROVAL (Approval Final oleh Kemahasiswaan) 
CREATE TABLE IF NOT EXISTS letter_approval (
    approval_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    letter_id        UUID NOT NULL REFERENCES letter(letter_id),
    approved_by      UUID NOT NULL REFERENCES app_user(user_id),
    approval_level   VARCHAR(30) NOT NULL DEFAULT 'KEMAHASISWAAN',
    status           approval_status_enum NOT NULL DEFAULT 'PENDING',
    approval_date    TIMESTAMP
);

--  PROPOSAL 
CREATE TABLE IF NOT EXISTS proposal (
    proposal_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    organization_id  UUID NOT NULL REFERENCES organization(organization_id),
    title            VARCHAR(200) NOT NULL,
    activity_date    DATE NOT NULL,
    location         VARCHAR(150),
    status           proposal_status_enum NOT NULL DEFAULT 'DRAFT',
    created_at       TIMESTAMP NOT NULL DEFAULT now(),
    updated_at       TIMESTAMP NOT NULL DEFAULT now()
);

--  PROPOSAL_APPROVAL 
CREATE TABLE IF NOT EXISTS proposal_approval (
    proposal_approval_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proposal_id           UUID NOT NULL REFERENCES proposal(proposal_id),
    approved_by           UUID NOT NULL REFERENCES app_user(user_id),
    status                approval_status_enum NOT NULL DEFAULT 'PENDING',
    approval_date         TIMESTAMP
);

--  CALENDAR_EVENT 
CREATE TABLE IF NOT EXISTS calendar_event (
    event_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    proposal_id   UUID REFERENCES proposal(proposal_id),
    letter_id     UUID REFERENCES letter(letter_id),
    event_name    VARCHAR(200) NOT NULL,
    event_date    DATE NOT NULL,
    location      VARCHAR(150),
    created_at    TIMESTAMP NOT NULL DEFAULT now()
);

--  NOTIFICATION 
CREATE TABLE IF NOT EXISTS notification (
    notification_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id          UUID NOT NULL REFERENCES app_user(user_id),
    message          TEXT NOT NULL,
    status           notification_status_enum NOT NULL DEFAULT 'UNREAD',
    created_at       TIMESTAMP NOT NULL DEFAULT now()
);

--  AUDIT_LOG (fallback lokal, audit utama di MongoDB) 
CREATE TABLE IF NOT EXISTS audit_log (
    log_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID,
    activity    TEXT NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT now()
);

--  LOGIN_SESSION (fallback lokal, sesi utama di Redis) 
CREATE TABLE IF NOT EXISTS login_session (
    session_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES app_user(user_id),
    redis_key   VARCHAR(200) NOT NULL,
    expired_at  TIMESTAMP NOT NULL
);

--  INDEXES 
CREATE INDEX IF NOT EXISTS idx_letter_org ON letter(organization_id);
CREATE INDEX IF NOT EXISTS idx_proposal_org ON proposal(organization_id);
CREATE INDEX IF NOT EXISTS idx_calendar_date ON calendar_event(event_date);
CREATE INDEX IF NOT EXISTS idx_user_org ON app_user(organization_id);