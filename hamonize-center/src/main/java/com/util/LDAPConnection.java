package com.util;

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

import com.model.LdapVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

public class LDAPConnection {

	@Autowired
	LdapVO ldap;
    // @Value("${ldap.ip}")
	// private String ldapUrl; 
	
	// @Value("${ldap.id}")
	// private String ldapAdminUser; 
	
	// @Value("${ldap.password}")
	// private String ldapAdminPasswd; 
	
	private DirContext dc = null; 
	
        public static void main() throws NamingException {
            LDAPConnection con = new LDAPConnection();
            con.connection();
            System.out.println("start--->");
            //con.searchUsers();
			System.out.println("\nou List");
			con.searchGroups();
            System.out.println("\n<---end");
        }

    public void connection(){
        Properties env = new Properties();
		
		System.out.println("ldap url : " +"ldap://10.8.0.6:389");
		System.out.println("ldapAdminUser : " +"cn=admin,dc=ldap,dc=hamonize,dc=com");
		System.out.println("ldapAdminPasswd : " +"exitem08");


        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, "ldap://10.8.0.6:389");
        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, "cn=admin,dc=ldap,dc=hamonize,dc=com");
        env.put(Context.SECURITY_CREDENTIALS, "exitem08");
        
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

    public void searchUsers() throws NamingException {
		//String searchFilter = "(uid=1)"; //  for one user
		//String searchFilter = "(&(uid=1)(cn=Smith))"; // and condition 
		//String searchFilter = "(|(uid=1)(uid=2)(cn=Smith))"; // or condition
        String searchFilter = "(&(objectClass=inetOrgPerson))";
		
		String[] reqAtt = { "cn", "sn","employeeNumber" };
		//String[] reqAtt = { "cn", "sn","uid" };
		
		SearchControls controls = new SearchControls();
		controls.setSearchScope(SearchControls.SUBTREE_SCOPE);
		controls.setReturningAttributes(reqAtt);

		NamingEnumeration users = dc.search("o=tesCom,dc=ldap,dc=hamonize,dc=com", searchFilter, controls);

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

//		NamingEnumeration depts = dc.search("o=tesCom,dc=ldap,dc=hamonize,dc=com", searchFilter, controls);
		NamingEnumeration depts = dc.search("dc=ldap,dc=hamonize,dc=com", searchFilter, controls);

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

		NamingEnumeration users = dc.search("o=tesCom,dc=ldap,dc=hamonize,dc=com", searchFilter, controls);

		SearchResult result = null;
		while (users.hasMore()) {
			result = (SearchResult) users.next();
			Attributes attr = result.getAttributes();
			String name = attr.get("cn").get(0).toString();
			System.out.println(result.getNameInNamespace());
			System.out.println(attr.get("cn"));
			System.out.println(attr.get("sn"));
		}

	}
	public  void addOu(String ouName) {
		System.out.println("ouName======" + ouName);
		Attributes attributes = new BasicAttributes();
		Attribute attribute = new BasicAttribute("objectClass");
		String baseDn = ",dc=ldap,dc=hamonize,dc=com";
		String Dn = "ou="+ouName+baseDn;
		attribute.add("top");
		attribute.add("organizationalUnit");
		attributes.put(attribute);
		attributes.put("ou", ouName);

		// ou details
		//attributes.put("ou", ouName);
		try {
			dc.createSubcontext(Dn, attributes);
			System.out.println("success");
		} catch (NamingException e) {
			System.out.println("fail");
			e.printStackTrace();
		}

		// try {

		// 	String username = ouName;

		// 	//String baseDn = ",DC=adserver,DC=invesume,DC=com";
		// 	String baseDn = AdLdapUtils.baseDn;
		// 	//String serverIP = "adserver.invesume.com";
		// 	String serverIP = AdLdapUtils.serverIP;

		// 	String distinguishedName = username + baseDn;
		// 	Attributes newAttributes = new BasicAttributes(true);
		// 	Attribute oc = new BasicAttribute("objectclass");
		// 	oc.add("top");
		// 	oc.add("organizationalUnit");
		// 	newAttributes.put(oc);
		// 	System.out.println("Name: " + username + " Attributes: " + oc);
		// 	ctx.createSubcontext(distinguishedName, newAttributes);

		// } catch (Exception exception) {
		// 	exception.printStackTrace();
		// }

	}


	public void addUser() {
		Attributes attributes = new BasicAttributes();
		Attribute attribute = new BasicAttribute("objectClass");
		attribute.add("inetOrgPerson");

		attributes.put(attribute);
		// user details
		attributes.put("sn", "Ricky");
		try {
			dc.createSubcontext("cn=Tommy,ou=users,ou=system", attributes);
			System.out.println("success");
		} catch (NamingException e) {
			e.printStackTrace();
		}

	}

	public void addUserToGroup(String username, String groupName)
	{
		ModificationItem[] mods = new ModificationItem[1];
		Attribute attribute = new BasicAttribute("uniqueMember","cn="+username+",ou=users,ou=system");
		mods[0] = new ModificationItem(DirContext.ADD_ATTRIBUTE, attribute);
		try {
			dc.modifyAttributes("cn="+groupName+",ou=groups,ou=system", mods);
			System.out.println("success");
		} catch (NamingException e) {
			e.printStackTrace();
		}
		
	}
	public void deleteUser()
	{
		try {
			dc.destroySubcontext("cn=Tommy,ou=users,ou=system");
			System.out.println("success");
		} catch (NamingException e) {
			e.printStackTrace();
		}
	}
	
	public void deleteUserFromGroup(String username, String groupName)
	{
		ModificationItem[] mods = new ModificationItem[1];
		Attribute attribute = new BasicAttribute("uniqueMember","cn="+username+",ou=users,ou=system");
		mods[0] = new ModificationItem(DirContext.REMOVE_ATTRIBUTE, attribute);
		try {
			dc.modifyAttributes("cn="+groupName+",ou=groups,ou=system", mods);
			System.out.println("success");
		} catch (NamingException e) {
			e.printStackTrace();
		}
		
	}

    /* use this to authenticate any existing user */
	public static boolean authUser(String username, String password)
	{
		try {
			Properties env = new Properties();
			env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
			env.put(Context.PROVIDER_URL, "ldap://localhost:10389");
			env.put(Context.SECURITY_PRINCIPAL, "cn="+username+",ou=users,ou=system");  //check the DN correctly
			env.put(Context.SECURITY_CREDENTIALS, password);
			DirContext con = new InitialDirContext(env);
			System.out.println("success");
			con.close();
			return true;
		}catch (Exception e) {
			System.out.println("failed: "+e.getMessage());
			return false;
		}
	}
	
	/* use this to update user password */
	public void updateUserPassword(String username, String password) {
		try {
			String dnBase=",ou=users,ou=system";
			ModificationItem[] mods= new ModificationItem[1];
			mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("userPassword", password));// if you want, then you can delete the old password and after that you can replace with new password 
			dc.modifyAttributes("cn="+username +dnBase, mods);//try to form DN dynamically
			System.out.println("success");
		}catch (Exception e) {
			System.out.println("failed: "+e.getMessage());
			
		}
	}
}