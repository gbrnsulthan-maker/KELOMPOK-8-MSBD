# LAPORAN Latihan PERTEMUAN 2
## Dari Kebutuhan ke Skema Berversi

## Domain
**Sistem Peminjaman Alat Laboratorium**

## 1. Domain dan Alasan Pemilihan

Kelompok memilih **Sistem Peminjaman Alat Laboratorium** karena domain ini memiliki proses bisnis yang jelas serta hubungan data yang cukup kompleks untuk diterapkan pada latihan basis data.

Sistem perlu mengelola anggota laboratorium, kategori alat, alat, unit fisik alat, transaksi peminjaman, detail unit yang dipinjam, petugas, riwayat perbaikan, serta data peran.

Domain ini juga memiliki hubungan banyak-ke-banyak antara Peminjaman dan Unit Alat yang diuraikan melalui Detail Peminjaman.

Dengan domain ini, kelompok dapat menerapkan perancangan kebutuhan data, ERD konseptual, migration, perubahan skema secara bertahap, seed data, serta pengamatan aktivitas database PostgreSQL.

## 2. Ringkasan Lingkup Sistem

Sistem mencakup:

- Pendataan anggota laboratorium.
- Pendataan kategori alat.
- Pendataan alat dan unit fisik alat.
- Peminjaman dan pengembalian alat.
- Pencatatan kondisi unit alat.
- Riwayat perbaikan unit alat.
- Pendataan petugas.
- Pengelolaan data peran.

Sistem tidak mencakup:

- Proses pengadaan alat.
- Pembayaran denda secara online.
- Sistem akademik mahasiswa.
- Jadwal perkuliahan.
- Penggajian petugas.
- Pembelian suku cadang.

Batasan tersebut dibuat agar sistem berfokus pada pengelolaan inventaris alat laboratorium dan proses peminjamannya.

## 3. Ringkasan Kebutuhan Data

Kelompok menyusun sembilan kebutuhan data sebagai berikut:

1. KD-01 Data Anggota
2. KD-02 Data Kategori Alat
3. KD-03 Data Alat
4. KD-04 Data Unit Alat
5. KD-05 Data Peminjaman
6. KD-06 Detail Peminjaman
7. KD-07 Data Petugas
8. KD-08 Riwayat Perbaikan
9. KD-09 Data Peran

### KD-01 Data Anggota

Sistem membutuhkan data anggota yang memiliki hak untuk melakukan peminjaman alat. Data yang disimpan meliputi nomor anggota, nama, email, status, dan tanggal bergabung.

Nomor anggota dan email harus unik. Selain itu, hanya anggota dengan status aktif yang dapat melakukan peminjaman.

### KD-02 Data Kategori Alat

Kategori alat digunakan untuk mengelompokkan alat yang tersedia di laboratorium.

Data yang dibutuhkan meliputi kode kategori, nama kategori, dan deskripsi. Kode kategori harus unik dan setiap alat harus memiliki kategori.

### KD-03 Data Alat

Data alat digunakan untuk menyimpan jenis alat yang dimiliki laboratorium.

Data yang disimpan meliputi kode alat, nama alat, kategori, dan deskripsi. Setiap kode alat harus unik dan satu jenis alat dapat mempunyai lebih dari satu unit fisik.

### KD-04 Data Unit Alat

Unit alat digunakan untuk mencatat barang fisik dari suatu jenis alat.

Data yang dibutuhkan meliputi kode unit, alat, kondisi, dan status ketersediaan. Setiap kode unit harus unik. Unit yang sedang dipinjam atau diperbaiki tidak dapat dipinjam kembali.

### KD-05 Data Peminjaman

Data peminjaman digunakan untuk mencatat transaksi peminjaman yang dilakukan anggota.

Data yang disimpan meliputi nomor peminjaman, anggota, tanggal pinjam, jatuh tempo, tanggal kembali, dan status.

Peminjaman hanya dapat dilakukan oleh anggota aktif dan tanggal jatuh tempo tidak boleh lebih awal dari tanggal pinjam.

### KD-06 Detail Peminjaman

Detail peminjaman digunakan untuk mencatat unit alat yang terdapat dalam setiap transaksi peminjaman.

