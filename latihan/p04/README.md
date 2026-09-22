# Latihan Kelompok Pertemuan 4
## SQL Lanjutan II: Audit Log, Materialized View, dan Migrasi Aman

Latihan ini membahas penggunaan View, Materialized View, Trigger Audit, Constraint, serta proses migrasi database menggunakan metode Expand–Contract pada PostgreSQL 17.

Seluruh percobaan yang mengubah atau menghapus data dilakukan pada schema `lab4`. Schema `public` tetap digunakan sebagai sumber data awal Pagila supaya data aslinya tidak ikut berubah.

## Prasyarat

Sebelum menjalankan latihan, pastikan:

1. PostgreSQL 17 sudah terpasang dan berjalan.
2. Database Pagila sudah tersedia.
3. Tabel `public.film` sudah tersedia dan dapat diakses.
4. Seluruh percobaan dilakukan pada database latihan.
5. File jawaban Q1–Q21 disimpan pada folder `latihan/p04/`.
6. File migration disimpan pada folder `migrations/`.

## Setup Awal

Sebelum mengerjakan Q1–Q21, jalankan terlebih dahulu:

```text
latihan/p04/q00_setup.sql
```

File `q00_setup.sql` digunakan untuk menyiapkan schema dan data yang digunakan selama latihan. Setup yang dilakukan meliputi:

- Membuat schema `lab4`.
- Mengatur `search_path` ke `lab4, public`.
- Menyalin tabel `public.film` menjadi `lab4.film`.
- Menambahkan primary key pada `film_id`.
- Membuat tabel `lab4.jejak_akses`.
- Memasukkan 500.000 data ke `lab4.jejak_akses`.
- Menjalankan `ANALYZE`.
- Memeriksa jumlah data hasil setup.

Pada lingkungan kelompok kami, file setup dijalankan dengan perintah:

```powershell
Get-Content .\latihan\p04\q00_setup.sql | docker exec -i prak-postgres psql -U admin -d p04_pagila
```

Setelah setup selesai, jumlah data pada `lab4.jejak_akses` harus berjumlah:

```text
500000
```

Apabila setup belum berhasil, pengerjaan Q1 dan seterusnya tidak dilanjutkan karena tabel dan data dari tahap setup masih digunakan pada soal berikutnya.

## Urutan Pengerjaan Q1–Q21

Pengerjaan dilakukan secara berurutan karena beberapa soal menggunakan objek atau hasil dari soal sebelumnya.

```text
q00_setup.sql
      ↓
Q1
      ↓
Q2
      ↓
Q3
      ↓
Q4
      ↓
Q5
      ↓
Q6
      ↓
Q7
      ↓
Q8
      ↓
Q9
      ↓
Q10
      ↓
Q11
      ↓
Q12
      ↓
Q13
      ↓
Q14
      ↓
Q15
      ↓
Q16
      ↓
Q17
      ↓
Q18
      ↓
Q19
      ↓
Q20
      ↓
Q21
```

Setiap soal dijalankan setelah soal sebelumnya selesai supaya objek database yang dibutuhkan sudah tersedia.

## Q8 - Pengujian Dua Sesi

Pada Q8 digunakan dua sesi `psql` yang terhubung ke database yang sama.

### Sesi 1

Sesi pertama digunakan untuk menjalankan proses refresh pada Materialized View.

Pengujian dilakukan untuk membandingkan:

```sql
REFRESH MATERIALIZED VIEW ...
```

dengan:

```sql
REFRESH MATERIALIZED VIEW CONCURRENTLY ...
```

### Sesi 2

Sesi kedua digunakan sebagai reader. Pada sesi ini data dibaca ketika proses refresh sedang dilakukan pada sesi pertama.

Dua sesi digunakan supaya dapat dilihat perbedaan kondisi pembacaan data antara refresh biasa dengan `REFRESH MATERIALIZED VIEW CONCURRENTLY`.

## Q18–Q20 - Migrasi Expand–Contract

Pada Q18 sampai Q20 dilakukan proses pemindahan harga film dari struktur lama:

```text
lab4.film.rental_rate
```

ke struktur baru:

```text
lab4.harga_film
```

Proses migrasi dilakukan secara bertahap supaya struktur lama tidak langsung dihapus sebelum struktur baru siap digunakan.

Urutannya adalah:

```text
Membuat struktur baru
        ↓
Memasang dual-write
        ↓
Melakukan backfill
        ↓
Melakukan verifikasi
        ↓
Menyediakan facade
        ↓
Menghapus bentuk lama
```

### Q18 - Expand dan Dual-Write

Pada tahap Q18 dibuat tabel `lab4.harga_film` sebagai tempat penyimpanan harga pada struktur baru.

Setelah itu dipasang trigger dual-write. Trigger digunakan supaya perubahan `rental_rate` pada struktur lama juga ikut tercatat pada `lab4.harga_film`.

Dengan cara ini, struktur lama masih dapat digunakan selama proses migrasi berlangsung.

## Q19 - Backfill

Setelah dual-write aktif, data harga dari struktur lama dipindahkan ke `lab4.harga_film`.

