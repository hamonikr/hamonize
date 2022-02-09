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

import com.id.OrgId;

import org.hibernate.annotations.Comment;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@IdClass(OrgId.class)
@Table(name="tbl_org")
public class OrgVo {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Comment("조직 시리얼넘버")
	private Long seq;

	@Id
	@Size(max=50)
	@Comment("")
	private String domain;
	
	@Comment("상위조직번호")
	private Long p_seq;
	
	@Comment("조직순서")
	private Integer org_ordr;
	
	@Size(max=100)
	@Comment("조직명")
	private String org_nm;
	
	@Size(max=100)
	@Comment("상위조직명")
	private String p_org_nm;
	
	@Size(max=500)
	@Comment("조직경로")
	private String all_org_nm;
	
	@Size(max=100)
	@Comment("지역(시/도)")
	private String sido;
	
	@Size(max=100)
	@Comment("지역(구/군)")
	private String gugun;
	
	@Comment("삭제예정")
	private String org_num;
	
	@Size(max=100)
	@Comment("등록자아이디")
	private String writer_id;
	
	@Size(max=30)
	@Comment("등록자아이피")
	private String writer_ip;
	
	@Size(max=100)
	@Comment("수정자아이디")
	private String update_writer_id;
	
	@Size(max=30)
	@Comment("수정자아이피")
	private String update_writer_ip;
	
	@Comment("삭제예정")
	private String section;
	
	@Comment("등록일")
	private Timestamp rgstr_date;
	
	@Comment("수정일")
	private Timestamp updt_date;
	
	@Comment("앤서블인벤토리아이디")
	private Long inventory_id;
	
	@Comment("앤서블그룹아이디")
	private Long group_id;
	
	@Transient
	private String orgname;
	
	@Transient
	private String pc_uuid;
	
	@Transient
	private String level;

}
