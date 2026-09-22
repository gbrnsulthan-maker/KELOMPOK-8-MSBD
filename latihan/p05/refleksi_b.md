# Refleksi B: tags (ARRAY) vs metadata (JSONB)

## tags -> tetap ARRAY
Tags cocok disimpan sebagai text[] karena isinya hanya daftar label sederhana
tanpa atribut tambahan, dan query-nya sebatas "apakah tag X ada?" (pakai ANY).
Memecahnya menjadi tabel relasi tersendiri (misal content_tags) hanya menambah
JOIN yang tidak perlu untuk kebutuhan sesederhana ini.

## metadata -> tetap JSONB
Metadata cocok sebagai jsonb karena bentuknya dinamis dan jarang (sparse):
hari ini berisi channel dan device, besok bisa bertambah version, ip, dsb.
Kalau dibuat kolom relasional, tabel akan penuh kolom NULL setiap kali ada
atribut baru. JSONB fleksibel dan tetap bisa diindeks GIN bila pencarian
mulai sering dilakukan.
