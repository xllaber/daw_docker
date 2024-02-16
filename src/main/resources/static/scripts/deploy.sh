#!/bin/bash
cd /opt/ximollacer/java
sudo docker container stop ximollacer_java
sudo docker container rm ximollacer_java
sudo docker container stop ximollacer_mysql
sudo docker container rm ximollacer_mysql
sudo docker network rm ximollacer_network
sudo docker network create ximollacer_network
sudo rm -rf /opt/ximollacer/java/DockerDB
sudo rm -rf /opt/ximollacer/mysql
sudo mkdir /opt/ximollacer/mysql
sudo docker container run -dit --restart always -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=datos -e MYSQL_USER=datos -e MYSQL_PASSWORD=datos -v /opt/ximollacer/mysql:/var/lib/mysql -p 3002:3306 --network ximollacer_network  --name ximollacer_mysql --hostname ximollacer_mysql mysql:8.3.0
sudo git clone https://github.com/xllaber/DockerDB.git
sudo docker container run -v /opt/ximollacer/java/DockerDB:/usr/src/mymaven --network ximollacer_network -w /usr/src/mymaven maven:3.9.6-eclipse-temurin-17 mvn clean package -Dmaven.test.skip=true
sudo rm -rf /opt/ximollacer/java/target
sudo mkdir /opt/ximollacer/java/target
sudo mv /opt/ximollacer/java/DockerDB/target/*.jar /opt/ximollacer/java/target/app.jar
sudo rm -rf /opt/ximollacer/java/daw_docker
sudo docker container run -dit --restart always -v /opt/ximollacer/java/target:/tmp -p 9002:8080 --network ximollacer_network --name  ximollacer_java --hostname ximollacer_java eclipse-temurin:17.0.10_7-jdk java -jar /tmp/app.jar
