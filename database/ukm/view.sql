
-- VIEW - NODE 4: UKM


CREATE OR REPLACE VIEW v_letter_ukm_status AS
SELECT letter_id, title, status, created_at
FROM letter_ukm
ORDER BY created_at DESC;

CREATE OR REPLACE VIEW v_proposal_ukm_status AS
SELECT proposal_id, title, activity_date, status
FROM draft_proposal_ukm
ORDER BY activity_date;