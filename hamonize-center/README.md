# Hamonize-center

<b>Hamonize-center 설치</b>

1 단계 : 코드 받기<br>
2 단계 : 데이터베이스 만들기<br>
3 단계 : 개발환경 구성하기<br>

<br>

**1 단계 : 코드 받기**<br>
현재/최신 릴리스는 항상 [깃헙 소스저장소](https://github.com/hamonikr/hamonize)에서 페이지 에서 찾을 수 있습니다. 

<b>git clone https://github.com/hamonikr/hamonize.git </b><br><br>


**2 단계 : 도커로 데이터베이스 구성하기**<br>
- DB 스키마 파일 위치 : db/hamonize_center.sql 
<br><br> 

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

3) env/config.properties 파일에 생성한 postgresql 서버 ip 적어준다 파일의 위치는 기본적으로 홈디렉토리 위치에 위치시킨다. 
```
## PostgreSQL
spring.db1.datasource.primary.jndi-name=jdbc/postgresqldb
spring.db1.datasource.driverClassName=org.postgresql.Driver
spring.db1.datasource.url=jdbc:postgresql://{postgresql-vpnip}:5432/hamonize_center
# default db admin user
spring.db1.datasource.username=ivs
spring.db1.datasource.password={db 생성시 사용한 비밀번호}

```
** 변경을 원할 경우 src/main/java/com/GlobalPropertySource.java 파일의 PropertySource 위치를 변경시켜준다.
```

@Configuration
@PropertySources({
    @PropertySource( value = "file:${user.home}/env/config.properties", ignoreResourceNotFound = true)
   })
public class GlobalPropertySource {
    //db
    ....
```


- WAS에서 실행할 경우 <br>

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



- docker로 실행할 경우<br>
```
```

