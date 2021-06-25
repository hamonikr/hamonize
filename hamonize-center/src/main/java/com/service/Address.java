package com.service;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

@XmlRootElement(name = "result")
@XmlType(name="Info", namespace="com.addr.Address", propOrder={"zipNo", "lnmAdres", "rnAdres"})
//@XmlType(propOrder={"zipNo", "lnmAdres", "rnAdres"})
public class Address {
	private String zipNo;
	private String lnmAdres;
	private String rnAdres;
	
	
	@Override
	public String toString() {
		return "Address [zipNo=" + zipNo + ", lnmAdres=" + lnmAdres + ", rnAdres=" + rnAdres + "]";
	}
	
	@Override
	public int hashCode() {
		// TODO Auto-generated method stub
		return super.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		return super.equals(obj);
	}

	public String getZipNo() {
		return zipNo;
	}
	
	@XmlElement(name="zipNo")
	public void setZipNo(String zipNo) {
		this.zipNo = zipNo;
	}
	
	public String getLnmAdres() {
		return lnmAdres;
	}
	
	@XmlElement(name="lnmAdres")
	public void setLnmAdres(String lnmAdres) {
		this.lnmAdres = lnmAdres;
	}
	
	public String getRnAdres() {
		return rnAdres;
	}
	
	@XmlElement(name="rnAdres")
	public void setRnAdres(String rnAdres) {
		this.rnAdres = rnAdres;
	}
	
	
}
