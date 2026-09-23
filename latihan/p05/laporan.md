# Laporan Latihan Kelompok Pertemuan 5

## Anggota dan Kontribusi

**Novri**  
Mengerjakan setup, Q1 sampai Q5, serta Refleksi A.

**Bintang**  
Mengerjakan Q6 sampai Q12 serta Refleksi B.

**Limjun**  
Mengerjakan Q13 sampai Q18 serta Refleksi C.

**Ghibran Sultan Alfarabi**  
Mengerjakan Q19 sampai Q24, Refleksi D, Refleksi E, README.md, serta finalisasi laporan.md.

## Ringkasan N+1

Pada Q17 dilakukan pengujian lazy loading dengan mengambil 10 customer kemudian mengakses relationship `rentals` dari setiap customer. Cara ini menunjukkan masalah N+1 karena setelah query awal untuk mengambil customer, terdapat query tambahan ketika data rental setiap customer diakses.

Jumlah SELECT berdasarkan hasil pengujian:

`[ISI HASIL AKTUAL Q17]`

Pada Q18 digunakan `selectinload(Customer.rentals)`. Cara ini mengurangi jumlah query karena SQLAlchemy mengambil customer terlebih dahulu, kemudian mengambil rental yang berhubungan dengan customer tersebut menggunakan query terpisah secara terkontrol.

Jumlah SELECT berdasarkan hasil pengujian:

`[ISI HASIL AKTUAL Q18]`

Pada Q19 digunakan `joinedload(Customer.rentals)`. Berbeda dengan `selectinload`, `joinedload` menggunakan JOIN untuk mengambil customer beserta relationship rental.

Jumlah SELECT berdasarkan hasil pengujian:

`[ISI HASIL AKTUAL Q19]`

Dari ketiga pengujian tersebut dapat dilihat bahwa strategi pemuatan relationship berpengaruh terhadap jumlah dan bentuk query yang dikirimkan ke database. Hasil aktual dari log SQL digunakan untuk membuktikan perbedaannya.

# Di Mana Aturan Itu Tinggal

## Pembayaran Harus Positif

Aturan pembayaran positif diterapkan pada dua lapisan, yaitu Pydantic di sisi aplikasi dan domain PostgreSQL di sisi database.

Pydantic berfungsi menolak input tidak valid lebih awal sebelum data dikirimkan ke database. Sementara itu, domain PostgreSQL memastikan bahwa aturan pembayaran positif tetap berlaku meskipun data dimasukkan melalui jalur selain FastAPI.

Bukti penerapan aturan ini dapat dilihat pada Q6 dan Q23.

## Rental dan Payment Harus Atomik

Aturan berikutnya adalah proses rental dan payment harus dilakukan secara atomik. Aturan ini ditempatkan pada procedure dan transaksi PostgreSQL.

Procedure `lab5.process_rental` melakukan proses INSERT rental dan payment dalam satu proses. Apabila terjadi kegagalan sebelum transaksi selesai, perubahan dapat dibatalkan sehingga tidak terjadi kondisi ketika rental berhasil tercatat tetapi payment gagal tercatat.

Bukti perilaku transaksi ini dapat dilihat pada Q2, Q3, dan Q13.

## Detail SQL Tidak Boleh Diberikan kepada Client

Aturan ketiga berada pada lapisan endpoint FastAPI. Error dari database tidak seharusnya langsung diberikan secara mentah kepada pengguna API.

FastAPI menerjemahkan kondisi tertentu menjadi HTTP status yang sesuai, misalnya 422 untuk input yang tidak valid dan 409 untuk konflik inventory.

Dengan cara tersebut, pengguna mendapatkan informasi yang diperlukan tanpa melihat detail SQL atau implementasi internal database. Pengujian aturan ini dilakukan pada Q23 dan Q24.

# Penggunaan AI dan Verifikasi

AI digunakan sebagai alat bantu untuk memahami instruksi latihan, menyusun struktur kode Python, memahami konsep ORM dan N+1, serta membantu penyusunan dokumentasi.

AI juga digunakan untuk membantu memahami perbedaan `selectinload` dan `joinedload`, menyusun implementasi FastAPI, serta merapikan README.md dan laporan.md.

Hasil yang diberikan AI tidak langsung dianggap sebagai hasil pengujian. Kode tetap diverifikasi dengan menjalankannya pada lingkungan PostgreSQL kelompok.

Verifikasi dilakukan dengan menjalankan file SQL, `lab5_driver.py`, `lab5_orm.py`, dan `lab5_api.py`. Endpoint FastAPI juga diuji menggunakan curl atau `/docs`. Output aktual kemudian dibandingkan dengan requirement masing-masing soal.

# Pemeriksaan Akhir

Setup Lab 5 harus berhasil dijalankan dan seluruh Q1 sampai Q24 harus memiliki bukti output atau pesan error yang sesuai.

Untuk Q17 sampai Q19, jumlah SELECT perlu dicatat berdasarkan log SQL aktual. Untuk Q20, waktu eksekusi ORM dan Raw SQL juga perlu dicatat berdasarkan hasil pengujian.

Pengujian FastAPI harus membuktikan bahwa Q22 menghasilkan HTTP 201, Q23 menghasilkan HTTP 422, dan Q24 menghasilkan HTTP 409.

Refleksi A sampai E, README.md, dan laporan.md juga harus sudah lengkap. Setiap anggota kelompok harus memiliki commit yang dapat ditelusuri.

Setelah seluruh pengujian selesai, merge request dibuat dan link merge request dicantumkan pada laporan.

## Link Merge Request

`[ISI LINK MERGE REQUEST]`