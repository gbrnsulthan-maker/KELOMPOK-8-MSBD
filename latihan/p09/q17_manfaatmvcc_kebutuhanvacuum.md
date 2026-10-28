# Q17: Manfaat MVCC dan Kebutuhan VACUUM

## Manfaat MVCC

**Multi-Version Concurrency Control (MVCC)** adalah cara PostgreSQL menyimpan beberapa versi dari satu baris. Saat UPDATE/DELETE, data lama tidak langsung ditimpa atau dihapus, tetapi dibuat **versi baru**.

1. **Pembaca tidak memblokir penulis, dan sebaliknya.** (Laporan berat tidak menghambat transaksi penjualan).
2. **Konsistensi data.** Setiap transaksi melihat "foto" (snapshot) database yang konsisten saat transaksi dimulai, tanpa dirty read.
3. **Konkurensi tinggi.** Lock contention berkurang karena konflik hanya terjadi jika dua transaksi menulis ke baris yang sama.
4. **Rollback cepat.** Versi lama masih ada, jadi versi baru cukup diabaikan.

## Kebutuhan VACUUM

Akibat MVCC, versi lama yang sudah tidak dibutuhkan transaksi mana pun menjadi **dead tuple** yang tetap memakan ruang disk. VACUUM diperlukan untuk:

1. **Membersihkan dead tuple** agar ruangnya bisa dipakai ulang, sehingga tabel dan indeks tidak mengalami **bloat**.
2. **Menjaga performa query**, karena scan tidak perlu membaca halaman yang berisi baris mati.
3. **Memperbarui statistik dan visibility map** agar query planner memilih rencana eksekusi yang tepat.
4. **Mencegah transaction ID wraparound** dengan melakukan *freezing* pada baris lama.