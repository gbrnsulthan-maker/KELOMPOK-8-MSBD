@"
# P06 — Mengukur Harga Sebuah Index

## Deskripsi

Latihan Pertemuan 6 membahas pengukuran biaya dan manfaat penggunaan index pada PostgreSQL. Eksperimen mencakup penggunaan EXPLAIN (ANALYZE, BUFFERS), B-Tree, selectivity, extended statistics, biaya random page, serta statistik penggunaan index.

## Database

- DBMS: PostgreSQL 17
- Database: latihan
- Schema: lab6
- Tabel utama: lab6.event_log
- Jumlah data: 2.000.000 baris

## Struktur Eksperimen

Eksperimen dilakukan untuk melihat pengaruh index terhadap:

- execution time
- execution plan
- jumlah buffer yang dibaca
- ukuran penyimpanan
- selectivity
- penggunaan index
- biaya operasi INSERT

## Q22–Q31

- Q22: Index pada kolom status
- Q23: Selectivity dan perubahan strategi scan
- Q24: Pengaruh random_page_cost
- Q25: Extended statistics pada wilayah dan kota
- Q26: Refleksi selectivity dan strategi scan
- Q27: Pengaruh index terhadap INSERT
- Q28: Perbandingan ukuran tabel
- Q29: Statistik penggunaan index
- Q30: Rekomendasi index
- Q31: Refleksi keputusan index

## Index Utama

### event_log_pkey

Primary key pada event_id.

### ev_status_idx

B-Tree index pada kolom status untuk menguji query berdasarkan status.

## Hasil Utama Q22–Q31

- SUKSES memiliki selectivity 70% dan menggunakan Seq Scan.
- GAGAL memiliki selectivity 20% dan menggunakan Bitmap Scan pada pengujian awal.
- TERTUNDA memiliki selectivity 10% dan menggunakan Bitmap Scan.
- Dengan random_page_cost = 1.1, PostgreSQL memilih Index Scan untuk GAGAL dan TERTUNDA.
- Extended statistics memperbaiki estimasi baris untuk kombinasi wilayah dan kota.
- INSERT pada tabel dengan lima index membutuhkan waktu jauh lebih besar dibandingkan tabel tanpa index.
- event_log_pkey dan ev_status_idx dipertahankan berdasarkan hasil penggunaan index.

## Catatan

Seluruh objek eksperimen dibuat pada schema lab6 dan pengukuran menggunakan EXPLAIN (ANALYZE, BUFFERS) sesuai kebutuhan latihan.
"@ | Set-Content .\latihan\p06\README.md -Encoding utf8