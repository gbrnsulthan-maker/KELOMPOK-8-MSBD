-- ============================================
-- Q4: GRANT OPTION DAN REVOKE CASCADE
-- ============================================

-- Membuat role penerima
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_roles WHERE rolname = 'p11_penerima'
    ) THEN
        CREATE ROLE p11_penerima LOGIN PASSWORD 'penerima_p11';
    END IF;
END
$$;

-- Memberikan hak SELECT dengan GRANT OPTION
GRANT SELECT
ON p11.data_pengujian
TO p11_pengujian
WITH GRANT OPTION;

-- Role penguji meneruskan hak SELECT
SET ROLE p11_pengujian;

GRANT SELECT
ON p11.data_pengujian
TO p11_penerima;

RESET ROLE;

-- Memeriksa hak akses kedua role
SELECT
    has_table_privilege(
        'p11_pengujian',
        'p11.data_pengujian',
        'SELECT'
    ) AS hak_pengujian,
    has_table_privilege(
        'p11_penerima',
        'p11.data_pengujian',
        'SELECT'
    ) AS hak_penerima;

-- Mencabut hak SELECT dengan CASCADE
REVOKE SELECT
ON p11.data_pengujian
FROM p11_pengujian
CASCADE;

-- Memeriksa kembali hak akses
SELECT
    has_table_privilege(
        'p11_pengujian',
        'p11.data_pengujian',
        'SELECT'
    ) AS hak_pengujian,
    has_table_privilege(
        'p11_penerima',
        'p11.data_pengujian',
        'SELECT'
    ) AS hak_penerima;