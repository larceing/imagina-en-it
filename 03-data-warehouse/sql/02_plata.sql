-- PLATA: limpiar y unificar. Mismas columnas, mismos formatos, mismos códigos.
CREATE SCHEMA IF NOT EXISTS plata;

CREATE OR REPLACE TABLE plata.ventas AS
WITH unidas AS (
    -- Sevilla: fecha dd/mm/aaaa y decimales con coma
    SELECT
        'SEV-' || NumTicket                                   AS ticket,
        Linea::INTEGER                                        AS linea,
        strptime(Fecha, '%d/%m/%Y')::DATE                     AS fecha,
        upper(CodProducto)                                    AS cod_producto,
        CodCliente                                            AS cod_cliente,
        'Sevilla'                                             AS tienda,
        Unidades::INTEGER                                     AS unidades,
        replace(PrecioUnitario, ',', '.')::DECIMAL(10, 2)     AS precio,
        replace(Descuento, ',', '.')::DECIMAL(4, 2)           AS descuento
    FROM bronce.sevilla_excel

    UNION ALL
    -- Málaga: fecha americana, código con guion, descuento en %, tienda "MLG"
    SELECT
        'MLG-' || ticket,
        linea::INTEGER,
        strptime(fecha, '%m/%d/%Y')::DATE,
        upper(replace(articulo, '-', '')),
        cliente,
        CASE tienda WHEN 'MLG' THEN 'Málaga' ELSE tienda END,
        cant::INTEGER,
        precio::DECIMAL(10, 2),
        (dto_pct::INTEGER / 100.0)::DECIMAL(4, 2)
    FROM bronce.malaga_caja

    UNION ALL
    -- Web: timestamp ISO, sku en minúsculas, columnas en inglés
    SELECT
        'WEB-' || order_id,
        line::INTEGER,
        CAST(created_at::TIMESTAMPTZ AS DATE),
        upper(sku),
        customer_id,
        'Web',
        qty::INTEGER,
        unit_price::DECIMAL(10, 2),
        discount::DECIMAL(4, 2)
    FROM bronce.web_pedidos
)
-- Quitar duplicados: la caja de Málaga exportó un día dos veces.
-- Una línea de ticket es única por (ticket, linea).
SELECT * FROM unidas
QUALIFY row_number() OVER (PARTITION BY ticket, linea ORDER BY fecha) = 1;

-- Productos: un solo registro por código (P013 venía repetido; nos quedamos con el modelo vigente)
CREATE OR REPLACE TABLE plata.productos AS
SELECT
    upper(CodProducto)        AS cod_producto,
    Producto                  AS producto,
    Categoria                 AS categoria,
    Coste::DECIMAL(10, 2)     AS coste,
    PVP::DECIMAL(10, 2)       AS pvp
FROM bronce.productos
QUALIFY row_number() OVER (PARTITION BY upper(CodProducto) ORDER BY PVP::DECIMAL DESC) = 1;

CREATE OR REPLACE TABLE plata.clientes AS
SELECT
    CodCliente              AS cod_cliente,
    Cliente                 AS cliente,
    Ciudad                  AS ciudad,
    Tipo                    AS tipo,
    FechaAlta::DATE         AS fecha_alta
FROM bronce.clientes;
