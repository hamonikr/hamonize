package com.mapper;

import java.util.Map;

import com.model.LoginVO;

public interface ILoginMapper {

	LoginVO getSalt(Map<String, Object> params) throws Exception;

	LoginVO getLoginInfo(Map<String, Object> params) throws Exception;

	void insertLoginInfo(LoginVO lvo) throws Exception;

	int getSeqMax() throws Exception;
	
	int getLoginFailCount(Map<String, Object> params) throws Exception;

	void updateLoginFailCount(Map<String, Object> params) throws Exception;

	void updateLoginInfo(LoginVO lvo) throws Exception;

	LoginVO getSSOLoginInfo(Map<String, String> params) throws Exception;

}
