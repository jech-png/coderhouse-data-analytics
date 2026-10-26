USE Ventas_Tech_DB;
GO

-- =========================================================
-- M5 - CONSULTAS CON JOINs
-- Proyecto Final: RetailPro
-- =========================================================
-- Hallazgos calculados sobre los datos originales de M3:
-- 5 clientes, 6 productos y 10 ventas de marzo de 2024.

-- CONSULTA 1 - Vista base del proyecto (INNER JOIN)
SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS cliente,
    c.ciudad,
    p.nombre_producto AS producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM dbo.ventas AS v
INNER JOIN dbo.clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN dbo.productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN dbo.categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;

-- Hallazgo: Las 10 ventas entre el 05/03/2024 y el 15/03/2024 suman
-- 6444.00. Laptop Pro 15 aporta 3600.00 (55.87% de la facturación).
-- Esta concentración justifica monitorear su disponibilidad y explorar
-- la venta cruzada de accesorios con los clientes que compran laptops.


-- CONSULTA 2 - Clientes sin ventas (LEFT JOIN)
SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM dbo.clientes AS c
LEFT JOIN dbo.ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.fecha_registro, c.nombre;

-- Hallazgo: La consulta devuelve 0 filas: los 5 clientes registrados
-- tienen ventas (2 cada uno). En esta muestra no hay destinatarios para
-- una campaña de primera compra. Para CRM, conviene analizar la frecuencia
-- y la última compra antes de definir acciones de reactivación.


-- CONSULTA 3 - Productos sin ventas (LEFT JOIN)
SELECT
    p.nombre_producto AS producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM dbo.productos AS p
LEFT JOIN dbo.categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN dbo.ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.nombre_producto;

-- Hallazgo: La consulta devuelve 0 filas: los 6 productos tienen al menos
-- una venta. En esta muestra no hay productos sin rotación identificados.
-- Para decidir promociones o liquidaciones, conviene revisar también
-- el stock disponible y la velocidad de venta de cada producto.


-- CONSULTA 4 - Consolidado por canal/origen (UNION ALL)
-- Como el modelo no posee una columna canal, se crea una etiqueta
-- según dos períodos de venta, tal como permite la consigna.
SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        v.fecha_venta,
        v.cantidad * v.precio_unitario AS total,
        'Periodo 1' AS canal
    FROM dbo.ventas AS v
    WHERE v.fecha_venta <= '2024-03-10'

    UNION ALL

    SELECT
        v.fecha_venta,
        v.cantidad * v.precio_unitario AS total,
        'Periodo 2' AS canal
    FROM dbo.ventas AS v
    WHERE v.fecha_venta > '2024-03-10'
) AS consolidado
GROUP BY canal
ORDER BY canal;

-- Hallazgo: El Periodo 1 suma 3620.00 (56.18%) y el Periodo 2, 2824.00
-- (43.82%); el consolidado coincide con los 6444.00 de la Consulta 1.
-- La diferencia es de 796.00. Como los grupos representan períodos de
-- distinta duración, se deben comparar ventanas equivalentes para evaluar
-- la evolución comercial. Estas etiquetas no representan canales reales.
