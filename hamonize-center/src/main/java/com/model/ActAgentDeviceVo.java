package com.model;

public class ActAgentDeviceVo {

	private Integer orgseq;
	private String datetime;
	private String uuid;
	private String hostname;
	private String status_yn;
	private String product;
	private String vendorCode;
	private String productCode;
	
	@Override
	public String toString() {
		return "ActAgentDeviceVo [orgseq=" + orgseq + ", datetime=" + datetime + ", uuid=" + uuid + ", hostname="
				+ hostname + ", status_yn=" + status_yn + ", product=" + product + ", vendorCode=" + vendorCode
				+ ", productCode=" + productCode + "]";
	}
	
	public Integer getOrgseq() {
		return orgseq;
	}
	public void setOrgseq(Integer orgseq) {
		this.orgseq = orgseq;
	}
	public String getDatetime() {
		return datetime;
	}
	public void setDatetime(String datetime) {
		this.datetime = datetime;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getHostname() {
		return hostname;
	}
	public void setHostname(String hostname) {
		this.hostname = hostname;
	}
	public String getStatus_yn() {
		return status_yn;
	}
	public void setStatus_yn(String status_yn) {
		this.status_yn = status_yn;
	}
	public String getProduct() {
		return product;
	}
	public void setProduct(String product) {
		this.product = product;
	}
	public String getVendorCode() {
		return vendorCode;
	}
	public void setVendorCode(String vendorCode) {
		this.vendorCode = vendorCode;
	}
	public String getProductCode() {
		return productCode;
	}
	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}
	
	
	
	
	
	


}