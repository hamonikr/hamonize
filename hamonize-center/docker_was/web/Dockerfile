FROM tomcat:8-jdk11
MAINTAINER yejisoft@gmail.com

COPY ./hamonize-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/staging.war
COPY ./context.xml /usr/local/tomcat/conf/
COPY ./server.xml /usr/local/tomcat/conf/
COPY env/ /root/env/

CMD ["catalina.sh","run"]

RUN ["mv", "/usr/local/tomcat/webapps/staging.war","/usr/local/tomcat/webapps/ROOT.war"]
RUN ["rm", "-rf", "/usr/local/tomcat/webapps/ROOT"]
