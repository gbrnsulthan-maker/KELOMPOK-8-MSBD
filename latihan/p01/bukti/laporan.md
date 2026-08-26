# LAPORAN MSBD 01
## Manajemen Sistem Basis Data

### Anggota Kelompok
1. Ghibran Sultan Alfarabi - 251402031
2. Novri Ilyasah - 251402005
3. Limjun Basani Sipayung - 251402114
4. Bintang Pamungkas - 251402082

# 1. Persiapan Docker

## 1.1 Docker Version

Untuk memastikan Docker sudah terpasang dan dapat digunakan, dilakukan pengecekan menggunakan perintah:

docker --version

Hasil yang diperoleh:

Docker version 29.7.2

Berdasarkan hasil tersebut, Docker sudah berhasil terpasang dan dapat digunakan untuk menjalankan container.

## 1.2 Docker Compose Version

Selanjutnya dilakukan pengecekan Docker Compose menggunakan perintah:

docker compose version

Hasil yang diperoleh:

Docker Compose version v5.4.0

Docker Compose sudah tersedia dan dapat digunakan untuk menjalankan beberapa service melalui file docker-compose.yml.

# 2. Pemahaman Docker

## 2.1 Docker Image

Docker Image merupakan template atau cetakan yang digunakan untuk membuat sebuah container.

Image sudah berisi komponen yang dibutuhkan agar suatu aplikasi atau service dapat dijalankan.

Pada praktikum ini, image digunakan untuk menyediakan PostgreSQL, MongoDB, dan Redis tanpa perlu melakukan instalasi masing-masing service secara langsung pada sistem operasi.

## 2.2 Container

Container merupakan lingkungan yang dibuat dan dijalankan berdasarkan Docker Image.

Jika image dapat dianggap sebagai cetakan, maka container merupakan hasil dari cetakan tersebut yang sudah dijalankan.

Pada praktikum ini, PostgreSQL berjalan di dalam container sehingga PostgreSQL dapat digunakan tanpa harus menginstalnya secara langsung pada Windows.

## 2.3 Volume

Volume merupakan tempat penyimpanan data yang digunakan oleh container.

Volume digunakan agar data tidak hanya tersimpan di dalam container. Dengan adanya volume, data database tetap dapat dipertahankan ketika container dihentikan atau dibuat ulang, selama volume tersebut tidak ikut dihapus.

Pada PostgreSQL, volume digunakan untuk menyimpan data database agar data tidak hilang setiap kali container dibuat kembali.

# 3. Docker Compose

Docker Compose digunakan untuk menjalankan beberapa service sekaligus melalui satu file konfigurasi, yaitu docker-compose.yml.

Pada praktikum ini, Docker Compose digunakan untuk menjalankan PostgreSQL, MongoDB, dan Redis.

Perintah yang digunakan untuk menjalankan seluruh service adalah:

docker compose up -d

Kemudian kondisi service diperiksa menggunakan:

docker compose ps

Dengan perintah tersebut dapat diketahui apakah PostgreSQL, MongoDB, dan Redis berhasil berjalan.

## 3.1 Apa yang terjadi jika bagian volumes pada PostgreSQL dihapus kemudian menjalankan docker compose down -v?

Volume pada PostgreSQL digunakan sebagai tempat penyimpanan data database agar data tidak ikut hilang ketika container dihentikan atau dibuat ulang.

Apabila konfigurasi volume dihapus dan kemudian menjalankan:

docker compose down -v

Docker akan menghentikan serta menghapus container dan volume yang digunakan oleh Docker Compose.

Jika data PostgreSQL sebelumnya tersimpan pada volume tersebut, data tersebut dapat ikut terhapus.

Oleh karena itu, penggunaan opsi -v harus dilakukan dengan hati-hati terutama jika database sudah berisi data penting.

## 3.2 Mengapa pemetaan port ditulis 5432:5432?

Penulisan:

5432:5432

merupakan pemetaan port antara host atau laptop dengan container Docker.

Angka 5432 pada bagian kiri merupakan port yang digunakan pada host atau laptop, sedangkan angka 5432 pada bagian kanan merupakan port PostgreSQL yang digunakan di dalam container.

Dengan pemetaan tersebut, PostgreSQL yang berjalan di dalam container dapat diakses dari laptop melalui:

localhost:5432

Jika port 5432 pada laptop sudah digunakan oleh PostgreSQL atau aplikasi lain, maka port pada bagian host dapat diganti.

Contohnya:

5433:5432

Dalam kondisi tersebut, PostgreSQL tetap berjalan pada port 5432 di dalam container, tetapi dari laptop PostgreSQL diakses melalui port 5433.

## 3.3 Apa fungsi healthcheck?

Healthcheck digunakan untuk mengecek apakah PostgreSQL yang berjalan di dalam container benar-benar sudah siap digunakan.

