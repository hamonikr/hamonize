package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class GetAgentNxssVo {

	private int sma_seq;
	private int nxsshistory_seq;
	private int agent_seq;
	private String pcm_uuid;
	private String sma_domain; 
	private String sma_gubun;
	private String sma_info;
	private int sma_history_seq;
	private int hist_seq;
		
}
