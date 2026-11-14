-- ============================================
-- Q2: HAK DROP DAN ALTER
-- ============================================

-- Membuat role penguji
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_roles WHERE rolname = 'p11_pengujian'
    ) THEN
        CREATE ROLE p11_pengujian LOGIN PASSWORD 'uji_p11';
    END IF;
END
$$;

-- Memberikan hak akses schema
GRANT USAGE ON SCHEMA p11 TO p11_pengujian;

-- Memberikan hak akses tabel
GRANT SELECT, INSERT, UPDATE, DELETE
ON p11.data_pengujian
TO p11_pengujian;

-- Memeriksa pemilik tabel
SELECT
    tablename,
    tableowner
FROM pg_tables
WHERE schemaname = 'p11'
  AND tablename = 'data_pengujian';

-- Memeriksa hak akses dasar role penguji
SELECT
    has_table_privilege(
        'p11_pengujian',
        'p11.data_pengujian',
        'SELECT'
    ) AS hak_select,
    has_table_privilege(
        'p11_pengujian',
        'p11.data_pengujian',
        'INSERT'
    ) AS hak_insert,
    has_table_privilege(
        'p11_pengujian',
        'p11.data_pengujian',
        'UPDATE'
    ) AS hak_update,
    has_table_privilege(
        'p11_pengujian',
        'p11.data_pengujian',
        'DELETE'
    ) AS hak_delete;

-- Membandingkan pemilik tabel dengan role penguji
SELECT
    pg_get_userbyid(c.relowner) AS pemilik_tabel,
    r.rolname AS role_penguji,
    (c.relowner = r.oid) AS apakah_penguji_pemilik
FROM pg_class c
CROSS JOIN pg_roles r
WHERE c.oid = 'p11.data_pengujian'::regclass
  AND r.rolname = 'p11_pengujian';