Satu transaksi dapat memiliki beberapa unit alat. Satu unit alat hanya boleh berada pada satu peminjaman aktif pada waktu yang sama.

### KD-07 Data Petugas

Data petugas digunakan untuk menyimpan informasi petugas laboratorium yang melayani transaksi.

Data yang disimpan meliputi nomor petugas, nama, email, dan status. Nomor petugas harus unik dan hanya petugas aktif yang dapat melayani transaksi.

### KD-08 Riwayat Perbaikan

Riwayat perbaikan digunakan untuk mencatat proses perbaikan unit alat yang mengalami kerusakan.

Data yang disimpan meliputi unit alat, tanggal mulai, tanggal selesai, keterangan, dan status.

Unit yang sedang dalam proses perbaikan harus memiliki status tidak tersedia sehingga tidak dapat digunakan dalam transaksi peminjaman.

### KD-09 Data Peran

Data peran digunakan untuk menyimpan peran dasar pengguna sistem.

Data yang disimpan meliputi kode dan nama peran. Setiap kode peran harus unik.

## 4. ERD Konseptual

ERD konseptual terdiri dari entitas:

1. Anggota
2. Kategori
3. Alat
4. Unit Alat
5. Peminjaman
6. Detail Peminjaman
7. Petugas
8. Perbaikan

Kategori memiliki hubungan dengan Alat, yaitu satu kategori dapat mempunyai banyak alat.

Satu Alat juga dapat mempunyai banyak Unit Alat. Pemisahan antara Alat dan Unit Alat dilakukan karena Alat menggambarkan jenis atau model alat, sedangkan Unit Alat merupakan barang fisik individual yang dimiliki laboratorium.

Satu Anggota dapat melakukan banyak Peminjaman, sedangkan setiap Peminjaman dilakukan oleh satu Anggota.

Satu Petugas dapat melayani banyak transaksi Peminjaman.

Hubungan antara Peminjaman dan Unit Alat bersifat banyak-ke-banyak. Satu transaksi Peminjaman dapat memiliki beberapa Unit Alat dan satu Unit Alat dapat tercatat pada banyak transaksi Peminjaman pada waktu yang berbeda.

Hubungan tersebut diuraikan menggunakan entitas asosiatif **Detail Peminjaman**.

Unit Alat juga dapat mempunyai beberapa Riwayat Perbaikan karena satu unit yang sama dapat mengalami proses perbaikan lebih dari satu kali selama masa penggunaannya.

## 5. Migration

Migration database dikelola menggunakan **Flyway** melalui Docker.

Migration digunakan agar setiap perubahan struktur database dapat dicatat dan diterapkan secara berurutan.

File migration yang digunakan adalah:

- `V1__skema_awal.sql`
- `V2__perubahan_skema.sql`
- `V3__petugas_langkah1_tambah_nullable.sql`
- `V4__petugas_langkah2_isi_data_lama.sql`
- `V5__petugas_langkah3_pasang_constraint.sql`

### V1 - Skema Awal

Migration `V1__skema_awal.sql` digunakan untuk membuat empat tabel inti, yaitu:

- anggota
- kategori
- alat
- unit_alat

Migration ini menjadi struktur awal database sebelum dilakukan perubahan pada migration berikutnya.

### V2 - Perubahan Skema

Migration `V2__perubahan_skema.sql` digunakan untuk melengkapi struktur database berdasarkan rancangan sistem.

Tabel lanjutan yang dibuat antara lain:

- petugas
- peminjaman
- detail_peminjaman
- perbaikan
- peran

### V3 - Penambahan Kolom Petugas

Migration `V3__petugas_langkah1_tambah_nullable.sql` digunakan untuk menambahkan kolom `petugas` pada tabel `peminjaman`.

Pada tahap pertama, kolom masih diperbolehkan memiliki nilai `NULL`.

### V4 - Mengisi Data Lama

Migration `V4__petugas_langkah2_isi_data_lama.sql` digunakan untuk mengisi data lama pada kolom `petugas` yang masih memiliki nilai `NULL`.

Data tersebut diberikan nilai:

text
tidak tercatat

### V5 - Penerapan NOT NULL

Migration `V5__petugas_langkah3_pasang_constraint.sql` digunakan untuk menerapkan constraint `NOT NULL` setelah seluruh data lama mempunyai nilai pada kolom `petugas`.

