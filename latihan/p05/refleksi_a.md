# Refleksi A

## Siapa yang memulai dan mengakhiri transaksi?

Pada Q3, transaksi dikendalikan oleh PostgreSQL. Ketika terjadi error,
perubahan dalam transaksi dibatalkan (rollback), sehingga data tidak
bertambah.

Pada Q4, procedure mencoba melakukan COMMIT di dalam procedure.
Pengujian langsung melalui PostgreSQL menunjukkan bahwa COMMIT dapat
dijalankan ketika procedure dipanggil sebagai CALL tingkat atas.

Ketika transaksi dikendalikan oleh aplikasi Python, COMMIT di dalam
procedure dapat bermasalah karena aplikasi Python/driver mengelola
transaksinya sendiri.

## Bukti

- Q3 membuktikan rollback ketika terjadi error.
- Q4 membuktikan penggunaan COMMIT di dalam procedure.
- Q5 membuktikan penanganan `foreign_key_violation` menggunakan
  `EXCEPTION`.
