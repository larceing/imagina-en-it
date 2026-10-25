-- ORO: modelo en estrella listo para Power BI.
-- Claves propias del almacén (producto_key, ...) independientes de los códigos de cada programa.
CREATE SCHEMA IF NOT EXISTS oro;

CREATE OR REPLACE TABLE oro.dim_producto AS
SELECT row_number() OVER (ORDER BY cod_producto) AS producto_key, *
FROM plata.productos;

CREATE OR REPLACE TABLE oro.dim_cliente AS
SELECT row_number() OVER (ORDER BY cod_cliente) AS cliente_key, *
FROM plata.clientes;

CREATE OR REPLACE TABLE oro.dim_tienda AS
SELECT row_number() OVER (ORDER BY tienda) AS tienda_key, tienda,
       CASE WHEN tienda = 'Web' THEN 'Online' ELSE 'Física' END AS canal
FROM (SELECT DISTINCT tienda FROM plata.ventas);

CREATE OR REPLACE TABLE oro.dim_fecha AS
SELECT
    d::DATE                         AS fecha,
    year(d)                         AS anio,
    month(d)                        AS mes,
    strftime(d, '%Y-%m')            AS anio_mes,
    isodow(d)                       AS dia_semana
FROM range(
    (SELECT date_trunc('year', min(fecha)) FROM plata.ventas),
    (SELECT date_trunc('year', max(fecha)) + INTERVAL 1 YEAR FROM plata.ventas),
    INTERVAL 1 DAY
) t(d);

CREATE OR REPLACE TABLE oro.fact_ventas AS
SELECT
    v.ticket,
    v.linea,
    v.fecha,
    p.producto_key,
    c.cliente_key,
    t.tienda_key,
    v.unidades,
    v.precio,
    v.descuento,
    v.unidades * v.precio * (1 - v.descuento)           AS importe,
    v.unidades * p.coste                                AS coste
FROM plata.ventas v
LEFT JOIN oro.dim_producto p ON p.cod_producto = v.cod_producto
LEFT JOIN oro.dim_cliente  c ON c.cod_cliente  = v.cod_cliente
LEFT JOIN oro.dim_tienda   t ON t.tienda       = v.tienda;
