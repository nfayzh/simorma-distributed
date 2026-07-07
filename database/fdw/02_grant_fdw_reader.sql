
-- GRANT AKSES FDW READER - dijalankan di NODE 2 (BEM)


GRANT USAGE ON SCHEMA public TO fdw_reader;
GRANT SELECT ON letter_bem, letter_hima, letter_ukm TO fdw_reader;