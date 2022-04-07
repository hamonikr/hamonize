package com.hamonize.portal.login;

import javax.persistence.Entity;
import javax.persistence.GenerationType;

import java.io.Serializable;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Date;

import javax.persistence.*;

import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@SequenceGenerator( 
            name="TBL_ADMIN_LOGIN_HISTORY_SEQ_GEN2",
            sequenceName="TBL_ADMIN_LOGIN_HISTORY_SEQ_SEQ2",
            initialValue=136, 
            allocationSize=1                                
            )
@Table(name="tbl_admin_login_history")
public class LoginHistory implements Serializable {
    
    @Id
    @GeneratedValue(
    	strategy = GenerationType.SEQUENCE
    	, generator = "TBL_ADMIN_LOGIN_HISTORY_SEQ_GEN2"
    )
    // @GeneratedValue(strategy = GenerationType.AUTO)
    private Long seq;

    private String domain;
    
    @Column(name = "user_id")
    private String userid;

    @Column(name = "user_ip")
    private String userip;

    @Column(name = "login_date")
    private LocalDateTime logindate;
    
    @Column(name = "logout_date")
    private LocalDateTime logoutdate;
    
    @Column(name = "time_spent")
    private Date timespent;

    
}
