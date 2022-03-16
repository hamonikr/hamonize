package com.id;

import java.io.Serializable;

public class UserId implements Serializable{
  private Long seq;
  private String domain;

  public UserId(Long seq,String domain){
    this.seq = seq;
    this.domain = domain;
  }
  
}
