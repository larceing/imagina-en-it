# Prompts del episodio 1

## 1. Entender los datos (sin código)

```
Eres un analista de datos experto en Power BI y modelado en estrella.
Te adjunto el Excel de ventas de Ciclos del Sur, una tienda de bicis de Sevilla.
Tiene 4 hojas: Ventas, Productos, Clientes y Objetivos.
1. Para cada hoja dime qué representa una fila, sus columnas clave y
   cualquier problema de calidad que veas.
2. Propón un modelo en estrella para Power BI: tablas de hechos,
   dimensiones y relaciones con su cardinalidad.
No escribas código todavía.
```

## 2. Carga y tabla calendario

```
Genera el código M de Power Query para una tabla Calendario
del 1 de enero de 2025 al 31 de diciembre de 2026, con las columnas
Fecha, Año, Mes, Nombre mes (en español), Trimestre y AñoMes.
Solo el código.
```

Pégalo en una consulta en blanco y márcala como tabla de fechas.

## 3. Medidas DAX (plantilla de 6 partes)

```
ROL: Eres experto en DAX y modelado en Power BI.
TAREA: Crea estas medidas: Ventas, Coste, Margen, Margen %,
Ventas año anterior, Crecimiento interanual % y Cumplimiento objetivo %.
CONTEXTO: Ventas[Unidades], Ventas[PrecioUnitario], Ventas[Descuento],
Productos[Coste], Objetivos[Objetivo]. Calendario marcada como tabla de fechas.
RAZONAMIENTO: Prioriza legibilidad. Usa variables.
SALIDA: Solo el código de cada medida, con un comentario de una línea.
CONDICIONES: Usa DIVIDE. Nada de columnas calculadas.
```

## Consejo: dale contexto desde el principio

Añade al primer prompt algo así y la IA fallará mucho menos:

```
Contexto del negocio:
- Los datos de 2026 llegan solo hasta septiembre.
- Hay productos que se renuevan con un modelo nuevo.
- Los objetivos son mensuales y por categoría.
```
