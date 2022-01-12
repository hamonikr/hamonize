package com;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Setter
@Getter
@Configuration
@PropertySource(value = "file:${user.home}/env/config.properties", ignoreResourceNotFound = true)
public class GlobalPropertySource {
    // db
    @Value("${spring.db1.datasource.primary.jndi-name}")
    private String jndiName;

    @Value("${spring.db1.datasource.driverClassName}")
    private String driverClassName;

    @Value("${spring.db1.datasource.jdbc-url}")
    private String url;

    @Value("${spring.db1.datasource.username}")
    private String username;

    @Value("${spring.db1.datasource.password}")
    private String password;

    @Value("${ldap.urls}")
    private String ldapUrl;

    @Value("${ldap.password}")
    private String ldapPassword;

    @Value("${apt.ip}")
    private String aptIp;

}

