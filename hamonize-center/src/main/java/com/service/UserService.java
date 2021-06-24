package com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IUserMapper;
import com.model.UserVo;

@Service
public class UserService {
	
	@Autowired
	private IUserMapper userMapper;
	
	public List<UserVo> userList(UserVo vo){
		return userMapper.userList(vo);	
	}
	
	public UserVo userView(UserVo vo) {
		return userMapper.userView(vo);	
	}
	
	public int adminSave(UserVo vo) {
		return userMapper.userSave(vo);
	}
	
	public int adminModify(UserVo vo) {
		return userMapper.userModify(vo);
	}
	
	public int adminDelete(UserVo vo) {
		return userMapper.userDelete(vo);
	}
	
}
