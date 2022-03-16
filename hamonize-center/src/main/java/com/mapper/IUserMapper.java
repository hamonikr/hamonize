package com.mapper;

import java.util.List;
import java.util.Map;

import com.model.OrgVo;
import com.model.UserVo;

public interface IUserMapper {
	
	public List<UserVo> userList(UserVo vo);
	
	public UserVo userView(UserVo vo);
	
	public int userSave(UserVo vo);
	
	public int userModify(UserVo vo);
	
	public int userDelete(List<UserVo> vo);

	public int userIdCheck(UserVo vo);

	public int countListInfo(UserVo vo);
	
	public List<Map<String, Object>> userListExcel(UserVo vo);

	public OrgVo getUserOrgPath(Long seq);

	public OrgVo getUserNewOrgPath(Long seq);

	public UserVo getUserInfo(Long seq);
	
}
