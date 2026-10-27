# Penjelasan MVCC (Q15)

**Multi-Version Concurrency Control (MVCC)** adalah cara PostgreSQL memungkinkan pembaca (SELECT) tidak diblokir oleh penulis (UPDATE/INSERT), dan sebaliknya.

**Analogi:** 
Bayangkan sebuah dokumen Google Docs yang punya "Riwayat Versi". 
Ketika Sesi 1 mengedit dokumen (UPDATE), PostgreSQL tidak menimpa dokumen asli. Ia membuat **versi baru** dari baris tersebut. 
Sesi 2 yang sedang membaca (SELECT) akan tetap melihat **versi lama** (snapshot) sampai Sesi 1 melakukan COMMIT. 
Begitu Sesi 1 COMMIT, Sesi 2 yang baru *mulai* membaca akan melihat versi terbaru.

**Manfaat:**
1. **Pembaca tidak memblokir penulis.** (Laporan berat tidak menghambat transaksi penjualan).
2. **Penulis tidak memblokir pembaca.**
3. Setiap transaksi melihat "foto" (snapshot) database yang konsisten pada saat transaksi itu dimulai.
