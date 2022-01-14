package com.id;

import java.io.Serializable;

public class OrgId implements Serializable{
  
  private Long seq;
  private String domain;

  public OrgId(Long seq,String domain){
    this.seq = seq;
    this.domain = domain;
  }

}
