-- Q16: pengenal daftar putih
-- Bagian yang tidak bisa diparameterkan: nama kolom dan arah urut.

BEGIN;
SET LOCAL ROLE app_portal;
SET LOCAL app.tenant = '1';

-- A. Diterima: kolom dan arah ada di daftar putih
SELECT id, nama, kota, dibuat_pada FROM lab11.pelanggan
WHERE nama ILIKE '%Pelanggan 12%'
ORDER BY dibuat_pada DESC
LIMIT 5;

-- B. Nama kolom lewat parameter: PostgreSQL menganggapnya konstanta, bukan nama kolom
PREPARE urut_param(text) AS
  SELECT id, nama, kota FROM lab11.pelanggan
  WHERE nama ILIKE '%Pelanggan 12%'
  ORDER BY $1::text DESC
  LIMIT 5;
EXECUTE urut_param('dibuat_pada');
DEALLOCATE urut_param;

COMMIT;