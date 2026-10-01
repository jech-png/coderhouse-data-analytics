-- RetailPro | Entregable 4: Extrayendo métricas clave con SQL
-- Base de datos: Ventas_Tech_DB. Única tabla consultada: ventas.
-- Sintaxis de la consigna: PostgreSQL (EXTRACT y LIMIT).
-- Conectarse a la base antes de ejecutar este archivo.
-- Para el SQL Server del Codespace, usar sql_server/m4_consultas_negocio_sqlserver.sql.
-- Datos de origen: ../modulo_4/ventas_tech_db.sql (10 ventas de marzo de 2024).
-- Cada fila de ventas representa un pedido, según la consigna.
-- Los importes se expresan en la unidad monetaria del conjunto de datos.

-- CONSULTA 1 — Resumen ejecutivo mensual
-- El ticket promedio es el promedio del importe de cada pedido.
-- Se incluye el año para no mezclar el mismo mes de años diferentes.
SELECT
    EXTRACT(YEAR FROM fecha_venta) AS anio,
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    ROUND(AVG(cantidad * precio_unitario), 2) AS ticket_promedio
FROM ventas
GROUP BY
    EXTRACT(YEAR FROM fecha_venta),
    EXTRACT(MONTH FROM fecha_venta)
ORDER BY anio, mes;

-- CONSULTA 2 — Ranking de productos
-- El ID resuelve los empates para que el orden sea reproducible.
SELECT
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC, id_producto ASC
LIMIT 5;

-- CONSULTA 3 — Clientes recurrentes
-- HAVING filtra los grupos después de contar los pedidos de cada cliente.
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC, total_gastado DESC, id_cliente ASC;

-- CONSULTA 4 — Meses por encima/por debajo del promedio
-- Primero se suma la facturación de cada mes; después se promedian esos totales.
-- El promedio incluye solo los meses con ventas presentes en la tabla.
-- Se compara sin redondear; solo se redondea el promedio mostrado.
-- Se contempla la igualdad: con un único mes, no corresponde etiquetarlo
-- como 'Por encima' ni 'Por debajo'. La CTE es una consulta temporal, no otra tabla.
WITH ventas_mensuales AS (
    SELECT
        EXTRACT(YEAR FROM fecha_venta) AS anio,
        EXTRACT(MONTH FROM fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY
        EXTRACT(YEAR FROM fecha_venta),
        EXTRACT(MONTH FROM fecha_venta)
)
SELECT
    anio,
    mes,
    total_facturado,
    ROUND((SELECT AVG(total_facturado) FROM ventas_mensuales), 2)
        AS promedio_mensual_general,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM ventas_mensuales)
            THEN 'Por encima'
        WHEN total_facturado < (SELECT AVG(total_facturado) FROM ventas_mensuales)
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion_con_promedio
FROM ventas_mensuales
ORDER BY anio, mes;

-- HALLAZGOS — Calculados sobre las 10 ventas originales del entregable anterior.
-- 1. Marzo de 2024 suma 6444.00 en 10 pedidos, con un ticket promedio de 644.40.
--    Es el único mes cargado: su facturación coincide con el promedio mensual
--    general (6444.00), por lo que la consulta 4 devuelve 'Igual al promedio'.
-- 2. El producto 1 lidera el ranking: 3 unidades y 3600.00 facturados,
--    equivalentes al 55.87% de la facturación total (3600.00 / 6444.00 * 100).
-- 3. Los 5 clientes son recurrentes: cada uno registra 2 pedidos. El cliente 1
--    presenta el mayor gasto acumulado (2640.00), seguido del cliente 5 (2100.00).
