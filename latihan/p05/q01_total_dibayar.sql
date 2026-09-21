CREATE OR REPLACE FUNCTION lab5.total_dibayar(p_rental_id bigint)
RETURNS numeric(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total numeric(10,2);
BEGIN
    SELECT COALESCE(SUM(amount), 0)
    INTO v_total
    FROM lab5.payment_tx
    WHERE rental_id = p_rental_id;

    RETURN v_total;
END;
$$;

SELECT lab5.total_dibayar(1) AS total_dibayar;