# Kebutuhan Data
## Sistem Peminjaman Alat Laboratorium

## Alasan Pemilihan Domain

Kelompok memilih Sistem Peminjaman Alat Laboratorium karena proses bisnisnya memiliki kebutuhan data yang jelas dan cukup kompleks untuk menggambarkan hubungan antarentitas, relasi banyak-ke-banyak, aturan bisnis, serta pengelolaan perubahan skema basis data.

Sistem ini menangani anggota laboratorium, alat, unit fisik alat, peminjaman, detail barang yang dipinjam, petugas, riwayat perbaikan, serta peran pengguna.

## Lingkup

Termasuk : Tidak termasuk 

Pendataan anggota laboratorium : Proses pengadaan alat 
Pendataan alat dan unit fisiknya : Pembayaran denda secara online 
Peminjaman dan pengembalian alat : Sistem akademik mahasiswa 
Pencatatan kondisi unit alat : Jadwal perkuliahan 
Riwayat perbaikan unit alat : Penggajian petugas 
Pendataan petugas : Pembelian suku cadang 

## KD-01 Data Anggota

- Deskripsi : sistem menyimpan data anggota yang memiliki hak melakukan peminjaman alat.
- Data      : nomor_anggota, nama, email, status, tanggal_bergabung
- Aturan    : nomor anggota dan email harus unik; hanya anggota berstatus aktif yang dapat melakukan peminjaman.
- Volume    : ±500 anggota
- Sumber    : administrasi laboratorium
- Prioritas : wajib

## KD-02 Data Kategori Alat

- Deskripsi : sistem menyimpan kategori yang digunakan untuk mengelompokkan alat.
- Data      : kode_kategori, nama_kategori, deskripsi
- Aturan    : kode kategori harus unik dan setiap alat harus memiliki kategori.
- Volume    : ±20 kategori
- Sumber    : inventaris laboratorium
- Prioritas : wajib

## KD-03 Data Alat

- Deskripsi : sistem menyimpan jenis alat yang tersedia pada laboratorium.
- Data      : kode_alat, nama_alat, kategori, deskripsi
- Aturan    : kode alat harus unik dan satu jenis alat dapat memiliki lebih dari satu unit fisik.
- Volume    : ±200 jenis alat
- Sumber    : inventaris laboratorium
- Prioritas : wajib

## KD-04 Data Unit Alat

- Deskripsi : sistem menyimpan setiap unit fisik dari suatu jenis alat.
- Data      : kode_unit, alat, kondisi, status_ketersediaan
- Aturan    : kode unit harus unik; unit yang sedang dipinjam atau diperbaiki tidak dapat dipinjam kembali.
- Volume    : ±1000 unit
- Sumber    : inventaris laboratorium
- Prioritas : wajib

## KD-05 Data Peminjaman

- Deskripsi : sistem mencatat transaksi peminjaman yang dilakukan oleh anggota.
- Data      : nomor_peminjaman, anggota, tanggal_pinjam, jatuh_tempo, tanggal_kembali, status
- Aturan    : peminjaman hanya boleh dilakukan oleh anggota aktif; tanggal jatuh tempo tidak boleh lebih awal dari tanggal pinjam.
- Volume    : ±60 transaksi per hari
- Sumber    : petugas laboratorium
- Prioritas : wajib

## KD-06 Detail Peminjaman

- Deskripsi : sistem mencatat unit alat yang terdapat di dalam setiap transaksi peminjaman.
- Data      : peminjaman, unit_alat, kondisi_saat_pinjam
- Aturan    : satu transaksi dapat memuat beberapa unit; satu unit hanya boleh berada pada satu peminjaman aktif pada waktu yang sama.
- Volume    : ±120 baris transaksi per hari
- Sumber    : transaksi peminjaman
- Prioritas : wajib

## KD-07 Data Petugas

- Deskripsi : sistem menyimpan data petugas laboratorium yang melayani transaksi.
- Data      : nomor_petugas, nama, email, status
- Aturan    : nomor petugas harus unik; hanya petugas aktif yang dapat melayani transaksi.
- Volume    : ±20 petugas
- Sumber    : administrasi laboratorium
- Prioritas : penting

## KD-08 Riwayat Perbaikan

- Deskripsi : sistem mencatat riwayat perbaikan unit alat yang mengalami kerusakan.
- Data      : unit_alat, tanggal_mulai, tanggal_selesai, keterangan, status
- Aturan    : unit yang sedang dalam proses perbaikan harus berstatus tidak tersedia untuk peminjaman.
- Volume    : ±20 proses perbaikan per bulan
- Sumber    : petugas laboratorium
- Prioritas : penting

## KD-09 Data Peran

- Deskripsi : sistem menyimpan peran dasar yang digunakan oleh pengguna sistem.
- Data      : kode, nama
- Aturan    : kode peran harus unik.
- Volume    : ±3 sampai 10 peran
- Sumber    : konfigurasi sistem
- Prioritas : penting