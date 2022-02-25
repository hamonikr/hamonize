// package com;

// import com.fasterxml.jackson.databind.ObjectMapper;


// import org.springframework.beans.factory.annotation.Value;
// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.data.redis.connection.RedisConnectionFactory;
// import org.springframework.data.redis.connection.RedisPassword;
// import org.springframework.data.redis.connection.RedisStandaloneConfiguration;
// import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
// import org.springframework.data.redis.core.RedisTemplate;
// import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
// import org.springframework.data.redis.serializer.StringRedisSerializer;
// import org.springframework.session.web.context.AbstractHttpSessionApplicationInitializer;

// import lombok.RequiredArgsConstructor;


// @Configuration
// // @EnableRedisHttpSession(maxInactiveIntervalInSeconds = 1800) /* 세션 만료 시간 : 30분 */
// @RequiredArgsConstructor
// public class RedisConfig extends AbstractHttpSessionApplicationInitializer{
//     @Value("${spring.redis.host}")
//     private String host;

//     @Value("${spring.redis.port}")
//     private Integer port;

//     @Value("${spring.redis.password}")
//     private String password;

//     private final ObjectMapper objectMapper;

//     @Bean 
//     public RedisConnectionFactory lettuceConnectionFactory() {
//         RedisStandaloneConfiguration standaloneConfiguration = new RedisStandaloneConfiguration(host, port);
//         standaloneConfiguration.setPassword(password.isEmpty() ? RedisPassword.none() : RedisPassword.of(password));
    
//         return new LettuceConnectionFactory(standaloneConfiguration);
//     }
    
//     @Bean
//     public RedisTemplate<String, Object> redisTemplate() {
//         RedisTemplate<String, Object> redisTemplate = new RedisTemplate<>();
//         System.out.println("\n\n\n\n<<<<<<<<RedisConfig>>>>>>>>>\n\n\n");
        
//         redisTemplate.setConnectionFactory(lettuceConnectionFactory());
//         redisTemplate.setEnableTransactionSupport(true);
//         redisTemplate.setKeySerializer(new StringRedisSerializer());
//         redisTemplate.setValueSerializer(new GenericJackson2JsonRedisSerializer(objectMapper));

//         return redisTemplate;
//     }
// }