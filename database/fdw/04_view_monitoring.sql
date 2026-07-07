
CREATE OR REPLACE FUNCTION fn_monitoring_semua_surat()
RETURNS TABLE (asal_node TEXT, letter_id UUID, organization_id UUID, title VARCHAR, status TEXT, created_at TIMESTAMP) AS $$
BEGIN
    BEGIN
        RETURN QUERY SELECT 'BEM'::TEXT, f.letter_id, f.organization_id, f.title, f.status::TEXT, f.created_at FROM foreign_letter_bem f;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Node BEM tidak dapat diakses: %', SQLERRM;
    END;
    BEGIN
        RETURN QUERY SELECT 'HIMA'::TEXT, f.letter_id, f.organization_id, f.title, f.status::TEXT, f.created_at FROM foreign_letter_hima f;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Node HIMA tidak dapat diakses: %', SQLERRM;
    END;
    BEGIN
        RETURN QUERY SELECT 'UKM'::TEXT, f.letter_id, f.organization_id, f.title, f.status::TEXT, f.created_at FROM foreign_letter_ukm f;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Node UKM tidak dapat diakses: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fn_monitoring_semua_proposal_draft()
RETURNS TABLE (asal_node TEXT, proposal_id UUID, organization_id UUID, title VARCHAR, activity_date DATE, status TEXT) AS $$
BEGIN
    BEGIN
        RETURN QUERY SELECT 'HIMA'::TEXT, f.proposal_id, f.organization_id, f.title, f.activity_date, f.status::TEXT FROM foreign_draft_proposal_hima f;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Node HIMA tidak dapat diakses: %', SQLERRM;
    END;
    BEGIN
        RETURN QUERY SELECT 'UKM'::TEXT, f.proposal_id, f.organization_id, f.title, f.activity_date, f.status::TEXT FROM foreign_draft_proposal_ukm f;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Node UKM tidak dapat diakses: %', SQLERRM;
    END;
    BEGIN
        RETURN QUERY SELECT 'BEM'::TEXT, f.proposal_id, f.organization_id, f.title, f.activity_date, f.status::TEXT FROM foreign_draft_proposal_bem f;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Node BEM tidak dapat diakses: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;