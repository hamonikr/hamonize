FROM tomcat:8-jdk11
MAINTAINER bono6315@gmail.com

COPY /target/*.war /root/ROOT.war
COPY env/ /root/env/
COPY server.xml /usr/local/tomcat/conf/server.xml
