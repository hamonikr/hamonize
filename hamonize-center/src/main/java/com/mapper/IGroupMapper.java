package com.mapper;

import java.util.List;

import com.model.GroupVo;

public interface IGroupMapper {
	public GroupVo[] groupList(GroupVo gvo);

	public String groupOrgcodeCheck(String orgcode);

	public GroupVo groupUpperCode(GroupVo gvo);

	public int groupInsert(GroupVo vo);

	public int groupDelete(GroupVo vo) throws Exception;
	
	public int groupSelectDelete(GroupVo vo) throws Exception;
	
	public GroupVo groupChk(GroupVo vo);

	public List<GroupVo> groupSgbList( GroupVo gvo );
	
	public GroupVo selectGroupInfo( GroupVo gvo );
}
