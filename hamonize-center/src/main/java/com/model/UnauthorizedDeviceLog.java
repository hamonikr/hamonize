package com.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Size;

import org.hibernate.annotations.Comment;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@Table(name="tbl_unauthorized_device_log")
public class UnauthorizedDeviceLog {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼넘버")
	private Long seq;

	@Comment("부서번호")
	private Long org_seq;
	
	@Size(max=50)
	@Comment("벤더코드")
	private String vendor;

	@Size(max=50)
	@Comment("프로덕트코드")
	private String product;
	
	@Size(max=100)
	@Comment("PC고유번호")
	private String pc_uuid;
	
	@Size(max=100)
	@Comment("PC호스트명")
	private String pc_hostname;

	@Size(max=100)
	@Comment("PC유저명")
	private String pc_user;

	@Size(max=200)
	@Comment("디바이스정보")
	private String info;

	@Comment("등록일")
	private Timestamp rgstr_date;
	
	@Comment("수정일")
	private Timestamp updt_date;

}