# Latihan 9 — Menguji Transaksi dan Kendali Konkurensi

## Tujuan
Mempelajari transaction isolation, locking, MVCC, anomali konkurensi, dan strategi retry pada PostgreSQL.

## Setup
Database: `latihan`
Schema eksperimen tambahan: `lab9`
Container: `msbd-pg`

Jalankan `q00_setup_lab9.sql` terlebih dahulu. Untuk eksperimen konkurensi, gunakan dua sesi psql dan ikuti urutan pada komentar file SQL.

## Daftar file
- `q00_setup_lab9.sql`: membuat tabel rekening pengujian.
- `q25_nowait.sql`: menguji `FOR UPDATE NOWAIT`.
- `q26_write_skew.sql`: skenario write skew pada REPEATABLE READ.
- `q27_write_skew_serializable.sql`: skenario write skew pada SERIALIZABLE.
- `q28_sireadlock.sql`: memeriksa SIReadLock.
- `q29_retry.md`: pseudocode retry transaksi.
- `laporan.md`: pembahasan Q25–Q32.

## Status validasi
Q25 pernah menghasilkan error NOWAIT ketika baris sedang dikunci sesi lain. Q26–Q28 masih perlu dijalankan dan hasil aktualnya dicatat. Jangan menganggap hasil yang diharapkan sebagai bukti eksperimen.
