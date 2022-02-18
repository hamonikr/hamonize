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
@Table(name="tbl_policy_backup_restore_list")
public class PolicyRestoreVo {

	@Size(max=50)
	@Comment("테넌트")
	private String domain;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼번호")
	private Long br_seq;

	@Comment("부서번호")
	private Long br_org_seq;

	@Size(max=100)
	@Comment("프로그램명")
	private String br_backup_path;

	private Timestamp br_backup_iso_dt;

	@Size(max=10)
	@Comment("백업구분(A:초기백업본, B: 일반백업본)")
	private String br_backup_status;

	@Size(max=100)
	@Comment("백업명")
	private String br_backup_name;

	@Comment("pc seq번호")
	private Long pc_seq;

	private Timestamp rgstr_date;
	private Timestamp updt_date;
		
}