Container yang memiliki status berjalan belum tentu berarti PostgreSQL di dalamnya sudah siap menerima koneksi. PostgreSQL mungkin masih berada dalam proses startup atau inisialisasi.

Dengan adanya healthcheck, Docker dapat melakukan pengecekan secara berkala terhadap kondisi PostgreSQL.

Jika PostgreSQL sudah siap menerima koneksi, container akan menunjukkan kondisi healthy.

Healthcheck penting terutama apabila terdapat service lain yang bergantung pada database, karena service tersebut sebaiknya baru digunakan ketika database benar-benar siap.

## 3.4 Mengapa password tidak sebaiknya disimpan langsung di docker-compose.yml?

Password database sebaiknya tidak ditulis langsung di dalam file konfigurasi yang akan dimasukkan ke repository Git karena file tersebut dapat ikut terbaca oleh orang lain yang memiliki akses ke repository.

Jika password pernah di-commit, informasi tersebut juga dapat tersimpan pada riwayat commit.

Salah satu cara yang lebih aman adalah menyimpan credential pada file:

.env

Kemudian file .env dimasukkan ke dalam .gitignore agar tidak ikut di-commit dan di-push ke repository.

Dengan cara tersebut, informasi yang bersifat rahasia dapat dipisahkan dari file konfigurasi utama.

# 4. PostgreSQL Menggunakan psql

Setelah PostgreSQL berhasil dijalankan melalui Docker, PostgreSQL diakses melalui psql.

Perintah yang digunakan adalah:

docker compose exec postgres psql -U msbd -d latihan

Setelah berhasil masuk ke database latihan, dilakukan pengecekan versi PostgreSQL menggunakan:

SELECT version();

Hasil yang diperoleh menunjukkan bahwa PostgreSQL yang digunakan adalah:

PostgreSQL 17.11

Hal ini menunjukkan bahwa PostgreSQL yang berjalan di dalam container sudah dapat diakses dengan baik.

## 4.1 Perintah Dasar psql

Beberapa perintah yang digunakan selama praktikum antara lain:

\l

Digunakan untuk melihat daftar database yang tersedia.

\dt

Digunakan untuk melihat daftar tabel pada database yang sedang digunakan.

\dn

Digunakan untuk melihat daftar schema.

\du

Digunakan untuk melihat daftar user atau role PostgreSQL.

SHOW data_directory;

Digunakan untuk melihat lokasi penyimpanan data PostgreSQL.

SHOW shared_buffers;

Digunakan untuk melihat konfigurasi shared buffer PostgreSQL.

\timing on

Digunakan untuk menampilkan waktu yang diperlukan PostgreSQL dalam menjalankan query.

Dari penggunaan perintah tersebut dapat dipahami bahwa psql dapat digunakan untuk mengakses PostgreSQL secara langsung melalui terminal.

# 5. PostgreSQL Menggunakan DBeaver

Selain menggunakan psql, PostgreSQL juga diakses menggunakan DBeaver.

DBeaver digunakan karena menyediakan antarmuka grafis sehingga struktur database dapat dilihat dengan lebih mudah.

Konfigurasi koneksi yang digunakan adalah:

Host     : localhost
Port     : 5432
Database : latihan
Username : msbd

Setelah dilakukan Test Connection, DBeaver berhasil terhubung dengan PostgreSQL 17.11 yang berjalan melalui Docker.

Setelah koneksi berhasil, database latihan dapat dibuka dan schema public dapat diakses melalui DBeaver.

## 5.1 Perbandingan psql dan DBeaver

Menurut hasil praktikum, psql lebih cepat digunakan ketika hanya ingin menjalankan query atau perintah sederhana karena perintah dapat langsung diketik melalui terminal.

Contohnya, untuk melihat daftar tabel cukup menggunakan:

\dt

psql juga lebih praktis ketika pengguna sudah mengetahui command yang ingin dijalankan.

Sedangkan DBeaver lebih nyaman digunakan ketika ingin melihat struktur database secara visual, seperti schema, tabel, kolom, dan hubungan antar tabel.

DBeaver juga lebih mudah digunakan ketika ingin menelusuri database karena pengguna dapat menggunakan tampilan grafis tanpa harus menghafal seluruh perintah.

Jadi, psql lebih cocok untuk penggunaan berbasis command line, sedangkan DBeaver lebih nyaman digunakan untuk melihat dan memahami struktur database secara visual.

# 6. Restore Database Pagila

Pada praktikum ini digunakan database Pagila sebagai database contoh untuk melakukan pengujian query.

File yang digunakan adalah:

pagila.dump

File tersebut kemudian direstore ke PostgreSQL.

Setelah proses restore selesai, tabel-tabel Pagila berhasil muncul pada schema public.

Beberapa tabel yang berhasil ditampilkan antara lain:

