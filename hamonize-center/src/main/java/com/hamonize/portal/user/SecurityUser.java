package com.hamonize.portal.user;
import java.util.HashSet;
import java.util.Set;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SecurityUser extends User {

    private String userid;
    private String passwd;
    private String status;
    private String username;
    private String salt;
    private String email;
    private String role;

    // 결제정보
    private String domain;
    private int itemno;

    public SecurityUser(com.hamonize.portal.user.User user) {
        super(user.getUserid(), user.getPasswd(), makeGrantedAuthority()); 
        this.userid = user.getUserid();
        this.passwd = user.getPasswd();
        this.username = user.getUsername();
        this.salt = user.getSalt();
        this.domain = user.getDomain();
        this.email = user.getEmail();
        this.status = user.getStatus();
        this.role = user.getRole();
    }

    private static Set<GrantedAuthority> makeGrantedAuthority() {
        Set<GrantedAuthority> grantedAuthorities = new HashSet<>();
        grantedAuthorities.add(new SimpleGrantedAuthority(ROLE.USER.getValue()));

        return grantedAuthorities;
    }

}