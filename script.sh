docker-compose up -d --build
sleep 30s
cat web2.sql | docker exec -i docker_app-db_1 /usr/bin/mysql -u root --password=root web2
