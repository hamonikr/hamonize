package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class NotiVo {

	private int noti_seq;
	private String noti_title;
	private String noti_contents;
	private String noti_writer_id;
	private String noti_group;
	private String noti_rank;
	private Integer noti_orgcode;
	private Integer noti_orguppercode;
	private String first_date;
	private String last_date;
	private int hit;
	
	// search ====
	private String txtSearch;
	private String keyWord;

	private int mngeListInfoCurrentPage;
	
	//	writer] orgname, orgname_value
	private String orgname;
	private String orguppername;
	private String orgname_upcode;
	
	private String rankSelect;
	private String notiSelect;
	private String groupSelect;

}