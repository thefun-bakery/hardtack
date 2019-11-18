cd $(dirname -- "$0")

docker build -t hardtack-dev -f ../dockerfiles/ci ..
