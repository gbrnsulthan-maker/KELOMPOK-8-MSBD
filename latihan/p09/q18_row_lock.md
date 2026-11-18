# Q18: Perbandingan FOR UPDATE, FOR NO KEY UPDATE, FOR SHARE, dan FOR KEY SHARE

## Tujuan Umum

Keempatnya adalah **row-level lock** pada `SELECT ... FOR <mode>`. Tujuannya mengunci baris yang dipilih agar tidak diubah transaksi lain sebelum transaksi saat ini selesai (COMMIT/ROLLBACK). Urutan kekuatannya dari yang terlemah ke terkuat: **FOR KEY SHARE < FOR SHARE < FOR NO KEY UPDATE < FOR UPDATE**.

## Perbandingan

| Mode | Tujuan | Dipakai otomatis oleh |
|---|---|---|
| **FOR UPDATE** | Mengunci baris secara eksklusif karena akan di-UPDATE/DELETE, termasuk mengubah kolom kunci. Mode terkuat. | `DELETE` dan `UPDATE` yang mengubah kolom kunci (unique index) |
| **FOR NO KEY UPDATE** | Mengunci baris untuk di-UPDATE **tanpa mengubah kolom kunci**. Lebih lemah dari FOR UPDATE. | `UPDATE` biasa yang tidak mengubah kolom kunci |
| **FOR SHARE** | Kunci bersama: baris boleh dibaca dan di-share-lock transaksi lain, tetapi tidak boleh diubah atau dihapus. | Tidak otomatis (dipakai manual) |
| **FOR KEY SHARE** | Kunci bersama paling lemah: hanya melindungi **kolom kunci** agar tidak berubah atau baris tidak dihapus. | Pengecekan **foreign key** |

## Kapan Transaksi Lain Terhalang

Tabel konflik (**X** = terhalang/menunggu, kosong = tidak terhalang):

| Lock yang sudah dipegang → / Lock yang diminta ↓ | FOR KEY SHARE | FOR SHARE | FOR NO KEY UPDATE | FOR UPDATE |
|---|:---:|:---:|:---:|:---:|
| **FOR KEY SHARE** | | | | X |
| **FOR SHARE** | | | X | X |
| **FOR NO KEY UPDATE** | | X | X | X |
| **FOR UPDATE** | X | X | X | X |

Poin penting:

1. **FOR UPDATE** menghalangi semua mode lain, serta `UPDATE` dan `DELETE` dari transaksi lain.
2. **FOR NO KEY UPDATE** tidak menghalangi FOR KEY SHARE, sehingga insert pada tabel anak (foreign key) tetap bisa berjalan.
3. **FOR SHARE** membolehkan banyak transaksi membaca-mengunci bersamaan, tetapi menghalangi `UPDATE`, `DELETE`, FOR UPDATE, dan FOR NO KEY UPDATE.
4. **FOR KEY SHARE** hanya menghalangi `DELETE`, `UPDATE` pada kolom kunci, dan FOR UPDATE.
5. `SELECT` biasa (tanpa FOR ...) **tidak pernah terhalang** karena PostgreSQL memakai MVCC.

**Kesimpulan:** Semakin kuat mode lock, semakin banyak transaksi lain yang terhalang. Gunakan mode sekuat yang dibutuhkan saja: FOR UPDATE untuk perubahan besar atau penghapusan, FOR NO KEY UPDATE untuk update biasa, FOR SHARE untuk mencegah perubahan saat membaca, dan FOR KEY SHARE untuk menjaga integritas foreign key.