set -e

host="$1"
port="$2"
username="$3"
password="$4"
shift 4
cmd="$@"

timeout=30
elapsed=0

echo "Esperando a que MySQL esté disponible en $host:$port..."

until echo "SELECT 1" | mysql -h"$host" -P"$port" -u"$username" -p"$password" &> /dev/null; do
  if [ "$elapsed" -ge "$timeout" ]; then
    >&2 echo "Tiempo de espera agotado: $host:$port no está disponible después de ${timeout}s."
    exit 1
  fi
  echo "Todavía esperando a $host:$port..."
  sleep 1
  elapsed=$((elapsed + 1))
done

>&2 echo "MySQL está disponible en $host:$port - ejecutando comando"
exec $cmd