from decimal import Decimal

import psycopg
from fastapi import FastAPI, Depends, HTTPException, status
from pydantic import BaseModel, Field


# ============================================================
# KONFIGURASI DATABASE
# ============================================================

# Samakan dengan koneksi PostgreSQL yang kalian gunakan.
DSN = "postgresql://postgres:PASSWORD@localhost:5432/pagila"


# ============================================================
# FASTAPI
# ============================================================

app = FastAPI(
    title="Lab 5 Rental API"
)


# ============================================================
# Q21 - DEPENDENCY get_conn()
# ============================================================

def get_conn():
    with psycopg.connect(DSN) as conn:
        yield conn


# ============================================================
# MODEL REQUEST
# ============================================================

class RentalRequest(BaseModel):
    rental_id: int
    customer_id: int
    inventory_id: int

    # Q23:
    # amount harus lebih besar dari 0.
    amount: Decimal = Field(gt=0)


# ============================================================
# Q22 - POST /rentals
# ============================================================

@app.post(
    "/rentals",
    status_code=status.HTTP_201_CREATED
)
def create_rental(
    data: RentalRequest,
    conn=Depends(get_conn)
):

    try:
        # ----------------------------------------------------
        # Q24 - CEK INVENTORY
        # ----------------------------------------------------

        inventory = conn.execute(
            """
            SELECT inventory_id
            FROM inventory
            WHERE inventory_id = %s
            """,
            (data.inventory_id,)
        ).fetchone()

        if inventory is None:
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Inventory tidak tersedia"
            )


        # ----------------------------------------------------
        # PANGGIL PROCEDURE Q2
        # ----------------------------------------------------

        conn.execute(
            """
            CALL lab5.process_rental(
                %s,
                %s,
                %s,
                %s
            )
            """,
            (
                data.rental_id,
                data.customer_id,
                data.inventory_id,
                data.amount
            )
        )


        # ----------------------------------------------------
        # RESPONSE Q22
        # ----------------------------------------------------

        return {
            "message": "Rental berhasil dibuat",
            "rental_id": data.rental_id
        }


    except HTTPException:
        raise


    except psycopg.errors.UniqueViolation:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Rental ID sudah digunakan"
        )


    except psycopg.errors.ForeignKeyViolation:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Customer atau inventory tidak valid"
        )


    except Exception:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Terjadi kesalahan pada server"
        )


# ============================================================
# ROOT - OPSIONAL
# ============================================================

@app.get("/")
def root():
    return {
        "message": "Lab 5 Rental API aktif"
    }