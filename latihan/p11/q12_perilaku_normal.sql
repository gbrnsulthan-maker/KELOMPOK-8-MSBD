-- Q12: perilaku normal, masukan "Pelanggan 12"
-- SQL di bawah ini dicetak oleh rentan.py (rekonstruksi dari deskripsi handout,
-- Bagian dari masukan pengguna : Pelanggan 12 (hanya di antara tanda % pada ILIKE)
-- Bagian dari kode program      : SELECT, FROM, WHERE nama ILIKE, dan LIMIT 100

SELECT id, nama, kota
FROM lab11.pelanggan
WHERE nama ILIKE '%Pelanggan 12%'
LIMIT 100;