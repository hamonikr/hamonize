package com;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.PropertySources;
import org.springframework.data.influxdb.InfluxDBProperties;

import lombok.ToString;

@ToString
@Primary
@Configuration
@PropertySources({
    @PropertySource( value = "file:${user.home}/env/config.properties", ignoreResourceNotFound = true)
})
public class InfluxDBPropertiesCustom extends InfluxDBProperties{
    @Value("${spring.influxdb.url}")
    private String url;

    @Value("${spring.influxdb.database}")
    private String database;

    @Value("${spring.influxdb.username}")
    private String username;

    @Value("${spring.influxdb.password}")
    private String password;
    
    @Value("${spring.influxdb.retentionPolicy}")
    private String retentionPolicy;
    
    @Value("${spring.influxdb.read-timeout}")
    private int readTimeout;
    
    @Value("${spring.influxdb.gzip}")
    private boolean gzip=true;
   
   private int connectTimeout = 10;

   private int writeTimeout = 10;

}
