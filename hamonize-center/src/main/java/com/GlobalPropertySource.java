package com;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.PropertySources;

@Configuration
@PropertySources({
    @PropertySource( value = "file:${user.home}/env/config.properties", ignoreResourceNotFound = true)
   })
public class GlobalPropertySource {
    //db
    @Value("${spring.db1.datasource.primary.jndi-name}")
    private String jndiName;

    @Value("${spring.db1.datasource.driverClassName}")
    private String driverClassName;
    
    @Value("${spring.db1.datasource.url}")
    private String url;
    
    @Value("${spring.db1.datasource.username}")
    private String username;
    
    @Value("${spring.db1.datasource.password}")
    private String password;

    public String getJndiName() {
        return jndiName;
    }   
    
    public String getDriverClassName() {
        return driverClassName;
    }   
    
    public String getUrl() {
        return url;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    
    

}

