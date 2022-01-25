package com.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mapper.IAdminMapper;
import com.model.AdminVo;

@Service
public class AdminService {
	
	@Autowired
	private IAdminMapper adminMapper;
	
	//센터 관리자
	public List<AdminVo> adminList(AdminVo vo){
		return adminMapper.adminList(vo);	
	}
	
	public int countListInfo(AdminVo vo) {
		return adminMapper.countListInfo(vo);
	}
	
	public AdminVo adminView(AdminVo vo) {
		return adminMapper.adminView(vo);	
	}
	
	public int adminSave(AdminVo vo) {
		return adminMapper.adminSave(vo);
	}
	
	public int adminModify(AdminVo vo) {
		return adminMapper.adminModify(vo);
	}
	
	public int adminDelete(AdminVo vo) {
		return adminMapper.adminDelete(vo);
	}
	
	public int adminIdCheck(AdminVo vo) {
		return adminMapper.adminIdCheck(vo);
	}

	public int adminPasswordCheck(AdminVo vo) {
		return adminMapper.adminPasswordCheck(vo);
	}
	//사지방 관리자
	public List<AdminVo> sgbManagerList(AdminVo vo){
		return adminMapper.sgbManagerList(vo);	
	}
	
}
