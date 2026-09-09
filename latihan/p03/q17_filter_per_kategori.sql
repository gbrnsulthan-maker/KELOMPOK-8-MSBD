SELECT 
    c.name AS kategori, 
    COUNT(*) AS total_film, 

    Versi FILTER
    COUNT(*) FILTER (WHERE f.rating = 'G') AS rating_g_filter, 
    COUNT(*) FILTER (WHERE f.rating = 'PG-13') AS rating_pg13_filter, 
    AVG(f.length) FILTER (WHERE f.length > 90) AS rata_durasi_panjang_filter,

    Versi CASE WHEN
    COUNT(CASE WHEN f.rating = 'G' THEN 1 END) AS rating_g_case, 
    COUNT(CASE WHEN f.rating = 'PG-13' THEN 1 END) AS rating_pg13_case, 
    AVG(CASE WHEN f.length > 90 THEN f.length END) AS rata_durasi_panjang_case

FROM category c
JOIN film_category fc 
    ON fc.category_id = c.category_id 
JOIN film f 
    ON f.film_id = fc.film_id 
GROUP BY c.name
ORDER BY c.name;