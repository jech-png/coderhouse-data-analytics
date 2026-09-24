#!/usr/bin/env bash
set -euo pipefail

config_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
env_path="$config_dir/.env"

# Mantener la misma clave al reabrir o reconstruir el Codespace.
if [[ ! -s "$env_path" ]]; then
    umask 077
    sql_password="Cdh!$(openssl rand -hex 24)"
    printf 'MSSQL_SA_PASSWORD=%s\nSQLCMDPASSWORD=%s\n' \
        "$sql_password" "$sql_password" > "$env_path"
fi

