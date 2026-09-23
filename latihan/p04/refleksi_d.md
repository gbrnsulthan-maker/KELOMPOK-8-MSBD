# Refleksi D

## Trigger vs EXCLUDE untuk Aturan Periode

Aturan periode harga yang tidak boleh tumpang tindih dapat dibuat menggunakan trigger yang membaca data sebelum proses INSERT. Namun, cara tersebut dapat mengalami masalah ketika dua transaksi berjalan secara bersamaan. Kedua transaksi dapat melakukan pengecekan pada waktu yang hampir sama dan sama-sama melihat bahwa belum ada periode yang overlap. Akibatnya, keduanya dapat memasukkan data yang sebenarnya memiliki periode yang saling tumpang tindih.

Berbeda dengan trigger, EXCLUDE digunakan sebagai constraint yang langsung menjadi bagian dari aturan integritas tabel. PostgreSQL akan memeriksa apakah data yang akan dimasukkan bertentangan dengan data yang sudah ada berdasarkan kondisi EXCLUDE. Jika terdapat periode yang overlap untuk film dan wilayah yang sama, salah satu proses INSERT akan ditolak.

Dengan demikian, EXCLUDE lebih kuat untuk menjaga aturan periode karena pengecekan konflik dilakukan oleh database sebagai bagian dari constraint, bukan hanya berdasarkan pemeriksaan data yang dilakukan oleh trigger.