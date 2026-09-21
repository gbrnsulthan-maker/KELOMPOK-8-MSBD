-- Q4: COMMIT di dalam procedure

CREATE OR REPLACE PROCEDURE lab5.process_rental_commit(
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

    COMMIT;

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

CALL lab5.process_rental_commit(4, 1, 1, 4.99);