Backfill dilakukan secara bertahap dengan rentang 1000 `film_id`. Query juga menggunakan `NOT EXISTS` supaya data yang sebelumnya sudah masuk melalui dual-write tidak dimasukkan kembali.

Setelah backfill selesai, dilakukan pemeriksaan jumlah film yang belum mempunyai data harga pada struktur baru.

Hasil verifikasi yang diperoleh:

```text
film_belum_dimigrasi
--------------------
0
```

Hasil `0` menunjukkan seluruh film sudah memiliki data pada struktur harga baru. Setelah hasil ini didapatkan, proses dapat dilanjutkan ke tahap contract.

## Q20 - Pengujian Old Reader

Pada Q20 digunakan dua sesi `psql`.

### Sesi 1

Sesi pertama digunakan untuk melakukan perubahan struktur database pada tahap contract.

### Sesi 2

Sesi kedua digunakan sebagai simulasi aplikasi lama atau old reader.

Query yang digunakan pada old reader adalah:

```sql
SELECT title, rental_rate
FROM lab4.film
LIMIT 5;
```

Selama percobaan, old reader awalnya masih dapat membaca kolom `rental_rate`.

Ketika kolom `rental_rate` langsung dihapus dari `lab4.film`, old reader menghasilkan error:

```text
ERROR:  column "rental_rate" of relation "film" does not exist
```

Hal ini terjadi karena pada saat itu facade masih menggunakan nama `lab4.film_fasad`, sedangkan old reader tetap mengakses `lab4.film`.

Dari percobaan tersebut, kami melihat bahwa membuat facade dengan nama yang berbeda belum cukup untuk mempertahankan aplikasi lama. Nama objek yang digunakan aplikasi lama juga perlu tetap tersedia.

Setelah itu, tabel fisik diubah namanya menjadi:

```text
lab4.film_base
```

Kemudian dibuat view dengan nama:

```text
lab4.film
```

View `lab4.film` digunakan sebagai facade untuk old reader. Kolom `rental_rate` pada facade tidak lagi mengambil nilai dari kolom lama, tetapi mengambil nilai `harga` dari `lab4.harga_film`.

Setelah facade menggunakan nama `lab4.film`, query old reader:

```sql
SELECT title, rental_rate
FROM lab4.film
LIMIT 5;
```

kembali berhasil dijalankan.

Dari hasil percobaan ini, urutan contract yang lebih aman adalah menyiapkan facade terlebih dahulu sebelum bentuk lama benar-benar dihapus. Dengan begitu aplikasi lama masih dapat menggunakan nama dan bentuk data yang sama selama perubahan struktur database berlangsung.

## Migration

Seluruh migration disimpan pada folder:

```text
migrations/
```

Migration dibuat dalam pasangan file `.up.sql` dan `.down.sql`.

Struktur migration yang digunakan adalah:

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

Urutan migration tersebut adalah:

```text
0041 → Membuat struktur lab4.harga_film
0042 → Memasang trigger dual-write
0043 → Melakukan backfill data
0044 → Melakukan verifikasi hasil migrasi
0045 → Menyediakan facade untuk aplikasi lama
0046 → Menghentikan dual-write dan menghapus bentuk lama
```

Migration harus dijalankan sesuai urutan karena setiap tahap menggunakan hasil dari migration sebelumnya.

## Peringatan Q20 dan Migration 0046

Tahap Q20 dan migration `0046_contract_drop_kolom_lama.up.sql` perlu diperhatikan karena pada tahap ini kolom `rental_rate` pada tabel fisik akan dihapus.

Setelah sebuah kolom dihapus menggunakan `DROP COLUMN`, isi lama dari kolom tersebut tidak dapat dikembalikan secara penuh hanya dengan membuat kembali kolomnya.

File:

```text
0046_contract_drop_kolom_lama.down.sql
```

dapat membuat kembali kolom `rental_rate` dan mengisi nilainya berdasarkan data harga yang sudah berada pada `lab4.harga_film`.

Namun, nilai tersebut merupakan hasil rekonstruksi dari struktur baru dan bukan pemulihan penuh terhadap isi kolom lama sebelum dihapus.

Karena itu, migration `0046` baru dilakukan setelah:

1. Proses backfill selesai.
2. Hasil verifikasi menunjukkan seluruh data sudah berhasil dipindahkan.
3. Facade sudah tersedia.
4. Old reader sudah dipastikan dapat membaca data melalui facade.

## Laporan

Seluruh hasil pengerjaan kelompok dicatat pada:

```text
latihan/p04/laporan.md
```

Laporan berisi:

- Identitas kelompok dan pembagian kontribusi.
- Jawaban Q1–Q21.
- Perintah yang dijalankan.
- Keluaran dari setiap percobaan.
- Alasan dari keputusan yang digunakan.
- Pesan error lengkap dari Q3, Q6, dan Q7.
- Jawaban Refleksi A–E.
- Waktu pengujian Q5, Q6, Q7, Q12, dan Q13 beserta penjelasannya.
- Screenshot struktur folder `migrations/`.
- Tautan commit anggota.
- Catatan pengujian dua sesi dan old reader pada Q20.