\# Refleksi Q6 - HOT Update
\## Mengapa UPDATE kolom terindeks dan tidak terindeks menghasilkan perilaku HOT yang berbeda?

HOT (Heap-Only Tuple) memungkinkan PostgreSQL melakukan UPDATE tanpa harus membuat perubahan pada index ketika kolom yang diubah tidak digunakan oleh index.

Pada UPDATE kolom yang tidak terindeks, index tidak perlu diperbarui. Jika masih tersedia ruang pada page yang sama, PostgreSQL dapat menempatkan versi baru tuple pada page tersebut dan menggunakan HOT update.

Sebaliknya, jika kolom yang diubah memiliki index, perubahan nilai kolom tersebut dapat memengaruhi isi index. PostgreSQL harus memperbarui index sehingga HOT tidak dapat digunakan dengan cara yang sama.

Hasil percobaan Q5 juga menunjukkan pengaruh ruang kosong pada page. Tabel `hot\_penuh` dengan fillfactor 100 menghasilkan 0 HOT update, sedangkan `hot\_longgar` dengan fillfactor 80 menghasilkan 21.885 HOT update.

Kesimpulannya, HOT update dipengaruhi oleh dua hal utama: apakah kolom yang diubah memiliki index dan apakah masih tersedia ruang pada page yang sama.