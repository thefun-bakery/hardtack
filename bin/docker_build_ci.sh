cd $(dirname -- "$0")

docker build --rm --no-cache -t hardtack-ci -f ../dockerfiles/ci ..
