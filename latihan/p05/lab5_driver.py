import psycopg
from psycopg import sql
from sqlalchemy import ForeignKey, create_engine, select
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship, Session, selectinload

DSN = "postgresql://msbd:msbd2026@localhost:5432/pagila"

def q10_koneksi_dasar():
    print("--- Q10: Koneksi + SELECT dengan %s ---")
    with psycopg.connect(DSN) as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT customer_id, first_name, last_name "
                "FROM public.customer WHERE customer_id = %s",
                (1,),
            )

            print("Hasil:", cur.fetchone())

def q11_injection():
    print("\n--- Q11: SQL Injection Test ---")
    nama = "SMITH' OR '1'='1"
    # Versi f-string: HANYA DICETAK, TIDAK DIEKSEKUSI (larangan modul)
    query_bahaya = f"SELECT * FROM public.customer WHERE last_name = '{nama}'"
    print("F-String (TIDAK dieksekusi):", query_bahaya)
    # Versi parameter binding: benar-benar dijalankan
    with psycopg.connect(DSN) as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT * FROM public.customer WHERE last_name = %s",
                (nama,),
            )
            rows = cur.fetchall()
            print(f"Parameter binding dijalankan. Jumlah baris: {len(rows)} (harusnya 0)")

def q12_order_by():
    print("\n--- Q12: ORDER BY dinamis ---")
    kolom = "last_name"
    with psycopg.connect(DSN) as conn:
        with conn.cursor() as cur:
            # Cara SALAH: parameter biasa untuk nama kolom (simpan errornya)
            try:
                cur.execute(
                    "SELECT first_name, last_name FROM public.customer "
                    "ORDER BY %s LIMIT 3",
                    (kolom,),
                )
            except Exception as e:
                print("Error cara salah:", e)
            # Cara BENAR: sql.Identifier + allow-list
            allow = {"customer_id", "first_name", "last_name"}
            if kolom not in allow:
                raise ValueError(f"kolom {kolom} tidak diizinkan")
            query_aman = sql.SQL(
                "SELECT first_name, last_name FROM public.customer "
                "ORDER BY {} LIMIT 3"
            ).format(sql.Identifier(kolom))
            cur.execute(query_aman)
            print("Cara benar berhasil:", cur.fetchall())

def q13_rollback_aplikasi():
    print("\n--- Q13: Rollback dari aplikasi ---")

    with psycopg.connect(DSN) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM lab5.rental_tx")
            jumlah_sebelum = cur.fetchone()[0]

    print("Jumlah rental sebelum:", jumlah_sebelum)

    try:
        with psycopg.connect(DSN) as conn:
            conn.execute(
                "CALL lab5.process_rental(%s, %s, %s, %s)",
                (1, 1, 1, 4.99)
            )

            raise RuntimeError("gagal di tengah alur")

    except RuntimeError as e:
        print("Error Python:", e)

    with psycopg.connect(DSN) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM lab5.rental_tx")
            jumlah_sesudah = cur.fetchone()[0]

    print("Jumlah rental sesudah:", jumlah_sesudah)

def q14_connection_pool():
    print("\n--- Q14: ConnectionPool ---")

    with ConnectionPool(DSN, min_size=2, max_size=2) as pool:
        for i in range(5):
            with pool.connection() as conn:
                with conn.cursor() as cur:
                    cur.execute("SELECT %s AS request_number", (i + 1,))
                    result = cur.fetchone()[0]
                    print(f"Request {result} selesai")

        stats = pool.get_stats()
        print("Pool stats:", stats)

def q15_idle_in_transaction():
    print("\n--- Q15: Idle in transaction ---")

    conn = psycopg.connect(DSN)
    conn.execute("BEGIN")
    conn.execute("SELECT 1")

    print("Transaksi terbuka. Tunggu 30 detik...")

    import time
    time.sleep(30)

    conn.rollback()
    conn.close()

# Q16: Model deklaratif
class Base(DeclarativeBase):
    pass

class Customer(Base):
    __tablename__ = "customer"

    customer_id: Mapped[int] = mapped_column(primary_key=True)

    rentals: Mapped[list["Rental"]] = relationship(
        back_populates="customer"
    )

class Rental(Base):
    __tablename__ = "rental"

    rental_id: Mapped[int] = mapped_column(primary_key=True)

    customer_id: Mapped[int] = mapped_column(
        ForeignKey("customer.customer_id")
    )

    customer: Mapped["Customer"] = relationship(
        back_populates="rentals"
    )

# Q17: Bukti N+1
def q17_n_plus_one():
    print("\n--- Q17: Bukti N+1 ---")

    engine = create_engine(DSN)

    with Session(engine) as session:
        rows = session.scalars(
            select(Customer).limit(10)
        ).all()

        for c in rows:
            print(c.customer_id, len(c.rentals))

    engine.dispose()

# Q18: selectinload
def q18_selectinload():
    print("\n--- Q18: selectinload ---")

    engine = create_engine(DSN)

    with Session(engine) as session:
        rows = session.scalars(
            select(Customer)
            .options(selectinload(Customer.rentals))
            .limit(10)
        ).all()

        print([(c.customer_id, len(c.rentals)) for c in rows])

    engine.dispose()

if __name__ == "__main__":
    q10_koneksi_dasar()
    q11_injection()
    q12_order_by()
    q13_rollback_aplikasi()
    q14_connection_pool()
    q15_idle_in_transaction()
    q17_n_plus_one()
    q18_selectinload()