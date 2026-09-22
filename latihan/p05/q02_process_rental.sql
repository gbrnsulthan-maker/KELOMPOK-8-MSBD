CREATE OR REPLACE PROCEDURE lab5.process_rental(
    p_rental_id bigint,
    p_customer_id integer,
    p_inventory_id integer,
    p_amount numeric(10,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO lab5.rental_tx (
        rental_id,
        customer_id,
        inventory_id,
        status
    )
    VALUES (
        p_rental_id,
        p_customer_id,
        p_inventory_id,
        'completed'
    );

    INSERT INTO lab5.payment_tx (
        rental_id,
        customer_id,
        amount
    )
    VALUES (
        p_rental_id,
        p_customer_id,
        p_amount
    );
END;
$$;

CALL lab5.process_rental(1, 1, 1, 4.99);

SELECT * FROM lab5.rental_tx WHERE rental_id = 1;

SELECT * FROM lab5.payment_tx WHERE rental_id = 1;