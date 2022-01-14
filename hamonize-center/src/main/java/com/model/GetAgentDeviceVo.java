package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class GetAgentDeviceVo {

	private int aj_seq;
	private Long org_seq;
	private String ppm_seq;
	private String insert_dt;
	private String progrm_nm;
	private String arrPpmSeq;
	private String sum_ppm_seq;

	private String pajob_seq;
	private String pa_seq;
	private String pcm_uuid;
	private String pcm_seq;
	private String pcm_name;
	private String remarks;
	
	private int new_pa_seq;
	private int old_pa_seq;
	private String gubun;
	private String device_code;
	private String dvc_seq;
	
}
