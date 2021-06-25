package com.service;

import javax.transaction.Transactional;

import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IGroupMapper;
import com.model.GroupVo;
import com.util.AdLdapUtils;
import com.util.Constant;
import com.util.StringUtil;




@Service
public class GroupService {
	
	@Autowired
	private IGroupMapper groupMapper;


	/**
	 *  조직관리 페이지
	 * @return jsonGroupList
	 * @throws ParseException 
	 */
	public JSONArray groupList( GroupVo gvo ) throws ParseException {

		JSONArray jsonArray = new JSONArray();
		GroupVo[] groupList = null;
		Object jObj = null;
		
		// 리스트
		groupList = groupMapper.groupList(gvo);
		
		
		
		// 조직이 없는경우
		if(null == groupList) {
			return jsonArray;
		}
		
		// json 으로 만들기 위한 String
		String jsonStr = "{";
		int step = 0;
		
		for(int i = 0; i<groupList.length ;++i) {
				if(i != 0) {
					// 처음이 아닌경우 실행
					if(step < groupList[i].getOrgstep()) {
						// 하위그룹이 있는 경우
						jsonStr += ", \"children\" : [{";
						step = groupList[i].getOrgstep();
					}else {
						// 하위그룹이 없는 경우
						int calcStep = step - groupList[i].getOrgstep();
						jsonStr += "}";
						for(int k=0;k<calcStep;++k) {
							jsonStr += "]}";
						}
						jsonStr += ", {";
						// 마지막 데이터인지 확인
						step = groupList[i].getOrgstep(); 
					}
	
				}
				
				// 데이터
				jsonStr += "\"text\" : \"" + groupList[i].getOrgname() + "\"";
				jsonStr += ", \"code\" : \"" + groupList[i].getOrgcode() + "\"";
				jsonStr += ", \"uppercode\" : \"" + groupList[i].getOrguppercode() + "\"";
				jsonStr += ", \"step\" : \"" + groupList[i].getOrgstep() + "\"";	
				jsonStr += ", \"seq\" : \"" + groupList[i].getOrg_seq() + "\"";	
				
				
				String chkGroupGubun = StringUtil.isNull(groupList[i].getGroup_gubun(), groupList[i].getGroup_gubun());
				if( chkGroupGubun != null ){
					jsonStr += ", \"groupgubun\" : \"[" + chkGroupGubun + "]\"";	
				}
				
			}
//		}
		
		// 괄호 닫기
		int calcStep = groupList[groupList.length-1].getOrgstep() - 1;
		jsonStr += "}";
		for(int k=0;k<calcStep;++k) {
			jsonStr += "]}";
		}
		
		// json 변환
		JSONParser parser = new JSONParser(); 
		
		jObj = parser.parse(jsonStr);
		
		jsonArray.add(jObj);
		
		
		return jsonArray;
	}

