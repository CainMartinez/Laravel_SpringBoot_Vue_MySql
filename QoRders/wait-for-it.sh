#!/usr/bin/env bash
set -e

# Parámetros
host="$1"
port="$2"
username="$3"
password="$4"
database="$5"
shift 5
cmd="$@"

# Configuración de tiempo de espera
timeout=30
elapsed=0

echo "Iniciando script de espera para MySQL..."
echo "Host: $host"
echo "Puerto: $port"
echo "Usuario: $username"
echo "Base de datos: $database"

# Verificar conexión al servicio MySQL
echo "Verificando conexión a MySQL en $host:$port..."
until mysqladmin ping -h"$host" -P"$port" --silent; do
  if [ "$elapsed" -ge "$timeout" ]; then
    >&2 echo "Error: No se pudo conectar al servicio MySQL en $host:$port después de ${timeout}s."
    exit 1
  fi
  echo "Todavía esperando al servicio MySQL en $host:$port..."
  sleep 1
  elapsed=$((elapsed + 1))
done
echo "Conexión al servicio MySQL exitosa en $host:$port."

# Verificar acceso con las credenciales proporcionadas
echo "Verificando acceso con las credenciales proporcionadas..."
if ! mysql -h"$host" -P"$port" -u"$username" -p"$password" -e "SELECT 1;" &>/dev/null; then
  >&2 echo "Error: No se pudo autenticar con las credenciales proporcionadas (usuario: $username, contraseña: $password)."
  exit 1
fi
echo "Autenticación exitosa con las credenciales proporcionadas."

# Verificar acceso a la base de datos especificada
echo "Verificando acceso a la base de datos '$database'..."
if ! echo "USE $database;" | mysql -h"$host" -P"$port" -u"$username" -p"$password" &>/dev/null; then
  >&2 echo "Error: La base de datos '$database' no está disponible o no existe."
  exit 1
fi
echo "Acceso exitoso a la base de datos '$database'."

# Comando final
>&2 echo "MySQL y la base de datos '$database' están disponibles en $host:$port. Ejecutando comando..."
exec $cmd