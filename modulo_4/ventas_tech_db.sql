-- Motor: Microsoft SQL Server. Ejecutar el script completo en SSMS.
-- Entregable 3: Script SQL de Ingenieria de Datos - TechStore.
-- El script recrea las cuatro tablas y carga los 25 registros de la consigna.

-- Preparacion: crear la base solo si no existe y seleccionar su contexto.
USE master;
GO

IF DB_ID(N'Ventas_Tech_DB') IS NULL
BEGIN
    EXEC(N'CREATE DATABASE Ventas_Tech_DB;');
END;
GO

USE Ventas_Tech_DB;
GO

-- === SECCIÓN 1: DROP ===
-- Eliminar primero las tablas que dependen de otras mediante foreign keys.

DROP TABLE IF EXISTS dbo.ventas;
DROP TABLE IF EXISTS dbo.productos;
DROP TABLE IF EXISTS dbo.clientes;
DROP TABLE IF EXISTS dbo.categorias;
GO

-- === SECCIÓN 2: CREATE ===
-- Crear primero las tablas independientes y luego las tablas con foreign keys.

CREATE TABLE dbo.categorias (
    id_categoria     INT NOT NULL PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion      VARCHAR(200) NULL
);

CREATE TABLE dbo.clientes (
    id_cliente     INT NOT NULL PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    email          VARCHAR(100) NULL UNIQUE,
    ciudad         VARCHAR(50) NULL,
    fecha_registro DATE NOT NULL
);

CREATE TABLE dbo.productos (
    id_producto     INT NOT NULL PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria    INT NULL,
    precio          DECIMAL(10,2) NOT NULL,
    stock           INT NULL DEFAULT 0,
    activo          BIT NULL DEFAULT 1,
    CONSTRAINT FK_productos_categorias
        FOREIGN KEY (id_categoria) REFERENCES dbo.categorias (id_categoria)
);

CREATE TABLE dbo.ventas (
    id_venta        INT NOT NULL PRIMARY KEY,
    id_cliente      INT NULL,
    id_producto     INT NULL,
    cantidad        INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta     DATE NOT NULL,
    CONSTRAINT FK_ventas_clientes
        FOREIGN KEY (id_cliente) REFERENCES dbo.clientes (id_cliente),
    CONSTRAINT FK_ventas_productos
        FOREIGN KEY (id_producto) REFERENCES dbo.productos (id_producto)
);
GO

-- === SECCIÓN 3: INSERT ===
-- Cargar los datos en el mismo orden de dependencias utilizado en CREATE.
-- Los literales N'...' preservan los acentos al interpretar el texto del script.

INSERT INTO dbo.categorias (id_categoria, nombre_categoria, descripcion)
VALUES
    (1, N'Computación',    N'Laptops, PCs y monitores'),
    (2, N'Accesorios',     N'Periféricos y complementos'),
    (3, N'Audio',          N'Auriculares y parlantes'),
    (4, N'Almacenamiento', N'Discos y memorias');

INSERT INTO dbo.clientes (id_cliente, nombre, email, ciudad, fecha_registro)
VALUES
    (1, N'María López',  'maria@mail.com',  N'Buenos Aires', '2024-01-05'),
    (2, N'Carlos Ruiz',  'carlos@mail.com', N'Córdoba',      '2024-01-10'),
    (3, N'Ana Gómez',    'ana@mail.com',    N'Rosario',      '2024-02-01'),
    (4, N'Pedro Sanz',   'pedro@mail.com',  N'Mendoza',      '2024-02-15'),
    (5, N'Laura Torres', 'laura@mail.com',  N'Tucumán',      '2024-03-01');

INSERT INTO dbo.productos (id_producto, nombre_producto, id_categoria, precio, stock, activo)
VALUES
    (1, N'Laptop Pro 15',      1, 1200.00, 15, 1),
    (2, N'Mouse Inalámbrico',  2,   28.00, 80, 1),
    (3, N'Monitor 4K 27',      1,  450.00, 12, 1),
    (4, N'Auriculares BT Pro', 3,  120.00, 35, 1),
    (5, N'SSD Externo 1TB',    4,  130.00, 18, 1),
    (6, N'Teclado Mecánico',   2,   95.00, 40, 1);

INSERT INTO dbo.ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta)
VALUES
    ( 1, 1, 1, 2, 1200.00, '2024-03-05'),
    ( 2, 2, 2, 5,   28.00, '2024-03-06'),
    ( 3, 3, 3, 1,  450.00, '2024-03-07'),
    ( 4, 1, 4, 2,  120.00, '2024-03-08'),
    ( 5, 4, 5, 3,  130.00, '2024-03-10'),
    ( 6, 2, 6, 4,   95.00, '2024-03-11'),
    ( 7, 5, 1, 1, 1200.00, '2024-03-12'),
    ( 8, 3, 2, 8,   28.00, '2024-03-13'),
    ( 9, 4, 4, 1,  120.00, '2024-03-14'),
    (10, 5, 3, 2,  450.00, '2024-03-15');
GO

-- === SECCIÓN 4: VALIDACIÓN ===
-- Ejecutar el script completo dos veces: ambas deben devolver las mismas filas.

SELECT * FROM dbo.categorias; -- Esperado: 4 filas.
SELECT * FROM dbo.clientes;   -- Esperado: 5 filas.
SELECT * FROM dbo.productos;  -- Esperado: 6 filas.
SELECT * FROM dbo.ventas;     -- Esperado: 10 filas.
