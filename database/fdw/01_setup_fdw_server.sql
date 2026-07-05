
-- FDW SETUP - dijalankan di NODE 1 (KEMAHASISWAAN)
-- Tujuan: membaca tabel LETTER dari Node BEM, HIMA, UKM tanpa copy data


-- Pastikan ekstensi sudah ada
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

--  SERVER: BEM 
CREATE SERVER IF NOT EXISTS server_bem
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'node2-bem', port '5432', dbname 'db_bem');

--  SERVER: HIMA 
CREATE SERVER IF NOT EXISTS server_hima
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'node3-hima', port '5432', dbname 'db_hima');

--  SERVER: UKM 
CREATE SERVER IF NOT EXISTS server_ukm
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'node4-ukm', port '5432', dbname 'db_ukm');

--  USER MAPPING 
CREATE USER MAPPING IF NOT EXISTS FOR CURRENT_USER
    SERVER server_bem
    OPTIONS (user 'fdw_reader', password 'fdw_pass123');

CREATE USER MAPPING IF NOT EXISTS FOR CURRENT_USER
    SERVER server_hima
    OPTIONS (user 'fdw_reader', password 'fdw_pass123');

CREATE USER MAPPING IF NOT EXISTS FOR CURRENT_USER
    SERVER server_ukm
    OPTIONS (user 'fdw_reader', password 'fdw_pass123');