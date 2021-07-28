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

	public OrgVo getOrgName(OrgVo gvo);
	
	public OrgVo getOrgLastSeq();
	
	public List<OrgVo> orgChoose();

	// 하위 부서/팀 조회
	public List<OrgVo> searchChildDept(OrgVo gvo);
	
	// 하위 부서/팀 all_org_nm 업데이트
	public int allOrgNmUpdate(OrgVo gvo);

	public OrgVo getAllOrgNm(int seq);

    public int deleteChildUser(OrgVo orgVo);
}
