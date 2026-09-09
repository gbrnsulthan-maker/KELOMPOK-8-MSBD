SELECT 
    CASE 
        WHEN GROUPING(c.name) = 1 
        THEN 'SEMUA' 
        ELSE c.name 
    END AS kategori,
    CASE 
        WHEN GROUPING(f.rating) = 1 
        THEN 'SEMUA' 
        ELSE f.rating 
    END AS rating, AVG(f.rental_rate) AS rata_rata_tarif
    FROM film f 

JOIN film_category fc 
    ON fc.film_id = f.film_id  

JOIN category c 
    ON c.category_id = fc.category_id 
GROUP BY ROLLUP(c.name, f.rating) 
ORDER BY kategori, rating;
