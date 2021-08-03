package com.mapper;

import java.util.List;

import com.model.AdminVo;

public interface IAdminMapper {
	//센터 관리자
	public List<AdminVo> adminList(AdminVo vo);
	
	public int countListInfo(AdminVo vo);
	
	public AdminVo adminView(AdminVo vo);
	
	public int adminSave(AdminVo vo);
	
	public int adminModify(AdminVo vo);
	
	public int adminDelete(AdminVo vo);
	
	public int adminIdCheck(AdminVo vo);
	
	
	//사지방 관리자
	public List<AdminVo> sgbManagerList(AdminVo vo);
	
	public int sgbManagercountListInfo(AdminVo vo);
	
	public AdminVo sgbManagerView(AdminVo vo);
	
	public int sgbManagerSave(AdminVo vo);
	
	public int sgbManagerOrgSeq(AdminVo vo);
	
	public int sgbManagerModify(AdminVo vo);
	
	public int sgbManagerDelete(AdminVo vo);
	
	public int sgbManagerIdCheck(AdminVo vo);

}
