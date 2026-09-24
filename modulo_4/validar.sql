-- Controles automáticos del entregable; el archivo principal se conserva intacto.
USE Ventas_Tech_DB;
GO
SET NOCOUNT ON;

IF (SELECT COUNT(*) FROM sys.tables WHERE is_ms_shipped = 0) <> 4
    THROW 51000, 'Se esperaban exactamente cuatro tablas.', 1;
IF (SELECT COUNT(*) FROM dbo.categorias) <> 4
    THROW 51001, 'categorias: se esperaban 4 registros.', 1;
IF (SELECT COUNT(*) FROM dbo.clientes) <> 5
    THROW 51002, 'clientes: se esperaban 5 registros.', 1;
IF (SELECT COUNT(*) FROM dbo.productos) <> 6
    THROW 51003, 'productos: se esperaban 6 registros.', 1;
IF (SELECT COUNT(*) FROM dbo.ventas) <> 10
    THROW 51004, 'ventas: se esperaban 10 registros.', 1;

IF (SELECT COUNT(*) FROM sys.key_constraints WHERE type = 'PK') <> 4
    THROW 51005, 'Se esperaban cuatro claves primarias.', 1;
IF (SELECT COUNT(*) FROM sys.foreign_keys
    WHERE is_disabled = 0 AND is_not_trusted = 0) <> 3
    THROW 51006, 'Se esperaban tres claves foraneas activas y validadas.', 1;

IF EXISTS (
    SELECT 1 FROM dbo.productos AS p
    LEFT JOIN dbo.categorias AS c ON c.id_categoria = p.id_categoria
    WHERE c.id_categoria IS NULL
) OR EXISTS (
    SELECT 1 FROM dbo.ventas AS v
    LEFT JOIN dbo.clientes AS c ON c.id_cliente = v.id_cliente
    LEFT JOIN dbo.productos AS p ON p.id_producto = v.id_producto
    WHERE c.id_cliente IS NULL OR p.id_producto IS NULL
)
    THROW 51007, 'Se encontraron registros sin su relacion correspondiente.', 1;

IF (SELECT SUM(cantidad * precio_unitario) FROM dbo.ventas) <> 6444.00
    THROW 51008, 'El importe total de las ventas debe ser 6444.00.', 1;

SELECT 'categorias' AS tabla, COUNT(*) AS registros FROM dbo.categorias
UNION ALL SELECT 'clientes', COUNT(*) FROM dbo.clientes
UNION ALL SELECT 'productos', COUNT(*) FROM dbo.productos
UNION ALL SELECT 'ventas', COUNT(*) FROM dbo.ventas;
PRINT 'OK: conteos, claves y relaciones correctos.';
GO
