-- Diminta: menyiapkan skema lab5 sesuai modul resmi: enum, domain, tabel dengan FK ke public, dan procedure process_rental.
-- Dipilih: struktur resmi modul karena Q13-Q24 (ORM & API) bergantung pada FK, tipe data, dan procedure ini.
-- Alternatif: struktur sederhana tanpa FK/procedure; tidak dipilih karena Q24 tidak bisa diuji sesuai modul.
DROP SCHEMA IF EXISTS lab5 CASCADE;
CREATE SCHEMA lab5;

CREATE TYPE lab5.rental_status AS ENUM ('ACTIVE', 'RETURNED', 'CANCELLED');
CREATE DOMAIN lab5.positive_amount AS numeric(10,2) CHECK (VALUE > 0);

CREATE TABLE lab5.rental_tx (
  rental_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  customer_id integer NOT NULL REFERENCES public.customer(customer_id),
  inventory_id integer NOT NULL REFERENCES public.inventory(inventory_id),
  staff_id integer NOT NULL REFERENCES public.staff(staff_id),
  status lab5.rental_status NOT NULL DEFAULT 'ACTIVE',
  tags text[] NOT NULL DEFAULT '{}',
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE lab5.payment_tx (
  payment_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  rental_id bigint NOT NULL REFERENCES lab5.rental_tx(rental_id),
  amount lab5.positive_amount NOT NULL,
  paid_at timestamptz NOT NULL DEFAULT now()
);

-- Procedure untuk Q2-Q5, Q13, dan Q22
CREATE OR REPLACE PROCEDURE lab5.process_rental(
    p_customer_id integer,
    p_inventory_id integer,
    p_staff_id integer,
    p_amount numeric
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rental_id bigint;
BEGIN
    INSERT INTO lab5.rental_tx (customer_id, inventory_id, staff_id)
    VALUES (p_customer_id, p_inventory_id, p_staff_id)
    RETURNING rental_id INTO v_rental_id;

    INSERT INTO lab5.payment_tx (rental_id, amount)
    VALUES (v_rental_id, p_amount);
END;
$$;
