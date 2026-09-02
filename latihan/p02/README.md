# Pertemuan 2 MSBD
## Sistem Peminjaman Alat Laboratorium

## 1. Nama Kelompok / Domain

**Sistem Peminjaman Alat Laboratorium**

Sistem ini digunakan untuk mengelola data anggota laboratorium, alat, unit alat, peminjaman, pengembalian, petugas, serta riwayat perbaikan alat.

## 2. Anggota Kelompok

1. Ghibran 
2. Novri
3. Limjun
4. Bintang

## 3. Cara Menjalankan Docker Compose

Pastikan Docker Desktop sudah berjalan.

Buka terminal pada folder utama repository, kemudian jalankan:

bash
docker compose up -d

Untuk memastikan container sudah berjalan, gunakan:

bash
docker compose ps

Pastikan service PostgreSQL memiliki status berjalan sebelum melanjutkan ke proses migration.

## 4. Cara Menjalankan Migration

Migration database menggunakan Flyway.

Untuk menjalankan seluruh migration yang belum diterapkan, gunakan:

bash
docker compose run --rm flyway migrate

Untuk melihat status migration, gunakan:

bash
docker compose run --rm flyway info

File migration berada pada folder:

text
latihan/p02/migrations/

File migration yang digunakan:

text
V1__skema_awal.sql
V2__perubahan_skema.sql
V3__petugas_langkah1_tambah_nullable.sql
V4__petugas_langkah2_isi_data_lama.sql
V5__petugas_langkah3_pasang_constraint.sql

## 5. Cara Menjalankan Seed Data

File seed berada pada:

text
latihan/p02/seeds/01_peran.sql

Jika menggunakan **PowerShell Windows**, jalankan:

powershell
Get-Content latihan/p02/seeds/01_peran.sql | docker compose exec -T postgres psql -U postgres -d proyek_dev

Seed dapat dijalankan kembali menggunakan perintah yang sama.

Untuk memeriksa hasil seed, jalankan:

bash
docker compose exec postgres psql -U postgres -d proyek_dev -c "SELECT * FROM peran;"

Untuk memastikan seed tidak menghasilkan data ganda ketika dijalankan berulang kali, jumlah data dapat diperiksa menggunakan:

bash
docker compose exec postgres psql -U postgres -d proyek_dev -c "SELECT count(*) FROM peran;"

Jika seed berhasil dijalankan dua kali dengan benar, jumlah data pada tabel `peran` tetap **3 baris**.