
-- VIEW - NODE 3: HIMA


CREATE OR REPLACE VIEW v_letter_hima_status AS
SELECT letter_id, title, status, created_at
FROM letter_hima
ORDER BY created_at DESC;

CREATE OR REPLACE VIEW v_proposal_hima_status AS
SELECT proposal_id, title, activity_date, status
FROM draft_proposal_hima
ORDER BY activity_date;