# RetailPro — Proyecto de Data Analytics

RetailPro es un proyecto de análisis de ventas desarrollado como parte del curso de Data Analytics. El objetivo es construir un flujo completo desde la creación y consulta de la base de datos hasta la preparación de información para análisis y visualización en Power BI.

## Objetivo del proyecto

Analizar el desempeño comercial de RetailPro mediante métricas de ventas, productos y clientes, generando una base estructurada que permita responder preguntas de negocio y alimentar un dashboard ejecutivo.

## Herramientas utilizadas

- SQL Server para creación y consulta de la base `Ventas_Tech_DB`.
- GitHub para versionado y entrega de scripts.
- GitHub Codespaces para ejecutar SQL Server sin instalarlo localmente.
- Power BI para el proceso ETL, modelado, medidas DAX y dashboard.
- ChatGPT como herramienta de apoyo para revisión, documentación y validación del proyecto.

## Estructura principal

- `../modulo_4/ventas_tech_db.sql`: crea la base `Ventas_Tech_DB`, las tablas y los datos de ejemplo.
- `m4_consultas_negocio.sql`: consultas de métricas de negocio sobre la tabla `ventas`.
- `sql_server/m4_consultas_negocio_sqlserver.sql`: versión compatible con SQL Server de las consultas de M4.
- `m5_consultas_joins.sql`: consultas con `INNER JOIN`, `LEFT JOIN` y `UNION ALL` para enriquecer el análisis.
- `ejecutar_sqlserver.sh`: script de apoyo para ejecutar las consultas de M4 en Codespaces.

## Modelo de datos

La base contiene cuatro tablas principales:

- `clientes`
- `productos`
- `categorias`
- `ventas`

Las relaciones permiten asociar cada venta con el cliente, el producto y la categoría correspondiente.

## Cómo ejecutar los scripts SQL

### 1. Crear y cargar la base

Desde el Codespace, ejecutar el script:

```bash
sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -i modulo_4/ventas_tech_db.sql
```

Este script crea `Ventas_Tech_DB`, genera las cuatro tablas y carga los datos de ejemplo.

### 2. Ejecutar las consultas de M4

```bash
bash RetailPro/ejecutar_sqlserver.sh
```

También puede abrirse `RetailPro/sql_server/m4_consultas_negocio_sqlserver.sql` y ejecutarse directamente contra `Ventas_Tech_DB`.

### 3. Ejecutar las consultas de M5

Abrir `RetailPro/m5_consultas_joins.sql` en SQL Server y ejecutarlo sobre `Ventas_Tech_DB`.

La consulta principal combina `ventas`, `clientes`, `productos` y `categorias` para generar una vista enriquecida con fecha, cliente, ciudad, producto, categoría, cantidad, precio unitario y total de venta.

## Principales hallazgos del análisis inicial

Con los datos cargados en M3 y analizados en M4:

- Marzo de 2024 registra 10 pedidos por un total facturado de 6444.00 y un ticket promedio de 644.40.
- El producto 1 concentra 3600.00 de facturación, equivalente aproximadamente al 55.87% del total.
- Los cinco clientes son recurrentes, con dos pedidos cada uno. El cliente 1 presenta el mayor gasto acumulado, con 2640.00.

## Uso de IA en el proyecto

La IA se utilizó como herramienta de apoyo para revisar consultas SQL, identificar posibles mejoras, resumir hallazgos comerciales y mejorar la documentación del repositorio. Las sugerencias fueron evaluadas antes de incorporarlas para evitar cambios que no aportaran valor al modelo o alteraran la lógica de negocio.

## Repositorio

Repositorio público: <https://github.com/jech-png/coderhouse-data-analytics>
