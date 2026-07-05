
-- CEK STATUS REPLIKASI


-- Dijalankan di Node 1 (Publisher): melihat subscriber yang terhubung
SELECT * FROM pg_stat_replication;

-- Dijalankan di Node 2/3/4 (Subscriber): melihat status subscription
SELECT subname, pid, received_lsn, latest_end_lsn, latest_end_time
FROM pg_stat_subscription;

-- Melihat daftar publication
SELECT * FROM pg_publication;

-- Melihat daftar subscription
SELECT * FROM pg_subscription;