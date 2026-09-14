-- Diminta: membuat view dengan GROUP BY dan mencoba INSERT melalui view tersebut.
-- Dipilih: view agregasi sederhana untuk membuktikan batas auto-updatable view.
-- Alternatif: view tanpa agregasi; tidak dipilih karena tidak menjawab pertanyaan soal.
DROP VIEW IF EXISTS lab4.pendapatan_kategori;
CREATE VIEW lab4.pendapatan_kategori AS
SELECT rating, COUNT(*) AS total_film
FROM lab4.film
GROUP BY rating;

INSERT INTO lab4.pendapatan_kategori (rating, total_film)
VALUES ('NC-17', 100);
