package com;

import org.influxdb.dto.Point; 
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.influxdb.DefaultInfluxDBTemplate;
import org.springframework.data.influxdb.InfluxDBConnectionFactory;
import org.springframework.data.influxdb.InfluxDBTemplate;
import org.springframework.data.influxdb.converter.PointConverter;

@Configuration
@EnableConfigurationProperties(InfluxDBPropertiesCustom.class)
public class InfluxDatabaseConfig {

	@Bean
	public InfluxDBConnectionFactory connectionFactory(final InfluxDBPropertiesCustom properties) {
        System.out.println("InfluxDBConnectionFactory properties >> "+properties.getUrl());
        System.out.println("InfluxDBConnectionFactory properties >> "+properties.getDatabase());
        System.out.println("InfluxDBConnectionFactory properties >> "+properties.getUsername());

		return new InfluxDBConnectionFactory(properties);
	}
	
	@Bean
	public InfluxDBTemplate<Point> influxDBTemplate(final InfluxDBConnectionFactory connectionFactory) {
		 return new InfluxDBTemplate<>(connectionFactory, new PointConverter());
	}
	
	@Bean
	public DefaultInfluxDBTemplate defaultTemplate(final InfluxDBConnectionFactory connectionFactory) {
		return new DefaultInfluxDBTemplate(connectionFactory);
	}
	
}
