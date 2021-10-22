FROM tomcat:8-jdk11

COPY /target/*.war /root/ROOT.war
COPY env/ /root/env/
COPY uploads/ /root/uploads/
COPY server.xml /usr/local/tomcat/conf/server.xml
