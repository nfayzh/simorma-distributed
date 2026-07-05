
-- GRANT UNTUK REPLICATION USER - dijalankan di NODE 1 (KEMAHASISWAAN)


GRANT SELECT ON organization, calendar_event, letter_approval, proposal_approval TO repl_user;
ALTER TABLE organization OWNER TO CURRENT_USER; -- pastikan owner tabel bisa publish