
-- LOGICAL REPLICATION - PUBLICATION di NODE 1 (KEMAHASISWAAN)
-- Data yang direplikasi ke semua node: ORGANIZATION, CALENDAR_EVENT,
-- status approval final (LETTER_APPROVAL, PROPOSAL_APPROVAL)


CREATE PUBLICATION pub_kemahasiswaan_to_all
    FOR TABLE organization, calendar_event, letter_approval, proposal_approval;

-- Pastikan wal_level = logical sudah diset di postgresql.conf (lihat docker/postgres/)