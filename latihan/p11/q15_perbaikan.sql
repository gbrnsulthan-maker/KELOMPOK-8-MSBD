-- Q15: perbaikan dengan query berparameter (versi psql)
-- Mode "aman" di rentan.py mengirim masukan sebagai parameter.
-- Di psql, itu ditiru dengan PREPARE dan EXECUTE.

BEGIN;
SET LOCAL ROLE app_portal;
SET LOCAL app.tenant = '1';

PREPARE cari_aman(text) AS
  SELECT id, nama, kota FROM lab11.pelanggan WHERE nama ILIKE $1 LIMIT 100;

-- Kontrol: "Pelanggan 12". Hasil: 100 baris.
EXECUTE cari_aman('%Pelanggan 12%');

-- Payload 1: zz' OR '1'='1' --
-- Di dalam literal SQL, kutip tunggal ditulis dua kali (''). Hasil: 0 baris.
EXECUTE cari_aman('%zz'' OR ''1''=''1'' --%');

-- Payload 2: zz' UNION SELECT '1', nama_pengguna, peran_aplikasi FROM lab11.akun --
-- Hasil: 0 baris, tidak ada data dari akun.
EXECUTE cari_aman('%zz'' UNION SELECT ''1'', nama_pengguna, peran_aplikasi FROM lab11.akun --%');

DEALLOCATE cari_aman;
COMMIT;