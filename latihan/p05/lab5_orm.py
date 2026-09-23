from sqlalchemy import ForeignKey, create_engine, select
from sqlalchemy.orm import (
    DeclarativeBase,
    Mapped,
    Session,
    mapped_column,
    relationship,
    selectinload,
)

DSN = "postgresql+psycopg://msbd:msbd2026@localhost:5432/pagila"


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

    engine = create_engine(DSN, echo=True)

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

    engine = create_engine(DSN, echo=True)

    with Session(engine) as session:
        rows = session.scalars(
            select(Customer)
            .options(selectinload(Customer.rentals))
            .limit(10)
        ).all()

        print([
            (c.customer_id, len(c.rentals))
            for c in rows
        ])

    engine.dispose()