package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PcPackageVo {

	private String uuid;
	private String package_name;
	private String package_version;
	private String package_status;
	private String package_desc;
	
}

