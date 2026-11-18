-- Q17: second-order injection
-- Definisi laporan_kota_rentan dan laporan_kota_aman tidak ada di teks modul yang tersedia.

-- 1. Tabel penyimpan status laporan (dibuat sebagai pemilik skema)
BEGIN;
SET LOCAL ROLE skema_owner;
CREATE TABLE IF NOT EXISTS lab11.status_laporan (
  id serial PRIMARY KEY,
  status text NOT NULL
);
TRUNCATE lab11.status_laporan RESTART IDENTITY;
GRANT SELECT, INSERT ON lab11.status_laporan TO app_write;
GRANT USAGE ON SEQUENCE lab11.status_laporan_id_seq TO app_write;
COMMIT;

-- 2. Dua fungsi laporan: satu menyambung teks, satu memakai parameter
BEGIN;
SET LOCAL ROLE skema_owner;

CREATE OR REPLACE FUNCTION lab11.laporan_kota_rentan()
RETURNS TABLE (kota_hasil text, jumlah_hasil bigint)
LANGUAGE plpgsql AS $$
DECLARE
  s text;
  q text;
BEGIN
  SELECT status INTO s FROM lab11.status_laporan ORDER BY id DESC LIMIT 1;
  -- RENTAN: nilai dari tabel disambung langsung ke teks SQL
  q := 'SELECT p.kota, count(*) FROM lab11.pelanggan p WHERE p.kota = ''' || s || ''' GROUP BY p.kota';
  RAISE NOTICE 'SQL: %', q;
  RETURN QUERY EXECUTE q;
END $$;

CREATE OR REPLACE FUNCTION lab11.laporan_kota_aman()
RETURNS TABLE (kota_hasil text, jumlah_hasil bigint)
LANGUAGE plpgsql AS $$
DECLARE
  s text;
BEGIN
  SELECT status INTO s FROM lab11.status_laporan ORDER BY id DESC LIMIT 1;
  -- AMAN: nilai dikirim sebagai parameter $1
  RETURN QUERY EXECUTE
    'SELECT p.kota, count(*) FROM lab11.pelanggan p WHERE p.kota = $1 GROUP BY p.kota'
    USING s;
END $$;
COMMIT;

-- 3. Kontrol: status biasa "Medan". Kedua fungsi harus memberi hasil yang sama.
BEGIN;
SET LOCAL ROLE app_portal;
SET LOCAL app.tenant = '1';
PREPARE simpan_status(text) AS INSERT INTO lab11.status_laporan (status) VALUES ($1);
EXECUTE simpan_status('Medan');
DEALLOCATE simpan_status;
SELECT * FROM lab11.laporan_kota_rentan();
SELECT * FROM lab11.laporan_kota_aman();
COMMIT;

-- 4. Second-order: simpan status berbahaya lewat INSERT berparameter
BEGIN;
SET LOCAL ROLE app_portal;
SET LOCAL app.tenant = '1';
PREPARE simpan_status(text) AS INSERT INTO lab11.status_laporan (status) VALUES ($1);
EXECUTE simpan_status('Medan'' OR ''1''=''1');
DEALLOCATE simpan_status;
SELECT status AS status_tersimpan FROM lab11.status_laporan ORDER BY id DESC LIMIT 1;
SELECT * FROM lab11.laporan_kota_rentan();
SELECT * FROM lab11.laporan_kota_aman();
COMMIT;