	/*
	 * 조직등록
	 * @param reqVo.name
	 * @param reqVo.step
	 * @param reqVo.orguppercode
	 * @param reqVo.orgcode
	 * @return msg
	 */
	@Transactional
	public String groupInsert(GroupVo reqVo) throws Exception{
		String msg = "";
		String selectOrgcode = "";
		String[] codeStrArr = null;
		String reqOrgcode = reqVo.getOrgcode();
		
		// 공백제거
		reqVo.setOrgcode(reqVo.getOrgcode().trim());
		reqVo.setOrguppercode(reqVo.getOrguppercode().trim());
		
		// 부모그룹의 orgcode로 orguppercode 를 검색하여 마지막 등록 숫자만 찾아옴
		selectOrgcode = groupMapper.groupOrgcodeCheck(reqOrgcode);
		
		if(null != selectOrgcode) {
			// 같은 선상에 등록된 부문이 있는 경우 마지막 부문의 코드를 가져온다
			codeStrArr = selectOrgcode.split("(?<!^)");
			
			for(int i=codeStrArr.length-1;i>=0;--i) {
				
				if( !("0").equals(codeStrArr[i]) ) {
					
					// 자리수 확인
					if(i % 2 == 1) {
						// ex - 01010'1'0000
						int codeAddNum = (Integer.parseInt(codeStrArr[i])+1);
						
						if(codeAddNum % 10 == 0) {
							// ex - 0101'09'0000 -> 0101'10'0000
							codeStrArr[i] = "0";
							codeStrArr[i-1] = Integer.toString(Integer.parseInt(codeStrArr[i-1]) + 1);
						} else {
							// ex - 01010'1'0000 -> 01010'2'0000
							codeStrArr[i] = Integer.toString(codeAddNum);
						}
						break;
					}else {
						// ex - 0101'1'00000
						int codeAddNum = (Integer.parseInt(codeStrArr[i+1])+1);
						
						if(codeAddNum % 10 == 0) {
							// ex - 01011'9'0000 -> 01011'10'0000 -> 0101'20'0000
							codeStrArr[i+1] = "0";
							codeStrArr[i] = Integer.toString(Integer.parseInt(codeStrArr[i]) + 1);
						} else {
							// ex - 01011'1'0000 -> 01011'2'0000
							codeStrArr[i+1] = Integer.toString(codeAddNum);
						}
						break;
					}
				}
			}
		}else {
			// 같은 선상에 등록된 부문이 없을 때
			codeStrArr = reqOrgcode.split("(?<!^)");
			
			for(int i=codeStrArr.length-1;i>=0;--i) {
				
				if( !("0").equals(codeStrArr[i]) ) {
					if(i % 2 == 1) {
						// ex - 0101000000 -> 0101010000
						codeStrArr[i+2] = Integer.toString(Integer.parseInt(codeStrArr[i+2]) + 1);
					}else{
						// ex - 011000000 -> 0110010000
						codeStrArr[i+3] = Integer.toString(Integer.parseInt(codeStrArr[i+3]) + 1);
					}
					break;
				}
			}
		}
		
		// orgcode value setting
		selectOrgcode = "";
		for(String str : codeStrArr) {
			selectOrgcode += str;
		}
		
		// value setting
		reqVo.setOrgcode(selectOrgcode);
		reqVo.setOrguppercode(reqOrgcode);
		reqVo.setOrgstep(reqVo.getOrgstep()+1);
		
		int insertCheck = groupMapper.groupInsert(reqVo);
		
		if(insertCheck == 1) {
			msg = Constant.Group.SUCCESS_CREATE;
			
			
//			create ad group 
			System.out.println("create===" + reqVo);
			GroupVo upGroupInfo = groupMapper.groupUpperCode(reqVo);
			System.out.println("upGroupInfo========"+upGroupInfo);
			AdLdapUtils adUtils = new AdLdapUtils();
			
			adUtils.adOuCreate(upGroupInfo.getOrgname());
			
			if( "sgb".equals(reqVo.getGroup_gubun()) ){
				adUtils.sgbOuModify(upGroupInfo.getOrgname());
			}
			System.out.println("upGroupInfo.getOrgname()====="+ upGroupInfo.getOrgname());

		}else {
			msg = Constant.Group.FAIL_CREATE;
		}
		return msg;
	}

	/*
	 * 조직삭제
	 * @param groupVo.orguppercode
	 * @param groupVo.orgcode
	 * @return msg
	 */
	@Transactional
	public String groupDelete(GroupVo  groupVo) {
		String msg = "";
		
		int deleteCheck  = 0;
		
		
		try {
			
			GroupVo chkGroupVo = groupMapper.groupChk(groupVo);
			
			String tmpGroupCode = groupVo.getOrgcode();
			int tmpGroupVal = groupVo.getOrgstep();
			
			tmpGroupCode = tmpGroupCode.substring(0, (2*tmpGroupVal));
			groupVo.setOrgcodeparsing(tmpGroupCode);
			
			// 하위조직 삭제
			if( chkGroupVo.getOrgUpCnt() > 0 ){
				deleteCheck = groupMapper.groupDelete(groupVo);
			}else{
				// 선택 조직 삭제
				deleteCheck = groupMapper.groupSelectDelete(groupVo);
			}
			
			msg = Constant.Group.SUCCESS_DELETE;
		} catch (Exception e) {
			e.printStackTrace();
			msg = Constant.Group.FAIL_DELETE;
		}

		return msg;
	}
}
