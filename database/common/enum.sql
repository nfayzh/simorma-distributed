-- ENUM TYPES

DO $$ BEGIN
    CREATE TYPE organization_type_enum AS ENUM ('BEM', 'HIMA', 'UKM');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE letter_status_enum AS ENUM ('DRAFT', 'DIKIRIM', 'DISETUJUI_BEM', 'DISETUJUI', 'DITOLAK');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE proposal_status_enum AS ENUM ('DRAFT', 'DIAJUKAN', 'DISETUJUI', 'DITOLAK');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE approval_status_enum AS ENUM ('PENDING', 'APPROVED', 'REJECTED');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE user_status_enum AS ENUM ('ACTIVE', 'INACTIVE', 'SUSPENDED');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
    CREATE TYPE notification_status_enum AS ENUM ('UNREAD', 'READ');
EXCEPTION WHEN duplicate_object THEN NULL; END $$;