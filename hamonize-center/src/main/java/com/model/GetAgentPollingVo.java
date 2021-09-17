package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class GetAgentPollingVo {

	private String seq;
	private String uuid;
	private String pu_name;
	private Integer polling_tm;
}
