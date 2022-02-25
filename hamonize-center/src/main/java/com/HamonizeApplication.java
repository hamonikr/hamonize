package com;


import java.nio.charset.Charset;
import java.time.LocalDateTime;

import javax.servlet.http.HttpSession;

import com.navercorp.lucy.security.xss.servletfilter.XssEscapeServletFilter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.filter.HiddenHttpMethodFilter;
import org.springframework.web.reactive.function.client.WebClient;

@SpringBootApplication
public class HamonizeApplication {
	private Logger logger = LoggerFactory.getLogger(this.getClass());
    @Autowired
    HttpSession httpSession;

	public static void main(String[] args) {
		SpringApplication.run(HamonizeApplication.class);
	}

	@Bean
	public HttpMessageConverter<String> responseBodyConverter() {
		return new StringHttpMessageConverter(Charset.forName("UTF-8"));
	}

	// @Bean
	// public Filter characterEncodingFilter() {
	// 	CharacterEncodingFilter characterEncodingFilter = new CharacterEncodingFilter();
	// 	characterEncodingFilter.setEncoding("UTF-8");
	// 	characterEncodingFilter.setForceEncoding(true);
	// 	return characterEncodingFilter;
	// }

	@Bean
	public HiddenHttpMethodFilter hiddenHttpMethodFilter() {
		HiddenHttpMethodFilter filter = new HiddenHttpMethodFilter();
		return filter;
	}


	// @Bean
	// public EmbeddedServletContainerCustomizer containerCustomizer() {
	// 	return new EmbeddedServletContainerCustomizer() {

	// 		@Override
	// 		public void customize(ConfigurableEmbeddedServletContainer container) {
	// 			ErrorPage error403Page = new ErrorPage(HttpStatus.FORBIDDEN, "/error-403.html");
	// 			ErrorPage error404Page = new ErrorPage(HttpStatus.NOT_FOUND, "/error-404.html");
	// 			ErrorPage error500Page =
	// 					new ErrorPage(HttpStatus.INTERNAL_SERVER_ERROR, "/error-405.html");

	// 			container.addErrorPages(error403Page, error404Page, error500Page);
	// 		}
	// 	};
	// }

	@Bean
	public FilterRegistrationBean xssEscapeServletFilter() {
		FilterRegistrationBean registrationBean = new FilterRegistrationBean();
		registrationBean.setFilter(new XssEscapeServletFilter());
		registrationBean.setOrder(1);
		registrationBean.addUrlPatterns("/mntrng/*","/org/*","/pcMngr/*","/auditLog/*","/admin/*");
		return registrationBean;
	}

	@Bean
	public WebClient webClient()
	{
		return WebClient.builder()
		.defaultHeaders(header -> header.setBasicAuth("admin","password"))
		.baseUrl("http://192.168.0.220")
		.build();
	}

	@GetMapping(path = "/getsession")
    public String getsessionAPI() {
        String value = (String) httpSession.getAttribute("KEY");
    	logger.info("\n\n\n returnValue >> {}\n\n", value);

		String returnValue = LocalDateTime.now().toString() + " \n<br>session get id : " + httpSession.getId() + " \n<br>session get userid :  " + value; 
		return returnValue;
    }
}
