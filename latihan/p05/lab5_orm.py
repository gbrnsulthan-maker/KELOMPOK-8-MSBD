import time

from sqlalchemy import (
    ForeignKey,
    create_engine,
    select,
    text,
    func,
)

from sqlalchemy.orm import (
    DeclarativeBase,
    Mapped,
    Session,
    mapped_column,
    relationship,
    selectinload,
    joinedload,
)


# ============================================================
# KONFIGURASI DATABASE
# ============================================================

# Ganti username dan password sesuai PostgreSQL masing-masing.
DSN = "postgresql+psycopg://postgres:PASSWORD@localhost:5432/pagila"


# ============================================================
# Q16 - MODEL ORM
# ============================================================

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

    inventory_id: Mapped[int] = mapped_column(
        ForeignKey("inventory.inventory_id")
    )

    customer: Mapped["Customer"] = relationship(
        back_populates="rentals"
    )


class Inventory(Base):
    __tablename__ = "inventory"

    inventory_id: Mapped[int] = mapped_column(primary_key=True)

    film_id: Mapped[int] = mapped_column(
        ForeignKey("film.film_id")
    )


class Film(Base):
    __tablename__ = "film"

    film_id: Mapped[int] = mapped_column(primary_key=True)
    title: Mapped[str] = mapped_column()


# ============================================================
# Q17 - BUKTI N+1
# ============================================================

def q17_n_plus_one():
    print("\n======================================")
    print("Q17 - BUKTI N+1")
    print("======================================")

    # echo=True supaya SQL yang dijalankan terlihat.
    engine = create_engine(DSN, echo=True)

    with Session(engine) as session:

        # Mengambil 10 customer.
        rows = session.scalars(
            select(Customer).limit(10)
        ).all()

        # Saat rentals diakses satu per satu,
        # SQLAlchemy melakukan query tambahan.
        for customer in rows:
            print(
                "Customer:",
                customer.customer_id,
                "| Jumlah rental:",
                len(customer.rentals)
            )

    engine.dispose()


# ============================================================
# Q18 - SELECTINLOAD
# ============================================================

def q18_selectinload():
    print("\n======================================")
    print("Q18 - SELECTINLOAD")
    print("======================================")

    engine = create_engine(DSN, echo=True)

    with Session(engine) as session:

        rows = session.scalars(
            select(Customer)
            .options(
                selectinload(Customer.rentals)
            )
            .limit(10)
        ).all()

        print("\nHasil Q18:")

        for customer in rows:
            print(
                "Customer:",
                customer.customer_id,
                "| Jumlah rental:",
                len(customer.rentals)
            )

    engine.dispose()


# ============================================================
# Q19 - JOINEDLOAD
# ============================================================

def q19_joinedload():
    print("\n======================================")
    print("Q19 - JOINEDLOAD")
    print("======================================")

    engine = create_engine(DSN, echo=True)

    with Session(engine) as session:

        rows = session.scalars(
            select(Customer)
            .options(
                joinedload(Customer.rentals)
            )
            .limit(10)
        ).unique().all()

        print("\nHasil Q19:")

        for customer in rows:
            print(
                "Customer:",
                customer.customer_id,
                "| Jumlah rental:",
                len(customer.rentals)
            )

    engine.dispose()


# ============================================================
# Q20 - ORM VS RAW SQL
# ============================================================

def q20_orm_vs_raw():
    print("\n======================================")
    print("Q20 - ORM VS RAW SQL")
    print("======================================")

    engine = create_engine(DSN)

    with Session(engine) as session:

        # ----------------------------------------------------
        # VERSI ORM
        # ----------------------------------------------------

        start_orm = time.perf_counter()

        orm_query = (
            select(
                Film.title,
                func.count(Rental.rental_id).label("jumlah_rental")
            )
            .join(
                Inventory,
                Film.film_id == Inventory.film_id
            )
            .join(
                Rental,
                Inventory.inventory_id == Rental.inventory_id
            )
            .group_by(
                Film.film_id,
                Film.title
            )
            .order_by(
                func.count(Rental.rental_id).desc()
            )
            .limit(5)
        )

        hasil_orm = session.execute(
            orm_query
        ).all()

        end_orm = time.perf_counter()

        waktu_orm = end_orm - start_orm


        # ----------------------------------------------------
        # VERSI RAW SQL
        # ----------------------------------------------------

        start_raw = time.perf_counter()

        raw_query = text("""
            SELECT
                f.title,
                COUNT(r.rental_id) AS jumlah_rental
            FROM film AS f
            JOIN inventory AS i
                ON f.film_id = i.film_id
            JOIN rental AS r
                ON i.inventory_id = r.inventory_id
            GROUP BY
                f.film_id,
                f.title
            ORDER BY
                COUNT(r.rental_id) DESC
            LIMIT 5
        """)

        hasil_raw = session.execute(
            raw_query
        ).all()

        end_raw = time.perf_counter()

        waktu_raw = end_raw - start_raw


        # ----------------------------------------------------
        # OUTPUT
        # ----------------------------------------------------

        print("\n5 Film Paling Banyak Disewa")
        print("--------------------------------------")

        print("\nHasil ORM:")

        for nomor, row in enumerate(
            hasil_orm,
            start=1
        ):
            print(
                nomor,
                row.title,
                "-",
                row.jumlah_rental,
                "rental"
            )


        print("\nHasil Raw SQL:")

        for nomor, row in enumerate(
            hasil_raw,
            start=1
        ):
            print(
                nomor,
                row.title,
                "-",
                row.jumlah_rental,
                "rental"
            )


        print("\nWaktu Eksekusi")
        print("--------------------------------------")

        print(
            "ORM     :",
            waktu_orm,
            "detik"
        )

        print(
            "Raw SQL :",
            waktu_raw,
            "detik"
        )


        # Membuktikan apakah hasil keduanya sama.
        hasil_orm_list = [
            tuple(row)
            for row in hasil_orm
        ]

        hasil_raw_list = [
            tuple(row)
            for row in hasil_raw
        ]

        print(
            "\nApakah hasil ORM dan Raw SQL sama?",
            hasil_orm_list == hasil_raw_list
        )

    engine.dispose()


# ============================================================
# MAIN
# ============================================================

if __name__ == "__main__":

    print("\n======================================")
    print("LATIHAN P05 - SQLALCHEMY ORM")
    print("======================================")

    print("""
Pilih soal yang ingin dijalankan:

1. Q17 - Bukti N+1
2. Q18 - selectinload
3. Q19 - joinedload
4. Q20 - ORM vs Raw SQL
5. Jalankan Semua
""")

    pilihan = input("Pilihan: ")

    if pilihan == "1":
        q17_n_plus_one()

    elif pilihan == "2":
        q18_selectinload()

    elif pilihan == "3":
        q19_joinedload()

    elif pilihan == "4":
        q20_orm_vs_raw()

    elif pilihan == "5":
        q17_n_plus_one()
        q18_selectinload()
        q19_joinedload()
        q20_orm_vs_raw()

    else:
        print("Pilihan tidak tersedia.")