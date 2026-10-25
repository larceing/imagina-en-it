"""Construye el Data Warehouse de ejemplo de Ciclos del Sur (bronce -> plata -> oro) y pasa las pruebas.

Uso:
    pip install duckdb
    python run.py
"""
import os
import pathlib
import sys

import duckdb

AQUI = pathlib.Path(__file__).parent
SQL = AQUI / "sql"


def main() -> int:
    os.chdir(AQUI)  # las rutas de los CSV son relativas a esta carpeta
    con = duckdb.connect("almacen.duckdb")

    for capa in ["01_bronce.sql", "02_plata.sql", "03_oro.sql"]:
        con.execute((SQL / capa).read_text(encoding="utf-8"))
        print(f"OK  {capa}")

    print("\nFilas por capa")
    for tabla in ["bronce.sevilla_excel", "bronce.malaga_caja", "bronce.web_pedidos",
                  "plata.ventas", "oro.fact_ventas"]:
        n = con.execute(f"SELECT count(*) FROM {tabla}").fetchone()[0]
        print(f"  {tabla:<22} {n:>6}")

    print("\nPruebas")
    fallos = 0
    bloques = (SQL / "04_pruebas.sql").read_text(encoding="utf-8").split("-- name: ")[1:]
    for bloque in bloques:
        nombre, consulta = bloque.split("\n", 1)
        n = len(con.execute(consulta).fetchall())
        estado = "PASA" if n == 0 else f"FALLA ({n} filas)"
        fallos += n > 0
        print(f"  {nombre:<32} {estado}")

    print("\nVentas por tienda (una sola versión de la verdad)")
    for tienda, ventas in con.execute("""
        SELECT t.tienda, round(sum(f.importe), 2)
        FROM oro.fact_ventas f JOIN oro.dim_tienda t USING (tienda_key)
        GROUP BY ALL ORDER BY 2 DESC
    """).fetchall():
        print(f"  {tienda:<10} {ventas:>14,.2f} €")
    total = con.execute("SELECT round(sum(importe), 2) FROM oro.fact_ventas").fetchone()[0]
    print(f"  {'TOTAL':<10} {total:>14,.2f} €")

    con.close()
    return 1 if fallos else 0


if __name__ == "__main__":
    sys.exit(main())
