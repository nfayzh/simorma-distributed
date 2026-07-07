CREATE OR REPLACE FUNCTION fn_letter_masuk_bem()
RETURNS TABLE (asal TEXT, letter_id UUID, organization_id UUID, title VARCHAR, status letter_status_enum, created_at TIMESTAMP) AS $$
BEGIN
    BEGIN
        RETURN QUERY SELECT 'HIMA'::TEXT, f.letter_id, f.organization_id, f.title, f.status, f.created_at FROM foreign_letter_hima f;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Node HIMA tidak dapat diakses: %', SQLERRM;
    END;
    BEGIN
        RETURN QUERY SELECT 'UKM'::TEXT, f.letter_id, f.organization_id, f.title, f.status, f.created_at FROM foreign_letter_ukm f;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Node UKM tidak dapat diakses: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;
