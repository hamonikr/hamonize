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
	private String domain;

	private Integer p_seq;
	private Integer org_ordr;
	private String org_nm;
	private String p_org_nm;
	private String all_org_nm;
	private String sido;
	private String gugun;
	private String org_num;
	private String writer_id;
	private String writer_ip;
	private String update_writer_id;
	private String update_writer_ip;
	private String section;
	private Timestamp rgstr_date;
	private Timestamp updt_date;
	private Long inventory_id;
	private Long group_id;
	@Transient
	private String orgname;
	@Transient
	private String pc_uuid;
	@Transient
	private String level;

}
