package com;

import javax.sql.DataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;


@Configuration
@MapperScan(value = "com.mapper")
@EnableTransactionManagement
public class PsqlDatabaseConfig {

    @Autowired
    GlobalPropertySource globalPropertySource;

    // @Bean
    // @Primary
    // public DataSource customDataSource() {
    // return DataSourceBuilder
    // .create()
    // .url(globalPropertySource.getUrl())
    // .driverClassName(globalPropertySource.getDriverClassName())
    // .username(globalPropertySource.getUsername())
    // .password(globalPropertySource.getPassword())
    // .build();
    // }

    @Bean(name = "db1DataSource")
    @ConfigurationProperties(prefix = "spring.db1.datasource")
    public DataSource db1DataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean
    public SqlSessionFactory db1SqlSessionFactory(ApplicationContext applicationContext)
            throws Exception {
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(db1DataSource());
        sqlSessionFactoryBean.setMapperLocations(
                applicationContext.getResources("classpath:publicMapper/*.xml"));

        return sqlSessionFactoryBean.getObject();
    }

    @Bean
    public SqlSessionTemplate db1SqlSessionTemplate(SqlSessionFactory db1SqlSessionFactory)
            throws Exception {
        return new SqlSessionTemplate(db1SqlSessionFactory);
    }
}
