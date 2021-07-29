// package com;


// import java.io.IOException;
// import javax.naming.NamingException;
// import javax.sql.DataSource;
// import org.apache.catalina.Context;
// import org.apache.catalina.startup.Tomcat;
// import org.apache.ibatis.session.SqlSessionFactory;
// import org.apache.tomcat.util.descriptor.web.ContextResource;
// import org.mybatis.spring.SqlSessionFactoryBean;
// import org.mybatis.spring.annotation.MapperScan;
// import org.mybatis.spring.transaction.SpringManagedTransactionFactory;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.beans.factory.annotation.Qualifier;
// import org.springframework.boot.context.embedded.tomcat.TomcatEmbeddedServletContainer;
// import org.springframework.boot.context.embedded.tomcat.TomcatEmbeddedServletContainerFactory;
// import org.springframework.boot.context.properties.EnableConfigurationProperties;
// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
// import org.springframework.jdbc.datasource.DataSourceTransactionManager;
// import org.springframework.jndi.JndiObjectFactoryBean;
// import org.springframework.transaction.PlatformTransactionManager;

// @Configuration 
// @MapperScan(value="com.mapper")
// @EnableConfigurationProperties
// public class AppConfig {

//     @Autowired
//     GlobalPropertySource globalPropertySource;  

// 	@Bean
//     public TomcatEmbeddedServletContainerFactory tomcatFactory() {  // if datasouce defind in tomcat xml configuration then no need to create this bean
//         return new TomcatEmbeddedServletContainerFactory() {

//             @Override
//             protected TomcatEmbeddedServletContainer getTomcatEmbeddedServletContainer(Tomcat tomcat) {
//                 tomcat.enableNaming();
//                 return super.getTomcatEmbeddedServletContainer(tomcat);
//             }


//             @Override                   // create JNDI resource
//             protected void postProcessContext(Context context) {
//                 System.out.println("globalPropertySource.getJndiName() >> "+ globalPropertySource.getJndiName());
//                 System.out.println("globalPropertySource.ldapUrl() >> "+ globalPropertySource.getLdapUrl());
//                 ContextResource resource = new ContextResource();
//                 resource.setName(globalPropertySource.getJndiName());
//                 resource.setType(DataSource.class.getName());
//                 resource.setProperty("driverClassName", globalPropertySource.getDriverClassName());
//                 resource.setProperty("url", globalPropertySource.getUrl());
//                 resource.setProperty("username", globalPropertySource.getUsername());
//                 resource.setProperty("password", globalPropertySource.getPassword());
//                 resource.setProperty("factory", "org.apache.tomcat.jdbc.pool.DataSourceFactory");
//                 resource.setProperty("validationQuery", "SELECT 1");
//                 resource.setProperty("testOnBorrow", "true");
//                 resource.setProperty("validationInterval", "5000");
//                 context.getNamingResources().addResource(resource);
//             }            
//         };
//     }
// 	 @Bean(name = "dataSource", destroyMethod = "")
//     public DataSource jndiDataSource() throws IllegalArgumentException,
//                                               NamingException {
//         JndiObjectFactoryBean bean = new JndiObjectFactoryBean();           // create JNDI data source
//         bean.setJndiName("java:/comp/env/jdbc/postgresqldb");  // jndiDataSource is name of JNDI data source 
//         bean.setProxyInterface(DataSource.class);
//         bean.setLookupOnStartup(false);
//         bean.afterPropertiesSet();
//         return (DataSource) bean.getObject();
//     }
	 
// 	 	@Bean
// 	    public SqlSessionFactory sqlSessionFactory(@Qualifier("dataSource") DataSource dataSource) throws Exception {
// 	        SqlSessionFactoryBean sessionFactoryBean = new SqlSessionFactoryBean();
// 	        configureSqlSessionFactory(sessionFactoryBean, dataSource);
// 	        sessionFactoryBean.setTransactionFactory(new SpringManagedTransactionFactory());
// 	        return sessionFactoryBean.getObject();
// 	    }
	 
// 	    @Bean
// 	    public PlatformTransactionManager transactionManager(@Qualifier("dataSource") DataSource dataSource) {
// 	        DataSourceTransactionManager transactionManager = new DataSourceTransactionManager(dataSource);
// 	        transactionManager.setGlobalRollbackOnParticipationFailure(false);
// 	        return transactionManager;
// 	    }

// 	    public void configureSqlSessionFactory(SqlSessionFactoryBean sessionFactoryBean, DataSource dataSource) throws IOException {
// 	        PathMatchingResourcePatternResolver pathResolver = new PathMatchingResourcePatternResolver();
// 	        sessionFactoryBean.setDataSource(dataSource);
// 	        sessionFactoryBean.setMapperLocations(pathResolver.getResources("classpath:publicMapper/*.xml"));
// 	    }
// }