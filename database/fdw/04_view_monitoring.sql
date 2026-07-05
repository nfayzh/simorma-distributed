
-- VIEW MONITORING LINTAS NODE (via FDW) - dijalankan di NODE 1


CREATE OR REPLACE VIEW v_monitoring_semua_surat AS
SELECT 'BEM' AS asal_node, letter_id, organization_id, title, status, created_at FROM foreign_letter_bem
UNION ALL
SELECT 'HIMA' AS asal_node, letter_id, organization_id, title, status, created_at FROM foreign_letter_hima
UNION ALL
SELECT 'UKM' AS asal_node, letter_id, organization_id, title, status, created_at FROM foreign_letter_ukm
ORDER BY created_at DESC;

CREATE OR REPLACE VIEW v_monitoring_semua_proposal_draft AS
SELECT 'HIMA' AS asal_node, proposal_id, organization_id, title, activity_date, status FROM foreign_draft_proposal_hima
UNION ALL
SELECT 'UKM' AS asal_node, proposal_id, organization_id, title, activity_date, status FROM foreign_draft_proposal_ukm
UNION ALL
SELECT 'BEM' AS asal_node, proposal_id, organization_id, title, activity_date, status FROM foreign_draft_proposal_bem
ORDER BY activity_date;