package com.model;


import java.sql.Timestamp;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.validation.constraints.Size;

import org.hibernate.annotations.Comment;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@Table(name="tbl_pc_ip_change_log")
public class PcIpChangeLog {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("PC시리얼넘버")
	private Long seq;
	
	@Size(max=100)
	@Comment("macaddress정보")
	private String pc_macaddress;
	
	@Size(max=30)
	@Comment("ip정보")
	private String pc_ip;
		
	@Size(max=30)
	@Comment("vpn_ip정보")
	private String pc_vpnip;

	@Size(max=100)
	@Comment("이전 macaddress정보")
	private String old_pc_macaddress;
	
	@Size(max=30)
	@Comment("이전 ip정보")
	private String old_pc_ip;
		
	@Size(max=30)
	@Comment("이전 vpn_ip정보")
	private String old_pc_vpnip;
	
	@Size(max=100)
	@Comment("PC호스트명")
	private String pc_hostname;

	@Size(max=100)
	@Comment("PC유저명")
	private String pc_user;
	
	@Size(max=100)
	@Comment("PC고유번호")
	private String pc_uuid;

	private Long org_seq;
	
	@Comment("등록일")
	private Timestamp rgstr_date;
	
	@Comment("수정일")
	private Timestamp updt_date;

}