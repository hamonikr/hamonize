package com;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Value("${attach.path}")
	private String path;
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
	    registry.addResourceHandler("/uploads/**")
        .addResourceLocations("file:"+path);
    }
}
