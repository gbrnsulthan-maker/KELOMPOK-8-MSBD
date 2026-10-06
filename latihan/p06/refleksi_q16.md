# Refleksi Q16 - Visibility Map & Heap Fetches
## Mengapa Heap Fetches berubah setelah VACUUM padahal definisi index tidak berubah?

Index-Only Scan memungkinkan PostgreSQL mengambil data langsung dari index tanpa membaca tabel utama (heap) ketika seluruh kolom yang diminta query sudah tersedia di dalam index.

Sebelum `VACUUM` dijalankan, PostgreSQL belum mengetahui apakah tuple pada page terkait terlihat (*visible*) oleh transaksi aktif saat ini berdasarkan aturan MVCC. Meskipun data yang dicari sudah ada di index, PostgreSQL tetap terpaksa mendatangi heap untuk memverifikasi visibilitas tuple tersebut, yang menyebabkan nilai *Heap Fetches > 0*.

Proses `VACUUM` berfungsi memindai tabel dan memperbarui *Visibility Map* (VM) dengan menandai page data yang terverifikasi sebagai *all-visible*.

Setelah *Visibility Map* diperbarui oleh `VACUUM`, PostgreSQL dapat membaca peta tersebut terlebih dahulu. Karena page sudah ditandai *all-visible*, PostgreSQL yakin bahwa data di dalam index pasti valid untuk dibaca tanpa perlu memverifikasi ulang ke heap. Hal ini membuat nilai *Heap Fetches* turun menjadi **0**.

Kesimpulannya, nilai *Heap Fetches* tidak dipengaruhi oleh perubahan struktur atau definisi index, melainkan oleh status *Visibility Map*. Perintah `VACUUM` memperbarui Visibility Map sehingga PostgreSQL dapat melakukan *Index-Only Scan* secara murni.