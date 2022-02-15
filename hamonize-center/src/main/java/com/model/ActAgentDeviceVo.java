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
@Table(name="tbl_act_device_log")
public class ActAgentDeviceVo {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼넘버")
	private Long seq;
	
	@Comment("부서번호")
	private Long org_seq;

	@Size(max=100)
	@Comment("PC고유번호")
	private String pc_uuid;
	
	@Size(max=100)
	@Comment("PC호스트명")
	private String pc_hostname;

	@Size(max=10)
	@Comment("정책적용여부 Y:허용 N:차단")
	private String status;

	@Size(max=200)
	@Comment("디바이스명")
	private String product;

	@Size(max=200)
	@Comment("디바이스vender코드")
	@Column(name = "vendorcode", nullable = false)
	private String vendorCode;

	@Size(max=200)
	@Comment("디바이스product코드")
	@Column(name = "productcode", nullable = false)
	private String productCode;

	@Comment("등록일")
	private Timestamp rgstr_date;
	
	@Comment("수정일")
	private Timestamp updt_date;

}