
-- GRANT AKSES fdw_reader - dijalankan di NODE 4 (UKM)
-- Diperlukan agar Node 1 (Kemahasiswaan) dan Node 2 (BEM) bisa
-- membaca/update data surat UKM secara real-time via FDW


GRANT USAGE ON SCHEMA public TO fdw_reader;
GRANT SELECT, UPDATE ON letter_ukm TO fdw_reader;
GRANT SELECT ON draft_proposal_ukm TO fdw_reader;