package com.model;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Size;

import com.vladmihalcea.hibernate.type.json.JsonBinaryType;
import com.vladmihalcea.hibernate.type.json.JsonType;

import org.hibernate.annotations.Comment;
import org.hibernate.annotations.Type;
import org.hibernate.annotations.TypeDef;
import org.json.simple.JSONObject;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@Table(name="tbl_ansible_event_job")
@TypeDef(name="jsonb", typeClass = JsonBinaryType.class)
//@TypeDef(name="json", typeClass=JsonType.class)
public class AnsibleEventJob {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼넘버")
	private Long seq;

	@Size(max=50)
	private String domain;

	private Long org_seq;

	private Long job_id;
	
	@Type(type="jsonb")
	@Column(columnDefinition = "jsonb")
	//@Convert(converter=JsonbConverter.class)
	private String data;

	@Comment("등록일")
	private Timestamp rgstr_date;

}
