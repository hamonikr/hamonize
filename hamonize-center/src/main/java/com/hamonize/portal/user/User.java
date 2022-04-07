package com.hamonize.portal.user;


import java.time.LocalDateTime;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;
import javax.validation.constraints.Size;

import org.hibernate.annotations.Comment;
import org.jetbrains.annotations.NotNull;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name="tbl_admin_user")
public class User {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
    Long seq;

	@Size(max=50)
	@Comment("도메인 명")
	private String domain;

    @Column(name = "user_id")
	@Comment("유저 아이디")
	private String userid;

	@NotNull
	@Column(name = "pass_wd")
    @Size(max=300)
	@Comment("유저 패스워드")
	private String passwd;

	@Transient
	private String beforepasswd;
	
	@Column(name = "user_name")
    @Size(max=50)
	@Comment("유저 이름")
	private String username;

	@Size(max=50)
	@Comment("유저 이름")
	private String email;

	@Comment("비밀번호 암호화 솔트 값")
	private String salt;

	@Comment("활성 비활성 구분 값 > 1 : 활성 , 0 : 비활성")
	private String status;
	
	@Column(name = "rgstr_date")
	private LocalDateTime rgstrdate;

	@Column(name = "updt_date")
	private LocalDateTime updtdate;
	
    @Transient
	@Column(name="login_check",columnDefinition = "integer default 0")
	private int logincheck;
	
	@Comment("유저권한 포탈 유저 : USER / 어드민 유저 : ADMIN ")
	private String role;

	@Comment("이메일 인증키")
	private String authkey;

	@Comment("소셜 이미지")
	private String picture;
		
}