Status migration diperiksa menggunakan:

bash
docker compose run --rm flyway info

Riwayat migration juga diperiksa melalui tabel:

text
flyway_schema_history

Query yang digunakan adalah:

sql
SELECT
    installed_rank,
    version,
    description,
    success
FROM flyway_schema_history
ORDER BY installed_rank;

## 6. Rebuild Database

Pengujian rebuild dilakukan untuk membuktikan bahwa database dapat dibangun kembali hanya menggunakan file migration.

Database `proyek_dev` terlebih dahulu dihapus menggunakan:

bash
docker compose exec postgres psql -U postgres -c "DROP DATABASE proyek_dev;"

Kemudian database dibuat kembali:

bash
docker compose exec postgres psql -U postgres -c "CREATE DATABASE proyek_dev;"

Setelah database kembali dalam keadaan kosong, seluruh migration dijalankan menggunakan:

bash
docker compose run --rm flyway migrate

Status migration kemudian diperiksa kembali menggunakan:

bash
docker compose run --rm flyway info

Hasil pengujian menunjukkan bahwa struktur database dapat dibangun kembali berdasarkan file migration yang tersedia.

Hal ini menunjukkan bahwa struktur database dapat direproduksi secara konsisten tanpa harus membuat kembali setiap tabel secara manual.

## 7. Evolusi Schema dengan Pola Tiga Langkah NOT NULL

Kebutuhan baru mengharuskan tabel `peminjaman` menyimpan informasi petugas yang melayani transaksi.

Penambahan kolom yang wajib memiliki nilai tidak langsung dilakukan menggunakan `NOT NULL` karena tabel dapat saja sudah memiliki data sebelumnya.

Oleh karena itu perubahan dilakukan menggunakan pola tiga langkah.

### Langkah 1 - Menambahkan Kolom Nullable

Migration V3 menjalankan:

sql
ALTER TABLE peminjaman
ADD COLUMN petugas varchar(120);

Pada tahap ini kolom `petugas` masih diperbolehkan mempunyai nilai `NULL`.

Hal tersebut dilakukan agar penambahan kolom tidak bermasalah terhadap data lama yang sudah terdapat pada tabel.

### Langkah 2 - Mengisi Data Lama

Migration V4 menjalankan:

sql
UPDATE peminjaman
SET petugas = 'tidak tercatat'
WHERE petugas IS NULL;

Data lama yang belum mempunyai nilai petugas diisi dengan nilai `tidak tercatat`.

Dengan demikian, tidak ada lagi data lama yang mempunyai nilai `NULL` pada kolom tersebut.

### Langkah 3 - Memasang Constraint NOT NULL

Setelah seluruh data mempunyai nilai, migration V5 menjalankan:

sql
ALTER TABLE peminjaman
ALTER COLUMN petugas SET NOT NULL;

Setelah tahap tersebut, kolom `petugas` tidak lagi diperbolehkan mempunyai nilai `NULL`.

Pola tiga langkah digunakan agar perubahan struktur database lebih aman ketika tabel sudah mempunyai data.

## 8. Seed Data

Seed digunakan untuk memasukkan data awal atau data referensi yang dibutuhkan sistem.

Pada Latihan ini seed digunakan untuk memasukkan data pada tabel `peran`.

Data yang dimasukkan adalah:

- ADM - Administrator
- PTG - Petugas
- AGT - Anggota

Isi seed adalah:

sql
INSERT INTO peran (kode, nama) VALUES
('ADM', 'Administrator'),
('PTG', 'Petugas'),
('AGT', 'Anggota')
ON CONFLICT (kode)
DO UPDATE SET nama = EXCLUDED.nama;

Seed kemudian dijalankan sebanyak dua kali.

Setelah dijalankan dua kali, jumlah data diperiksa menggunakan:

sql
SELECT count(*) FROM peran;

Jumlah baris pada tabel `peran` tetap:

text
3


dan bukan menjadi 6.

Hal tersebut membuktikan bahwa seed bersifat **idempoten**, yaitu dapat dijalankan berulang kali tanpa menghasilkan data ganda.

## 9. Pengamatan pg_stat_activity

