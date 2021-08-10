# Hamonize-center

## <b>Hamonize-center 데모 서버</b><br>
### [하모나이즈 센터](http://ts.hamonikr.org/)

<br><br>
## <b>Hamonize-center 설치</b>

1 단계 : 코드 받기<br>
2 단계 : 개발 환경 구성하기<br>
3 단계 : 실행하기  <br>

<br>


# **1 단계 : 코드 받기**<br>
현재/최신 릴리스는 항상 [깃헙 소스저장소](https://github.com/hamonikr/hamonize)에서 페이지 에서 찾을 수 있습니다. 

<b>git clone https://github.com/hamonikr/hamonize.git </b><br><br><br>


# **2 단계 : 필요서버 구성하기**<br>
<br>

### 1. DB 서버 구성하기

1) docker-compose.yml 파일 설정<br>
먼저, /hamonize-center/Dockerfile 에서 database의 password를 
원하는 패스워드로 설정해주세요

```

version : '3'
services : 
    db:
        image: postgres:10.16
        environment:
            POSTGRES_USER : hamonize
            POSTGRES_PASSWORD : {your own db pw}
            POSTGRES_DB : hamonize_center
        ports:
            - "5432:5432"
        volumes:
            - ./sql:/docker-entrypoint-initdb.d
            - psql-data:/var/lib/postgresql/data
            
        ...

```

<br><br>
2) env > config.propertis 설정
<br>

/hamonize-center/env/config.propertis 에 1) 에서 설정한 database password를 입력해주세요

```
## PostgreSQL
spring.db1.datasource.primary.jndi-name=jdbc/postgresqldb
spring.db1.datasource.driverClassName=org.postgresql.Driver
# 10.8.0.5 is example vpn ip
spring.db1.datasource.url=jdbc:postgresql://localhost:5432/hamonize_center
# default db admin user
spring.db1.datasource.username=hamonize
spring.db1.datasource.password={your own db pw}
```
<br><br>

## 2. LDAP 서버 구성하기

1) docker-compose.yml 파일 설정<br>
첫번째로, /hamonize-center/Dockerfile 에서 ldap admin user의 password를 원하는 패스워드로 설정해주세요<br>그리고 LDAP_ORGANISATION 에 본인의 소속된 조직의 명칭을 입력해주세요

```

   ...
   
   ldap:
        image: osixia/openldap:latest
        hostname: ldap.hamonize.com        
        ports:            
            - "389:389"
            - "636:636"
        environment:
            HOSTNAME: ldap.hamonize.com
            LOG_LEVEL: 256
            LDAP_DOMAIN: hamonize.com
            LDAP_BASE_DN: dc=hamonize,dc=com
            LDAP_ADMIN_PASSWORD: {your own ldap pw}
            LDAP_ORGANISATION: {your own ldap company} 
        volumes:
            - ./ldap/data:/var/lib/openldap
            - ./ldap/config:/etc/openldap/slapd.d              
        domainname: "ldap.hamonize.com"
        restart: always

    ...

```

<br><br>
2) env > config.propertis 설정
<br>

/hamonize-center/env/config.propertis 에 1) 에서 설정한 ldap password를 입력해주세요

```
...

## ldap 
ldap.urls=ldap://{your own ldap ip}
ldap.password={your own ldap pw}
...

```
<br><br>

## 3. influx 서버 구성하기

1) 

```
 
```

<br><br>

# **3 단계 : 실행하기**<br>
<br>

- Docker version 20.10.7

1) 모든 서버 올리기
```
docker-compose up
```
<br>

2) 모든 서버 내리기
```
docker-compose down
```
** 서버를 재시작할땐 logs/ 하위의 로그파일들을 삭제해줘야합니다

<br>
3) 로그파일 위치 : **/logs/catalina.{실행날짜}.log **


