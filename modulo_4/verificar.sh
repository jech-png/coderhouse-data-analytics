#!/usr/bin/env bash
set -euo pipefail

module_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
output_dir="$module_dir/resultados"
sqlcmd_bin="${SQLCMD_BIN:-/opt/mssql-tools18/bin/sqlcmd}"
sql_server="${SQL_SERVER:-localhost}"
sql_user="${SQL_USER:-sa}"
: "${SQLCMDPASSWORD:?Falta SQLCMDPASSWORD; abrir el repositorio en Codespaces.}"
mkdir -p "$output_dir"

sql=("$sqlcmd_bin" -S "$sql_server" -U "$sql_user" -C -b -l 5 -t 60 -f 65001 -r 1)

# SQL Server puede seguir iniciando cuando se llama fuera de Docker Compose.
ready=0
for ((attempt=1; attempt<=60; attempt++)); do
    if "${sql[@]}" -Q 'SET NOCOUNT ON; SELECT 1;' >/dev/null 2>&1; then
        ready=1
        break
    fi
    sleep 2
done
if [[ "$ready" != 1 ]]; then
    printf 'ERROR: SQL Server no respondió a tiempo.\n' >&2
    exit 1
fi

"${sql[@]}" -Q 'SET NOCOUNT ON; SELECT @@VERSION;' > "$output_dir/version.txt"
for run in 1 2; do
    printf '\nEjecución %s de 2\n' "$run"
    if ! "${sql[@]}" -i "$module_dir/ventas_tech_db.sql" \
        > "$output_dir/ejecucion-$run.txt" 2>&1; then
        cat "$output_dir/ejecucion-$run.txt" >&2
        exit 1
    fi
    "${sql[@]}" -i "$module_dir/validar.sql" | tee "$output_dir/validacion-$run.txt"
    "${sql[@]}" -i "$module_dir/snapshot.sql" > "$output_dir/datos-$run.txt"
done

diff -u "$output_dir/datos-1.txt" "$output_dir/datos-2.txt"
printf '\nOK: dos ejecuciones completas; 4, 5, 6 y 10 registros en ambas; datos idénticos.\n'
