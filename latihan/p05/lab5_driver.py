import psycopg
from psycopg import sql

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

if __name__ == "__main__":
    q10_koneksi_dasar()
    q11_injection()
    q12_order_by()
