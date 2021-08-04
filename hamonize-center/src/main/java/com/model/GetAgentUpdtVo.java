package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class GetAgentUpdtVo {

	private int aj_seq;
	private int org_seq;
	private String ppm_seq;
	private String insert_dt;
	private String progrm_nm;
	private String arrPpmSeq;
	private String sum_ppm_seq;

	private String pajob_seq;
	private String pa_seq;
	private String pcm_uuid; //pc 관리번호
	private String pcm_seq; // 프로그램 번호
	private String pcm_name;
	private String deb_apply_name;
	private String deb_new_version;//버전 정보 추가
	private String remarks;
	private String updt_ap_seq;
	
	
	private int new_pa_seq;
	private int old_pa_seq;
	private String gubun;
	
	private String arrStatus;
	private String pu_status;

}
