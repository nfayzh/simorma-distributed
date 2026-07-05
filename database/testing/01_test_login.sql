
-- TEST: LOGIN & VERIFIKASI PASSWORD
-- Jalankan di masing-masing node


SELECT user_id, username, status
FROM app_user
WHERE username = 'admin_hima'
  AND password = crypt('hima123', password);