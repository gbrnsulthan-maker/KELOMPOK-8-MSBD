-- Q19: Hash password menggunakan bcrypt dan salt.
-- Keputusan: bcrypt karena dirancang untuk hashing password.
-- Alternatif: MD5 karena terlalu cepat untuk penyimpanan password.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

SELECT
 crypt('contoh-password',gen_salt('bf',8)) AS hash_1,
 crypt('contoh-password',gen_salt('bf',8)) AS hash_2;

-- Verifikasi password menggunakan crypt.
WITH data AS (
 SELECT crypt('contoh-password',gen_salt('bf',8)) AS hash_password
)
SELECT crypt('contoh-password',hash_password)=hash_password AS password_valid
FROM data;

-- Q20: Perbandingan cost bcrypt dan MD5.
-- Keputusan: bcrypt dengan cost yang sesuai kapasitas server.
-- Alternatif: memilih hash hanya berdasarkan kecepatan.
SELECT clock_timestamp() AS mulai_cost_6;
SELECT crypt('uji',gen_salt('bf',6));
SELECT clock_timestamp() AS mulai_cost_10;
SELECT crypt('uji',gen_salt('bf',10));
SELECT md5('uji') AS md5_pembanding;

-- Q21: Enkripsi rekening.
-- Keputusan: pgp_sym_encrypt untuk data yang perlu didekripsi kembali.
-- Alternatif: menyimpan data sensitif dalam teks biasa.
SET app.kunci_kolom = 'kunci-lab11-jangan-dipakai-produksi';

ALTER TABLE lab11.pelanggan
ADD COLUMN IF NOT EXISTS rekening_enc bytea;

UPDATE lab11.pelanggan
SET rekening_enc=pgp_sym_encrypt(
 rekening,current_setting('app.kunci_kolom')
)
WHERE id BETWEEN 1 AND 1000;

SELECT id,
 pgp_sym_decrypt(rekening_enc,current_setting('app.kunci_kolom')) AS rekening
FROM lab11.pelanggan
WHERE id=1 AND rekening_enc IS NOT NULL;

SELECT
 pgp_sym_encrypt('nilai-sama','kunci-uji') =
 pgp_sym_encrypt('nilai-sama','kunci-uji') AS ciphertext_sama;

-- Q22: Pengamatan aktivitas database dari sesi lain.
-- Keputusan: membatasi akses statistik dan melindungi secret.
-- Alternatif: menganggap enkripsi menyembunyikan seluruh metadata.
SELECT pid,usename,application_name,state,
 wait_event_type,wait_event,left(query,250) AS query_terlihat
FROM pg_stat_activity
WHERE datname=current_database()
AND pid<>pg_backend_pid();

-- Q23: View masking.
-- Keputusan: aplikasi analitik hanya membaca view tersamar.
-- Alternatif: memberi akses langsung ke tabel pelanggan.
CREATE OR REPLACE VIEW lab11.v_pelanggan_samar
WITH (security_barrier=true) AS
SELECT id,tenant_id,
 left(nama,1)||repeat('*',greatest(length(nama)-1,1)) AS nama,
 'xxxxxxxxxxxx'||right(nik,4) AS nik,
 regexp_replace(surel,'^[^@]+','****') AS surel,
 date_trunc('year',lahir)::date AS lahir_tahun,
 kota,round(saldo,-5) AS saldo_bulat
FROM lab11.pelanggan;

REVOKE ALL ON lab11.pelanggan FROM PUBLIC;
REVOKE ALL ON lab11.v_pelanggan_samar FROM PUBLIC;
GRANT SELECT ON lab11.v_pelanggan_samar TO app_analitik;

-- Q24: Risiko identifikasi ulang.
-- Keputusan: menggeneralisasi tanggal lahir ke tahun.
-- Alternatif: menganggap masking satu atribut sudah cukup.
SELECT count(DISTINCT (kota,lahir)) AS kombinasi_awal
FROM lab11.pelanggan;

SELECT count(DISTINCT (kota,date_trunc('year',lahir))) AS kombinasi_setelah_generalisasi
FROM lab11.pelanggan;

SELECT kota,date_trunc('year',lahir)::date AS tahun_lahir,
 count(*) AS jumlah
FROM lab11.pelanggan
GROUP BY kota,date_trunc('year',lahir)
ORDER BY jumlah ASC
LIMIT 20;

