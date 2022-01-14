package com.id;

import java.io.Serializable;

public class PcMangrId implements Serializable{
  private Long seq;
  private String domain;

  public PcMangrId(Long seq,String domain){
    this.seq = seq;
    this.domain = domain;
  }
  
}
