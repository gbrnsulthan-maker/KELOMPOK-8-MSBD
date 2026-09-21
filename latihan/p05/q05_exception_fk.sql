-- Q5: EXCEPTION foreign_key_violation

CREATE OR REPLACE FUNCTION lab5.test_exception_fk(
    p_rental_id bigint
)
RETURNS text
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO lab5.payment_tx (
        rental_id,
        customer_id,
        amount
    )
    VALUES (
        p_rental_id,
        1,
        4.99
    );

    RETURN 'Insert berhasil';

EXCEPTION
    WHEN foreign_key_violation THEN
        RETURN 'Gagal: rental_id tidak ditemukan';
END;
$$;

-- Pengujian FK dengan rental_id yang tidak ada
SELECT lab5.test_exception_fk(999999);