-- Q25: Audit perubahan pelanggan.
-- Keputusan: session_user digunakan untuk mencatat login pemanggil.
-- Alternatif: current_user pada SECURITY DEFINER.
CREATE OR REPLACE FUNCTION lab11.rekam_audit()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path=pg_catalog,lab11
AS $$
BEGIN
 IF TG_OP='UPDATE' THEN
  INSERT INTO lab11.jejak_audit
  (aktor,aksi,tabel_target,kunci,nilai_lama,nilai_baru)
  VALUES
  (session_user,TG_OP,TG_TABLE_SCHEMA||'.'||TG_TABLE_NAME,
   OLD.id::text,to_jsonb(OLD),to_jsonb(NEW));
  RETURN NEW;
 ELSIF TG_OP='DELETE' THEN
  INSERT INTO lab11.jejak_audit
  (aktor,aksi,tabel_target,kunci,nilai_lama,nilai_baru)
  VALUES
  (session_user,TG_OP,TG_TABLE_SCHEMA||'.'||TG_TABLE_NAME,
   OLD.id::text,to_jsonb(OLD),NULL);
  RETURN OLD;
 END IF;
 RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_audit_pelanggan ON lab11.pelanggan;

CREATE TRIGGER trg_audit_pelanggan
AFTER UPDATE OR DELETE ON lab11.pelanggan
FOR EACH ROW EXECUTE FUNCTION lab11.rekam_audit();

REVOKE ALL ON lab11.jejak_audit
FROM PUBLIC,app_portal,app_analitik;

-- Q26: Uji audit menggunakan transaksi yang dapat dibatalkan.
-- Keputusan: menggunakan ROLLBACK agar data uji tidak berubah permanen.
-- Alternatif: mengubah data secara permanen ketika pengujian.
BEGIN;
UPDATE lab11.pelanggan SET kota='Kota Uji' WHERE id=3;
DELETE FROM lab11.pelanggan WHERE id=4;
SELECT id,waktu,aktor,aksi,tabel_target,kunci
FROM lab11.jejak_audit ORDER BY id DESC LIMIT 10;
ROLLBACK;

-- Q27: Pemeriksaan anomali audit.
-- Keputusan: memeriksa aktor, waktu, dan frekuensi aktivitas.
-- Alternatif: menyimpulkan anomali dari satu indikator.
SELECT aktor,count(*) AS jumlah_aksi
FROM lab11.jejak_audit
GROUP BY aktor ORDER BY jumlah_aksi DESC;

SELECT aktor,count(*) AS aktivitas_luar_jam
FROM lab11.jejak_audit
WHERE extract(hour FROM waktu AT TIME ZONE 'Asia/Jakarta')<7
   OR extract(hour FROM waktu AT TIME ZONE 'Asia/Jakarta')>=19
GROUP BY aktor;

SELECT date_trunc('hour',waktu) AS jam,aksi,count(*) AS jumlah
FROM lab11.jejak_audit
GROUP BY 1,2 ORDER BY 1 DESC;

-- Q28: Tenggat penghapusan 72 jam.
-- Keputusan: DEFAULT now()+interval, bukan GENERATED.
-- Alternatif: generated column berbasis waktu yang tidak immutable.
CREATE TABLE IF NOT EXISTS lab11.permintaan_hapus (
 id bigint GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
 pelanggan_id integer NOT NULL,
 diminta_pada timestamptz NOT NULL DEFAULT now(),
 tenggat timestamptz NOT NULL DEFAULT (now()+interval '72 hours'),
 status text NOT NULL DEFAULT 'diterima'
);

INSERT INTO lab11.permintaan_hapus(pelanggan_id)
VALUES (12),(13);

SELECT * FROM lab11.permintaan_hapus
ORDER BY id DESC LIMIT 5;

-- Q29: Simulasi penghapusan pelanggan.
-- Keputusan: mencatat permintaan, menghapus transaksi, lalu pelanggan.
-- Alternatif: menghapus pelanggan sebelum menangani foreign key.
-- Hanya simulasi: perubahan dibatalkan dengan ROLLBACK.
BEGIN;
INSERT INTO lab11.permintaan_hapus(pelanggan_id) VALUES (12),(13);
DELETE FROM lab11.transaksi WHERE pelanggan_id IN (12,13);
DELETE FROM lab11.pelanggan WHERE id IN (12,13);

SELECT count(*) AS sisa_pelanggan
FROM lab11.pelanggan WHERE id IN (12,13);

SELECT count(*) AS sisa_transaksi
FROM lab11.transaksi WHERE pelanggan_id IN (12,13);
ROLLBACK;
