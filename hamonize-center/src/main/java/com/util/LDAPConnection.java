package com.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import javax.naming.AuthenticationException;
import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.BasicAttribute;
import javax.naming.directory.BasicAttributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.ModificationItem;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;

import com.model.OrgVo;
import com.model.PcMangrVo;
import com.model.UserVo;

public class LDAPConnection {
	private DirContext dc = null; 

	/* connection */

	/**
	 * ldap 서버에 connection
	 * @param url
	 * @param password
	 * @throws NamingException
	 */
	public void connection(String url, String password) throws NamingException{
        Properties env = new Properties();

		System.out.println("ldap url : " +url.trim());
		System.out.println("ldap password : " +password.trim());
		System.out.println("ldapAdminUser : " +"cn=admin,dc=hamonize,dc=com");
		
		env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, url.trim());
        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, "cn=admin,dc=hamonize,dc=com");
        env.put(Context.SECURITY_CREDENTIALS, password.trim());
        
		System.out.println("env---? " + env);    	
		
		try {
			dc = new InitialDirContext(env);
			System.out.println("success");
        } catch (AuthenticationException ex) {
			System.out.println(ex.getMessage());
		} catch (NamingException e) {
            e.printStackTrace();
        }
    }

	/* add */

	/**
	 * ldap 서버에 조직 추가
	 * @param vo
	 * @throws NamingException
	 */
	public void addOu(OrgVo vo) throws NamingException{

		String ouName = vo.getOrg_nm();
		Attributes attributes = new BasicAttributes();
		Attributes comAttributes = new BasicAttributes();

		Attribute attribute = new BasicAttribute("objectClass");
		String baseDn = "dc=hamonize,dc=com";
		String upperDn = "";

		
		String str = vo.getAll_org_nm();
		String[] p_array = str.split("\\|");
		
		if(p_array.length > 1){
				for(int i=p_array.length-1;i>=0;i--) {
					System.out.println(p_array[i]);
					upperDn += "ou="+p_array[i]+",";
				}
		
			baseDn = ","+upperDn+baseDn;

		}else{ //최상위 회사와 그다음 부서
			if(vo.getP_seq()==1){
				System.out.println("ccc : " +vo.getP_seq());
				// 최상위 부서 바로 다음 부서
				String subStr [] = vo.getP_org_nm().split("\\ -");
				upperDn = "ou="+subStr[0]+",";
				baseDn = ","+upperDn + baseDn;

			} else{
				baseDn = ",dc=hamonize,dc=com";
			}
			
		}

		String Dn = "ou="+ouName+baseDn;
		System.out.println("Dn > "+ Dn);
		
		String DnCom = "ou=computers,"+Dn;
		String DnUser = "ou=users,"+Dn;

		attribute.add("top");
		attribute.add("organizationalUnit");
		attributes.put(attribute);
		attributes.put("ou", ouName);
		
		comAttributes.put(attribute);		
		comAttributes.put("description", ouName+" computers");

		try {
			dc.createSubcontext(Dn, attributes);
			dc.createSubcontext(DnCom, comAttributes);
			dc.createSubcontext(DnUser, attributes);

			System.out.println("success");
		} catch (NamingException e) {
			System.out.println("fail");
			e.printStackTrace();
		}

	}

	/**
	 * ldap 서버에 유저 정보 추가
	 * @param vo
	 * @param dn
	 * @param host
	 * @throws NamingException
	 */
	public void addUser(UserVo vo, String dn, String host) throws NamingException{
		String addUser = "";
		Attributes attributes = new BasicAttributes();
		Attribute attribute = new BasicAttribute("objectclass","top");
		
		attribute.add("shadowAccount");
		attribute.add("posixAccount");
		attribute.add("account");
		attributes.put(attribute);
		host = vo.getUser_name()+host;

		// user details
		attributes.put("cn", vo.getUser_name());
		attributes.put("gidNumber", vo.getOrg_seq().toString());
		attributes.put("homeDirectory", "/home/"+vo.getUser_name());
		attributes.put("host", host);
		attributes.put("loginShell", "/bin/bash");	
		attributes.put("userPassword", vo.getPass_wd());	
		attributes.put("uidNumber", vo.getUser_sabun().toString());	
	
		addUser = "uid="+vo.getUser_name()+",ou=users"+dn+",dc=hamonize,dc=com";
		
		try {
			dc.createSubcontext(addUser, attributes);
			System.out.println("success");
		} catch (NamingException e) {
			e.printStackTrace();
		}

	}

	/**
	 * ldap 서버에 pc 정보 추가
	 * @param pvo
	 * @param uvo
	 * @throws NamingException
	 */
	public void addPC(PcMangrVo pvo, UserVo uvo) throws NamingException{
		Attributes attributes = new BasicAttributes();
		Attribute attribute = new BasicAttribute("objectClass","ipHost");
		String dn ="";
		String cn ="";

		String upperDn="";
		String str = pvo.getAlldeptname();

		String[] p_array = str.split("\\|");
		for(int i= p_array.length-1; i>=0 ;i--){
			System.out.println(p_array[i]);
			upperDn += ",ou="+p_array[i];
			cn += "."+p_array[i];
		}

		attribute.add("device");
		attribute.add("extensibleObject");
		attributes.put(attribute);
		
		attributes.put("cn", pvo.getPc_hostname());
		attributes.put("ipHostNumber", pvo.getPc_vpnip().toString()); 
		attributes.put("name", pvo.getPc_hostname());	
		
		dn = "cn="+pvo.getPc_hostname()+",ou=computers"+upperDn+",dc=hamonize,dc=com";

		try {
			dc.createSubcontext(dn, attributes);
			System.out.println("success");
		} catch (NamingException e) {
			e.printStackTrace();
		}

	}

	/* delete */

	/**
	 * ldap 서버에 조직 정보 삭제
	 * @param vo
	 * @throws NamingException
	 */
	public void deleteOu(OrgVo vo) throws NamingException{
		System.out.println("delete ou all name : " + vo.getAll_org_nm());
		String baseDn = "dc=hamonize,dc=com";
		String upperDn = "";

		
		String str = vo.getAll_org_nm();
		System.out.println("str : "+ str.trim());
		
		String[] p_array = str.split("\\|");
		System.out.println("array.length > "+p_array.length);
		System.out.println("vo.getOrg_nm() : " +vo.getOrg_nm());
	
		if(str.length() > 0){
			// 최상위 ou가 아닌경우
			for(int i=p_array.length-1;i>=0;i--) {
				System.out.println(p_array[i]);
				upperDn += "ou="+p_array[i]+",";
			}
			baseDn = upperDn + baseDn;
	
		} else{ // 최상위 ou 
			System.out.println("최상위인 경우 : " +vo.getOrg_nm());

			baseDn = "ou="+vo.getOrg_nm()+",dc=hamonize,dc=com";
		}
		
		System.out.println("baseDn : "+ baseDn);

		// 하위 엔트리 조회
		String searchFilter = "(&(objectClass=*))";
		SearchControls controls = new SearchControls();
		controls.setSearchScope(SearchControls.SUBTREE_SCOPE);

		NamingEnumeration depts = dc.search(baseDn, searchFilter, controls);
		SearchResult result = null;	
		
		List<String> delDn = new ArrayList<>();
	
		while (depts.hasMore()) {
			result = (SearchResult) depts.next();
			System.out.println(result.getNameInNamespace());
			delDn.add(result.getNameInNamespace());
		}

		// 하위 엔트리가 있다면 엔트리들까지 삭제
		try {

			for(int i=delDn.size()-1; i>=0 ; i--){
				System.out.println("delDn : " +delDn.get(i));
				dc.destroySubcontext(delDn.get(i));
			}
			
			System.out.println("success");
		} catch (NamingException e) {
			e.printStackTrace();
		}
			
	}
	

	public void deleteUser(OrgVo ovo, UserVo uvo) throws NamingException{
		System.out.println("cn : "+ uvo.getUser_name());
		System.out.println("All_org_nm : "+ ovo.getAll_org_nm());
		
		String baseDn = ",dc=hamonize,dc=com";
		String upperDn = "";


		String str = ovo.getAll_org_nm();
		System.out.println("str : "+ str.trim());
		
		String[] p_array = str.split("\\|");

		for(int i=p_array.length-1;i>=0;i--){
			System.out.println("p_array " + p_array[i]);
			upperDn += ",ou="+p_array[i];
		}

		baseDn = upperDn+baseDn;		
		String dn = "uid="+uvo.getUser_name()+",ou=users"+baseDn; 
		System.out.println("dn : " +dn);
		
		
		try {
			dc.destroySubcontext(dn);
			System.out.println("success---");
		} catch (NamingException e) {
			System.out.println("fail---");			
			e.printStackTrace();
		}
	}

	/* update */

	/**
	 * ldap 서버에 조직이름 업데이트
	 * @param oldVo
	 * @param newVo
	 * @throws NamingException
	 */
	public void updateOu(OrgVo oldVo, OrgVo newVo) throws NamingException{
		String baseDn = "dc=hamonize,dc=com";
		String upperDn = "";
		
		String newDn = "";
		String oldDn = "";

		System.out.println("old ou" + oldVo.getOrg_nm());
		System.out.println("new ou" + newVo.getOrg_nm());
		System.out.println("update all ou : " + newVo.getAll_org_nm());


		String str = newVo.getAll_org_nm().trim();
		System.out.println("str : "+ str);
		
		String[] p_array = str.split("\\|");

		if(oldVo.getOrg_nm() != newVo.getOrg_nm()){
			if(p_array.length > 0){// 최상위 ou가 아닌경우
				for(int i=p_array.length-2;i>=0;i--) {
					System.out.println(p_array[i]);
					upperDn += "ou="+p_array[i]+",";
				}

				oldDn = "ou="+oldVo.getOrg_nm()+","+upperDn +baseDn;
				newDn = "ou="+newVo.getOrg_nm()+","+upperDn +baseDn; 

			} else{ // 최상위 ou 
				newDn = "ou="+newVo.getOrg_nm()+",dc=hamonize,dc=com";
			}
			
			try {
					dc.rename(oldDn,newDn);
					System.out.println("success");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else{
			System.out.println("업데이트할 사항 없음!");
		}
	}

	public void updateUser(UserVo oldVo, UserVo newVo, String oDn,String nDn, String host){
		String oldDn="";
		String newDn="";

		host = newVo.getUser_name()+host;

		ModificationItem[] mods = new ModificationItem[6];

		Attribute mod1 = new BasicAttribute("gidNumber", newVo.getOrg_seq().toString());
		Attribute mod2 = new BasicAttribute("homeDirectory", "/home/"+newVo.getUser_name());
		Attribute mod3 = new BasicAttribute("host", host);
		Attribute mod4 = new BasicAttribute("userPassword", newVo.getPass_wd());
		Attribute mod5 = new BasicAttribute("uidNumber", newVo.getUser_sabun());
		Attribute mod6 = new BasicAttribute("cn", newVo.getUser_name());

		mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod1);
		mods[1] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod2);
		mods[2] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod3);
		mods[3] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod4);
		mods[4] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod5);
		mods[5] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod6);

		if(oldVo.getOrg_seq() != newVo.getOrg_seq() ){
			newDn="uid="+newVo.getUser_name()+",ou=users"+nDn+",dc=hamonize,dc=com";
			oldDn = "uid="+oldVo.getUser_name()+",ou=users"+oDn+",dc=hamonize,dc=com";
		}else{
			newDn="uid="+newVo.getUser_name()+",ou=users"+oDn+",dc=hamonize,dc=com";
			oldDn = "uid="+oldVo.getUser_name()+",ou=users"+oDn+",dc=hamonize,dc=com";
		}

		
		try {
			
			dc.modifyAttributes(oldDn, mods);
			dc.rename(oldDn, newDn);

		} catch (NamingException e) {
			e.printStackTrace();
		}


	}

	/**
	 * ldap 서버에 pc hostname 업데이트
	 * @param oldVo
	 * @param newVo
	 */
	public void updatePc(PcMangrVo oldVo, PcMangrVo newVo){
		String oldDn="";	
		String newDn="";	
		String upperDn="";

		ModificationItem[] mods = new ModificationItem[1];
		Attribute mod = new BasicAttribute("name", newVo.getPc_hostname());
		
		mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod);
		
		String str = oldVo.getAlldeptname();

		String[] p_array = str.split("\\|");
		for(int i= p_array.length-1; i>=0 ;i--){
			System.out.println(p_array[i]);
			upperDn += ",ou="+p_array[i];
		}

		oldDn = "cn="+oldVo.getPc_hostname()+",ou=computers"+upperDn+",dc=hamonize,dc=com";
		newDn = "cn="+newVo.getPc_hostname()+",ou=computers"+upperDn+",dc=hamonize,dc=com";


		try {
			
			dc.modifyAttributes(oldDn, mods);
			dc.rename(oldDn, newDn);

		} catch (NamingException e) {
			e.printStackTrace();
		}


	}

	/**
	 * ldap 서버에 pc vpn ip 업데이트
	 * @param pvo
	 */
	public void updatePcVpn(PcMangrVo pvo){
		String dn="";
		String upperDn="";
		ModificationItem[] mods = new ModificationItem[1];

		Attribute mod = new BasicAttribute("ipHostNumber", pvo.getPc_vpnip().toString());
		mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod);
		
		String str = pvo.getAlldeptname();

		String[] p_array = str.split("\\|");
		for(int i= p_array.length-1; i>=0 ;i--){
			System.out.println(p_array[i]);
			upperDn += ",ou="+p_array[i];
		}

		dn = "cn="+pvo.getPc_hostname()+",ou=computers"+upperDn+",dc=hamonize,dc=com";

		try {
			
			dc.modifyAttributes(dn, mods);
	
		} catch (NamingException e) {
			e.printStackTrace();
		}


	}

}

