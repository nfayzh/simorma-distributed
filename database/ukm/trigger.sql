
-- TRIGGER - NODE 4: UKM


CREATE TRIGGER trg_letter_ukm_updated_at
BEFORE UPDATE ON letter_ukm
FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

CREATE TRIGGER trg_proposal_ukm_updated_at
BEFORE UPDATE ON draft_proposal_ukm
FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

-- Trigger: saat surat dikirim (status DRAFT -> DIKIRIM), catat audit lokal
CREATE OR REPLACE FUNCTION fn_log_letter_ukm_sent()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status = 'DRAFT' AND NEW.status = 'DIKIRIM' THEN
        INSERT INTO audit_log (log_id, user_id, activity, created_at)
        VALUES (gen_random_uuid(), NULL, 'Surat UKM "' || NEW.title || '" dikirim ke BEM', now());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_letter_ukm_sent
AFTER UPDATE ON letter_ukm
FOR EACH ROW EXECUTE FUNCTION fn_log_letter_ukm_sent();