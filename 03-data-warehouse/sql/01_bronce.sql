-- BRONCE: los datos tal cual llegan de cada sistema. No se toca nada.
CREATE SCHEMA IF NOT EXISTS bronce;

CREATE OR REPLACE TABLE bronce.sevilla_excel AS
SELECT * FROM read_csv('datos/bronce/sevilla_excel.csv', delim = ';', all_varchar = true);

CREATE OR REPLACE TABLE bronce.malaga_caja AS
SELECT * FROM read_csv('datos/bronce/malaga_caja.csv', all_varchar = true);

CREATE OR REPLACE TABLE bronce.web_pedidos AS
SELECT * FROM read_csv('datos/bronce/web_pedidos.csv', all_varchar = true);

CREATE OR REPLACE TABLE bronce.productos AS
SELECT * FROM read_csv('datos/bronce/productos.csv', all_varchar = true);

CREATE OR REPLACE TABLE bronce.clientes AS
SELECT * FROM read_csv('datos/bronce/clientes.csv', all_varchar = true);