actor
address
category
city
country
customer
film
film_actor
film_category
inventory
language
payment
rental
staff
store

Munculnya tabel-tabel tersebut menunjukkan bahwa proses restore database Pagila berhasil dilakukan.

# 7. Verifikasi Database Pagila

Setelah proses restore selesai, dilakukan beberapa query untuk memastikan database dapat digunakan dengan benar.

Query V1 sampai V4 disimpan pada file:

latihan/p01/verifikasi.sql

## 7.1 V1 — Menghitung Jumlah Tabel

Query V1 digunakan untuk menghitung jumlah base table yang terdapat pada schema public.

Query:

SELECT count(*)
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE';

Hasil yang diperoleh:

21

Berdasarkan hasil tersebut, terdapat 21 base table pada schema public.

Hasil ini menunjukkan bahwa struktur tabel database Pagila sudah berhasil direstore.

## 7.2 V2 — Menampilkan 10 Tabel Terbesar

Query V2 digunakan untuk melihat sepuluh tabel yang menggunakan ruang penyimpanan paling besar pada database.

Query:

SELECT relname,
       pg_size_pretty(pg_total_relation_size(relid))
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC
LIMIT 10;

Dari hasil query tersebut dapat diketahui tabel yang memiliki ukuran penyimpanan paling besar dibandingkan dengan tabel lainnya.

Fungsi pg_size_pretty digunakan agar ukuran penyimpanan ditampilkan dalam bentuk yang lebih mudah dibaca.

## 7.3 V3 — Lima Film dengan Jumlah Penyewaan Terbanyak

Query V3 digunakan untuk mencari lima film dengan jumlah penyewaan terbanyak.

Query:

SELECT f.title, count(*) AS total_sewa
FROM rental r
JOIN inventory i
  ON i.inventory_id = r.inventory_id
JOIN film f
  ON f.film_id = i.film_id
GROUP BY f.title
ORDER BY total_sewa DESC
LIMIT 5;

Pada query tersebut, tabel rental dihubungkan dengan tabel inventory melalui inventory_id.

Kemudian tabel inventory dihubungkan dengan tabel film melalui film_id.

Setelah data digabungkan, jumlah penyewaan dihitung menggunakan count(*), kemudian dikelompokkan berdasarkan judul film dan diurutkan dari jumlah penyewaan terbesar.

## 7.4 V4 — EXPLAIN ANALYZE

EXPLAIN ANALYZE digunakan untuk melihat bagaimana PostgreSQL menjalankan sebuah query sekaligus melihat waktu eksekusinya.

Query:

EXPLAIN ANALYZE
SELECT f.title, count(*)
FROM rental r
JOIN inventory i
  ON i.inventory_id = r.inventory_id
JOIN film f
  ON f.film_id = i.film_id
GROUP BY f.title;

Dari hasil EXPLAIN ANALYZE, PostgreSQL menampilkan tahapan yang digunakan untuk menjalankan query, seperti proses membaca tabel, menggabungkan data, mengelompokkan hasil, jumlah baris yang diproses, serta waktu eksekusi.

Planning Time menunjukkan waktu yang digunakan PostgreSQL untuk menentukan rencana eksekusi query.

Execution Time menunjukkan waktu yang dibutuhkan PostgreSQL untuk benar-benar menjalankan query tersebut.

Beberapa istilah yang muncul pada execution plan antara lain Seq Scan, Hash Join, actual time, rows, dan loops.

Yang paling membingungkan dari keluaran ini adalah cara membaca urutan execution plan serta memahami hubungan antara nilai cost, actual time, rows, dan loops pada setiap proses.

# 8. Repository Git

Repository Git digunakan sebagai tempat penyimpanan dan pengumpulan hasil praktikum kelompok.

Setiap anggota melakukan commit menggunakan akun Git masing-masing agar kontribusi setiap anggota dapat dilihat melalui riwayat commit.

URL Repository:

https://github.com/gbrnsulthan-maker/KELOMPOK-8-MSBD

# 9. Kesimpulan

Pada praktikum ini, Docker dan Docker Compose berhasil digunakan untuk menyediakan environment basis data.

PostgreSQL berhasil dijalankan melalui container dan dapat diakses melalui psql maupun DBeaver.

Docker Image digunakan sebagai template untuk membuat container, container digunakan untuk menjalankan service, sedangkan volume digunakan agar data dapat disimpan secara persisten.

Database Pagila berhasil direstore dan digunakan untuk melakukan pengujian query.

Melalui query V1 sampai V4 dapat dilakukan verifikasi terhadap jumlah tabel, ukuran tabel, data penyewaan film, serta proses eksekusi query menggunakan EXPLAIN ANALYZE.

Praktikum ini membantu memahami cara menjalankan database menggunakan Docker serta cara mengakses dan melakukan verifikasi database menggunakan PostgreSQL.
