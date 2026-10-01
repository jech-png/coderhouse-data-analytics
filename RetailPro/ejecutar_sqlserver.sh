#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
sqlcmd_bin="${SQLCMD_BIN:-/opt/mssql-tools18/bin/sqlcmd}"
sql_server="${SQL_SERVER:-localhost}"
sql_user="${SQL_USER:-sa}"
: "${SQLCMDPASSWORD:?Falta SQLCMDPASSWORD; ejecutar dentro del Codespace del proyecto.}"

# Solo consultas: se utiliza la base existente sin recrear ni modificar sus datos.
"$sqlcmd_bin" -S "$sql_server" -U "$sql_user" -C -b -l 10 -t 60 -f 65001 \
    -d Ventas_Tech_DB -i "$project_dir/sql_server/m4_consultas_negocio_sqlserver.sql"
