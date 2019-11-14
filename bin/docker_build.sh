cd $(dirname -- "$0")

docker build --build-arg DB_HOST --build-arg DB_PORT --build-arg DB_USER --build-arg DB_PASSWORD --build-arg DB_NAME --rm --no-cache -t hardtack -f ../dockerfiles/real ..
