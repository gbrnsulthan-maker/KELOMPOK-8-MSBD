# Q26 — Refleksi Selectivity dan Strategi Scan

Berdasarkan hasil pengukuran, status `TERTUNDA` dengan selectivity 10% lebih
cocok menggunakan akses berbasis index. PostgreSQL menggunakan
`Bitmap Heap Scan` dengan `Bitmap Index Scan` pada `ev_status_idx`.

Sebaliknya, status `SUKSES` dengan selectivity 70% lebih cocok menggunakan
`Seq Scan`, karena sebagian besar baris pada tabel harus dibaca.

Hasil pengujian menunjukkan bahwa transition point strategi scan tidak
merupakan angka yang selalu tetap. Pada data ini, 10% dan 20% masih
menggunakan index/bitmap, sedangkan 70% menggunakan `Seq Scan`, sehingga
titik perubahan berada di antara 20% dan 70%.

Transition point dapat berubah karena keputusan optimizer dipengaruhi oleh
beberapa faktor, seperti jumlah baris yang memenuhi kondisi, ukuran tabel,
ukuran index, biaya membaca halaman secara acak (`random_page_cost`),
kondisi cache/buffer, dan statistik tabel.

Hal ini juga terlihat pada Q24. Ketika `random_page_cost` diturunkan menjadi
1.1, PostgreSQL memilih `Index Scan` untuk status `GAGAL` (20%) dan
`TERTUNDA` (10%), sedangkan `SUKSES` (70%) tetap menggunakan `Seq Scan`.
Artinya, perubahan parameter biaya dapat mengubah keputusan optimizer
meskipun data dan index yang digunakan tetap sama.