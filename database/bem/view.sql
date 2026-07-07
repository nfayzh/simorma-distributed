-- Rekap surat BEM sendiri
CREATE OR REPLACE VIEW v_letter_bem_summary AS
SELECT status, COUNT(*) AS total
FROM letter_bem
GROUP BY status;

-- Surat yang masih pending approval BEM
CREATE OR REPLACE VIEW v_pending_approval_bem AS
SELECT ab.approval_id, ab.source_table, ab.letter_id, ab.status, ab.approval_date
FROM approval_bem ab
WHERE ab.status = 'PENDING';

