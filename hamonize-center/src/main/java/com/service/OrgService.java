package com.service;

import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.GlobalPropertySource;
import com.mapper.IOrgMapper;
import com.model.OrgVo;
import com.util.AdLdapUtils;
import com.util.LDAPConnection;

@Service
@Transactional(rollbackFor = RuntimeException.class)
public class OrgService {
	@Autowired
	GlobalPropertySource gs;
	
	@Autowired
	private IOrgMapper orgMapper;
	
	public JSONArray orgList(OrgVo orgvo){	
		List<OrgVo> orglist = null;
		JSONArray jsonArray = new JSONArray();
		
		try {
			orglist = orgMapper.orgList(orgvo);
			for (int i = 0; i < orglist.size(); i++) {	 
	            JSONObject data = new JSONObject();
	            data.put("seq", orglist.get(i).getSeq());
	            data.put("p_seq", orglist.get(i).getP_seq());
	            data.put("org_nm", orglist.get(i).getOrg_nm());
	            data.put("org_ordr", orglist.get(i).getOrg_ordr());
	            data.put("section", orglist.get(i).getSection());
	            data.put("level", orglist.get(i).getLevel());
	            jsonArray.add(i, data);   
	 }
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return jsonArray;
		
	}
	
	public OrgVo orgView(OrgVo orgvo){	
		return orgMapper.orgView(orgvo);		
	}
	
	public int orgSave(OrgVo orgvo) {
		System.out.println("--- orgService > orgSave working--- ");
		//수정전 이름 불러오기
		OrgVo oldOrgVo = new OrgVo();
		OrgVo orgPath = new OrgVo();
		OrgVo newOrgPath = new OrgVo();
		
		if(orgvo.getSeq() != null) {
			oldOrgVo = orgMapper.orgOldNm(orgvo);
			orgPath = orgMapper.groupUpperCode(orgvo);
			newOrgPath = orgMapper.groupNewUpperCode(orgvo);
		}

		int result = orgMapper.orgSave(orgvo);
		System.out.println(" 저장 여부 result======"+result);
		
		//AdLdapUtils adUtils = new AdLdapUtils();
		LDAPConnection con = new LDAPConnection();
		con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		
		if(result == 1) {
			try {
				con.addOu(orgvo.getOrg_nm());
			} catch (Exception e) {
				e.printStackTrace();
			}
				// if("S".equals(orgvo.getSection()) ){
				// 	con.OuModify(getOrg_nm());
				// }
		}else if (result == 0){
			System.out.println("db 저장 실패");
		}

		// if(result == 1) {
		// 	OrgVo seqOrg = orgMapper.getOrgLastSeq();
		// 	OrgVo upGroupInfo = orgMapper.groupUpperCode(seqOrg);
			
		// 	//ldap
		// 	// try {
		// 	// 	adUtils.adOuCreate(upGroupInfo.getOrg_nm());
		// 	// } catch (Exception e) {
		// 	// 	e.printStackTrace();
		// 	// }
		// 	// 	if("S".equals(orgvo.getSection()) ){
		// 	// 		adUtils.sgbOuModify(upGroupInfo.getOrg_nm());
		// 	// 	}

		// }else if (result == 0) {
		// 	String oldOrgNm = oldOrgVo.getOrg_nm().replaceAll("/","").replaceAll("_","").replaceAll("[(]", "").replaceAll("[)]", "").replaceAll("\\+", "").replaceAll(" ", "");
		// 	String orgNm = orgvo.getOrg_nm().replaceAll("/","").replaceAll("_","").replaceAll("[(]", "").replaceAll("[)]", "").replaceAll("\\+", "").replaceAll(" ", "");
		// 	String oldOrgPath = orgPath.getOrg_nm();
		// 	String neworgPath = "OU="+orgNm+",";
			
		// 	neworgPath += newOrgPath.getOrg_nm();
			
		// 	System.out.println("neworgPath====="+neworgPath);
		// 	System.out.println("oldOrgPath====="+oldOrgPath);
			
		// 	//adUtils.ouRename(oldOrgNm, orgNm,oldOrgPath);
		// 	// try {
		// 	// 	adUtils.ouPathMove(oldOrgPath,neworgPath);
		// 	// } catch (Exception e) {
		// 	// 	e.printStackTrace();
		// 	// 	System.out.println("==========error===========");
		// 	// 	throw new RuntimeException(e);
		// 	// }
			
		// }
		
		return result;
		
	}
	
	public int orgDelete(OrgVo orgvo) throws Exception{
		//AdLdapUtils adUtils = new AdLdapUtils();
		OrgVo upGroupInfo = orgMapper.groupUpperCode(orgvo);
		String check = "";
		
		// ldap
		// try {
		// 	check = adUtils.ouDelete(orgvo.getOrg_nm());
		// }catch(Exception e) {
		// 	e.printStackTrace();
		// 	System.out.println("==========error===========");
		// 	throw new RuntimeException(e);
		// }
		
		int result = 0;
		
		result = orgMapper.orgDelete(orgvo);
		
		// if("noaction".equals(check)) {
		// 	return result;
		// }else {
		// 	result = orgMapper.orgDelete(orgvo);
		// }

		System.out.println("getorg_nm=-===="+orgvo.getOrg_nm());
		System.out.println("result====="+result);
		return result;
		
		
	}
	

}
