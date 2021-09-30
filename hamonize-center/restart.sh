#!/bin/bash  

docker stop hamonize-center_web_1
docker rm hamonize-center_web_1
docker rmi hamonize-center_web
docker rmi tomcat:8-jdk11

echo "restart...hamonize center.."
docker-compose up -d