Eksperimen dilakukan menggunakan tiga terminal.

Pada Terminal 1 dibuka transaksi:

sql
BEGIN;

SELECT count(*)
FROM peminjaman;


Transaksi tersebut tidak langsung dilakukan `COMMIT`.

Pada Terminal 2 kemudian dilakukan perubahan struktur tabel menggunakan:

sql
ALTER TABLE peminjaman
ADD COLUMN catatan text;


dan:

sql
ALTER TABLE peminjaman
ALTER COLUMN petugas TYPE text;


Terminal 3 digunakan untuk mengamati aktivitas PostgreSQL menggunakan:

sql
SELECT pid,
       wait_event_type,
       state,
       left(query, 60) AS query
FROM pg_stat_activity
WHERE datname = 'proyek_dev';


Dari pengamatan tersebut dapat diketahui bahwa terdapat transaksi yang masih aktif karena Terminal 1 menjalankan `BEGIN` tetapi belum melakukan `COMMIT`.

Sementara itu, operasi `ALTER TABLE` pada terminal lain dapat berada dalam keadaan menunggu karena perubahan struktur tabel membutuhkan lock yang lebih kuat.

Setelah pengamatan selesai, transaksi pada Terminal 1 diselesaikan menggunakan:

sql
COMMIT;


Eksperimen ini menunjukkan bahwa transaksi yang belum selesai dapat memengaruhi operasi perubahan schema pada database.

# 10. Jawaban Pertanyaan 1-7

## Pertanyaan 1

Lingkungan pengujian membutuhkan database tersendiri agar proses pengujian benar-benar terisolasi dari database pengembangan.

Jika hanya menggunakan schema yang berbeda dalam database yang sama, keduanya masih berbagi instance, konfigurasi, resource, dan koneksi database yang sama sehingga proses pengujian masih berpotensi memengaruhi lingkungan pengembangan.

Dengan menggunakan `proyek_dev` dan `proyek_test` sebagai database yang terpisah, proses pengembangan dan pengujian dapat dilakukan dengan lebih terisolasi.

## Pertanyaan 2

Kebutuhan yang memiliki aturan paling rumit adalah **KD-06 Detail Peminjaman**.

Sistem harus memastikan bahwa unit alat yang dipilih benar-benar tersedia dan tidak sedang berada pada peminjaman aktif lainnya.

Menurut kelompok kami, aturan tersebut lebih tepat ditegakkan melalui kode aplikasi dengan dukungan constraint pada basis data.

Alasannya adalah proses pengecekan membutuhkan kondisi transaksi dan status data yang dapat berubah. Kondisi tersebut lebih mudah dikelola pada alur aplikasi, sedangkan constraint pada database tetap digunakan untuk menjaga integritas dasar data.

## Pertanyaan 3

Peminjaman dan Unit Alat tidak dihubungkan secara langsung karena hubungan keduanya bersifat banyak-ke-banyak.

Satu transaksi peminjaman dapat memuat beberapa unit alat. Sebaliknya, satu unit alat dapat tercatat dalam banyak transaksi peminjaman pada waktu yang berbeda.

Oleh karena itu digunakan entitas **Detail Peminjaman** sebagai entitas asosiatif untuk memecah hubungan banyak-ke-banyak tersebut.

Detail Peminjaman juga menyediakan tempat untuk menyimpan informasi yang hanya berlaku pada satu unit dalam satu transaksi tertentu, seperti kondisi unit ketika dipinjam.

## Pertanyaan 4

Alat menggambarkan jenis atau model alat, sedangkan Unit Alat menggambarkan barang fisik individual yang benar-benar dimiliki oleh laboratorium.

Sebagai contoh, **Multimeter Digital** merupakan sebuah Alat.

Namun, laboratorium dapat mempunyai beberapa unit Multimeter Digital seperti:

- UNIT-001
- UNIT-002
- UNIT-003

Pemisahan tersebut diperlukan karena masing-masing unit dapat mempunyai kondisi dan status yang berbeda.

Contoh pertanyaan bisnis yang hanya dapat dijawab apabila keduanya dipisahkan adalah:

**"Unit Multimeter Digital mana yang saat ini sedang diperbaiki?"**

Untuk menjawab pertanyaan tersebut, sistem membutuhkan identitas dari setiap unit fisik.

