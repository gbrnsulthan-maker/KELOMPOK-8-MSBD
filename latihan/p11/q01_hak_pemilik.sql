-- ============================================
-- Q1: HAK PEMILIK TABEL
-- ============================================

-- Menampilkan pengguna yang sedang terhubung
SELECT current_user AS pengguna_saat_ini;

-- Memeriksa pemilik tabel
SELECT
    schemaname,
    tablename,
    tableowner
FROM pg_tables
WHERE schemaname = 'p11'
  AND tablename = 'data_pengujian';

-- Memeriksa hak akses pemilik tabel
SELECT
    has_table_privilege(current_user, 'p11.data_pengujian', 'SELECT') AS hak_select,
    has_table_privilege(current_user, 'p11.data_pengujian', 'INSERT') AS hak_insert,
    has_table_privilege(current_user, 'p11.data_pengujian', 'UPDATE') AS hak_update,
    has_table_privilege(current_user, 'p11.data_pengujian', 'DELETE') AS hak_delete,
    has_table_privilege(current_user, 'p11.data_pengujian', 'TRUNCATE') AS hak_truncate,
    has_table_privilege(current_user, 'p11.data_pengujian', 'REFERENCES') AS hak_references,
    has_table_privilege(current_user, 'p11.data_pengujian', 'TRIGGER') AS hak_trigger;