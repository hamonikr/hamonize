package com.mapper;

import java.util.List;

import com.model.OrgVo;

public interface IOrgMapper {
	

	public List<OrgVo> orgList(OrgVo orgvo);
	
	public List<OrgVo> orgList();
	
	public OrgVo orgView(OrgVo orgvo);
	
	public int orgSave(OrgVo orgvo);
	
	public int orgDelete(OrgVo orgvo);

	public OrgVo selectGroupInfo( OrgVo gvo );
	
	public OrgVo groupUpperCode(OrgVo gvo);
	
	public OrgVo groupNewUpperCode(OrgVo gvo);
	
	public OrgVo orgOldNm(OrgVo gvo);

	public OrgVo groupUpperCodeTemp();

	public OrgVo getSgbName(OrgVo gvo);
	
	public OrgVo getOrgLastSeq();
	
	public List<OrgVo> orgChoose();
}
