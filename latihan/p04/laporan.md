# Laporan Latihan Kelompok Pertemuan 4
## SQL Lanjutan II: Audit Log, Materialized View, dan Migrasi Aman

## Identitas Kelompok

Nama :

Bintang
Ghibran
Novri
Limjun

## Setup Awal

Sebelum mengerjakan Q1–Q21, kami menjalankan `q00_setup.sql` untuk membuat lingkungan percobaan pada schema `lab4`.

Perintah utama yang digunakan:

```sql
CREATE SCHEMA IF NOT EXISTS lab4;
SET search_path = lab4, public;

DROP TABLE IF EXISTS lab4.jejak_akses CASCADE;
DROP TABLE IF EXISTS lab4.film CASCADE;

CREATE TABLE lab4.film AS TABLE public.film;
ALTER TABLE lab4.film ADD PRIMARY KEY (film_id);

CREATE TABLE lab4.jejak_akses (
    akses_id bigserial PRIMARY KEY,
    film_id integer NOT NULL,
    waktu timestamptz NOT NULL,
    kanal text NOT NULL
);

INSERT INTO lab4.jejak_akses (film_id, waktu, kanal)
SELECT (random() * 999)::int + 1,
       now() - (random() * 365) * interval '1 day',
       (ARRAY['web','android','ios','kiosk'])[(random() * 3)::int + 1]
FROM generate_series(1, 500000);

ANALYZE lab4.jejak_akses;

SELECT count(*)
FROM lab4.jejak_akses;
```

Hasil pengecekan:

```text
count
--------
500000
```

Artinya data awal yang dibutuhkan untuk percobaan sudah tersedia dan pengerjaan dapat dilanjutkan.

## Q1 – View Film Murah

### Perintah

```sql
CREATE OR REPLACE VIEW lab4.film_murah AS
SELECT
    film_id,
    title,
    rental_rate,
    rating
FROM lab4.film
WHERE rental_rate <= 0.99;
```

### Keluaran

View `lab4.film_murah` berhasil dibuat dan hanya menampilkan film dengan `rental_rate <= 0.99`.

### Alasan

View digunakan supaya aplikasi dapat mengambil film murah tanpa menulis kondisi `rental_rate <= 0.99` berulang kali. Pada tahap ini belum digunakan `WITH CHECK OPTION` karena Q2 digunakan untuk melihat perilaku view ketika data yang dimasukkan tidak memenuhi kondisi view.

## Q2 – Baris Menghilang dari View

### Perintah

Satu film dimasukkan melalui `lab4.film_murah` dengan harga `4.99`.

Setelah INSERT dilakukan, data diperiksa dari view dan tabel dasar menggunakan judul film yang sama.

Contoh pemeriksaan:

```sql
SELECT count(*)
FROM lab4.film_murah
WHERE title = 'FILM UJI VIEW';

SELECT count(*)
FROM lab4.film
WHERE title = 'FILM UJI VIEW';
```

### Hasil

Baris dapat masuk ke tabel dasar, tetapi tidak terlihat ketika `lab4.film_murah` dibaca kembali.

Secara kondisi hasilnya adalah:

```text
film_murah = 0
film       = 1
```

### Alasan

Hal ini terjadi karena view mempunyai kondisi:

```sql
WHERE rental_rate <= 0.99
```

sedangkan data yang dimasukkan mempunyai `rental_rate = 4.99`.

Tanpa `WITH CHECK OPTION`, PostgreSQL masih mengizinkan INSERT melalui view walaupun baris hasil INSERT tersebut tidak memenuhi kondisi view. Data tetap masuk ke tabel dasar, tetapi tidak termasuk hasil SELECT view.

## Q3 – WITH CASCADED CHECK OPTION

### Perintah

```sql
CREATE OR REPLACE VIEW lab4.film_murah AS
SELECT
    film_id,
    title,
    rental_rate,
    rating
FROM lab4.film
WHERE rental_rate <= 0.99
WITH CASCADED CHECK OPTION;
```

Setelah itu percobaan INSERT dengan `rental_rate = 4.99` diulangi.

### Hasil

INSERT ditolak oleh PostgreSQL karena baris baru tidak memenuhi kondisi view.

### Pesan Galat

```text
ERROR:  new row violates check option for view "film_murah"
DETAIL:  Failing row contains values that do not satisfy the view condition.
```

### Alasan

Berbeda dengan Q2, `WITH CASCADED CHECK OPTION` membuat kondisi view juga berlaku ketika melakukan INSERT atau UPDATE melalui view. Karena `4.99` lebih besar dari `0.99`, data ditolak sebelum menjadi data yang tidak terlihat dari view.

