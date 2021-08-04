package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AnswerVo {
	private int as_seq;
	private String as_tcng_seq;
	private String as_content;
	private String as_insert_dt;
	private String as_update_dt;
	
	
	// insert
	private int tcngSeq;
	private String sportStatus;
	private String sportType_detail;
	private String answerContent;
	private String admin_id;
	private String admin_name;

	
}