## Pertanyaan 5

Jika seorang anggota kelompok mengubah isi `V1__skema_awal.sql` setelah migration tersebut sudah diterapkan, Flyway akan membandingkan checksum file V1 saat ini dengan checksum V1 yang telah disimpan pada tabel `flyway_schema_history`.

Karena isi file berubah, nilai checksum juga berubah.

Akibatnya Flyway dapat menampilkan error:

text
migration checksum mismatch


Penyebabnya adalah migration yang sudah menjadi bagian dari riwayat database telah dimodifikasi.

Migration lama seharusnya tidak diedit lagi setelah berhasil diterapkan.

Cara memperbaikinya tanpa menghapus riwayat migration adalah mengembalikan `V1__skema_awal.sql` ke isi sebelumnya.

Apabila terdapat perubahan baru yang ingin diterapkan, perubahan tersebut dibuat pada migration dengan nomor versi berikutnya.

Dengan demikian, histori migration lama tetap konsisten dan perubahan baru tetap tercatat secara berurutan.

## Pertanyaan 6

Pada `pg_stat_activity` terlihat bahwa terdapat transaksi yang masih aktif karena Terminal 1 menjalankan `BEGIN` tetapi belum melakukan `COMMIT`.

Sementara itu, perintah `ALTER TABLE` pada terminal lain dapat berada dalam keadaan menunggu karena membutuhkan lock yang lebih kuat untuk mengubah struktur tabel.

Perintah yang menunggu adalah `ALTER TABLE` yang mencoba melakukan perubahan terhadap tabel `peminjaman` ketika transaksi lain masih menggunakan tabel tersebut.

Jika kondisi seperti ini terjadi pada database produksi ketika banyak pengguna sedang mengakses sistem, perubahan schema dapat tertahan dalam waktu yang lama.

Query atau transaksi lain juga dapat mengalami penundaan sehingga waktu respons aplikasi meningkat dan layanan dapat terasa lebih lambat bagi pengguna.

## Pertanyaan 7

Seed data tidak diletakkan langsung di dalam folder `migrations` karena migration dan seed memiliki tujuan yang berbeda.

Migration digunakan untuk mencatat perubahan struktur atau versi schema secara berurutan dan menjadi bagian dari riwayat perkembangan database.

Migration yang sudah berhasil diterapkan umumnya tidak dijalankan ulang atau diubah sembarangan.

Seed digunakan untuk memasukkan data awal atau data referensi.

Seed dapat dibuat idempoten sehingga aman dijalankan berulang kali tanpa menghasilkan data ganda.

Pada latihan ini sifat idempoten diperoleh menggunakan:

sql
ON CONFLICT (kode)
DO UPDATE SET nama = EXCLUDED.nama;

Dengan demikian, ketika seed dijalankan kembali, data dengan kode yang sama diperbarui dan bukan ditambahkan sebagai baris baru.

# 11. Kontribusi Anggota Kelompok

## Ghibran Sultan Alfarabi

Kontribusi:

- Menentukan domain Sistem Peminjaman Alat Laboratorium.
- Menentukan lingkup sistem.
- Menyusun kebutuhan data.
- Menyusun `kebutuhan.md`.
- Menggabungkan dan menyelesaikan laporan akhir.

Commit:

text
docs: add p02 requirements
docs: finalize p02 report


## Novri

Kontribusi:

- Membuat ERD konseptual.
- Menentukan entitas yang digunakan.
- Menentukan hubungan antarentitas.
- Menentukan kardinalitas setiap relasi.

Commit:

text
docs: add p02 conceptual ERD


## Limjun

Kontribusi:

- Menambahkan konfigurasi Flyway.
- Membuat migration V1 sampai V5.
- Menjalankan migration.
- Memeriksa status migration.
- Memeriksa migration history.
- Melakukan rebuild database.

Commit:

text
feat: add p02 migrations


## Bintang

Kontribusi:

- Melakukan eksperimen locking.
- Mengamati `pg_stat_activity`.
- Membuat dan menjalankan seed data.
- Menguji seed sebanyak dua kali.
- Menyusun README.
- Menyimpan bukti locking dan seed.

Commit:

text
docs: add p02 seed and locking results