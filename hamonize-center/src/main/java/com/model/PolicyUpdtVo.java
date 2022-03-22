package com.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
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
@Table(name="tbl_policy_package_list")
public class PolicyUpdtVo {

	//정책확정Insert
	@Transient
	private Integer seq;
	@Transient
	private Long org_seq;
	@Transient
	private String ppm_seq;
	
	//프로그램관리list
	@Size(max=50)
	@Comment("테넌트")
	private String domain;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼 번호")
	private Long pu_seq;

	@Size(max=300)
	@Comment("프로그램명")
	private String pu_name;

	@Size(max=10)
	@Comment("작업 상태값 (I-insert,U-update)")
	private String pu_status;

	@Size(max=500)
	@Comment("설명")
	private String pu_dc;

	@Size(max=10)
	@Comment("업데이트 실행 여부")
	private String status;

	@Size(max=300)
	@Comment("패키지명")
	private String deb_apply_name;

	@Size(max=10)
	@Comment("설치파일유무")
	private String base_deb_yn;

	@Size(max=50)
	@Comment("패키지 신규버전")
	private String deb_new_version;

	@Size(max=50)
	@Comment("패키지 현재버전")
	private String deb_now_version;

	@Column(columnDefinition = "integer default 0")
	@Comment("프로그램 폴링타임/하모나이즈 프로그램만")
	int polling_tm;

	private Timestamp rgstr_date;
	private Timestamp updt_date;

	@Transient
	private int mngeListInfoCurrentPage;
	@Transient
	private String[] deleteList;
		
}
