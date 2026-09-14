# Refleksi B

## Laporan Selalu Mutakhir vs Laporan Selalu Cepat

Materialized view tidak harus selalu di-refresh setiap saat karena proses
refresh membutuhkan waktu dan sumber daya database. Sebaliknya, jika terlalu
jarang di-refresh, data yang ditampilkan dapat menjadi tidak terbaru.

Dalam kasus ringkasan akses, kompromi yang dipilih adalah data boleh terlambat
maksimal 1 jam. Refresh dilakukan setiap 1 jam menggunakan
REFRESH MATERIALIZED VIEW CONCURRENTLY agar pembaca tetap dapat mengakses
materialized view selama proses refresh.

Jika proses refresh gagal, hasil refresh terakhir yang masih valid tetap
digunakan. Setelah itu proses refresh dicoba kembali pada jadwal berikutnya
atau dijalankan ulang setelah penyebab kegagalan diperbaiki.

Dengan pendekatan tersebut, sistem tidak harus selalu menggunakan data paling
baru setiap saat, tetapi tetap memiliki batas keterlambatan yang jelas dan
mengurangi gangguan terhadap pembaca.