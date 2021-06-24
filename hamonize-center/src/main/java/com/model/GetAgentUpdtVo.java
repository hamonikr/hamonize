package com.model;

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

	
	
	
	
	@Override
	public String toString() {
		return "GetAgentUpdtVo [aj_seq=" + aj_seq + ", org_seq=" + org_seq + ", ppm_seq=" + ppm_seq + ", insert_dt="
				+ insert_dt + ", progrm_nm=" + progrm_nm + ", arrPpmSeq=" + arrPpmSeq + ", sum_ppm_seq=" + sum_ppm_seq
				+ ", pajob_seq=" + pajob_seq + ", pa_seq=" + pa_seq + ", pcm_uuid=" + pcm_uuid + ", pcm_seq=" + pcm_seq
				+ ", pcm_name=" + pcm_name + ", deb_apply_name=" + deb_apply_name + ", deb_new_version=" + deb_new_version + ", remarks=" + remarks
				+ ", updt_ap_seq=" + updt_ap_seq + ", new_pa_seq=" + new_pa_seq + ", old_pa_seq=" + old_pa_seq
				+ ", gubun=" + gubun + ", arrStatus=" + arrStatus + ", pu_status=" + pu_status + "]";
	}

	public int getAj_seq() {
		return aj_seq;
	}

	public void setAj_seq(int aj_seq) {
		this.aj_seq = aj_seq;
	}

	public int getOrg_seq() {
		return org_seq;
	}

	public void setOrg_seq(int org_seq) {
		this.org_seq = org_seq;
	}

	public String getPpm_seq() {
		return ppm_seq;
	}

	public void setPpm_seq(String ppm_seq) {
		this.ppm_seq = ppm_seq;
	}

	public String getInsert_dt() {
		return insert_dt;
	}

	public void setInsert_dt(String insert_dt) {
		this.insert_dt = insert_dt;
	}

	public String getProgrm_nm() {
		return progrm_nm;
	}

	public void setProgrm_nm(String progrm_nm) {
		this.progrm_nm = progrm_nm;
	}

	public String getArrPpmSeq() {
		return arrPpmSeq;
	}

	public void setArrPpmSeq(String arrPpmSeq) {
		this.arrPpmSeq = arrPpmSeq;
	}

	public String getSum_ppm_seq() {
		return sum_ppm_seq;
	}

	public void setSum_ppm_seq(String sum_ppm_seq) {
		this.sum_ppm_seq = sum_ppm_seq;
	}

	public String getPajob_seq() {
		return pajob_seq;
	}

	public void setPajob_seq(String pajob_seq) {
		this.pajob_seq = pajob_seq;
	}

	public String getPa_seq() {
		return pa_seq;
	}

	public void setPa_seq(String pa_seq) {
		this.pa_seq = pa_seq;
	}

	public String getPcm_uuid() {
		return pcm_uuid;
	}

	public void setPcm_uuid(String pcm_uuid) {
		this.pcm_uuid = pcm_uuid;
	}

	public String getPcm_seq() {
		return pcm_seq;
	}

	public void setPcm_seq(String pcm_seq) {
		this.pcm_seq = pcm_seq;
	}

	public String getPcm_name() {
		return pcm_name;
	}

	public void setPcm_name(String pcm_name) {
		this.pcm_name = pcm_name;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public int getNew_pa_seq() {
		return new_pa_seq;
	}

	public void setNew_pa_seq(int new_pa_seq) {
		this.new_pa_seq = new_pa_seq;
	}

	public int getOld_pa_seq() {
		return old_pa_seq;
	}

	public void setOld_pa_seq(int old_pa_seq) {
		this.old_pa_seq = old_pa_seq;
	}

	public String getGubun() {
		return gubun;
	}

	public void setGubun(String gubun) {
		this.gubun = gubun;
	}

	public String getDeb_apply_name() {
		return deb_apply_name;
	}

	public void setDeb_apply_name(String deb_apply_name) {
		this.deb_apply_name = deb_apply_name;
	}


	public String getDeb_new_version() {
		return deb_new_version;
	}

	public void setDeb_new_version(String deb_new_version) {
		this.deb_new_version = deb_new_version;
	}

	public String getArrStatus() {
		return arrStatus;
	}

	public void setArrStatus(String arrStatus) {
		this.arrStatus = arrStatus;
	}

	public String getUpdt_ap_seq() {
		return updt_ap_seq;
	}

	public void setUpdt_ap_seq(String updt_ap_seq) {
		this.updt_ap_seq = updt_ap_seq;
	}

	public String getPu_status() {
		return pu_status;
	}

	public void setPu_status(String pu_status) {
		this.pu_status = pu_status;
	}

	
	
}