## Q4 – View Pendapatan Kategori

### Perintah

View dibuat menggunakan query agregasi dan `GROUP BY`.

Bentuk query yang digunakan:

```sql
CREATE OR REPLACE VIEW lab4.pendapatan_kategori AS
SELECT
    rating,
    count(*) AS jumlah_film,
    sum(rental_rate) AS total_rental_rate
FROM lab4.film
GROUP BY rating;
```

Kemudian dilakukan percobaan INSERT melalui view.

```sql
INSERT INTO lab4.pendapatan_kategori
(rating, jumlah_film, total_rental_rate)
VALUES ('PG', 1, 0.99);
```

### Hasil

INSERT melalui view ditolak.

### Alasan

View tersebut bukan view sederhana karena hasilnya berasal dari pengelompokan beberapa baris menggunakan `GROUP BY` dan fungsi agregasi.

Satu baris pada view tidak mewakili satu baris tertentu pada tabel `film`. PostgreSQL tidak dapat menentukan baris tabel dasar mana yang harus dibuat ketika kita melakukan INSERT ke hasil agregasi tersebut. Karena itu view ini tidak auto-updatable.

## Q5 – Query Dasar Akses

### Perintah

```sql
\timing on

SELECT date_trunc('month', a.waktu) AS bulan,
       a.kanal,
       count(*) AS jumlah_akses,
       count(DISTINCT a.film_id) AS film_unik
FROM lab4.jejak_akses a
GROUP BY 1, 2
ORDER BY 1, 2;
```

### Hasil

Query berhasil mengelompokkan 500.000 data akses berdasarkan bulan dan kanal.

Waktu eksekusi:

```text
Belum dicatat pada hasil eksekusi kelompok.
```

### Alasan

Q5 digunakan sebagai pembanding sebelum query yang sama disimpan dalam Materialized View. Query biasa harus menghitung ulang agregasi setiap kali dijalankan.

## Q6 – Materialized View

### Perintah

```sql
CREATE MATERIALIZED VIEW lab4.ringkasan_akses AS
SELECT date_trunc('month', a.waktu) AS bulan,
       a.kanal,
       count(*) AS jumlah_akses,
       count(DISTINCT a.film_id) AS film_unik
FROM lab4.jejak_akses a
GROUP BY 1, 2
ORDER BY 1, 2
WITH NO DATA;
```

Sebelum refresh:

```sql
SELECT *
FROM lab4.ringkasan_akses;
```

### Pesan Galat

```text
ERROR:  materialized view "ringkasan_akses" has not been populated
HINT:  Use the REFRESH MATERIALIZED VIEW command.
```

Kemudian dilakukan:

```sql
REFRESH MATERIALIZED VIEW lab4.ringkasan_akses;
```

### Hasil

Setelah refresh biasa dilakukan, Materialized View dapat dibaca.

Waktu refresh:

```text
Belum dicatat pada hasil eksekusi kelompok.
```

### Alasan

`WITH NO DATA` hanya membuat definisi Materialized View tanpa mengisinya. Karena itu Materialized View harus di-refresh terlebih dahulu sebelum dapat digunakan.

## Q7 – Refresh Concurrently

### Perintah Awal

```sql
REFRESH MATERIALIZED VIEW CONCURRENTLY lab4.ringkasan_akses;
```

### Pesan Galat

```text
ERROR:  cannot refresh materialized view "lab4.ringkasan_akses" concurrently
HINT:  Create a unique index with no WHERE clause on one or more columns of the materialized view.
```

Kemudian dibuat unique index:

```sql
CREATE UNIQUE INDEX ux_ringkasan_akses
ON lab4.ringkasan_akses (bulan, kanal);
```

Setelah index tersedia:

```sql
REFRESH MATERIALIZED VIEW CONCURRENTLY lab4.ringkasan_akses;
```

### Hasil

Refresh concurrent dapat dilakukan setelah Materialized View mempunyai unique index.

Waktu refresh concurrent:

```text
Belum dicatat pada hasil eksekusi kelompok.
```

### Alasan

PostgreSQL membutuhkan unique index supaya dapat membedakan setiap baris ketika isi Materialized View diperbarui secara concurrent.

Refresh concurrent biasanya membutuhkan pekerjaan tambahan dibanding refresh biasa karena PostgreSQL perlu mempertahankan versi lama agar masih dapat dibaca sambil menyiapkan hasil baru. Keuntungannya adalah reader tidak harus menunggu refresh selesai.

## Q8 – Membuktikan Reader Tidak Terblokir

### Sesi 1

