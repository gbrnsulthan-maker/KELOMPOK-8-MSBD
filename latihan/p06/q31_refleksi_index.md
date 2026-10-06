# Q31 — Refleksi Keputusan Index

## 1. event_log_pkey

Keputusan: KEEP.

Index `event_log_pkey` memiliki ukuran 43 MB dan memiliki `idx_scan = 7`.
Index ini juga merupakan primary key pada tabel `lab6.event_log`, sehingga
tetap diperlukan untuk menjaga identitas setiap baris dan mendukung akses
berdasarkan `event_id`.

## 2. ev_status_idx

Keputusan: KEEP.

Index `ev_status_idx` memiliki ukuran 13 MB dan memiliki `idx_scan = 20`.
Pada pengujian Q22, index ini digunakan untuk query `GAGAL` dan `TERTUNDA`.
Pada `random_page_cost = 1.1`, index tersebut juga digunakan dengan
`Index Scan` untuk kedua status tersebut.

Pada Q23, `GAGAL` memiliki selectivity 20% dan `TERTUNDA` 10%, sedangkan
`SUKSES` sebesar 70% menggunakan `Seq Scan`. Hal ini menunjukkan bahwa
index `status` masih bermanfaat terutama ketika jumlah baris yang memenuhi
kondisi relatif lebih kecil.

## Kesimpulan

Kedua index dipertahankan karena keduanya memiliki bukti penggunaan.
`event_log_pkey` digunakan 7 kali dan merupakan primary key, sedangkan
`ev_status_idx` digunakan 20 kali dan mendukung query berdasarkan status.
Tidak ada index dengan `idx_scan = 0` pada hasil pengukuran Q29.