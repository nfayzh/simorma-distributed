
-- VIEW - NODE 2: BEM


-- Gabungan semua surat yang perlu diapprove BEM (dari HIMA & UKM)
CREATE OR REPLACE VIEW v_letter_masuk_bem AS
SELECT 'HIMA' AS asal, letter_id, organization_id, title, status, created_at FROM foreign_letter_hima
UNION ALL
SELECT 'UKM' AS asal, letter_id, organization_id, title, status, created_at FROM foreign_letter_ukm
ORDER BY created_at DESC;

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