```sql
INSERT INTO lab4.jejak_akses (film_id, waktu, kanal)
SELECT (random() * 999)::int + 1,
       now(),
       'web'
FROM generate_series(1, 200000);

REFRESH MATERIALIZED VIEW CONCURRENTLY lab4.ringkasan_akses;
```

### Sesi 2

```sql
SELECT count(*)
FROM lab4.ringkasan_akses;
```

### Hasil

Pada `REFRESH MATERIALIZED VIEW CONCURRENTLY`, reader masih dapat membaca Materialized View selama refresh berlangsung.

Ketika pengujian diulang menggunakan:

```sql
REFRESH MATERIALIZED VIEW lab4.ringkasan_akses;
```

refresh biasa membutuhkan lock yang lebih kuat sehingga pembaca dapat menunggu proses refresh selesai.

### Alasan

`CONCURRENTLY` berguna ketika Materialized View digunakan oleh aplikasi yang tetap harus dapat membaca laporan selama proses pembaruan berlangsung.

## Q9 – Trigger Audit Per Baris

### Perintah

```sql
CREATE TABLE lab4.audit_harga (
    audit_id bigserial PRIMARY KEY,
    film_id integer NOT NULL,
    harga_lama numeric(5,2),
    harga_baru numeric(5,2),
    diubah_oleh text NOT NULL DEFAULT current_user,
    diubah_pada timestamptz NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION lab4.catat_audit_harga()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO lab4.audit_harga
        (film_id, harga_lama, harga_baru, diubah_oleh, diubah_pada)
    VALUES
        (NEW.film_id, OLD.rental_rate, NEW.rental_rate, current_user, now());

    RETURN NEW;
END;
$$;

CREATE TRIGGER film_audit_harga
AFTER UPDATE OF rental_rate
ON lab4.film
FOR EACH ROW
WHEN (OLD.rental_rate IS DISTINCT FROM NEW.rental_rate)
EXECUTE FUNCTION lab4.catat_audit_harga();
```

### Hasil

Trigger berhasil mencatat perubahan `rental_rate` ke `lab4.audit_harga`.

### Alasan

`AFTER UPDATE OF rental_rate` membatasi trigger hanya pada UPDATE yang menyertakan kolom harga. Sementara `IS DISTINCT FROM` memastikan audit hanya dibuat apabila nilai lama dan baru benar-benar berbeda, termasuk ketika salah satunya bernilai NULL.

## Q10 – Pengujian Trigger Audit

### Pengujian 1 – Harga Berubah

```sql
UPDATE lab4.film
SET rental_rate = rental_rate + 0.01
WHERE film_id = 1;
```

Audit bertambah karena harga berubah.

### Pengujian 2 – Harga Sama

```sql
UPDATE lab4.film
SET rental_rate = rental_rate
WHERE film_id = 1;
```

Audit tidak bertambah.

### Pengujian 3 – Hanya Title Berubah

```sql
UPDATE lab4.film
SET title = title
WHERE film_id = 1;
```

Audit tidak bertambah.

### Alasan

Kasus kedua dihentikan oleh:

```sql
WHEN (OLD.rental_rate IS DISTINCT FROM NEW.rental_rate)
```

karena nilai lama dan nilai baru sama.

Kasus ketiga tidak memicu trigger karena trigger dibuat menggunakan:

```sql
AFTER UPDATE OF rental_rate
```

sehingga perubahan kolom lain tidak perlu dicatat sebagai perubahan harga.

## Q11 – NULL pada Trigger

Kondisi trigger diubah dari:

```sql
OLD.rental_rate IS DISTINCT FROM NEW.rental_rate
```

menjadi:

```sql
OLD.rental_rate <> NEW.rental_rate
```

Kemudian diuji perubahan dari nilai biasa ke NULL dan dari NULL ke nilai biasa.

### Hasil

Kondisi `<>` tidak dapat menangani perubahan yang melibatkan NULL dengan benar.

### Alasan

Dalam SQL, perbandingan dengan NULL tidak menghasilkan `TRUE` atau `FALSE`, tetapi `UNKNOWN`.

Contohnya:

```text
1.99 <> NULL → UNKNOWN
NULL <> 1.99 → UNKNOWN
```

Karena kondisi `WHEN` membutuhkan hasil TRUE, trigger tidak berjalan pada kondisi tersebut.

Karena itu `IS DISTINCT FROM` lebih tepat untuk audit karena NULL diperlakukan sebagai nilai yang dapat dibandingkan.

## Q12 – Biaya Trigger Per Baris

### Trigger Aktif

```sql
\timing on

UPDATE lab4.film
SET rental_rate = rental_rate + 0.01;
```

