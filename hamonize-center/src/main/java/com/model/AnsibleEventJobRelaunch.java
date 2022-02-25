package com.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Size;

import com.vladmihalcea.hibernate.type.json.JsonBinaryType;

import org.hibernate.annotations.Comment;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@Table(name="tbl_ansible_event_job_relaunch")
@TypeDef(name="jsonb", typeClass = JsonBinaryType.class)
//@TypeDef(name="json", typeClass=JsonType.class)
public class AnsibleEventJobRelaunch {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼넘버")
	private Long seq;

	@Size(max=50)
	private String domain;

	@Size(max=50)
	private String kind;

	@Size(max=100)
	@Comment("PC고유번호")
	private String pc_uuid;

	private Long org_seq;

	private Long job_id;

	private Long parents_job_id;
	
	@Type(type="jsonb")
	@Column(columnDefinition = "jsonb")
	//@Convert(converter=JsonbConverter.class)
	private String data;

	@Comment("등록일")
	private Timestamp rgstr_date;

}
