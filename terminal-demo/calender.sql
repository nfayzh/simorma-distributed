
-- DEMO: KALENDER KEGIATAN OTOMATIS
-- Syarat: Surat APPROVED AND Proposal APPROVED -> muncul otomatis


--  Jalankan di NODE 1 (KEMAHASISWAAN) 

-- Cek kalender kegiatan (harus sudah terisi otomatis dari approval.sql)
SELECT * FROM v_calendar_full;

-- Detail lengkap kalender + relasi surat & proposal
SELECT
    ce.event_id,
    ce.event_name,
    ce.event_date,
    ce.location,
    l.status AS status_surat,
    p.status AS status_proposal
FROM calendar_event ce
LEFT JOIN letter l ON l.letter_id = ce.letter_id
LEFT JOIN proposal p ON p.proposal_id = ce.proposal_id
ORDER BY ce.event_date;

--  Verifikasi replikasi kalender ke node lain 
-- Jalankan di NODE 2 (BEM), NODE 3 (HIMA), NODE 4 (UKM):
SELECT * FROM calendar_event ORDER BY event_date;
-- Data ini seharusnya sama persis di semua node (hasil logical replication)