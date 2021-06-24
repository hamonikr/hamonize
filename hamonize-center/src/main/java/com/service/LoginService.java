package com.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.ILoginMapper;
import com.model.LoginVO;

@Service
public class LoginService {
	
	@Autowired
	ILoginMapper loginMapper;

	public LoginVO getLoginInfo(Map<String, Object> params) throws Exception {
		
		return loginMapper.getLoginInfo(params);
	}

	public void insertLoginInfo(LoginVO lvo) throws Exception {
		loginMapper.insertLoginInfo(lvo);
	}


	public int getSeqMax() throws Exception {
		
		return loginMapper.getSeqMax();
	}


	public void updateLoginInfo(LoginVO lvo) throws Exception {
		loginMapper.updateLoginInfo(lvo);
	}


	public LoginVO getSSOLoginInfo(Map<String, String> params) throws Exception {
		
		return loginMapper.getSSOLoginInfo(params);
		
	}
   
}