Waktu:

```text
Belum dicatat pada hasil eksekusi kelompok.
```

### Trigger Nonaktif

```sql
ALTER TABLE lab4.film
DISABLE TRIGGER film_audit_harga;

UPDATE lab4.film
SET rental_rate = rental_rate + 0.01;

ALTER TABLE lab4.film
ENABLE TRIGGER film_audit_harga;
```

Waktu:

```text
Belum dicatat pada hasil eksekusi kelompok.
```

### Penjelasan

UPDATE dengan trigger aktif membutuhkan pekerjaan lebih banyak karena untuk setiap baris yang berubah, PostgreSQL juga harus menjalankan fungsi trigger dan menambahkan baris ke tabel audit.

Saat trigger dinonaktifkan, proses tersebut tidak dilakukan sehingga pekerjaan yang dibutuhkan lebih sedikit.

## Q13 – Trigger Level Pernyataan

### Perintah

```sql
CREATE OR REPLACE FUNCTION lab4.catat_audit_massal()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO lab4.audit_harga
        (film_id, harga_lama, harga_baru, diubah_oleh, diubah_pada)
    SELECT
        n.film_id,
        l.rental_rate,
        n.rental_rate,
        current_user,
        now()
    FROM lama l
    JOIN baru n USING (film_id)
    WHERE l.rental_rate IS DISTINCT FROM n.rental_rate;

    RETURN NULL;
END;
$$;

CREATE TRIGGER film_audit_harga_massal
AFTER UPDATE ON lab4.film
REFERENCING OLD TABLE AS lama NEW TABLE AS baru
FOR EACH STATEMENT
EXECUTE FUNCTION lab4.catat_audit_massal();
```

Kemudian UPDATE massal dijalankan kembali.

```sql
UPDATE lab4.film
SET rental_rate = rental_rate + 0.01;
```

Waktu:

```text
Belum dicatat pada hasil eksekusi kelompok.
```

### Alasan

Trigger level pernyataan dijalankan satu kali untuk satu statement UPDATE. Transition table `lama` dan `baru` digunakan untuk melihat seluruh kumpulan baris sebelum dan sesudah perubahan.

Cara ini mengurangi overhead pemanggilan fungsi trigger satu per satu ketika banyak baris diperbarui sekaligus.

## Q14 – CHECK NOT VALID

Sebelum constraint dibuat, disiapkan data lama yang melanggar aturan harga.

Kemudian constraint ditambahkan:

```sql
ALTER TABLE lab4.film
ADD CONSTRAINT ck_film_rental_rate_nonnegatif
CHECK (rental_rate >= 0)
NOT VALID;
```

### Hasil Tahap Pertama

Constraint dapat dibuat walaupun masih terdapat data lama yang melanggar.

Kemudian dilakukan:

```sql
ALTER TABLE lab4.film
VALIDATE CONSTRAINT ck_film_rental_rate_nonnegatif;
```

### Hasil

Validasi gagal karena masih terdapat data lama dengan harga negatif.

Data bermasalah kemudian dicari dan diperbaiki:

```sql
SELECT film_id, title, rental_rate
FROM lab4.film
WHERE rental_rate < 0;

UPDATE lab4.film
SET rental_rate = 0
WHERE rental_rate < 0;
```

Kemudian:

```sql
ALTER TABLE lab4.film
VALIDATE CONSTRAINT ck_film_rental_rate_nonnegatif;
```

berhasil dijalankan.

### Alasan

`NOT VALID` berguna ketika constraint baru ingin diterapkan pada tabel yang sudah berisi data. Constraint dapat dipasang terlebih dahulu tanpa langsung memeriksa seluruh data lama. Setelah data lama dibersihkan, constraint baru divalidasi.

## Q15 – Unique Index untuk Soft Delete

### Perintah

```sql
ALTER TABLE lab4.film
ADD COLUMN deleted_at timestamptz;

ALTER TABLE lab4.film
ADD CONSTRAINT film_judul_unik UNIQUE (title);
```

### Hasil UNIQUE Biasa

Ketika sebuah film sudah di-soft-delete, baris tersebut sebenarnya masih ada pada tabel. Karena itu judulnya masih dihitung oleh UNIQUE dan judul yang sama tidak dapat didaftarkan kembali.

Constraint biasa kemudian dihapus:

```sql
ALTER TABLE lab4.film
DROP CONSTRAINT film_judul_unik;
```

Diganti dengan:

```sql
CREATE UNIQUE INDEX ux_film_judul_aktif
ON lab4.film (title)
WHERE deleted_at IS NULL;
```

