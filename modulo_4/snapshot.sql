-- Salida ordenada para comparar los datos completos después de cada ejecución.
USE Ventas_Tech_DB;
GO
SET NOCOUNT ON;
SELECT * FROM dbo.categorias ORDER BY id_categoria;
SELECT * FROM dbo.clientes ORDER BY id_cliente;
SELECT * FROM dbo.productos ORDER BY id_producto;
SELECT * FROM dbo.ventas ORDER BY id_venta;
GO
