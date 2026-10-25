# Arreglos en Power Query

## Error 2 · Producto duplicado

En la consulta **Productos**:

```m
= Table.Distinct(#"Tipo cambiado", {"CodProducto"})
```

Ojo: `Table.Distinct` se queda con la **primera** fila que encuentra. Antes de aplicarlo, decide con el cliente qué fila es la buena (aquí, ¿«Casco Urban» o «Casco Urban (nuevo modelo)»?) y ordena o filtra para que quede esa.

Después, cambia la relación Productos → Ventas a **uno a varios**.

## Error 3 · Otra granularidad

En la consulta **Objetivos**, añade una columna con el primer día de cada mes:

```m
= Table.AddColumn(#"Tipo cambiado", "Fecha", each #date([Año], [Mes], 1), type date)
```

1. Relaciona `Objetivos[Fecha]` con `Calendario[Fecha]` (varios a uno).
2. Crea una tabla **Categorías** (referencia a Productos, solo la columna Categoria, sin duplicados) y relaciónala con `Productos[Categoria]` y `Objetivos[Categoria]`.
3. Analiza el cumplimiento por mes o por categoría, nunca por día ni por producto.