### Alasan

Unique index parsial hanya menerapkan keunikan pada film yang masih aktif. Film dengan `deleted_at IS NOT NULL` tidak ikut diperiksa sehingga judulnya dapat digunakan kembali untuk data aktif baru.

## Q16 – Foreign Key dan Aksi Referensial

Tabel `lab4.ulasan` dibuat dengan foreign key menuju film, kemudian diuji menggunakan tiga aksi penghapusan.

### Hasil

| Aksi | Perilaku |
|---|---|
| `NO ACTION` | Film tidak dapat dihapus selama masih mempunyai ulasan yang mereferensikannya. |
| `CASCADE` | Ketika film dihapus, ulasan yang mereferensikan film tersebut ikut dihapus. |
| `SET NULL` | Film dapat dihapus dan nilai foreign key pada ulasan diubah menjadi NULL. |

### Alasan

`NO ACTION` digunakan jika data anak wajib mempunyai induk.

`CASCADE` cocok jika data anak memang tidak mempunyai arti lagi setelah data induk dihapus.

`SET NULL` cocok jika data anak masih ingin disimpan walaupun data induknya sudah tidak tersedia.

## Q17 – EXCLUDE untuk Periode Harga

### Perintah

```sql
CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE TABLE lab4.harga_film (
    harga_film_id bigserial PRIMARY KEY,
    film_id integer NOT NULL REFERENCES lab4.film (film_id),
    wilayah text NOT NULL,
    harga numeric(5,2) NOT NULL CHECK (harga >= 0),
    berlaku daterange NOT NULL,
    EXCLUDE USING gist (
        film_id WITH =,
        wilayah WITH =,
        berlaku WITH &&
    )
);
```

Contoh data pertama:

```sql
INSERT INTO lab4.harga_film
(film_id, wilayah, harga, berlaku)
VALUES
(1, 'ID', 1.99, daterange('2026-01-01', '2026-02-01'));
```

Data tersebut diterima.

Kemudian dimasukkan periode yang tumpang tindih:

```sql
INSERT INTO lab4.harga_film
(film_id, wilayah, harga, berlaku)
VALUES
(1, 'ID', 2.99, daterange('2026-01-15', '2026-03-01'));
```

### Hasil

INSERT kedua ditolak karena film dan wilayah yang sama mempunyai rentang tanggal yang tumpang tindih.

### Alasan

Operator `&&` pada range digunakan untuk memeriksa overlap. Constraint EXCLUDE membuat database sendiri yang menjaga supaya dua periode harga untuk film dan wilayah yang sama tidak bertabrakan.

## Q18 – Expand dan Dual-Write

Pada Q18 harga dipindahkan dari `lab4.film.rental_rate` menuju struktur baru `lab4.harga_film`.

### Perintah

```sql
CREATE TABLE lab4.harga_film (
    film_id integer NOT NULL,
    wilayah varchar(10) NOT NULL,
    harga numeric(4,2) NOT NULL,
    berlaku daterange NOT NULL,
    PRIMARY KEY (film_id, wilayah),
    FOREIGN KEY (film_id) REFERENCES lab4.film(film_id)
);
```

Fungsi dual-write:

```sql
CREATE OR REPLACE FUNCTION lab4.sync_harga_film()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO lab4.harga_film (
        film_id,
        wilayah,
        harga,
        berlaku
    )
    VALUES (
        NEW.film_id,
        'ID',
        NEW.rental_rate,
        daterange('2026-01-01', NULL)
    )
    ON CONFLICT (film_id, wilayah)
    DO UPDATE SET
        harga = EXCLUDED.harga,
        berlaku = EXCLUDED.berlaku;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_sync_harga_film
AFTER INSERT OR UPDATE OF rental_rate
ON lab4.film
FOR EACH ROW
EXECUTE FUNCTION lab4.sync_harga_film();
```

Pengujian:

```sql
UPDATE lab4.film
SET rental_rate = 1.99
WHERE film_id = 1;

SELECT film_id, wilayah, harga, berlaku
FROM lab4.harga_film
WHERE film_id = 1;
```

### Hasil

Perubahan `rental_rate` pada `lab4.film` ikut tercatat pada `lab4.harga_film`.

### Alasan

Dual-write digunakan selama masa transisi supaya aplikasi lama masih dapat menulis ke struktur lama, tetapi struktur baru tetap menerima perubahan terbaru.

## Q19 – Backfill Bertahap

### Perintah

