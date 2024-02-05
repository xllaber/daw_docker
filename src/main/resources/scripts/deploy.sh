#!/bin/bash
cd /opt/ximollacer/java
sudo docker container stop ximollacer_java
sudo docker container rm ximollacer_java
sudo rm -rf /opt/ximollacer/java/daw_docker
sudo git clone https://github.com/xllaber/daw_docker.git
sudo docker container run -v /opt/ximollacer/java/daw_docker:/usr/src/mymaven -w /usr/src/mymaven maven:3.9.6-eclipse-temurin-17 mvn clean package
sudo rm -rf /opt/ximollacer/java/target
sudo mkdir /opt/ximollacer/java/target
sudo mv /opt/ximollacer/java/daw_docker/target/daw_docker-0.0.1-SNAPSHOT.jar /opt/ximollacer/java/target/app.jar
sudo rm -rf /opt/ximollacer/java/daw_docker
sudo docker container run -dit --restart always -v /opt/ximollacer/java/target:/tmp -p 9002:8080 --name  ximollacer_java --hostname ximollacer_java eclipse-temurin:17.0.10_7-jdk java -jar /tmp/app.jar
