# Q22: Perbedaan Deadlock dan Antrean Lock Panjang

## Perbedaan

| Aspek | Deadlock | Antrean lock panjang |
|---|---|---|
| Penyebab | Dua transaksi atau lebih saling menunggu kunci milik lawannya (**siklus tunggu**) | Satu transaksi menahan kunci terlalu lama, transaksi lain **antre** menunggunya (tanpa siklus) |
| Pola | A menunggu B, B menunggu A | B, C, D menunggu A, dan A tidak menunggu siapa pun |
| Penyelesaian | Dideteksi otomatis PostgreSQL setelah `deadlock_timeout` (default 1 detik). Salah satu transaksi dibatalkan dengan `ERROR: deadlock detected` (SQLSTATE `40P01`) | **Tidak ada pembatalan otomatis**. Antrean baru jalan setelah pemegang kunci COMMIT/ROLLBACK, atau terkena timeout yang diatur |
| Gejala | Error muncul cepat, ada transaksi korban | Query menggantung tanpa error, aplikasi terasa lambat atau macet |
| Pencegahan | Urutan penguncian yang konsisten (lihat Q21) | Transaksi pendek, jangan ada proses lambat atau menunggu input di dalam transaksi, atur timeout |

## Contoh transaksi yang menahan lock terlalu lama

```sql
-- Sesi A: transfer yang "lupa" COMMIT (atau menunggu proses lain di dalam transaksi)
BEGIN;
SELECT * FROM p09.rekening WHERE id = 1 FOR UPDATE;
-- ... aplikasi memanggil API eksternal, menunggu persetujuan, atau pengguna meninggalkan sesi ...
-- COMMIT belum dijalankan -> kunci id 1 tetap dipegang.

-- Sesi B dan Sesi C: ingin mengubah rekening yang sama
UPDATE p09.rekening SET saldo = saldo - 50000 WHERE id = 1;
-- Keduanya MENGGANTUNG (antre) di belakang Sesi A.
```

Tidak ada siklus di sini: Sesi A tidak menunggu siapa pun, jadi PostgreSQL **tidak menganggapnya deadlock** dan tidak membatalkan apa pun. Sesi A berstatus `idle in transaction`, sementara Sesi B dan C menunggu selama Sesi A belum selesai. Semakin lama Sesi A menahan kunci, semakin panjang antrean dan semakin banyak koneksi yang tertahan.

## Cara mendeteksi dan menangani

```sql
-- Lihat siapa yang menunggu dan siapa yang memblokir
SELECT pid, state, wait_event_type, pg_blocking_pids(pid) AS diblokir_oleh, left(query, 50) AS query
FROM pg_stat_activity
WHERE datname = current_database() AND cardinality(pg_blocking_pids(pid)) > 0;

-- Batasi waktu tunggu dan transaksi yang menganggur
SET lock_timeout = '5s';
SET idle_in_transaction_session_timeout = '30s';

-- Darurat: hentikan sesi pemegang kunci
-- SELECT pg_terminate_backend(<pid_pemegang_kunci>);
```

## Kesimpulan

Deadlock adalah **saling menunggu** yang tidak akan selesai sendiri, sehingga PostgreSQL turun tangan dengan membatalkan salah satu transaksi. Antrean lock panjang adalah **menunggu satu pemegang kunci yang lambat**, dan masalahnya hanya hilang kalau pemegang kunci selesai atau dibatasi timeout. Solusinya: transaksi dibuat singkat, urutan penguncian konsisten, dan timeout diatur.