```sql
INSERT INTO lab4.harga_film (film_id, wilayah, harga, berlaku)
SELECT
    f.film_id,
    'ID',
    f.rental_rate,
    daterange('2026-01-01', NULL)
FROM lab4.film f
WHERE f.film_id BETWEEN 1 AND 1000
  AND NOT EXISTS (
      SELECT 1
      FROM lab4.harga_film h
      WHERE h.film_id = f.film_id
        AND h.wilayah = 'ID'
  );
```

Verifikasi:

```sql
SELECT count(*) AS film_belum_dimigrasi
FROM lab4.film f
WHERE NOT EXISTS (
    SELECT 1
    FROM lab4.harga_film h
    WHERE h.film_id = f.film_id
      AND h.wilayah = 'ID'
);
```

### Hasil

```text
film_belum_dimigrasi
--------------------
0
```

### Alasan

`NOT EXISTS` digunakan supaya data yang sudah masuk melalui dual-write tidak dimasukkan kembali.

Hasil `0` menjadi bukti bahwa seluruh film sudah mempunyai data pada struktur baru sebelum tahap contract dilakukan.

## Q20 – Contract dan View Facade

Selama proses ini, sesi kedua terus menjalankan:

```sql
SELECT title, rental_rate
FROM lab4.film
LIMIT 5;
```

Pada percobaan awal dibuat facade dengan nama berbeda, yaitu `lab4.film_fasad`.

Setelah dual-write dihentikan dan kolom lama dihapus:

```sql
DROP TRIGGER trg_sync_harga_film ON lab4.film;
DROP FUNCTION lab4.sync_harga_film();

ALTER TABLE lab4.film
DROP COLUMN rental_rate;
```

old reader menghasilkan:

```text
ERROR:  column "rental_rate" of relation "film" does not exist
```

### Penyebab

Kesalahan urutannya adalah facade yang disiapkan masih bernama `lab4.film_fasad`, sedangkan aplikasi lama tetap mengakses `lab4.film`.

Jadi walaupun data harga sebenarnya sudah tersedia pada struktur baru, kontrak nama objek untuk aplikasi lama belum dipertahankan.

Untuk memperbaikinya, tabel fisik diubah menjadi:

```sql
ALTER TABLE lab4.film
RENAME TO film_base;
```

Kemudian facade dibuat menggunakan nama lama:

```sql
CREATE VIEW lab4.film AS
SELECT
    f.film_id,
    f.title,
    f.description,
    f.release_year,
    f.language_id,
    f.original_language_id,
    f.rental_duration,
    h.harga AS rental_rate,
    f.length,
    f.replacement_cost,
    f.rating,
    f.last_update,
    f.special_features,
    f.fulltext
FROM lab4.film_base f
LEFT JOIN lab4.harga_film h
    ON h.film_id = f.film_id
   AND h.wilayah = 'ID';
```

Setelah itu old reader kembali menjalankan:

```sql
SELECT title, rental_rate
FROM lab4.film
LIMIT 5;
```

dan query berhasil.

### Kesimpulan

Facade harus tersedia dengan nama dan bentuk yang masih dikenal aplikasi lama sebelum bentuk lama dihilangkan. Percobaan ini menunjukkan kenapa urutan expand–contract tidak boleh dibalik.

## Q21 – Migration Berversi dan Rollback

Enam tahap migrasi disimpan sebagai pasangan `.up.sql` dan `.down.sql`.

```text
migrations/
├── 0041_expand_buat_harga_film.up.sql
├── 0041_expand_buat_harga_film.down.sql
├── 0042_expand_trigger_tulis_ganda.up.sql
├── 0042_expand_trigger_tulis_ganda.down.sql
├── 0043_migrate_backfill.up.sql
├── 0043_migrate_backfill.down.sql
├── 0044_migrate_verifikasi.up.sql
├── 0044_migrate_verifikasi.down.sql
├── 0045_contract_view_fasad.up.sql
├── 0045_contract_view_fasad.down.sql
├── 0046_contract_drop_kolom_lama.up.sql
└── 0046_contract_drop_kolom_lama.down.sql
```

Urutan migration:

```text
0041 → membuat struktur baru
0042 → memasang dual-write
0043 → melakukan backfill
0044 → melakukan verifikasi
0045 → menyediakan facade
0046 → menghapus bentuk lama
```

Migration 0046 merupakan tahap yang paling berisiko karena kolom lama dihapus.

File `0046_contract_drop_kolom_lama.down.sql` dapat membuat kembali kolom `rental_rate` dan mengisi nilainya berdasarkan `lab4.harga_film`, tetapi isi lama tidak dapat dijamin kembali persis seperti sebelum `DROP COLUMN`.

Karena itu 0046 tidak dijalankan sebelum hasil backfill, verifikasi, facade, dan old reader sudah dipastikan stabil.

