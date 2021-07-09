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
import com.model.UserVo;

public class LDAPConnection {
	private DirContext dc = null; 

	public static void main(String url, String password) throws NamingException {
		LDAPConnection con = new LDAPConnection();
		con.connection(url, password);
	}
	
	/* connection */

    public void connection(String url, String password){
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

	/* search */

    public void searchUsers() throws NamingException {
        String searchFilter = "(&(objectClass=inetOrgPerson))";
		String[] reqAtt = { "cn", "sn","employeeNumber" };
		
		SearchControls controls = new SearchControls();
		controls.setSearchScope(SearchControls.SUBTREE_SCOPE);
		controls.setReturningAttributes(reqAtt);

		NamingEnumeration users = dc.search("o=tesCom,dc=hamonize,dc=com", searchFilter, controls);

		SearchResult result = null;
		while (users.hasMore()) {
			result = (SearchResult) users.next();
			Attributes attr = result.getAttributes();
			String name = attr.get("cn").get(0).toString();

			System.out.println(result.getNameInNamespace());
			System.out.println(attr.get("cn"));
			System.out.println(attr.get("sn"));
			System.out.println(attr.get("employeeNumber"));
		}

	}

    public void searchGroups() throws NamingException {
	    String searchFilter = "(&(objectClass=organizationalUnit))";
		String[] reqAtt = { "ou" };
	
		SearchControls controls = new SearchControls();
		controls.setSearchScope(SearchControls.SUBTREE_SCOPE);
		controls.setReturningAttributes(reqAtt);

		NamingEnumeration depts = dc.search("dc=hamonize,dc=com", searchFilter, controls);
		SearchResult result = null;
		while (depts.hasMore()) {
			result = (SearchResult) depts.next();
			Attributes attr = result.getAttributes();
			String name = attr.get("ou").get(0).toString();
			System.out.println(result.getNameInNamespace());
			System.out.println(attr.get("ou"));
		}

	}

    public void getAllUsers() throws NamingException {
		String searchFilter = "(objectClass=inetOrgPerson)";
		String[] reqAtt = { "cn", "sn" };
		SearchControls controls = new SearchControls();
		controls.setSearchScope(SearchControls.SUBTREE_SCOPE);
		controls.setReturningAttributes(reqAtt);

		NamingEnumeration users = dc.search("o=tesCom,dc=hamonize,dc=com", searchFilter, controls);

		SearchResult result = null;
		while (users.hasMore()) {
			result = (SearchResult) users.next();
			Attributes attr = result.getAttributes();
			String name = attr.get("cn").get(0).toString();
			System.out.println(result.getNameInNamespace());
			System.out.println(attr.get("cn"));
			System.out.println(attr.get("sn"));
			System.out.println("----------------------");
		}

	}

	/* add */
	public void addOu(OrgVo vo) {

		String ouName = vo.getOrg_nm();
		System.out.println("ouName======" + ouName);
		Attributes attributes = new BasicAttributes();
		Attributes comAttributes = new BasicAttributes();

		Attribute attribute = new BasicAttribute("objectClass");
		String baseDn = "dc=hamonize,dc=com";
		String upperDn = "";

		
		String str = vo.getAll_org_nm();
		System.out.println("str : "+ str.trim());
		
		String[] p_array = str.split("\\|");
		System.out.println("array.length > "+p_array.length);
		System.out.println("str.length() > "+ str.length());
		
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
				System.out.println("upperDn : "+upperDn);
				baseDn = ","+upperDn + baseDn;

			} else{
				System.out.println("aaaa : "+vo.getP_seq());
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


	public void addUser(UserVo vo, String dn, String host) {
		String addUser = "";
		Attributes attributes = new BasicAttributes();
		Attribute attribute = new BasicAttribute("objectclass","top");
		
		attribute.add("shadowAccount");
		attribute.add("posixAccount");
		attribute.add("account");
		attributes.put(attribute);

		System.out.println("dn : "+ dn);

		host = vo.getUser_name()+host;
		System.out.println("host : "+host);
	
		// user details
		attributes.put("cn", vo.getUser_name());
		attributes.put("gidNumber", vo.getOrg_seq().toString());
		attributes.put("homeDirectory", "/home/"+vo.getUser_name());
		attributes.put("host", host);
		attributes.put("loginShell", "/bin/bash");	
		attributes.put("userPassword", vo.getPass_wd());	
		attributes.put("uidNumber", vo.getUser_sabun().toString());	
		attributes.put("uid", vo.getUser_name());	

		addUser = "cn="+vo.getUser_name()+",ou=users"+dn+",dc=hamonize,dc=com";
		
		try {
			dc.createSubcontext(addUser, attributes);
			System.out.println("success");
		} catch (NamingException e) {
			e.printStackTrace();
		}

	}

	/* delete */
	
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
		System.out.println("\n---하위 엔트리 조회---");

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
	

	public void deleteUser(OrgVo ovo, UserVo uvo){
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
		String dn = "cn="+uvo.getUser_name()+",ou=users"+baseDn; 
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

	public void updateOu(OrgVo oldVo, OrgVo newVo){
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
			} catch (NamingException e) {
				e.printStackTrace();
			}
		}else{
			System.out.println("업데이트할 사항 없음!");
		}
	}

	public void updateUser(UserVo oldVo, UserVo newVo, String dn, String host){
		String addUser="";
		host = newVo.getUser_name()+host;
		System.out.println("host : "+host);

		System.out.println("old org : " +oldVo.getOrg_seq());
		System.out.println("new org : " +newVo.getOrg_seq());

		if(oldVo.getOrg_seq() != newVo.getOrg_seq() ){
			System.out.println("--부서 위치 변경하는 경우---");

		}else{
			System.out.println("--부서 위치 변경하는 경우---");

		}

		ModificationItem[] mods = new ModificationItem[7];

		Attribute mod0 = new BasicAttribute("cn", newVo.getUser_name());
		Attribute mod1 = new BasicAttribute("gidNumber", newVo.getOrg_seq().toString());
		Attribute mod2 = new BasicAttribute("homeDirectory", "/home/"+newVo.getUser_name());
		Attribute mod3 = new BasicAttribute("host", host);
		Attribute mod4 = new BasicAttribute("userPassword", newVo.getPass_wd());
		Attribute mod5 = new BasicAttribute("uidNumber", newVo.getUser_sabun());
		Attribute mod6 = new BasicAttribute("uid", newVo.getUser_name());

		mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod0);
		mods[1] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod1);
		mods[2] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod2);
		mods[3] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod3);
		mods[4] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod4);
		mods[5] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod5);
		mods[6] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, mod6);

		addUser = "cn="+oldVo.getUser_name()+",ou=users"+dn+",dc=hamonize,dc=com";

		try {
			dc.modifyAttributes(addUser, mods);
		} catch (NamingException e) {
			e.printStackTrace();
		}




	}


}