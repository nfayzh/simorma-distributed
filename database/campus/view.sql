
-- VIEW - NODE 1: KEMAHASISWAAN


-- View: rekap surat per organisasi
CREATE OR REPLACE VIEW v_letter_summary AS
SELECT
    o.organization_name,
    o.organization_type,
    l.status,
    COUNT(*) AS total_letter
FROM letter l
JOIN organization o ON o.organization_id = l.organization_id
GROUP BY o.organization_name, o.organization_type, l.status;

-- View: rekap proposal per organisasi
CREATE OR REPLACE VIEW v_proposal_summary AS
SELECT
    o.organization_name,
    o.organization_type,
    p.status,
    COUNT(*) AS total_proposal
FROM proposal p
JOIN organization o ON o.organization_id = p.organization_id
GROUP BY o.organization_name, o.organization_type, p.status;

-- View: kalender kegiatan lengkap
CREATE OR REPLACE VIEW v_calendar_full AS
SELECT
    ce.event_id,
    ce.event_name,
    ce.event_date,
    ce.location,
    p.title AS proposal_title,
    l.title AS letter_title
FROM calendar_event ce
LEFT JOIN proposal p ON p.proposal_id = ce.proposal_id
LEFT JOIN letter l ON l.letter_id = ce.letter_id
ORDER BY ce.event_date;

-- View: monitoring approval pending (surat & proposal)
CREATE OR REPLACE VIEW v_pending_approval AS
SELECT 'LETTER' AS jenis, l.letter_id AS ref_id, l.title, o.organization_name
FROM letter l
JOIN organization o ON o.organization_id = l.organization_id
WHERE l.status IN ('DIKIRIM', 'DISETUJUI_BEM')
UNION ALL
SELECT 'PROPOSAL' AS jenis, p.proposal_id AS ref_id, p.title, o.organization_name
FROM proposal p
JOIN organization o ON o.organization_id = p.organization_id
WHERE p.status = 'DIAJUKAN';