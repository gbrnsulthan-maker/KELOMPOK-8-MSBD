-- ============================================
-- Q3: DEFAULT PRIVILEGES
-- ============================================

-- Mengatur hak akses default untuk tabel baru
ALTER DEFAULT PRIVILEGES
FOR ROLE msbd
IN SCHEMA p11
GRANT SELECT, INSERT, UPDATE, DELETE
ON TABLES
TO p11_pengujian;

-- Membuat tabel baru untuk pengujian
CREATE TABLE p11.data_default (
    id SERIAL PRIMARY KEY,
    nama VARCHAR(100) NOT NULL
);

-- Memeriksa hak akses role penguji
SELECT
    has_table_privilege(
        'p11_pengujian',
        'p11.data_default',
        'SELECT'
    ) AS hak_select,
    has_table_privilege(
        'p11_pengujian',
        'p11.data_default',
        'INSERT'
    ) AS hak_insert,
    has_table_privilege(
        'p11_pengujian',
        'p11.data_default',
        'UPDATE'
    ) AS hak_update,
    has_table_privilege(
        'p11_pengujian',
        'p11.data_default',
        'DELETE'
    ) AS hak_delete;