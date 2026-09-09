(
SELECT 
        i.film_id, 
        'inventory_tidak_pernah_dirental' AS arah 
    FROM inventory i 
    EXCEPT 

 SELECT 
         i.film_id, 
        'inventory_tidak_pernah_dirental' AS arah 
    FROM inventory i 
    JOIN rental r 
        ON r.inventory_id = i.inventory_id ) 

UNION ALL 
( 
    SELECT 
        i.film_id, 
        'rental_tanpa_inventory' AS arah
    FROM inventory i
    jOIN rental r 
        ON r.inventory_id = i.inventory_id 
    EXCEPT

    SELECT 
        i.film_id, 
        'rental_tanpa_inventory' AS arah
    FROM inventory i
);
