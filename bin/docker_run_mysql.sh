docker volume create --name mysql_data
docker run --rm -d -v mysql_data:/var/lib/mysql -p 3306:3306 --name mysql57 -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql:5.7
