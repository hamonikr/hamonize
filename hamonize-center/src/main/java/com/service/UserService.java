package com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.GlobalPropertySource;
import com.mapper.IOrgMapper;
import com.mapper.IUserMapper;
import com.model.OrgVo;
import com.model.UserVo;
import com.util.LDAPConnection;
import com.util.SHA256Util;

@Service
public class UserService {
	@Autowired
	GlobalPropertySource gs;
	
	@Autowired
	private IUserMapper userMapper;

	@Autowired
	private IOrgMapper orgMapper;
	
	public List<UserVo> userList(UserVo vo){
		return userMapper.userList(vo);	
	}
	
	public UserVo userView(UserVo vo) {
		return userMapper.userView(vo);	
	}
	
	public int userSave(UserVo vo) {
		int result=0;
		LDAPConnection con = new LDAPConnection();
		String dn ="";
		String tmp ="";
		String host ="";
		String pw= vo.getPass_wd();
		OrgVo ovo = new OrgVo();

		vo.setPass_wd(SHA256Util.getEncrypt(vo.getPass_wd(), SHA256Util.generateSalt()));
		result = userMapper.userSave(vo);
		
		
		if (result ==1){
			System.out.println("db 저장 완료");
			ovo.setSeq(vo.getOrg_seq());
		
			tmp = orgMapper.orgView(ovo).getAll_org_nm();
			
			String[] p_array = tmp.split("\\|");
			for(int i=p_array.length-1;i>=0;i--){
				host +="."+ p_array[i];
				dn += ",ou="+p_array[i];
			}

			con.connection(gs.getLdapUrl(), gs.getLdapPassword());		
			vo.setPass_wd(pw);
			con.addUser(vo, dn, host);

		}else{
			System.out.println("db 저장 실패");

		}

		return result;			
	}
	
	public int userModify(UserVo vo) {
		System.out.println("=== userModify ===");
		int result = 0;
		String host="";
		String dn="";
		OrgVo ovo = new OrgVo();
		
		String tmpPw =vo.getPass_wd();

		System.out.println("변경하려는 유저의 seq : "+ vo.getSeq());
		UserVo oldVo = userMapper.getUserInfo(vo.getSeq());


		LDAPConnection con = new LDAPConnection();
		con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		
		System.out.println("old org seq : " + oldVo.getOrg_seq());		
		System.out.println("new org seq : " + vo.getOrg_seq());		


		if(oldVo.getOrg_seq() != vo.getOrg_seq()){
			System.out.println("-- 부서가 변경되는 경우 --");
			ovo = userMapper.getUserOrgPath(oldVo.getSeq());
			System.out.println("old ovo : "+ ovo.getAll_org_nm());			

		} else{
			System.out.println("-- 부서가 변경되지않는 경우 --");
			ovo = userMapper.getUserOrgPath(vo.getSeq());
			System.out.println("old ovo : "+ ovo.getAll_org_nm());

		}

		String[] p_array =ovo.getAll_org_nm().split("\\|");
		for(int i=p_array.length-1;i>=0;i--){
			host +="."+ p_array[i];
			dn += ",ou="+p_array[i];
		}	

		if(vo.getPass_wd() != null || vo.getPass_wd() != "") {
			vo.setPass_wd(SHA256Util.getEncrypt(vo.getPass_wd(), SHA256Util.generateSalt()));
		}		

		result = userMapper.userModify(vo);

		if(result==1){
			vo.setPass_wd(tmpPw);
			System.out.println("---수정 성공---");
			con.updateUser(oldVo, vo, dn, host);

		}else{
			System.out.println("---수정 실패---");

		}

		return result;
	}
	
	public int userDelete(List<UserVo> vo) {
		
		LDAPConnection con = new LDAPConnection();
		con.connection(gs.getLdapUrl(), gs.getLdapPassword());		

		for(int i=0 ; i<vo.size() ; i++){
			OrgVo ovo = new OrgVo();
			UserVo uvo = new UserVo();
			System.out.println(vo.get(i).getSeq());	
			ovo = userMapper.getUserOrgPath(vo.get(i).getSeq());
			uvo = userMapper.userView(vo.get(i));
			
			con.deleteUser(ovo,uvo);				
		}
		
		
		int result = userMapper.userDelete(vo);
		
		if(result>=1){
			System.out.println("삭제 성공");
			
		}else{
			System.out.println("삭제 실패");
		}

		return result;
	}
	
	public int userIdCheck(UserVo vo) {
		return userMapper.userIdCheck(vo);
	}

	public List<OrgVo> getOrgList(OrgVo vo){
		return orgMapper.orgList();
	};

	
}
