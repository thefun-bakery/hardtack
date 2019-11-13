service mysql start

sleep 3

mysql -uroot -e "create database hardtack_development"
mysql -uroot -e "create database hardtack_test"
mysql -uroot -e "create database hardtack_production"

