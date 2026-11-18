# MSBD P11 — Menutup Pintu yang Terbuka

## Prasyarat
- PostgreSQL pada lingkungan praktikum terisolasi.
- Ekstensi pgcrypto tersedia.
- Hak membuat schema, tabel, view, dan trigger.

## Setup
1. Gunakan database praktikum, bukan database produksi.
2. Jalankan `lab11_setup_mandiri.sql` jika setup resmi modul tidak tersedia.
3. Pastikan hasil verifikasi: 3 tenant, 30.000 pelanggan, 4 akun, 120.000 transaksi.
4. Jalankan `q19_q29_lengkap.sql` sesuai urutan dan hak akses.

## Catatan
- Kunci enkripsi adalah contoh demonstrasi.
- Q26 dan Q29 menggunakan transaksi yang dibatalkan.
- Isi lima keluhan Ticket #1134 pada q30_peta_uu_pdp.md.
- Screenshot hanya dilampirkan setelah query benar-benar dijalankan.
