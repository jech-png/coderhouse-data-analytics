# RetailPro — Entregable 4

**Extrayendo métricas clave con SQL**

El archivo para entregar es [`m4_consultas_negocio.sql`](m4_consultas_negocio.sql).
Incluye las cuatro consultas y un bloque final con tres hallazgos calculados
sobre las diez ventas del [entregable anterior](../modulo_4/ventas_tech_db.sql).
Todas las consultas usan exclusivamente `ventas`, sin JOIN.

## Sintaxis y ejecución

La consigna solicita `EXTRACT(MONTH FROM fecha_venta)`. El archivo principal usa
sintaxis PostgreSQL con `EXTRACT` y `LIMIT 5`. Se ejecuta conectado a
`Ventas_Tech_DB`, con la tabla `ventas` ya cargada.

El Codespace existente utiliza SQL Server. Para consultar esa misma base sin
instalar nada en la computadora, se incluye una
[versión equivalente para SQL Server](sql_server/m4_consultas_negocio_sqlserver.sql),
que usa `YEAR`, `MONTH` y `TOP (5)`. Produce las mismas métricas.
El archivo principal no se ejecuta directamente en SQL Server.

En el Codespace, con la versión actual del repositorio:

1. Abrir la paleta con **F1**.
2. Elegir **Tasks: Run Task**.
3. Seleccionar **Entregable 4: ejecutar consultas de negocio**.

También se puede ejecutar en la terminal:

```bash
bash RetailPro/ejecutar_sqlserver.sh
```

Esta tarea solo lee la base existente. No vuelve a cargar los datos.

## Criterios de cálculo

- Cada fila de `ventas` cuenta como un pedido, tal como indica la consigna.
- Facturación: `cantidad * precio_unitario`; ticket promedio: promedio de ese importe.
- Los meses se agrupan por año y mes para no mezclar años diferentes.
- El promedio mensual general se calcula sobre los totales de los meses con ventas.
- Se contempla **Igual al promedio** para evitar clasificar una igualdad como
  superior o inferior. Las diez ventas originales son de marzo de 2024.
- La moneda no está especificada en los datos; no se asume ARS ni USD.

## Resultados esperados con los datos originales

Resumen mensual: marzo de 2024, **6444.00** facturados, **10** pedidos y
**644.40** de ticket promedio. La consulta 4 devuelve **Igual al promedio**,
con un promedio mensual general de **6444.00**.

| Ranking | id_producto | Unidades vendidas | Total facturado |
| ---: | ---: | ---: | ---: |
| 1 | 1 | 3 | 3600.00 |
| 2 | 3 | 3 | 1350.00 |
| 3 | 5 | 3 | 390.00 |
| 4 | 6 | 4 | 380.00 |
| 5 | 2 | 13 | 364.00 |

| id_cliente | Cantidad de pedidos | Total gastado |
| ---: | ---: | ---: |
| 1 | 2 | 2640.00 |
| 5 | 2 | 2100.00 |
| 3 | 2 | 674.00 |
| 2 | 2 | 520.00 |
| 4 | 2 | 510.00 |

## Entrega

Repositorio público: <https://github.com/jech-png/coderhouse-data-analytics>

Ruta del archivo: `RetailPro/m4_consultas_negocio.sql`.

## Referencias de sintaxis

- [EXTRACT — PostgreSQL](https://www.postgresql.org/docs/current/functions-datetime.html#FUNCTIONS-DATETIME-EXTRACT)
- [MONTH — Microsoft Learn](https://learn.microsoft.com/en-us/sql/t-sql/functions/month-transact-sql)
- [TOP — Microsoft Learn](https://learn.microsoft.com/en-us/sql/t-sql/queries/top-transact-sql)
