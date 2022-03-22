package com;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@EnableAutoConfiguration
@ComponentScan
public class I18nConfig implements WebMvcConfigurer {

	// 인터셉터 설정 (인터셉터에서 service 사용하기 위해 분리)
	@Bean
	HamonizeInterceptor hamonizeInterceptor() {
		return new HamonizeInterceptor();
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(hamonizeInterceptor()).addPathPatterns("/**")
				.excludePathPatterns("/manual/*").excludePathPatterns("/*")
				.excludePathPatterns("/login/*").excludePathPatterns("/hmsvc/*")
				.excludePathPatterns("/hmsvr/*").excludePathPatterns("/getAgent/*")
				.excludePathPatterns("/act/*").excludePathPatterns("/backup/*")
				.excludePathPatterns("/js/**").excludePathPatterns("/css/**")
				.excludePathPatterns("/fonts/**").excludePathPatterns("/images/**")
				.excludePathPatterns("/img/**").excludePathPatterns("/font/**")
				.excludePathPatterns("/test/*").excludePathPatterns("/file/**")
				.excludePathPatterns("/logintemplet/**")
				.excludePathPatterns("/vendor/**").excludePathPatterns("/test/**");

	}

}