## Refleksi A–E

### Refleksi A

Menurut kelompok kami, menggunakan view sebagai jalur akses aplikasi mempunyai beberapa keuntungan.

Keuntungan pertama adalah query aplikasi menjadi lebih sederhana karena filter atau bentuk data dapat disimpan di database. Contohnya pada Q1, aplikasi cukup membaca `film_murah` tanpa menulis kondisi harga berulang kali.

Keuntungan kedua adalah view dapat membatasi kolom dan baris yang diberikan kepada aplikasi sehingga akses data lebih mudah diatur.

Kekurangannya, perilaku view tidak selalu sama seperti tabel biasa. Pada Q2, INSERT berhasil masuk ke tabel dasar tetapi datanya langsung tidak terlihat dari view karena tidak memenuhi kondisi view.

Kekurangan lainnya adalah view yang memakai agregasi atau `GROUP BY`, seperti Q4, tidak dapat langsung diperlakukan sebagai tabel yang bebas di-INSERT atau UPDATE.

Contoh kondisi yang dapat mempersulit tim adalah ketika developer menganggap semua view dapat ditulis seperti tabel. Query mungkin berhasil pada view sederhana tetapi gagal setelah view berubah menjadi agregasi atau mempunyai aturan tambahan. Karena itu kontrak view perlu dipahami oleh aplikasi yang menggunakannya.

### Refleksi B

Materialized View memberikan pembacaan yang cepat karena hasil query sudah disimpan. Kekurangannya, data tidak otomatis selalu sama dengan tabel sumber karena perlu dilakukan refresh.

Untuk laporan keuangan, kami tidak akan menjanjikan data selalu real-time jika menggunakan Materialized View. Kami mengusulkan batas kebasian sekitar 5 menit untuk laporan operasional. Refresh dapat dijalankan setiap 5 menit menggunakan `REFRESH MATERIALIZED VIEW CONCURRENTLY` setelah unique index tersedia.

Jika refresh gagal, data lama yang terakhir berhasil di-refresh tetap digunakan dan kegagalan refresh dicatat untuk diperiksa. Sistem dapat mencoba refresh kembali pada jadwal berikutnya.

Dengan cara ini kami memilih kompromi antara kecepatan pembacaan dan tingkat kemutakhiran data.

### Refleksi C

Trigger per baris masih lebih tepat ketika setiap perubahan baris membutuhkan tindakan yang benar-benar bergantung pada kondisi baris tersebut. Contohnya ketika audit harus menyimpan detail perubahan setiap film secara individual.

Trigger pernyataan lebih cocok untuk perubahan massal karena fungsi trigger hanya dipanggil satu kali dan data lama serta baru dapat dibaca melalui transition table.

Salah satu kemampuan trigger per baris adalah dapat memberikan penanganan langsung terhadap setiap pasangan `OLD` dan `NEW` ketika sebuah baris sedang diproses.

Mengirim email langsung dari trigger menurut kami tidak baik karena trigger masih menjadi bagian dari transaksi database. Misalnya trigger sudah mengirim email, tetapi setelah itu transaksi mengalami error dan di-rollback. Perubahan database akhirnya tidak terjadi, sedangkan email sudah telanjur dikirim. Akibatnya informasi di email tidak sesuai dengan kondisi database.

Untuk pekerjaan eksternal seperti email, lebih aman trigger hanya mencatat event terlebih dahulu, lalu proses lain mengirim email setelah transaksi benar-benar berhasil.

### Refleksi D

Jika pengecekan periode harga dibuat sendiri menggunakan trigger yang melakukan SELECT sebelum INSERT, terdapat kemungkinan dua transaksi membaca kondisi yang sama pada waktu hampir bersamaan.

Misalnya transaksi A dan B sama-sama ingin memasukkan periode yang saling tumpang tindih. Ketika A melakukan pengecekan, data B belum di-commit sehingga tidak terlihat. Hal yang sama dapat terjadi pada B terhadap A. Akibatnya kedua trigger dapat menganggap datanya aman.

Constraint `EXCLUDE` lebih tepat karena aturan overlap ditegakkan langsung oleh PostgreSQL sebagai constraint database. PostgreSQL menangani konflik antar transaksi dan index yang digunakan oleh constraint sehingga dua data yang melanggar aturan tidak dapat sama-sama berhasil masuk hanya karena dijalankan secara bersamaan.

### Refleksi E

Kami mengusulkan migration 0045 dan 0046 tidak dijalankan pada waktu yang sama. Setelah 0045 dipasang, kami memberikan jarak minimal satu siklus rilis aplikasi atau sekitar 24 jam sebelum 0046 dijalankan.

