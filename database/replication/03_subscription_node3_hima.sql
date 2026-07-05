
-- LOGICAL REPLICATION - SUBSCRIPTION di NODE 3 (HIMA)


CREATE SUBSCRIPTION sub_hima_from_kemahasiswaan
    CONNECTION 'host=node1-kemahasiswaan port=5432 dbname=db_kemahasiswaan user=repl_user password=repl_pass123'
    PUBLICATION pub_kemahasiswaan_to_all
    WITH (copy_data = false, create_slot = true);

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