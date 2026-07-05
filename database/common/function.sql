--  FUNCTION: auto update timestamp 
CREATE OR REPLACE FUNCTION fn_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--  FUNCTION: buat notifikasi otomatis 
CREATE OR REPLACE FUNCTION fn_create_notification(
    p_user_id UUID,
    p_message TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO notification (notification_id, user_id, message, status, created_at)
    VALUES (gen_random_uuid(), p_user_id, p_message, 'UNREAD', now());
EXCEPTION WHEN undefined_table THEN
    -- tabel notification hanya ada di Node 1, abaikan di node lain
    NULL;
END;
$$ LANGUAGE plpgsql;