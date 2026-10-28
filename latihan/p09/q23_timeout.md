# Q23: Perbandingan lock_timeout, statement_timeout, idle_in_transaction_session_timeout, dan deadlock_timeout

## Perbandingan

| Parameter | Yang dibatasi | Default | Jika terlampaui | Fungsi utama |
|---|---|---|---|---|
| **lock_timeout** | Lama **menunggu kunci** untuk satu perintah | 0 (nonaktif) | Perintah dibatalkan dengan `ERROR: canceling statement due to lock timeout` (SQLSTATE `55P03`) | Mencegah query antre terlalu lama di belakang pemegang kunci (antrean lock panjang, lihat Q22) |
| **statement_timeout** | Lama **eksekusi satu perintah** secara total (termasuk waktu menunggu kunci) | 0 (nonaktif) | Perintah dibatalkan dengan `ERROR: canceling statement due to statement timeout` (SQLSTATE `57014`) | Mencegah query yang terlalu lambat atau macet memakan sumber daya |
| **idle_in_transaction_session_timeout** | Lama sesi **diam di dalam transaksi** (sudah `BEGIN` tetapi tidak mengirim perintah) | 0 (nonaktif) | **Sesi diputus** (koneksi ditutup) dengan SQLSTATE `25P03`, transaksinya di-rollback dan kuncinya dilepas | Mencegah transaksi yang ditinggalkan menahan kunci selamanya (penyebab antrean lock panjang) |
| **deadlock_timeout** | Lama menunggu kunci **sebelum PostgreSQL memeriksa deadlock** | 1 detik | Bukan timeout pembatalan. Jika ditemukan siklus tunggu, salah satu transaksi dibatalkan dengan `40P01`. Jika bukan deadlock, sesi tetap menunggu | Mengatur kapan deteksi deadlock dijalankan (pemeriksaan itu mahal, jadi tidak dilakukan setiap saat) |

## Fungsi masing-masing

1. **lock_timeout**: membatasi waktu tunggu kunci. Cocok untuk aplikasi yang lebih baik gagal cepat lalu mencoba ulang daripada menggantung.
2. **statement_timeout**: batas waktu total satu perintah. Melindungi server dari query yang berjalan terlalu lama.
3. **idle_in_transaction_session_timeout**: membersihkan sesi yang `idle in transaction`. Ini satu-satunya yang memutus koneksi, bukan hanya membatalkan perintah.
4. **deadlock_timeout**: bukan pelindung dari antrean lama, tetapi pemicu pemeriksaan deadlock. Menaikkannya mengurangi beban pemeriksaan tetapi membuat deadlock baru terdeteksi lebih lambat.

## Perbedaan penting

- **Antrean lock panjang** ditangani oleh `lock_timeout` (batasi tunggu) dan `idle_in_transaction_session_timeout` (hapus penahan kunci yang menganggur).
- **Query lambat** ditangani oleh `statement_timeout`.
- **Deadlock** ditangani otomatis lewat `deadlock_timeout`, tidak perlu timeout tambahan.
- `deadlock_timeout` adalah satu-satunya yang **tidak membatalkan** apa pun hanya karena waktunya habis. Ia hanya memicu pemeriksaan.

## Contoh penggunaan

```sql
SHOW lock_timeout;
SHOW statement_timeout;
SHOW idle_in_transaction_session_timeout;
SHOW deadlock_timeout;

SET lock_timeout = '5s';
SET statement_timeout = '30s';
SET idle_in_transaction_session_timeout = '60s';
-- deadlock_timeout umumnya diatur di postgresql.conf atau oleh superuser:
-- SET deadlock_timeout = '1s';
```

## Kesimpulan

Keempatnya mengatur waktu, tetapi untuk hal berbeda: `lock_timeout` membatasi menunggu kunci, `statement_timeout` membatasi lama eksekusi perintah, `idle_in_transaction_session_timeout` memutus sesi transaksi yang menganggur, dan `deadlock_timeout` menentukan kapan deteksi deadlock dijalankan.