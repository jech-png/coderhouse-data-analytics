# Entregable 3 — Ventas_Tech_DB

Script de ingeniería de datos para Microsoft SQL Server. El archivo principal es
[`ventas_tech_db.sql`](ventas_tech_db.sql), el original preparado para el entregable.
Se conserva sin modificaciones.

| Tabla | Registros esperados en cada ejecución |
| --- | ---: |
| categorias | 4 |
| clientes | 5 |
| productos | 6 |
| ventas | 10 |

## Abrir y ejecutar desde el navegador

1. En el repositorio, elegir **Code → Codespaces → Create codespace on main**.
2. Esperar a que termine la configuración. Se inicia SQL Server 2022 Developer,
   se instala la extensión SQL de Microsoft y se ejecuta automáticamente el
   script **dos veces**, validando los conteos después de cada ejecución.
3. Los resultados quedan en `modulo_4/resultados/`. La carpeta se genera dentro
   del Codespace y no se sube al repositorio.

Para repetir la prueba sin escribir comandos, abrir la paleta con
**F1 → Tasks: Run Task → Entregable 3: ejecutar y verificar dos veces**.

El script recrea las cuatro tablas y carga los datos de ejemplo en cada ejecución.
Al repetirlo, se reemplazan los datos que se hayan agregado a esas tablas.

## Hacer consultas con la extensión SQL

Abrir `ventas_tech_db.sql` y elegir el perfil **Ventas Tech - Codespaces** en la
extensión SQL Server. Los datos de conexión son:

| Campo | Valor |
| --- | --- |
| Servidor | `localhost,1433` |
| Base de datos | `Ventas_Tech_DB` |
| Autenticación | SQL Login |
| Usuario | `sa` |
| Contraseña | Valor de `MSSQL_SA_PASSWORD` en `.devcontainer/.env` |
| Confiar en el certificado del servidor | Sí, para este entorno local |

La contraseña se genera al crear el entorno; `.env` está excluido de Git.
El servidor no publica el puerto de la base de datos en Internet. Los datos de
SQL Server se guardan en un volumen del entorno. Al reconstruir el contenedor,
la prueba vuelve a cargar los datos del entregable.

## Verificación automática en GitHub

La pestaña **Actions → Validar SQL Server** ejecuta el mismo Docker Compose que
usa Codespaces. La prueba falla si una ejecución devuelve un error SQL, si los
conteos no son **4/5/6/10**, si faltan las claves primarias o foráneas, si hay
relaciones inválidas o si cambian los datos entre la primera y la segunda pasada.
También controla que el importe de las diez ventas sea **6444.00**.

Cada ejecución de Actions permite descargar el archivo de evidencia
`validacion-sql-server`, con la versión del servidor, las salidas del script,
los conteos y la comparación de datos. Un resultado exitoso termina con:

```text
OK: dos ejecuciones completas; 4, 5, 6 y 10 registros en ambas; datos idénticos.
```

Para consultar la estructura: `ventas_tech_db.sql`. Los archivos `validar.sql`,
`snapshot.sql` y `verificar.sh` son auxiliares de la prueba.

## Documentación de referencia

- [SQL Server en contenedores — Microsoft Learn](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-ver16)
- [Instalación de sqlcmd — Microsoft Learn](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-ver16)
- [Configuración de Codespaces — GitHub Docs](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/introduction-to-dev-containers)
