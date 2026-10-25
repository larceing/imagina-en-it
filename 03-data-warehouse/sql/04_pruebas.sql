-- PRUEBAS: cada consulta devuelve las filas problemáticas. Si devuelve 0, la prueba pasa.

-- name: lineas_duplicadas
SELECT ticket, linea, count(*) AS n FROM oro.fact_ventas GROUP BY ticket, linea HAVING count(*) > 1;

-- name: ventas_sin_producto
SELECT * FROM oro.fact_ventas WHERE producto_key IS NULL;

-- name: ventas_sin_tienda
SELECT * FROM oro.fact_ventas WHERE tienda_key IS NULL;

-- name: ventas_sin_fecha_en_calendario
SELECT f.* FROM oro.fact_ventas f LEFT JOIN oro.dim_fecha d USING (fecha) WHERE d.fecha IS NULL;

-- name: importes_negativos
SELECT * FROM oro.fact_ventas WHERE importe < 0;

-- name: productos_duplicados
SELECT cod_producto FROM oro.dim_producto GROUP BY cod_producto HAVING count(*) > 1;
