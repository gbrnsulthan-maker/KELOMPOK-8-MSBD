@"
# Laporan Latihan Kelompok Pertemuan 6

## Kondisi Uji

- DBMS: PostgreSQL 17.11
- Database: latihan
- Schema: lab6
- Tabel utama: lab6.event_log
- Jumlah data: 2.000.000 baris
- max_parallel_workers_per_gather: 0
- Pengukuran query menggunakan EXPLAIN (ANALYZE, BUFFERS)
- Setiap pengujian performa dijalankan sebanyak 3 kali.
- Hasil waktu dilaporkan menggunakan waktu tercepat dan median.

## Q1 — Ukuran Tabel

Jumlah baris: **2.000.000**

Ukuran total tabel: **490 MB** atau **514.121.728 bytes**.

Ukuran heap: **434 MB** atau **455.114.752 bytes**.

Rata-rata ukuran per baris: **257,06 bytes**.

## Q2 — Tuple per Page

Rata-rata jumlah tuple per page adalah sekitar **36 tuple/page**.

Hasil pengamatan pada block yang ditampilkan menunjukkan sekitar 36 tuple pada setiap block.

## Q3 — TOAST

Ukuran heap adalah **434 MB**, sedangkan ukuran total tabel adalah **490 MB**.

Beberapa kolom menggunakan storage `extended`, antara lain `status`, `wilayah`, `kota`, `email`, `tags`, dan `payload`.

TOAST table yang digunakan adalah `pg_toast.pg_toast_24578`.

## Q4 — HOT Update

Hasil pengujian:

- `n_tup_upd`: **100.000**
- `n_tup_hot_upd`: **0**

Pada kondisi pengujian tersebut tidak tercatat HOT update.

## Q5 — Fillfactor

| Tabel | n_tup_upd | n_tup_hot_upd | Ukuran |
|---|---:|---:|---:|
| hot_penuh | 100.000 | 0 | 18 MB |
| hot_longgar | 100.000 | 21.885 | 20 MB |

Tabel dengan fillfactor lebih longgar menghasilkan **21.885 HOT update**, sedangkan tabel dengan fillfactor 100 menghasilkan 0 HOT update.

## Q6 — Refleksi HOT Update

HOT update memungkinkan PostgreSQL melakukan update tanpa memperbarui index ketika kolom yang diubah tidak digunakan oleh index dan masih tersedia ruang pada page yang sama.

Hasil Q5 menunjukkan bahwa ruang kosong pada page memengaruhi peluang terjadinya HOT update. `hot_penuh` menghasilkan 0 HOT update, sedangkan `hot_longgar` menghasilkan 21.885 HOT update.

## Q7–Q11 — B-Tree dan Urutan Kolom

Berdasarkan hasil pengukuran Q11:

- Baseline tanpa index: median **631,329 ms**
- Index salah `(terjadi_pada, customer_id)`: median **12,182 ms**
- Index benar `(customer_id, terjadi_pada DESC)`: median **0,249 ms**

Ukuran kedua index hampir sama:

- `ev_benar_idx`: **60 MB** / 63.102.976 bytes
- `ev_salah_idx`: **60 MB** / 63.012.864 bytes
- Selisih sekitar **0,14%**

Hasil ini menunjukkan bahwa urutan kolom lebih berpengaruh terhadap efektivitas index daripada ukuran fisiknya.

## Q12–Q21 — Eksperimen Index Lanjutan

Bagian Q12–Q21 belum memiliki seluruh hasil pengukuran yang terverifikasi pada working tree saat penyusunan laporan ini.

File eksperimen yang tersedia akan digunakan untuk melengkapi bagian ini setelah seluruh dependensi index dan hasil `EXPLAIN (ANALYZE, BUFFERS)` berhasil diverifikasi.

## Q22 — Index Status

Index `ev_status_idx` dibuat pada kolom `status`.

### SUKSES — 70%

- Plan: **Seq Scan**
- Tercepat: **322,179 ms**
- Median: **332,754 ms**

### GAGAL — 20%

- Plan: **Bitmap Heap Scan + Bitmap Index Scan**
- Tercepat: **346,923 ms**
- Median: **389,828 ms**

Index digunakan untuk selectivity yang lebih rendah, sedangkan query dengan 70% baris yang cocok menggunakan Seq Scan.

## Q23 — Selectivity

Distribusi data:

| Status | Jumlah | Persentase |
|---|---:|---:|
| SUKSES | 1.400.000 | 70% |
| GAGAL | 400.000 | 20% |
| TERTUNDA | 200.000 | 10% |

