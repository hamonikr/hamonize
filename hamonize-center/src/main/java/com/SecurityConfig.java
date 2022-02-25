// package com;

// import org.slf4j.Logger;
// import org.slf4j.LoggerFactory;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
// import org.springframework.security.config.annotation.web.builders.HttpSecurity;
// import org.springframework.security.config.annotation.web.builders.WebSecurity;
// import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
// import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
// import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
// import org.springframework.security.crypto.password.PasswordEncoder;


// @Configuration
// @EnableWebSecurity
// public class SecurityConfig extends WebSecurityConfigurerAdapter{
// 	private Logger logger = LoggerFactory.getLogger(this.getClass());

//     @Autowired
//     SecurityUserDetailsService userDetailService;
    
    
//     @Bean
//     public PasswordEncoder passwordEncoder() {
//         return new BCryptPasswordEncoder();
//     }

//     @Override
//     public void configure(WebSecurity web) throws Exception {
//         web.ignoring()
//             .antMatchers("/resources/**")
//             .antMatchers("/css/**")
//             .antMatchers("/js/**")
//             .antMatchers("/img/**")
//             .antMatchers("/images/**")
//             .antMatchers("/vendors/**");
            
//     }

//     @Override
//     protected void configure(HttpSecurity http) throws Exception {


// 		http.csrf().disable()
//             .authorizeRequests()
//             .antMatchers("/api/**", "/login/**","/getsession/**").permitAll()
//             .anyRequest()
//             .authenticated();
        
//         http.formLogin().loginPage("http://192.168.0.210:8080/login");
        
//         http.logout()
//             .logoutSuccessUrl("http://192.168.0.210:8080/login")
//             .invalidateHttpSession(true);

            
//     }

//         @Override
//         public void configure(AuthenticationManagerBuilder auth) throws Exception {
//             auth.userDetailsService(userDetailService).passwordEncoder(passwordEncoder());
//         }
    

// }