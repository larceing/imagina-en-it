# Episodio 1 · Imagina que una IA te hace el dashboard de tu negocio

Le pides a una IA un dashboard de Power BI para una tienda de bicis. En 20 minutos lo tienes y parece perfecto, pero dice que las ventas caen un 8 % cuando en realidad suben un 26 %.

## Archivos

- `CiclosDelSur_ventas.xlsx`: datos de ejemplo (enero 2025 a septiembre 2026). Hojas: Ventas, Productos, Clientes y Objetivos.
- [`prompts.md`](prompts.md): los prompts del vídeo, listos para copiar.
- [`medidas.dax`](medidas.dax): las medidas DAX ya corregidas.
- [`power-query.md`](power-query.md): los arreglos en Power Query.
- [`checklist.md`](checklist.md): qué revisar siempre antes de enviar un informe hecho con IA.

## Las 3 trampas del Excel

| # | Error | Cómo se ve | Arreglo |
|---|---|---|---|
| 1 | Periodo incompleto | Crecimiento −8 % | Comparar enero–septiembre con enero–septiembre: **+26 %** |
| 2 | Producto duplicado (P013) | Relación varios a varios, ventas del casco contadas dos veces | Quitar duplicados en Power Query y preguntar al cliente cuál es el bueno |
| 3 | Otra granularidad | Objetivos por mes y categoría, ventas por día | Fecha de primer día de mes en Objetivos. Cumplimiento: **112,9 %** |

## Cifras de referencia

- Ventas enero–septiembre 2026: 622.398 €
- Ventas enero–septiembre 2025: 492.280 €
- Margen: 43,6 %
