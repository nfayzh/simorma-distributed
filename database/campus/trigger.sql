
-- TRIGGER - NODE 1: KEMAHASISWAAN


-- Trigger: auto update updated_at
CREATE TRIGGER trg_organization_updated_at
BEFORE UPDATE ON organization
FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

CREATE TRIGGER trg_user_updated_at
BEFORE UPDATE ON app_user
FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

CREATE TRIGGER trg_letter_updated_at
BEFORE UPDATE ON letter
FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

CREATE TRIGGER trg_proposal_updated_at
BEFORE UPDATE ON proposal
FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();


-- Trigger utama: KALENDER OTOMATIS
-- Syarat: Surat APPROVED AND Proposal APPROVED -> muncul di kalender


CREATE OR REPLACE FUNCTION fn_generate_calendar_event()
RETURNS TRIGGER AS $$
DECLARE
    v_letter_id   UUID;
    v_proposal_id UUID;
    v_event_name  VARCHAR(200);
    v_event_date  DATE;
    v_location    VARCHAR(150);
BEGIN
    -- Trigger dipanggil dari LETTER_APPROVAL atau PROPOSAL_APPROVAL
    IF TG_TABLE_NAME = 'letter_approval' AND NEW.status = 'APPROVED' THEN
        SELECT l.letter_id, l.title INTO v_letter_id, v_event_name
        FROM letter l WHERE l.letter_id = NEW.letter_id;

        -- Cek apakah ada proposal terkait organisasi yg sama & sudah approved
        SELECT p.proposal_id, p.title, p.activity_date, p.location
        INTO v_proposal_id, v_event_name, v_event_date, v_location
        FROM proposal p
        JOIN letter l ON l.organization_id = p.organization_id
        WHERE l.letter_id = NEW.letter_id
          AND p.status = 'DISETUJUI'
        LIMIT 1;

        IF v_proposal_id IS NOT NULL THEN
            INSERT INTO calendar_event (event_id, proposal_id, letter_id, event_name, event_date, location)
            VALUES (gen_random_uuid(), v_proposal_id, v_letter_id, v_event_name, v_event_date, v_location);
        END IF;

    ELSIF TG_TABLE_NAME = 'proposal_approval' AND NEW.status = 'APPROVED' THEN
        SELECT p.proposal_id, p.title, p.activity_date, p.location
        INTO v_proposal_id, v_event_name, v_event_date, v_location
        FROM proposal p WHERE p.proposal_id = NEW.proposal_id;

        -- Cek apakah ada surat terkait organisasi yg sama & sudah disetujui
        SELECT l.letter_id INTO v_letter_id
        FROM letter l
        JOIN proposal p ON p.organization_id = l.organization_id
        WHERE p.proposal_id = NEW.proposal_id
          AND l.status = 'DISETUJUI'
        LIMIT 1;

        IF v_letter_id IS NOT NULL THEN
            INSERT INTO calendar_event (event_id, proposal_id, letter_id, event_name, event_date, location)
            VALUES (gen_random_uuid(), v_proposal_id, v_letter_id, v_event_name, v_event_date, v_location);
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calendar_from_letter_approval
AFTER INSERT OR UPDATE ON letter_approval
FOR EACH ROW EXECUTE FUNCTION fn_generate_calendar_event();

CREATE TRIGGER trg_calendar_from_proposal_approval
AFTER INSERT OR UPDATE ON proposal_approval
FOR EACH ROW EXECUTE FUNCTION fn_generate_calendar_event();

-- Trigger: kirim notifikasi saat status surat berubah
CREATE OR REPLACE FUNCTION fn_notify_letter_status_change()
RETURNS TRIGGER AS $$
DECLARE
    v_user_id UUID;
BEGIN
    IF NEW.status IS DISTINCT FROM OLD.status THEN
        SELECT user_id INTO v_user_id
        FROM app_user
        WHERE organization_id = NEW.organization_id
        LIMIT 1;

        IF v_user_id IS NOT NULL THEN
            PERFORM fn_create_notification(
                v_user_id,
                'Status surat "' || NEW.title || '" berubah menjadi ' || NEW.status
            );
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_notify_letter_status
AFTER UPDATE ON letter
FOR EACH ROW EXECUTE FUNCTION fn_notify_letter_status_change();