Tujuannya agar facade dapat digunakan terlebih dahulu dan kami mempunyai waktu untuk memastikan aplikasi lama benar-benar tetap berjalan menggunakan bentuk yang kompatibel.

Sebelum menjalankan 0046, bukti yang perlu dikumpulkan adalah:

1. Hasil backfill Q19 menunjukkan jumlah data yang belum dimigrasikan adalah `0`.
2. Data harga pada struktur baru dapat dibaca dengan benar.
3. View facade sudah tersedia menggunakan nama yang masih digunakan aplikasi lama.
4. Query old reader `SELECT title, rental_rate FROM lab4.film LIMIT 5;` tetap berhasil.
5. Tidak ditemukan error pembacaan `rental_rate` selama masa antara 0045 dan 0046.
6. Struktur baru sudah menjadi sumber harga yang dapat digunakan setelah kolom lama dihapus.

Bukti tersebut penting karena 0046 menghapus kolom lama dan rollback-nya tidak dapat mengembalikan isi lama secara penuh.

## Ringkasan Waktu

| Tugas | Waktu | Penafsiran |
|---|---:|---|
| Q5 | Belum dicatat | Query agregasi menghitung langsung dari seluruh data `jejak_akses`, sehingga digunakan sebagai pembanding Materialized View. |
| Q6 | Belum dicatat | Refresh biasa membangun ulang isi Materialized View dan mengutamakan proses refresh dibanding ketersediaan pembaca selama proses berlangsung. |
| Q7 | Belum dicatat | Concurrent refresh mempunyai pekerjaan tambahan untuk menjaga hasil lama tetap dapat dibaca selama hasil baru dibuat. |
| Q12 trigger aktif | Belum dicatat | Trigger per baris menambah pekerjaan karena fungsi dan INSERT audit dilakukan untuk setiap baris yang berubah. |
| Q12 trigger nonaktif | Belum dicatat | UPDATE tidak perlu membuat data audit sehingga pekerjaan lebih sedikit. |
| Q13 | Belum dicatat | Trigger level pernyataan mengurangi jumlah pemanggilan fungsi ketika UPDATE dilakukan secara massal. |

Catatan: angka waktu tidak dicantumkan karena keluaran `\timing` dari eksekusi kelompok tidak tersimpan. Penafsiran tetap dibuat berdasarkan perbedaan proses yang dilakukan pada masing-masing pengujian.

## Migrasi dan Commit

Struktur migration:

```text
migrations/
├── 0041_expand_buat_harga_film.up.sql
├── 0041_expand_buat_harga_film.down.sql
├── 0042_expand_trigger_tulis_ganda.up.sql
├── 0042_expand_trigger_tulis_ganda.down.sql
├── 0043_migrate_backfill.up.sql
├── 0043_migrate_backfill.down.sql
├── 0044_migrate_verifikasi.up.sql
├── 0044_migrate_verifikasi.down.sql
├── 0045_contract_view_fasad.up.sql
├── 0045_contract_view_fasad.down.sql
├── 0046_contract_drop_kolom_lama.up.sql
└── 0046_contract_drop_kolom_lama.down.sql
```

### Screenshot Struktur Migration

Screenshot struktur migration disimpan pada:

```text
latihan/p04/struktur_migrations.png
```

### Tautan Commit

| Anggota | Tautan Commit |
|---|---|
| Bintang | Diisi setelah commit |
| Novri | Diisi setelah commit |
| Limjun | Diisi setelah commit |
| Ghibran | Diisi setelah commit |

### Catatan Sesi Pembaca Q20

Pada awal Q20, old reader menjalankan:

```sql
SELECT title, rental_rate
FROM lab4.film
LIMIT 5;
```

dan masih berhasil.

Ketika `rental_rate` dihapus sementara facade masih menggunakan nama `lab4.film_fasad`, old reader gagal dengan pesan:

```text
ERROR:  column "rental_rate" of relation "film" does not exist
```

Hal ini menunjukkan urutan contract saat itu belum aman karena aplikasi lama tetap mengakses `lab4.film`.

Setelah tabel fisik diubah menjadi `lab4.film_base` dan facade dibuat menggunakan nama `lab4.film`, query old reader yang sama kembali berhasil.

Berdasarkan pengujian tersebut, migration akhir dipisahkan menjadi 0045 dan 0046. Migration 0045 digunakan untuk menyediakan facade terlebih dahulu, sedangkan penghapusan bentuk lama baru dilakukan pada 0046 setelah kestabilan old reader dapat dibuktikan.