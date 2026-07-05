-- ROLE UNTUK FDW
DO $$ BEGIN
    CREATE ROLE fdw_reader WITH LOGIN PASSWORD 'fdw_pass123';
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ROLE UNTUK LOGICAL REPLICATION
DO $$ BEGIN
    CREATE ROLE repl_user WITH LOGIN REPLICATION PASSWORD 'repl_pass123';
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- Grant akan diberikan per-tabel setelah schema tiap node dibuat
-- (lihat database/fdw/*.sql dan database/replication/*.sql)