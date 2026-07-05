
-- TRIGGER - NODE 2: BEM


CREATE TRIGGER trg_letter_bem_updated_at
BEFORE UPDATE ON letter_bem
FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

CREATE TRIGGER trg_letter_hima_updated_at
BEFORE UPDATE ON letter_hima
FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

CREATE TRIGGER trg_letter_ukm_updated_at
BEFORE UPDATE ON letter_ukm
FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

CREATE TRIGGER trg_proposal_bem_updated_at
BEFORE UPDATE ON draft_proposal_bem
FOR EACH ROW EXECUTE FUNCTION fn_set_updated_at();

-- Trigger: saat BEM approve surat HIMA/UKM, update status jadi DISETUJUI_BEM
CREATE OR REPLACE FUNCTION fn_approve_bem_letter()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'APPROVED' THEN
        IF NEW.source_table = 'letter_hima' THEN
            UPDATE foreign_letter_hima SET status = 'DISETUJUI_BEM' WHERE letter_id = NEW.letter_id;
        ELSIF NEW.source_table = 'letter_ukm' THEN
            UPDATE foreign_letter_ukm SET status = 'DISETUJUI_BEM' WHERE letter_id = NEW.letter_id;
        END IF;
    ELSIF NEW.status = 'REJECTED' THEN
        IF NEW.source_table = 'letter_hima' THEN
            UPDATE foreign_letter_hima SET status = 'DITOLAK' WHERE letter_id = NEW.letter_id;
        ELSIF NEW.source_table = 'letter_ukm' THEN
            UPDATE foreign_letter_ukm SET status = 'DITOLAK' WHERE letter_id = NEW.letter_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_approval_bem_process
AFTER INSERT OR UPDATE ON approval_bem
FOR EACH ROW EXECUTE FUNCTION fn_approve_bem_letter();