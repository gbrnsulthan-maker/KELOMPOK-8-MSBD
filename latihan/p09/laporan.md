# Laporan Latihan 9 — Menguji Transaksi dan Kendali Konkurensi

## Q25. FOR UPDATE NOWAIT

Pengujian dilakukan dengan dua sesi PostgreSQL. Sesi A mengunci baris rekening menggunakan `FOR UPDATE`. Ketika Sesi B mencoba mengunci baris yang sama menggunakan `FOR UPDATE NOWAIT`, PostgreSQL menghasilkan error karena baris sedang dikunci oleh transaksi lain.

**Hasil:** `ERROR: could not obtain lock on row in relation "rekening"`

**Kesimpulan:** `NOWAIT` membuat transaksi langsung gagal ketika lock tidak tersedia, tanpa menunggu transaksi lain selesai.

## Q26. Write Skew pada REPEATABLE READ

Write skew dapat terjadi ketika dua transaksi membaca kondisi data yang sama, kemudian memperbarui baris berbeda berdasarkan hasil pembacaan tersebut. Pada tingkat isolasi `REPEATABLE READ`, kedua transaksi dapat berhasil melakukan commit meskipun aturan bisnis yang melibatkan beberapa baris akhirnya dilanggar.

**Catatan:** Skenario ini belum berhasil diuji secara langsung. Hasil di atas merupakan analisis perilaku transaksi, bukan bukti eksekusi.

## Q27. Write Skew pada SERIALIZABLE

Tingkat isolasi `SERIALIZABLE` berusaha memastikan transaksi berjalan seolah-olah dieksekusi secara berurutan. Jika dua transaksi menghasilkan konflik serialisasi, salah satunya dapat gagal dengan SQLSTATE `40001` (*serialization_failure*).

**Kesimpulan:** Aplikasi harus siap mengulang transaksi yang gagal akibat konflik serialisasi.

**Catatan:** Pengujian langsung untuk skenario ini belum dilakukan.

## Q28. SIReadLock

Pada PostgreSQL, tingkat isolasi `SERIALIZABLE` menggunakan mekanisme Serializable Snapshot Isolation. PostgreSQL dapat mencatat predicate lock dengan mode `SIReadLock` untuk mendeteksi konflik baca-tulis yang berpotensi menyebabkan hasil transaksi tidak serializable.

Lock ini digunakan untuk deteksi konflik dan tidak sama dengan row lock biasa yang selalu menghalangi transaksi lain.

**Catatan:** Keberadaan `SIReadLock` pada sesi pengujian belum diverifikasi.

## Q29. Strategi Retry Transaksi

Transaksi yang gagal karena SQLSTATE `40001` atau `40P01` dapat dicoba ulang dengan batas percobaan tertentu.

Pseudocode:

1. Atur jumlah percobaan maksimum.
2. Jalankan transaksi.
3. Jika berhasil, akhiri proses.
4. Jika mendapat error `40001` atau `40P01`, batalkan transaksi dan coba kembali selama batas percobaan belum tercapai.
5. Berikan jeda dengan *exponential backoff* dan *jitter* sebelum mencoba kembali.
6. Jika tetap gagal, kembalikan error kepada pemanggil.

## Q30. Matriks Anomali Transaksi

| Anomali | Penjelasan |
|---|---|
| Dirty read | Membaca perubahan transaksi lain yang belum commit. PostgreSQL tidak mengizinkan dirty read. |
| Non-repeatable read | Nilai baris yang dibaca berubah ketika dibaca kembali setelah transaksi lain melakukan commit. |
| Phantom read | Hasil query berdasarkan kondisi tertentu berubah karena baris ditambahkan atau dihapus transaksi lain. |
| Lost update | Perubahan satu transaksi tertimpa perubahan transaksi lain. |
| Write skew | Dua transaksi memperbarui baris berbeda berdasarkan kondisi bersama sehingga aturan bisnis dapat dilanggar. |
| Inconsistent read | Pembacaan menghasilkan gabungan nilai yang tidak konsisten dengan keadaan data yang seharusnya diamati. |

## Q31. Rekomendasi Isolation Level

| Kebutuhan | Rekomendasi |
|---|---|
| Operasi sederhana dengan kebutuhan konsistensi standar | READ COMMITTED |
| Pembacaan berulang yang membutuhkan snapshot konsisten | REPEATABLE READ |
| Aturan bisnis lintas beberapa baris yang membutuhkan serialisasi | SERIALIZABLE |
| Mencegah perubahan pada baris tertentu selama transaksi | SELECT ... FOR UPDATE |
| Gagal langsung ketika lock tidak tersedia | SELECT ... FOR UPDATE NOWAIT |

Pemilihan isolation level perlu mempertimbangkan konsistensi data, potensi konflik, dan biaya pengulangan transaksi.

## Q32. Tiga Pelajaran Utama

1. **Lock mengatur akses bersamaan.** Pengujian Q25 menunjukkan bahwa `FOR UPDATE NOWAIT` menghasilkan error ketika baris telah dikunci oleh transaksi lain.
2. **Isolation level memengaruhi konsistensi.** `REPEATABLE READ` memberikan snapshot yang konsisten, tetapi tidak otomatis mencegah semua anomali lintas baris. `SERIALIZABLE` memberikan perlindungan lebih kuat dengan kemungkinan transaksi harus diulang.
3. **Aplikasi harus menangani kegagalan transaksi.** Error seperti `40001` dan `40P01` perlu ditangani menggunakan mekanisme retry yang memiliki batas percobaan dan jeda.

## Catatan Validasi

Q25 telah menghasilkan error `NOWAIT` saat baris dikunci oleh sesi lain. Q26–Q28 belum diverifikasi melalui eksperimen langsung. Hasil untuk bagian tersebut harus dilengkapi dengan bukti eksekusi sebelum laporan akhir dikumpulkan.
