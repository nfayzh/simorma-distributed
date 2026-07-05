
-- DEMO: LOGIN (jalankan di masing-masing node sesuai role)


--  Login sebagai Kemahasiswaan (Node 1) 
SELECT user_id, username, status
FROM app_user
WHERE username = 'admin_kemahasiswaan'
  AND password = crypt('kemahasiswaan123', password);

--  Login sebagai BEM (Node 2) 
SELECT user_id, username, status
FROM app_user
WHERE username = 'admin_bem'
  AND password = crypt('bem123', password);

--  Login sebagai HIMA (Node 3) 
SELECT user_id, username, status
FROM app_user
WHERE username = 'admin_hima'
  AND password = crypt('hima123', password);

--  Login sebagai UKM (Node 4) 
SELECT user_id, username, status
FROM app_user
WHERE username = 'admin_ukm'
  AND password = crypt('ukm123', password);

-- Jika hasil query mengembalikan 1 baris -> login berhasil.
-- (Simulasi: aplikasi backend akan membuat session di Redis, lihat redis.sql)