Hasil pengujian menunjukkan:

- 70%: **Seq Scan**
- 20%: **Bitmap Scan**
- 10%: **Bitmap Scan**

Pada dataset ini, transition point strategi scan berada di antara **20% dan 70% selectivity**.

## Q24 — random_page_cost

Dengan `random_page_cost = 1.1`:

- SUKSES 70% tetap menggunakan **Seq Scan**, execution time **318,366 ms**.
- GAGAL 20% menggunakan **Index Scan**, execution time **249,398 ms**.
- TERTUNDA 10% menggunakan **Index Scan**, execution time **210,798 ms**.

Hal ini menunjukkan bahwa perubahan biaya random page dapat memengaruhi keputusan optimizer.

## Q25 — Extended Statistics

Query:

`wilayah = 'SUMATERA UTARA' AND kota = 'Medan'`

Sebelum extended statistics:

- Estimasi: **77.619 rows**
- Aktual: **400.000 rows**
- Execution time: **612,628 ms**

Setelah extended statistics dan ANALYZE:

- Estimasi: **404.137 rows**
- Aktual: **400.000 rows**
- Execution time: **298,276 ms**

Extended statistics membuat estimasi jumlah baris menjadi jauh lebih dekat dengan jumlah aktual.

## Q26 — Refleksi Selectivity

Status `TERTUNDA` dengan selectivity 10% lebih cocok menggunakan akses berbasis index, sedangkan `SUKSES` dengan selectivity 70% lebih cocok menggunakan Seq Scan.

Transition point tidak bersifat tetap karena dipengaruhi jumlah baris, ukuran tabel, ukuran index, `random_page_cost`, kondisi cache, dan statistik tabel.

## Q27 — Biaya INSERT

Perbandingan INSERT 200.000 baris:

| Kondisi | Tercepat | Median |
|---|---:|---:|
| Tanpa index | 420,723 ms | 466,262 ms |
| Dengan 5 index | 3.213,847 ms | 3.232,406 ms |

Berdasarkan median, INSERT dengan lima index membutuhkan waktu sekitar **593,15% lebih lama** dibandingkan tanpa index.

## Q28 — Ukuran Tabel

| Kondisi | Ukuran |
|---|---:|
| Tanpa index | 43 MB / 45.555.712 bytes |
| Dengan 5 index | 56 MB / 59.088.896 bytes |

Penambahan lima index meningkatkan ukuran sekitar **13,53 MB** atau sekitar **29,71%**.

## Q29 — Statistik Index

Hasil `pg_stat_user_indexes`:

| Index | idx_scan | Ukuran |
|---|---:|---:|
| event_log_pkey | 7 | 43 MB |
| ev_status_idx | 20 | 13 MB |

Tidak terdapat index dengan `idx_scan = 0` pada hasil pengukuran.

## Q30 — Rekomendasi Index

### event_log_pkey

**KEEP**

Alasan:

- Merupakan primary key.
- `idx_scan = 7`.
- Ukuran: **43 MB**.

### ev_status_idx

**KEEP**

Alasan:

- `idx_scan = 20`.
- Ukuran: **13 MB**.
- Digunakan pada query berdasarkan status.

## Q31 — Refleksi Keputusan Index

`event_log_pkey` dipertahankan karena merupakan primary key dan memiliki `idx_scan = 7`.

`ev_status_idx` dipertahankan karena memiliki `idx_scan = 20` dan digunakan pada query dengan kondisi status.

Tidak ada index dengan `idx_scan = 0` pada hasil Q29.

## Rekomendasi Akhir

Berdasarkan pengukuran yang telah dilakukan, index perlu dipertahankan apabila memberikan manfaat nyata terhadap query yang sering digunakan dan tidak memberikan overhead penyimpanan atau write yang tidak diperlukan.

Pada `lab6.event_log`, `event_log_pkey` dan `ev_status_idx` dipertahankan berdasarkan bukti penggunaan yang diperoleh dari pengukuran.

## Penggunaan AI dan Verifikasi

AI digunakan sebagai alat bantu dalam memahami konsep PostgreSQL, menyusun query eksperimen, membantu membaca execution plan, dan menyusun dokumentasi.

Seluruh hasil angka dan keputusan dalam laporan diverifikasi melalui eksekusi query pada database PostgreSQL yang digunakan dalam praktikum.
"@ | Set-Content .\latihan\p06\laporan.md -Encoding utf8