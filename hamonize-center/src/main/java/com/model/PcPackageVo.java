package com.model;

public class PcPackageVo {

	private String uuid;
	private String package_name;
	private String package_version;
	private String package_status;
	private String package_desc;
	
	
	
	@Override
	public String toString() {
		return "PcPackageVo [uuid=" + uuid + ", package_name=" + package_name + ", package_version=" + package_version
				+ ", package_status=" + package_status + ", package_desc=" + package_desc + "]";
	}
	
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getPackage_name() {
		return package_name;
	}
	public void setPackage_name(String package_name) {
		this.package_name = package_name;
	}
	public String getPackage_version() {
		return package_version;
	}
	public void setPackage_version(String package_version) {
		this.package_version = package_version;
	}
	public String getPackage_status() {
		return package_status;
	}
	public void setPackage_status(String package_status) {
		this.package_status = package_status;
	}
	public String getPackage_desc() {
		return package_desc;
	}
	public void setPackage_desc(String package_desc) {
		this.package_desc = package_desc;
	}
	
	
	
}

