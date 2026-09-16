# Refleksi C

## Trigger Per Baris vs Trigger Pernyataan

Berdasarkan hasil Q12 dan Q13, trigger per baris tetap lebih tepat digunakan ketika proses audit atau logika membutuhkan pemrosesan setiap baris secara individual. Walaupun trigger per baris dapat lebih lambat pada UPDATE massal, penggunaannya lebih sesuai jika proses membutuhkan nilai OLD dan NEW dari setiap baris yang berubah.

Salah satu kemampuan yang tidak dimiliki trigger pernyataan adalah memproses nilai OLD dan NEW untuk setiap baris secara langsung. Trigger pernyataan berjalan satu kali untuk seluruh statement, sehingga untuk melihat kumpulan data lama dan baru digunakan transition table.

Mengirim email langsung dari trigger juga kurang tepat ketika transaksi dapat mengalami rollback. Jika perubahan database di-rollback, perubahan tersebut dibatalkan, tetapi email yang sudah terlanjur dikirim tidak dapat ikut dibatalkan. Akibatnya, penerima dapat menerima informasi tentang perubahan yang sebenarnya tidak tersimpan di database.