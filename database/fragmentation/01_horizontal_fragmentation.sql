
-- FRAGMENTASI HORIZONTAL
-- LETTER dan PROPOSAL dipecah berdasarkan organisasi (BEM / HIMA / UKM)
-- Implementasi: setiap organisasi punya tabel surat & draft proposal
-- sendiri di node masing-masing (letter_bem, letter_hima, letter_ukm,
-- draft_proposal_hima, draft_proposal_ukm)


-- Ilustrasi constraint check fragmentasi (opsional, didemokan di Node 1
-- menggunakan PostgreSQL declarative partitioning sebagai simulasi
-- konsep fragmentasi horizontal pada tabel LETTER pusat)

-- Contoh alternatif jika ingin mendemokan native partitioning di Node 1:
-- (tidak wajib dipakai karena fragmentasi fisik sudah dilakukan
--  lewat pemisahan tabel per-node, ini hanya untuk pembelajaran)

CREATE TABLE IF NOT EXISTS letter_partitioned (
    letter_id        UUID NOT NULL,
    organization_id  UUID NOT NULL,
    organization_type organization_type_enum NOT NULL,
    title            VARCHAR(200) NOT NULL,
    status           letter_status_enum NOT NULL DEFAULT 'DRAFT',
    created_at       TIMESTAMP NOT NULL DEFAULT now(),
    PRIMARY KEY (letter_id, organization_type)
) PARTITION BY LIST (organization_type);

CREATE TABLE IF NOT EXISTS letter_partitioned_bem
    PARTITION OF letter_partitioned FOR VALUES IN ('BEM');

CREATE TABLE IF NOT EXISTS letter_partitioned_hima
    PARTITION OF letter_partitioned FOR VALUES IN ('HIMA');

CREATE TABLE IF NOT EXISTS letter_partitioned_ukm
    PARTITION OF letter_partitioned FOR VALUES IN ('UKM');

-- Query ke tabel induk otomatis mengarah ke partisi yang sesuai
-- SELECT * FROM letter_partitioned WHERE organization_type = 'HIMA';