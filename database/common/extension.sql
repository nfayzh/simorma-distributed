-- Ekstensi yang dibutuhkan di setiap node
CREATE EXTENSION IF NOT EXISTS pgcrypto;      -- untuk gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";   -- alternatif uuid generator
CREATE EXTENSION IF NOT EXISTS postgres_fdw;  -- hanya wajib di Node 1 (Kemahasiswaan)