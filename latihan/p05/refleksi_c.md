# Refleksi C

## Apa persamaan rollback Q3 dan Q13?

Pada Q3, rollback terjadi ketika terjadi error pada basis data, sehingga perubahan dalam transaksi dibatalkan dan data kembali seperti semula.

Pada Q13, rollback terjadi ketika Python melempar exception setelah process_rental dipanggil. Karena transaksi belum selesai, perubahan yang dilakukan dibatalkan sehingga jumlah data sebelum dan sesudah tetap sama.

## Bukti

- Q3 membuktikan rollback yang dipicu oleh error di basis data.
- Q13 membuktikan rollback yang dipicu oleh exception dari aplikasi Python.
- Satu hal yang dapat dilakukan sisi aplikasi adalah memicu pembatalan transaksi berdasarkan kondisi atau exception yang terjadi dalam kode Python.