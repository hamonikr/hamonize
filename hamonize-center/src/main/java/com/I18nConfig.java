package com;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
 
@Configuration
@EnableAutoConfiguration
@ComponentScan
public class I18nConfig extends WebMvcConfigurerAdapter
{ 
	
	//인터셉터 설정 (인터셉터에서 service 사용하기 위해 분리)
	@Bean
	HamonizeInterceptor hamonizeInterceptor() {
		return new HamonizeInterceptor();
	}
	
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(hamonizeInterceptor()).addPathPatterns("/**")
			.excludePathPatterns("/login/*")
			.excludePathPatterns("/hmsvc/*")
			.excludePathPatterns("/hmsvr/*")
			.excludePathPatterns("/getAgent/*")
			.excludePathPatterns("/act/*")
			.excludePathPatterns("/backup/*")
			.excludePathPatterns("/getAgentServer/*")
			.excludePathPatterns("/hmsvcServer/*")
			.excludePathPatterns("/actServer/*");
	}

}