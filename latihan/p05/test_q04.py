import psycopg

with psycopg.connect(
    "host=localhost port=5432 dbname=latihan user=msbd password=msbd2026"
) as conn:
    conn.execute("CALL lab5.process_rental_commit(5, 1, 1, 4.99)")
    print("CALL berhasil")
