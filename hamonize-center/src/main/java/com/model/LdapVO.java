package com.model;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;


@Component						// 빈 등록
public class LdapVO {
    
    @Value("${ldap.ip}")
    private String ldapUrl;
    
    @Value("${ldap.id}")
    private String id;
    
    @Value("${ldap.password}")
    private String password;
    
    public String getLdapUrl(){
        return ldapUrl;
    }

    public void setLdapUrl(String ldapUrl){
        this.ldapUrl = ldapUrl;
    }
    
    public String getId(){
        return id;
    }

    public void setId(String id){
        this.id = id;
    }
    
    public String getPassword(){
        return password;
    }

    public void setPassword(String password){
        this.password = password;
    }
    

}
