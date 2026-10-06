# Refleksi Q11: Urutan Kolom B-Tree vs Kemampuan Membaca Data

Berdasarkan pengukuran di mesin pengujian (2 juta baris,
max_parallel_workers_per_gather = 0):
- Baseline (Tanpa Index): Median 631.329 ms
- Index Salah (terjadi_pada, customer_id): Median 12.182 ms
- Index Benar (customer_id, terjadi_pada DESC): Median 0.249 ms

## Rantai Sebab-Akibat
1. **Urutan kolom B-Tree menentukan urutan data di leaf.**
   Index (customer_id, terjadi_pada DESC) membuat leaf terurut
   berdasarkan customer_id dulu, lalu di dalam satu customer
   terurut berdasarkan terjadi_pada menurun.
2. **Predikat equality melompat langsung ke blok yang tepat.**
   Query menyaring customer_id = 4211, sehingga B-Tree langsung
   menuju blok customer 4211 tanpa menyentuh customer lain.
3. **Kolom kedua yang cocok dengan ORDER BY menghilangkan Sort.**
   Data customer 4211 sudah tersusun terjadi_pada DESC, jadi
   PostgreSQL tinggal membaca 20 entri pertama lalu berhenti
   (LIMIT 20). Tidak ada node Sort, tidak ada pemindaian baris lain.
   Inilah yang membuat waktu eksekusi anjlok ke ~0.25 ms
   (hampir 2500x lebih cepat dari baseline).
4. **Urutan salah membuat kolom kedua hampir tidak berguna.**
   Pada index (terjadi_pada, customer_id), leaf terurut berdasarkan
   waktu; baris milik customer 4211 tersebar di seluruh index,
   sehingga equality pada kolom kedua tidak bisa dipakai sebagai
   prefix. Planner tetap terbantu (turun ke ~12 ms), tetapi masih
   harus melakukan Filter dan Sort.

## Temuan Q10: Ukuran Hampir Sama, Efektivitas Berbeda Jauh
- ev_benar_idx (customer_id, terjadi_pada DESC): 60 MB (63.102.976 B)
- ev_salah_idx (terjadi_pada, customer_id):     60 MB (63.012.864 B)
- Selisih hanya ~90 KB (0.14%).

Artinya, urutan kolom hampir tidak memengaruhi ukuran: kedua index
menyimpan dua kolom yang sama dengan jumlah entri yang sama dan
kedalaman B-Tree yang serupa. Yang berubah drastis adalah
efektivitasnya — urutan leaf menentukan apakah B-Tree bisa langsung
melompat ke customer 4211 dan apakah data sudah terurut sesuai
ORDER BY. Kecepatan 0.25 ms vs 12 ms lahir dari urutan, bukan dari
ukuran.

## Kesimpulan
Index "cocok" dengan query bila prefix paling kiri sama dengan
predikat equality, dan kolom berikutnya mengikuti arah ORDER BY.
Jangan memilih urutan kolom berdasarkan ukuran; pilih berdasarkan
pola query yang akan dilayani.
