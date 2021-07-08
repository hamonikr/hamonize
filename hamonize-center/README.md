# Hamonize-center

<b>Hamonize-center 데모 서버</b><br>
[하모나이즈 센터](http://106.254.251.74:28080/)


<b>Hamonize-center 설치</b>

1 단계 : 코드 받기<br>
2 단계 : 필요서버 구성하기<br>
3 단계 : 개발환경 구성하기<br>

<br>

**1 단계 : 코드 받기**<br>
현재/최신 릴리스는 항상 [깃헙 소스저장소](https://github.com/hamonikr/hamonize)에서 페이지 에서 찾을 수 있습니다. 

<b>git clone https://github.com/hamonikr/hamonize.git </b><br><br>


**2 단계 : 필요서버 구성하기**<br>
1) 데이터 베이스 생성
- postsql 유저 생성
```
create user hamonize;
alter role hamonize superuser createdb;
alter user hamonize with password {your-own-db-pw} // 자신만의 db패스워드를 설정해주세요

```

- hamonize-center는 기본 SQL 스키마를 제공하고 있습니다.
- DB 스키마 파일 위치 : db/hamonize_center.sql 
- 다음 명령어를 통해 hamonize-center에 sql 내용을 create 할 수 있습니다.

```
psql -h localhost -U hamonize -W -d hamonize_center -f db/hamonize_center.sql
```
- localhost : IP를 적어주는 곳입니다 (default : localhost)
- user_name : postgresql 계정 이름을 적어주는 곳입니다 (default : 센터와 연동을 위해 hamonize 로 설정 필요. hamonize 유저를 만들어주세요)
- database_name : postgresql 데이터베이스 이름을 적어주는 곳입니다.(default : hamonize_center 로 설정 필요)

<br>

2) 데이터 베이스 접속
- 터미널로 데이터 베이스를 접속하는 방법입니다.
- 데이터베이스 접속 프로그램을 사용하면 더욱 편하게 사용하실 수 있습니다. (DBeaver, tadpole)
```
psql -h localhost -p port -U hamonize -d hamonize_center
```
<br>


<br> 

2) ldap 서버 구성하기
- 도커 설치 : Docker version 20.10.5, build 55c4c88

- docker로 ldap 실행하기 
```
docker run -it -p 389:389 -p 636:636 \
--name ldap-service \
--hostname ldap.hamonize.com \
--env LDAP_ORGANISATION="{your own org}" \
--env LDAP_DOMAIN="hamonize.com" \
--env LDAP_ADMIN_PASSWORD="{your own ldap password}" \
--detach osixia/openldap:1.5.0

```

- docker 생성 테스트 
```
ldapsearch -x -H ldap://{your own ldap ip}:389 -b dc=hamonize,dc=com -D "cn=admin,dc=hamonize,dc=com" -w {your own ldap password}

```

**3 단계 : 개발환경 구성하기**
- IDE 에서 실행<br>


1) vscode에서 실행할 경우<br>
Run > Open Configuration > launch.jason : "configuration"에 "vmArgs"추가 

```
"vmArgs": ["-Djava.net.preferIPv4Stack=true","-Djava.security.egd=file:/dev/./urandom "] 
```
<br>

2) eclipse에서 실행할 경우<br>
Run > Configuration > Arguments > VM arguments:

```
-Djava.security.egd=file:/dev/./urandom
-Djava.net.preferIPv4Stack=true
```
<br>

3) config.properties 민감정보 파일 설정 - hamonize-center/env/에 위치 
- env/config.properties 파일 위치를 사용하는 ${user.home}/ 위치에 옮겨둔다(디폴트 설정)

** 변경하고싶으면 GlobalPropertySource.java 파일에서 위치를 원하는 곳으로 변경해둔다

```
@PropertySources({
    @PropertySource( value = "file:${user.home}/env/config.properties", ignoreResourceNotFound = true)
})
... 
```
- 2단계에서 생성한 db 서버 정보등 입력
```
## PostgreSQL
spring.db1.datasource.primary.jndi-name=jdbc/postgresqldb
spring.db1.datasource.driverClassName=org.postgresql.Driver
# 10.8.0.5 is example vpn ip
spring.db1.datasource.url=jdbc:postgresql://{your own db ip}:5432/hamonize_center
# default db admin user
spring.db1.datasource.username={your own db id}
spring.db1.datasource.password={your own db pw}

## ldap 
ldap.urls=ldap://{your own ldap ip}
ldap.password={your own ldap pw}

## influxdb server
spring.influxdb.url= http://{your own influxdb ip}
spring.influxdb.database=telegraf
spring.influxdb.username={your own influxdb id}
spring.influxdb.password={your own influxdb pw}
```

<br>
4) 웹브라우저에서 실행

```
http://localhost:8080/
```
<br>
- WAS에서 실행 <br>

1) Java VM 을 구동할 때 다음 옵션을 추가

톰캣을 사용한다면 bin/catalina.sh 에 다음 내용을 추가한다.

```
JAVA_OPTS="-Djava.net.preferIPv4Stack=true"
```
2) war파일을 만들기 전에 pom.xml 파일에서 내장톰캣 disable

```
...
<!-- 운영 반영시 embed tomcat 주석 / ide 사용시 주석 해제 -->
		<dependency>
			<groupId>org.apache.tomcat.embed</groupId>
			<artifactId>tomcat-embed-jasper</artifactId>
		</dependency>
...		
```

3) jndi 설정
- server.xml

```
...
<GlobalNamingResources>
<Resource name="jdbc/postgresqldb"
    auth="Container"
    type="javax.sql.DataSource"
    driverClassName="org.postgresql.Driver"
    url="jdbc:postgresql://{your own db ip}/hamonize_center"
    factory="org.apache.tomcat.jdbc.pool.DataSourceFactory"
    username="hamonize"
    password="{your own db pw}"
    maxActive="100"
    maxWait="10000"
    timeBetweenEvictionRunsMillis="60000"
    minEvictableIdleTimeMillis="300000"/>
</GlobalNamingResources>
...
```
- context.xml 설정 추가
```
<Context>
    <ResourceLink name="jdbc/postgresqldb" global="jdbc/postgresqldb" type="javax.sql.DataSource" />
</Context>
...
````
<br>

