package com.util;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.BasicAttribute;
import javax.naming.directory.BasicAttributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.ModificationItem;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.InitialLdapContext;
import javax.naming.ldap.LdapContext;

import org.springframework.stereotype.Component;

@Component
public class AdLdapUtils{

	private LdapContext ctx = null;
	
	
	  //@Value("${ldap.ip}") private String ldapIp;
	  
	  //운영서버
	//   private static String searchBase = "dc=sgb,dc=skir,dc=kr";
	//   private static String baseDn = ",DC=sgb,DC=skir,DC=kr";
	//   private static String serverIP = "sgb.skir.kr";
	  //개발서버
	  private static String searchBase = "dc=adserver,dc=invesume,dc=com";
	  private static String baseDn = ",DC=adserver,DC=invesume,DC=com";
	  private static String serverIP = "adserver.invesume.com";
	 

	public void initAdConnection() throws Exception{

		try {

			String id = "administrator";
			String pw = "exitem0*!";
			//String pw = "9jg56JbCWnCU";
			String domain = "adserver.invesume.com";
			//String domain = "sgb.skir.kr";
			//String server = "LDAP://"+ldapIp+":389";
			String server = "LDAP://192.168.0.26:389";
			//String server = "LDAP://10.4.0.199:389"; 
			//String server = "LDAP://10.64.192.45:389";

			System.out.println("server=====" + server);
			Hashtable<String, String> env = new Hashtable<String, String>();

			env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
			env.put(Context.PROVIDER_URL, server);
			env.put(Context.SECURITY_AUTHENTICATION, "simple");
			env.put(Context.SECURITY_PRINCIPAL, id + "@" + domain);
			env.put(Context.SECURITY_CREDENTIALS, pw);
			env.put("java.naming.ldap.attributes.binary", "objectGUID");

			ctx = new InitialLdapContext(env, null);
			
			System.out.println("Connection Success!");
		} catch (NamingException e) {
			e.printStackTrace();
		}
	}

	public  String adComputerSearchUseCn(String ouName) throws Exception{
		System.out.println("adldaputil--adComputerSearchUseCn-" + ouName);
		String resultStr = "";
		try {

			initAdConnection();

			String _filterName = "*";
			String returnedAtts[] = { "cn" };

			//String searchBase = "dc=adserver,dc=invesume,dc=com";
			String searchBase = AdLdapUtils.searchBase ;
			String searchFilter = "(&(objectClass=computer)(cn=" + ouName + "))";

			// Create the search controls
			SearchControls searchCtls = new SearchControls();

			searchCtls.setReturningAttributes(returnedAtts);

			// Specify the search scope
			searchCtls.setSearchScope(SearchControls.SUBTREE_SCOPE);
			NamingEnumeration answer = ctx.search(searchBase, searchFilter, searchCtls);
			String chkOu = "";
			while (answer.hasMoreElements()) {
				SearchResult sr = (SearchResult) answer.next();
				System.out.println("adComputerSearchUseCn===" + sr);
				chkOu = sr.toString();
				Attributes attrs = sr.getAttributes();
			}

			String[] tmpOuSplit = chkOu.split(":");
			for (int i = 0; i < tmpOuSplit.length; i++) {
				System.out.println("tmpOuSplit=aaa==" + tmpOuSplit[i]);
			}

			resultStr = tmpOuSplit[0].toString();
		} catch (NamingException e) {
			System.out.println("Connection Fail!");
			e.printStackTrace();
			resultStr = "false";
		}

		return resultStr;
	}

	public  String adOuSearch(String ouName,String oldOrgPath) throws Exception{
		System.out.println("======adousearch========");
		String resultStr = "";
		try {

			initAdConnection();

			String _filterName = "*";
			String returnedAtts[] = { "cn", "description", "distinguishedName", "sn", "givenname", "mail",
					"telephonenumber", "lockoutThreshold", "lockoutDuration", "minPwdAge", "maxPwdAge", "minPwdLength",
					"pwdLastSet" };

			//String searchBase = "dc=adserver,dc=invesume,dc=com";
			String searchBase = AdLdapUtils.searchBase;
			String searchFilter = "(&(objectClass=organizationalunit)(ou=" + ouName + "))";	//	 
//			String searchFilter = "(&(objectClass=computer)(cn=" + ouName + "))";
			System.out.println("searchFilter====="+searchFilter);
			System.out.println("ouName======" + ouName); 
			// Create the search controls
			SearchControls searchCtls = new SearchControls();

			searchCtls.setReturningAttributes(returnedAtts);

			// Specify the search scope
			searchCtls.setSearchScope(SearchControls.SUBTREE_SCOPE);
			NamingEnumeration answer = ctx.search(searchBase, searchFilter, searchCtls);
			String chkOu = "";
			String chkOu2 = "";
			System.out.println("answerCNT===="+answer.toString().length());
			
			while (answer.hasMoreElements()) {
				String chOu="";
				SearchResult sr = (SearchResult) answer.next();
				chOu = sr.toString().split(":")[0];
				System.out.println("chOu====="+chOu);
				if(oldOrgPath.equals(chOu) || oldOrgPath == chOu) {
					chkOu = sr.toString();
				}
				
				chkOu2 = chOu;
				System.out.println("chkOu===="+chkOu);
				Attributes attrs = sr.getAttributes();
				Map amap = null;
			}
			
			String[] tmpOuSplit = chkOu.split(":");
//			for (int i = 0; i < tmpOuSplit.length; i++) {
//				System.out.println("adOuSearch]===" + tmpOuSplit[i]);
//			}
			//resultStr = tmpOuSplit[0].toString();
			resultStr = chkOu2;
			System.out.println("resultStr===="+resultStr);

		} catch (NamingException e) {
			System.out.println("Connection Fail!");
			e.printStackTrace();
			resultStr = "false";
		}

		return resultStr;
	}

	public  void adOuCreate(String ouName) throws Exception{

		System.out.println("ouName======" + ouName);
		initAdConnection();

		try {

			String username = ouName;

			//String baseDn = ",DC=adserver,DC=invesume,DC=com";
			String baseDn = AdLdapUtils.baseDn;
			//String serverIP = "adserver.invesume.com";
			String serverIP = AdLdapUtils.serverIP;

			String distinguishedName = username + baseDn;
			Attributes newAttributes = new BasicAttributes(true);
			Attribute oc = new BasicAttribute("objectclass");
			oc.add("top");
			oc.add("organizationalUnit");
			newAttributes.put(oc);
			System.out.println("Name: " + username + " Attributes: " + oc);
			ctx.createSubcontext(distinguishedName, newAttributes);

		} catch (Exception exception) {
			exception.printStackTrace();
		}

	}

	public  String adComputerSearch(String ouName) throws Exception{
		String resultStr = "";
		try {

			initAdConnection();

			String _filterName = "*";
			String returnedAtts[] = { "cn", "description", "distinguishedName", "sn", "givenname", "mail",
					"telephonenumber", "lockoutThreshold", "lockoutDuration", "minPwdAge", "maxPwdAge", "minPwdLength",
					"pwdLastSet", "macaddress", "objectguid", "objectSid" };

			//String searchBase = ouName + ",dc=adserver,dc=invesume,dc=com";
			String searchBase = ouName + AdLdapUtils.baseDn;
//			String searchFilter = "(&(objectClass=Computer)(" + ouName + "))";
			String searchFilter = "(&(objectClass=Computer)(sAMAccountName=" + _filterName + "))";

			// Create the search controls
			SearchControls searchCtls = new SearchControls();

			searchCtls.setReturningAttributes(returnedAtts);

			// Specify the search scope
			searchCtls.setSearchScope(SearchControls.SUBTREE_SCOPE);
			NamingEnumeration answer = ctx.search(searchBase, searchFilter, searchCtls);
			String chkOu = "";
			while (answer.hasMoreElements()) {
				SearchResult sr = (SearchResult) answer.next();
				chkOu = sr.toString();
				Attributes attrs = sr.getAttributes();

				byte[] GUID = (byte[]) attrs.get("objectGUID").get();
				String strGUID = "";
				String byteGUID = "";
				/*
				 * for (int c = 0; c < GUID.length; c++) { byteGUID = byteGUID + "\\" +
				 * AddLeadingZero((int) GUID[c] & 0xFF); }
				 */

				strGUID = "{";
				strGUID = strGUID + AddLeadingZero((int) GUID[3] & 0xFF);
				strGUID = strGUID + AddLeadingZero((int) GUID[2] & 0xFF);
				strGUID = strGUID + AddLeadingZero((int) GUID[1] & 0xFF);
				strGUID = strGUID + AddLeadingZero((int) GUID[0] & 0xFF);
				strGUID = strGUID + "-";
				strGUID = strGUID + AddLeadingZero((int) GUID[5] & 0xFF);
				strGUID = strGUID + AddLeadingZero((int) GUID[4] & 0xFF);
				strGUID = strGUID + "-";
				strGUID = strGUID + AddLeadingZero((int) GUID[7] & 0xFF);
				strGUID = strGUID + AddLeadingZero((int) GUID[6] & 0xFF);
				strGUID = strGUID + "-";
				strGUID = strGUID + AddLeadingZero((int) GUID[8] & 0xFF);
				strGUID = strGUID + AddLeadingZero((int) GUID[9] & 0xFF);
				strGUID = strGUID + "-";
				strGUID = strGUID + AddLeadingZero((int) GUID[10] & 0xFF);
				strGUID = strGUID + AddLeadingZero((int) GUID[11] & 0xFF);
				strGUID = strGUID + AddLeadingZero((int) GUID[12] & 0xFF);
				strGUID = strGUID + AddLeadingZero((int) GUID[13] & 0xFF);
				strGUID = strGUID + AddLeadingZero((int) GUID[14] & 0xFF);
				strGUID = strGUID + AddLeadingZero((int) GUID[15] & 0xFF);
				strGUID = strGUID + "}";
//                System.out.println("GUID (String format): " + strGUID); 
//                System.out.println("GUID (Byte format): " + byteGUID); 

				NamingEnumeration<? extends Attribute> enume = attrs.getAll();
//				LinkedHashMap<String, String> elements = new LinkedHashMap<String, String>();

				while (enume.hasMore()) {
					Attribute attribute = enume.next();
					NamingEnumeration<?> all = attribute.getAll();
					while (all.hasMore()) {
						Object key = all.next();
						String value = null;
						if (key instanceof byte[]) {
							value = new String((byte[]) key, "UTF-8");
						} else {
							value = key.toString();
						}

					}
				}
			}
			resultStr = chkOu;
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			System.out.println("Connection Fail!");
			e.printStackTrace();
			resultStr = "false";
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return resultStr;
	}

	 String AddLeadingZero(int k) {
		return (k <= 0xF) ? "0" + Integer.toHexString(k) : Integer.toHexString(k);
	}

	public  boolean computerModify(String ouNM, String cnNM, String macAddr) {
		boolean flag = false;
		try {

			initAdConnection();

			System.out.println("computerModify..\n\n\n\n");
			//String baseName = ",DC=adserver,DC=invesume,DC=com";
			String baseName = AdLdapUtils.baseDn;

			ModificationItem[] mods = new ModificationItem[1];
			mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("macAddress", macAddr));
			System.out.println("ouNM==="+ouNM);
			System.out.println("cnNM==="+cnNM);
			System.out.println("macaddr==="+macAddr);
//			mods[1] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("co", "room"));

//			ctx.modifyAttributes("cn=" + "TEST04VB" + baseName, mods);
			System.out.println("computerModify :ouNM + baseName==="+ ouNM + baseName);
			ctx.modifyAttributes(ouNM + baseName, mods);
			flag = true;
		} catch (Exception e) {
			System.out.println("computerModify error: " + e);
			flag = false;
		}
		return flag;
	}

	public  boolean sgbOuModify(String ouNM) {
		boolean flag = false;
		try {

			initAdConnection();

			System.out.println("computerModify..\n\n\n\n");
			//String baseName = ",DC=adserver,DC=invesume,DC=com";
			String baseName = AdLdapUtils.baseDn;

			ModificationItem[] mods = new ModificationItem[1];
			mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("co", "room"));

			ctx.modifyAttributes(ouNM + baseName, mods);
			flag = true;
		} catch (Exception e) {
			System.out.println("computerModify error: " + e);
			flag = false;
		}
		return flag;
	}

	// 컴퓨터 이름 변경
	public  void computerRename(String oldName, String newName) throws Exception{

		initAdConnection();

		String retOU = adComputerSearchUseCn(oldName);
		String newComputerName = retOU.replace(oldName, newName);

		try {

			String username = oldName;

			//String baseDn = ",DC=adserver,DC=invesume,DC=com";
			String baseDn = AdLdapUtils.baseDn;
			//String serverIP = "adserver.invesume.com";
			String serverIP = AdLdapUtils.serverIP;
			String distinguishedName = username + baseDn;

			ctx.rename(retOU + baseDn, newComputerName + baseDn);
		} catch (Exception exception) {
			exception.printStackTrace();
		}

	}
	
	// ou name change
	public  void ouRename(String oldName, String newName, String oldOrgPath) throws Exception{

		initAdConnection();

		String ouOldName = adOuSearch(oldName,oldOrgPath);
		System.out.println("ouOldName===" + ouOldName);

		String ouNewrName = ouOldName.replace(oldName, newName);
		System.out.println("newComputerName===" + ouNewrName);

		try {

			//String baseDn = ",DC=adserver,DC=invesume,DC=com";
			String baseDn = AdLdapUtils.baseDn;
			//String serverIP = "adserver.invesume.com";
			String serverIP = AdLdapUtils.serverIP;

			ctx.rename(ouOldName + baseDn, ouNewrName + baseDn);
		} catch (Exception exception) {
			exception.printStackTrace();
		}

	}
	
	// ou name change
		public  void ouPathMove(String oldOrgPath, String newOrgPath) throws Exception{

				initAdConnection();


			//String ouOldName = adOuSearch(oldName,oldOrgPath);
			//System.out.println("ouOldName===" + ouOldName);

			//String ouNewrName = ouOldName.replace(oldName, newName);
			//System.out.println("newComputerName===" + ouNewrName);

			try {

				//String baseDn = ",DC=adserver,DC=invesume,DC=com";
				String baseDn = AdLdapUtils.baseDn;
				//String serverIP = "adserver.invesume.com";
				String serverIP = AdLdapUtils.serverIP;
				System.out.println("baseDn===="+baseDn);
				//ctx.rename(oldOrgPath + baseDn, newOrgPath + baseDn);
				ctx.rename(oldOrgPath+""+baseDn,newOrgPath+""+baseDn);
			} catch (Exception exception) {
				exception.printStackTrace();
				System.out.println("------------------error------------------");
				throw new RuntimeException(exception);
				
			}

		}
		
	

	/**
	 * 
	 * @param ouName
	 * @return success : 0 or number, error : ERROR
	 */
	public  String delBeforeChkComInOu(String ouName) throws Exception{
		String resultStr = "";
		try {

			initAdConnection();

			String _filterName = "*";
			String returnedAtts[] = { "cn" };

			//String searchBase = ouName+",dc=adserver,dc=invesume,dc=com";
			String searchBase = ouName+AdLdapUtils.baseDn;
			String searchFilter = "(&(objectClass=computer)(cn="+_filterName+"))";

			SearchControls searchCtls = new SearchControls();
			searchCtls.setReturningAttributes(returnedAtts);
			searchCtls.setSearchScope(SearchControls.SUBTREE_SCOPE);
			NamingEnumeration answer = ctx.search(searchBase, searchFilter, searchCtls);
		
			String chkOu = "";
			int comInOu = 0;
			while (answer.hasMoreElements()) {
				SearchResult sr = (SearchResult) answer.next();
//				System.out.println("adComputerSearchUseCn===" + sr);
				chkOu = sr.toString();
				Attributes attrs = sr.getAttributes();
				
				String[] tmpOuSplit = chkOu.split(":");
				for (int i = 0; i < tmpOuSplit.length; i++) {
					
					if(tmpOuSplit[i].indexOf("CN=") != -1 ) {
						System.out.println("tmpOuSplit===" + tmpOuSplit[i]);
						comInOu++;
					}
				}
			}

			System.out.println("comInOu======"+ comInOu);
			
			resultStr = comInOu+"";
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			System.out.println("Connection Fail!");
			e.printStackTrace();
			resultStr = "ERROR";
		}

		return resultStr;
	}
	
	
	public static void main(String[] args) throws Exception {
		AdLdapUtils adu = new AdLdapUtils();
		//adu.ouPathMove("OU=test,OU=해병대사,OU=해병대사,OU=국방부"+baseDn, "OU=test,OU=국방전산정보원,OU=국방부"+baseDn);
		//adu.test("test");
		//adu.ouRename("Invesume", "Invesume1", oldOrgPath);
		//adu.test("OU=국방부");
		/*
		 * String[] org = {"1791", "1698", "628", "2856", "3708", "7558_1", "1699",
		 * "1746", "1749", "1829", "2857", "1789", "1963", "6693", "6694", "6715",
		 * "1964", "7896", "1601", "1747", "1748", "1750", "6677", "6227", "18", "1848",
		 * "2251", "9338", "6226", "980", "986", "3268", "2905", "1592", "43", "55",
		 * "60", "1577", "1578", "3459", "1354", "1728", "2903", "3066", "2578", "2224",
		 * "2247", "1856", "51", "44", "2237", "2250", "2234", "2235", "3553", "2699",
		 * "2246", "6468", "2386", "220", "6510", "709", "6512", "3301", "3304", "3302",
		 * "6225", "1635", "1663", "6706", "2694", "2705", "2704", "3427", "2706",
		 * "2703", "6223", "6228", "120", "6707", "3443", "3444", "9347", "6602", "635",
		 * "2435", "2436", "6079", "3467", "3205", "3465", "3469", "3466", "3303",
		 * "3464", "2509", "2510", "2511", "2513", "3888", "9200", "3204", "1108",
		 * "3041", "107", "3512", "1921", "117", "1917", "6672", "1918", "3203", "3206",
		 * "3207", "1051", "1054", "1052", "6704", "2437", "10036", "8038", "2617",
		 * "2618", "2619", "2620", "2621", "6083", "2112", "2113", "2114", "2115",
		 * "2116", "3404", "2117", "6081", "Invesume", "2106", "2107", "1853", "1854",
		 * "1855", "2438", "2439", "6082", "6080", "2441", "1849", "5799", "6695",
		 * "3436", "1615", "750", "2906", "2910", "2907", "2108", "1850", "1851",
		 * "1852", "1874", "1875", "1876", "1877", "527", "2456", "2457", "2458",
		 * "2459", "2460", "SGBCC", "1451", "2845", "8037", "1872", "1873", "1542",
		 * "1043", "6713", "2904", "1512", "10000", "528", "3543", "2454", "1447",
		 * "10023", "3218", "1223", "2150", "2104", "2105", "1845", "1804", "1805",
		 * "1806", "1807", "72", "9370", "6489", "3538", "3539", "2854", "2844", "2843",
		 * "3265", "10014", "1871", "1869", "2869", "2614", "2615", "1633", "1332",
		 * "1961", "1960", "1959", "1957", "1956", "3219", "1865", "1864", "1863",
		 * "2508", "1298", "1299", "480", "2564", "2565", "2926", "2872", "2876",
		 * "2871", "2862", "2863", "2858", "2866", "2870", "767", "367", "364", "376",
		 * "365", "409", "1589", "326", "1062", "6673", "6674", "6675", "10018", "398",
		 * "400", "3363", "3364", "3365", "10017", "10016", "10019", "2833", "2838",
		 * "2839", "2840", "6705", "408", "1919", "1920", "3478", "6676", "119", "7658",
		 * "2884", "3610", "2881", "3531", "3532", "3533", "2880", "6678", "6679",
		 * "3472", "2882", "370", "371", "180", "159", "10021", "160", "10022", "10020",
		 * "156", "188", "189", "185", "2831", "3445", "3446", "3563", "2892", "2891",
		 * "3885", "2885", "2883", "2888", "5586", "2223", "2226", "2221", "2249",
		 * "2227", "2228", "2225", "2229", "2243", "6584", "170", "169", "6662", "5130",
		 * "6645", "5115", "5584", "10002", "2222", "6703", "2230", "2282", "2290",
		 * "6668", "63", "53", "56", "54", "46", "47", "48", "62", "66", "49", "3331",
		 * "171tmp", "3332", "5116", "6682", "5583", "5585", "75", "71", "96", "137",
		 * "121", "52", "57", "3562", "2262", "2252", "6465", "6466", "194", "5121",
		 * "196", "5111", "5113", "74", "77", "76", "900", "70", "69", "67", "124",
		 * "5332", "1904", "2201tmp", "2236", "3557", "2202", "2238", "2240", "2241",
		 * "2244", "2245", "6472", "2248", "2242", "2254", "7680", "6467", "2231",
		 * "2232", "2267", "2259", "2294", "2265", "2263", "2264", "2275", "2276",
		 * "2277", "2278", "7689", "3266", "2233", "2266", "2258", "2260", "2261",
		 * "2268", "1505", "392", "402", "3275", "3387", "3281", "3234", "2269", "2270",
		 * "2271", "2272", "6653", "2273", "6670", "2274", "3230", "2841", "393", "395",
		 * "410", "388", "389", "390", "394", "401", "1947", "2286", "2288", "2285",
		 * "2284", "2289", "2849", "1951", "3541", "2824", "1198", "3737", "1966",
		 * "1948", "1949", "1300", "2279", "735", "2830", "2895", "2825", "2280",
		 * "2850", "1763", "1607", "2281", "405", "380", "1946", "703", "2291", "2842",
		 * "1623", "1624", "1625", "1621", "1622", "1632", "3519", "120", "1631",
		 * "3517", "2084", "3220", "2875", "1988", "10003", "2215", "2217", "2218",
		 * "2219", "2205", "2206", "1883", "171", "2111", "2453", "4501", "1073",
		 * "6631", "898", "2201", "2204", "2209", "2210", "1501", "1503", "9202",
		 * "2220", "7694", "3214", "1565", "1552", "2968", "2868", "2861", "1679",
		 * "1680", "1681", "1682", "1735", "1654", "1502", "2207", "1504", "2208",
		 * "2211", "2212", "2213", "2214", "2852", "2902", "6516", "6692", "2860",
		 * "6696", "2873", "3437", "899", "662", "1078", "2298", "8710", "1927", "1928",
		 * "1045", "2330", "1950", "3269", "2916", "2908", "2909", "-", "2299", "2900",
		 * "2898", "2901", "2897", "2899", "6680", "2292", "2293", "1734", "2877",
		 * "2894", "2295", "2296", "2297", "2853", "2823", "2302", "1978", "1977",
		 * "1295", "1297", "2306", "2305", "9218", "32", "2793", "453", "84", "1539",
		 * "1044", "1955", "1954", "1953", "863", "704", "1898", "94", "1614", "95",
		 * "86", "85", "1411", "1414", "706", "707", "708", "1408", "1887", "1613",
		 * "1514", "1517", "153", "1612", "1611", "2855", "2328", "7728", "7864",
		 * "2311", "9101", "9208", "9204", "9209", "9213", "9203", "9216", "9220",
		 * "2376", "7719", "387", "2315", "2316", "2317", "9201", "9205", "9206",
		 * "1507", "1508", "2353", "2309", "2331", "1985", "1899", "1900", "1890",
		 * "1901", "1902", "363", "1965", "3032", "3045", "3405", "1620", "3046",
		 * "3030", "1906", "158", "362", "9089", "1590", "3247", "3244", "3235", "3246",
		 * "3239", "1483", "10035", "337", "186", "168", "1700", "3240", "5128", "163",
		 * "162", "7076", "6644", "10008", "10006", "10004", "10010", "10011", "10009",
		 * "10005", "10007", "3402", "10012", "10013", "3272", "5346", "1241", "5350",
		 * "1242", "539", "101", "1239", "1240", "5349", "5352", "1211", "5109", "195",
		 * "5351", "1727", "1636", "1897", "1390", "375", "399", "7172", "379", "73",
		 * "9295", "341", "451", "1334", "454", "3357", "223", "224", "6664", "221",
		 * "10001", "3356", "432", "651", "652", "3292", "3476", "5348", "396", "382",
		 * "381", "383", "5356", "397", "79", "22", "19", "36", "40", "2257", "446",
		 * "413", "6597", "327", "386", "5360", "5361", "9125", "9124", "356", "9126",
		 * "411", "320", "374", "358", "3477", "2613", "10015", "3555", "412", "3274",
		 * "281", "282", "280", "298", "299", "300", "297", "271", "6688", "6689",
		 * "6690", "273", "268", "278", "270", "566", "277", "284", "285", "283", "431",
		 * "5051", "5059", "481", "3384", "6691", "5060", "483", "3485", "693", "6808",
		 * "5064", "5068", "5061", "488", "3486", "3406", "3408", "3409", "3407",
		 * "3410", "484", "482", "7042", "7021", "5073", "485", "7900", "486", "538",
		 * "3558", "5075", "3554", "694", "5071", "487", "546", "3285", "552", "3286",
		 * "3287", "551", "554", "553", "541", "544", "542", "7775", "543", "545",
		 * "695", "696", "697", "698", "567", "565", "568", "575", "576", "577", "574",
		 * "573", "561", "562", "558", "560", "559", "586", "591", "3414", "3413",
		 * "580", "578", "7049", "1530", "447", "592", "606", "602", "595", "596",
		 * "597", "594", "601", "609", "610", "608", "607", "598", "600", "491", "492",
		 * "493", "490", "495", "3340", "3339", "414", "415", "417", "416", "419",
		 * "3460", "619", "494", "498", "503", "504", "505", "502", "489", "605", "603",
		 * "10024", "10025", "434", "422", "427", "428", "425", "5091", "423", "444",
		 * "5050", "611", "506", "614", "615", "6657", "424", "430", "3474", "617",
		 * "613", "429", "507", "508", "510", "509", "515", "512", "511", "513", "514",
		 * "5084", "5002", "6576", "6665", "5006", "521", "524", "522", "523", "458",
		 * "456", "460", "455", "462", "468", "463", "464", "465", "466", "535", "1394",
		 * "471", "534", "3284", "6577", "472", "620", "525", "474", "531", "5029",
		 * "5030", "5031", "5032", "5035", "5034", "5033", "5036", "477", "478", "476",
		 * "145", "6586", "250", "252", "253", "5217", "245", "5222", "248", "5223",
		 * "254", "265", "5218", "479", "537", "475", "259", "2256", "5129", "3350",
		 * "5126", "5127", "5125", "3349", "5150", "5152", "3501", "3500", "3502",
		 * "3499", "3498", "5151", "3497", "3351", "202", "5186", "5179", "5184",
		 * "5176", "7110", "199", "5183", "197", "6666", "190", "193", "6667", "192",
		 * "6661", "5229", "201", "5181", "5182", "5103", "6641", "242", "5104", "235",
		 * "236", "237", "238", "239", "3707", "3330", "177", "178", "179", "176",
		 * "3329", "6643", "3326", "3328", "3564", "7072", "161", "6593", "5237",
		 * "6701", "213", "212", "5240", "211", "5239", "204", "5238", "232", "233",
		 * "234", "5235", "5236", "3358", "209", "3434", "10034", "231", "244", "243",
		 * "3544", "3549", "3550", "229", "228", "215", "247", "210", "216", "5230",
		 * "207", "208", "92", "90", "91", "93", "2724", "82", "102", "3335", "3333",
		 * "6635", "5233", "5234", "256", "255", "240", "5226", "5225", "5169", "1996",
		 * "141", "139", "114", "110", "111", "112", "113", "5247", "5248", "7140",
		 * "5252", "149", "251", "151", "150", "97", "8310", "5274", "108", "99",
		 * "3209", "148", "147", "98", "100", "103", "104", "5273", "134", "135", "136",
		 * "133", "127", "128", "126", "8", "5", "7629", "125", "131", "6663", "130",
		 * "132", "129", "122", "3210", "20", "5281", "6595", "6594", "23", "6636", "9",
		 * "11", "27", "24", "274", "6654", "5290", "33", "1", "5307", "5326", "3212",
		 * "4", "3313", "3231", "3211", "3236", "30", "31", "34", "123", "116", "152",
		 * "115", "3494", "3495", "3496", "26", "25", "5327", "3202", "2", "3", "3213",
		 * "6518", "1745", "2452", "2375", "2378", "68", "3482", "2427", "2428", "2685",
		 * "2686", "2668", "2688", "3233", "2717", "2732", "2548", "3243", "2549",
		 * "2550", "2558", "2560", "6700", "3255", "3253", "2417", "2421", "3262",
		 * "2757", "3263", "2758", "2718", "3264", "2754", "756", "2683", "2681",
		 * "2682", "2755", "2753", "2756", "2361", "2333", "2332", "2382", "2345",
		 * "2385", "2384", "2434", "2837", "2337", "2765", "2432", "2394", "2379",
		 * "2433", "5376", "5382", "2391", "2380", "2381", "5398", "2389", "2390",
		 * "2387", "3462", "10026", "2393", "5412", "2678", "5415", "2343", "2344",
		 * "2340", "2339", "2334", "2335", "2341", "2338", "2336", "2545", "2541",
		 * "2542", "2543", "2346", "2360", "2540", "9296", "2499", "9297", "2546",
		 * "2576", "2554", "5527", "2561", "2559", "6699", "2547", "2569", "2517",
		 * "2488", "2579", "2580", "2577", "2490", "2491", "2489", "2492", "2448",
		 * "5454", "5451", "2447", "2486", "2445", "2498", "5448", "2469", "2493",
		 * "5447", "2496", "2494", "2495", "2446", "2442", "5450", "2480", "2482",
		 * "2455", "2451", "2466", "9898", "4000", "5458", "2444", "2473", "2474",
		 * "2479", "2471", "7221", "2591", "2589", "2450", "2475", "2470", "2472",
		 * "5462", "2477", "3254", "2476", "2478", "2624", "2616", "2590", "2623",
		 * "2581", "2630", "2609", "2610", "2611", "2592", "2635", "2636", "2637",
		 * "2601", "2629", "2586", "2583", "2584", "2585", "2587", "2582", "2588",
		 * "2512", "10027", "5486", "3055", "5474", "886", "5481", "3061", "5494",
		 * "5496", "2676", "2673", "3063", "2663", "2769", "5487", "2818", "3510",
		 * "2817", "3064", "2822", "2768", "3062", "3065", "3050", "3447", "3051",
		 * "3053", "3058", "3052", "3057", "3049", "3059", "3054", "3056", "2727",
		 * "2693", "3060", "2712", "2692", "2697", "5504", "2696", "2798", "2691",
		 * "2720", "2721", "2726", "2723", "2722", "2684", "2797", "3710", "2713",
		 * "5508", "5530", "2800", "2816", "5509", "2806", "2728", "2740", "2741",
		 * "2733", "2734", "2735", "2736", "2742", "2739", "2781", "2743", "2744",
		 * "2745", "2748", "2746", "2747", "2737", "2738", "2749", "2750", "2725",
		 * "2783", "2778", "2779", "5515", "2777", "2776", "2782", "2780", "2775",
		 * "2795", "2771", "2785", "2784", "2671", "2670", "2813", "2811", "2812",
		 * "2815", "2810", "2814", "2809", "2790", "2792", "2786", "5525", "2774",
		 * "2787", "2794", "2788", "743", "745", "746", "744", "747", "1180", "5682",
		 * "735tmp", "740", "737", "1179", "736", "6625", "748", "2789", "2791", "1185",
		 * "1184", "1186", "1189", "753", "754", "761", "1181", "6051", "751", "1183",
		 * "1187", "1192", "1195", "1196", "1794", "760", "758", "759", "757", "5560",
		 * "5561", "762", "764", "765", "763", "6599", "768", "769", "766", "771",
		 * "5582", "777", "3450", "776", "5578", "3449", "5579", "775", "791", "792",
		 * "5596", "790", "798", "5592", "3511", "797", "795", "796", "801", "5593",
		 * "5595", "802", "839", "840", "841", "838", "779", "782", "780", "3470",
		 * "784", "785", "783", "788", "787", "786", "789", "803", "806", "807", "1930",
		 * "809", "810", "808", "815", "812", "813", "814", "811", "816", "817", "5681",
		 * "820", "819", "818", "823", "822", "831", "832", "833", "830", "1836",
		 * "1793", "824", "821", "827", "828", "826", "825", "829", "835", "836", "837",
		 * "834", "843", "845", "842", "3705", "3706", "6626", "846", "260", "5623",
		 * "848", "847", "852", "853", "854", "850", "5624", "5626", "862", "858",
		 * "861", "860", "5645", "5644", "5643", "5642", "865", "864", "3700", "879",
		 * "880", "5665", "885", "889", "882", "881", "893", "868", "869", "870", "867",
		 * "872", "874", "871", "876", "877", "875", "3703", "878", "890", "891", "892",
		 * "957", "958", "959", "956", "963", "965", "966", "967", "964", "3296", "962",
		 * "960", "961", "6709", "3344", "3297", "1767", "1785", "1783", "969", "970",
		 * "971", "968", "5666", "5667", "974", "975", "6618", "6619", "976", "978",
		 * "977", "979", "1782", "1784", "1764", "1765", "1766", "989", "990", "991",
		 * "1001", "1002", "1000", "1003", "1004", "1005", "1006", "3201", "1007",
		 * "1009", "1008", "1010", "1723", "1709", "1820", "1689", "1694", "1690",
		 * "988", "993", "994", "995", "992", "997", "998", "999", "996", "6617",
		 * "1011", "1012", "1691", "1692", "1693", "1718", "3366", "1695", "5612",
		 * "5613", "276", "279", "295", "321", "275", "726", "1125", "1126", "1127",
		 * "1128", "1130", "1131", "1129", "1133", "710", "718", "7277", "7797", "7276",
		 * "7281", "7798", "7953", "5598", "5599", "5600", "5597", "5601", "1134",
		 * "1137", "7279", "7799", "7280", "8434", "8436", "7274", "7275", "3479",
		 * "1124", "3480", "1123", "1175", "717", "727", "1143", "1144", "1146", "1164",
		 * "5615", "1159", "200", "1162", "5618", "1178", "1147", "1152", "1153",
		 * "3175", "1151", "1155", "1156", "1157", "1154", "1117", "1169", "1170",
		 * "1171", "1174", "1172", "1158", "1705", "6038", "1388", "1389", "1326",
		 * "6034", "1769", "6032", "1337", "6033", "1336", "8435", "1176", "1867",
		 * "1338", "955", "1393", "1397", "1725", "1724", "1726", "1835", "1708",
		 * "1776", "1775", "1281", "1341", "1392", "1280", "1398", "6031", "6612",
		 * "1777", "6041", "1442", "7441", "7440", "1013", "2165", "7748", "2168",
		 * "1837", "7439", "1529", "1531", "1532", "6613", "1664", "1662", "1659",
		 * "1657", "1017", "1016", "1014", "1015", "6621", "2167", "2097", "3352",
		 * "2169", "3424", "1938", "1933", "1665", "1660", "1788", "3345", "1786",
		 * "734", "2140", "1803", "1844", "1800", "1799", "1801", "1462", "1464",
		 * "6637", "1460", "1656", "8787", "8784", "8785", "1658", "1661", "1329",
		 * "1331", "1247", "1019", "1587", "6671", "5810", "1468", "622", "625", "1243",
		 * "1244", "1245", "1246", "5809", "1248", "3216", "6656", "5699", "1142",
		 * "699", "5711", "5713", "5715", "5709", "5726", "678", "5712", "3288", "5729",
		 * "679", "680", "681", "5730", "682", "714", "715", "716", "700", "688", "687",
		 * "683", "1361", "1363", "1364", "1365", "1367", "1366", "1089", "1090",
		 * "1088", "1091", "1484", "5727", "690", "702", "1459", "8490", "8494", "8493",
		 * "8495", "3220tmp", "4501tmp", "8498", "3214tmp", "8492", "7343", "8500",
		 * "7345", "1485", "8499", "1450", "8496", "9392", "449", "5813", "1418",
		 * "5812", "1518", "5814", "1216", "1251", "1262", "6603", "6604", "6606",
		 * "6607", "6608", "6605", "642", "675", "676", "677", "674", "6627", "691",
		 * "637", "638", "639", "1573", "1574", "1302", "621", "1301", "1330", "1328",
		 * "1456", "636", "644", "641", "643", "640", "3417", "3418", "3419", "3416",
		 * "3415", "646", "647", "645", "5808", "649", "648", "1419", "1525", "3451",
		 * "1228", "1548", "1237", "1543", "1566", "1558", "1781", "1209", "1561",
		 * "1204", "1210", "1570", "3452", "3453", "1494", "5765", "5766", "5767",
		 * "5768", "5773", "5770", "5771", "5775", "5769", "5774", "5761", "5762",
		 * "5772", "5763", "5736", "5737", "3421", "3422", "3423", "654", "655", "650",
		 * "653", "1271", "629", "630", "631", "632", "5782", "633", "1272", "5803",
		 * "1553", "1567", "1560", "3488", "6616", "902", "908", "6631tmp", "3492",
		 * "3355", "1544", "1562", "1563", "1569", "1571", "1206", "1207", "1208",
		 * "1212", "898tmp", "1069", "5895", "932", "1735tmp", "1654tmp", "1655",
		 * "5873", "923", "925", "926", "924", "929", "928", "930", "931", "7403",
		 * "5913", "949", "950", "947", "951", "952", "3295", "5921", "5920", "938",
		 * "939", "940", "941", "937", "6658", "5914", "5919", "3316", "3317", "3318",
		 * "953", "954", "218", "5937", "7423", "7424", "5925", "5922", "946", "944",
		 * "945", "943", "1252", "6615", "5918", "1033", "1032", "942", "1031", "1758",
		 * "5939", "1757", "1759", "1760", "1761", "1762", "1030", "5833", "217",
		 * "1037", "1035", "5845", "1036", "1034", "1038", "1041", "1042", "1040",
		 * "1047", "5846", "7425", "3294", "3293", "1046", "3321", "1053", "1050",
		 * "1048", "5852", "5870", "1061", "1072", "1056", "1057", "1055", "1058",
		 * "1059", "1060", "6610", "1063", "6609", "1070", "1071", "1068", "1704",
		 * "7812", "1376", "1555", "1074", "1093", "1095", "1092", "5863", "5862",
		 * "5866", "5869", "7395", "7394", "1383", "1382", "5949", "7415", "7393",
		 * "3215", "1846", "1333", "5957", "1576", "5952", "1094", "5950", "5954",
		 * "1778", "1779", "1780", "1105", "1304", "3381", "1306", "5956", "5951",
		 * "5955", "1218", "5946", "1097", "1098", "1099", "1096", "1107", "1109",
		 * "1106", "1103", "1104", "3487", "1102", "5942", "5941", "3226", "1666",
		 * "1114", "1269", "1115", "1100", "1111", "1112", "1113", "1110", "5948",
		 * "5947", "1667", "1668", "1670", "1673", "6630", "1672", "6629", "1674",
		 * "311", "312", "313", "310", "353", "305", "3514", "501", "661", "329", "315",
		 * "316", "317", "314", "335", "340", "286", "266", "287", "288", "349", "351",
		 * "345", "663", "664", "346", "355", "319", "5337", "318", "348", "352", "301",
		 * "302", "303", "304", "306", "307", "308", "309", "1683", "1710", "1713",
		 * "1816", "1817", "1818", "293", "292", "290", "291", "289", "659", "1345",
		 * "1355", "1356", "1357", "1358", "1381", "1495", "1498", "1819", "1684",
		 * "1685", "1687", "1347", "1348", "1349", "1350", "1359", "6628", "1433",
		 * "1434", "1432", "3412", "3457", "3458", "1466", "1472", "1474", "5963",
		 * "1487", "1488", "1489", "1490", "1493", "1511", "1496", "1519", "1521",
		 * "1523", "1528", "3471", "1526", "1415", "1413", "1202", "1219", "1222",
		 * "1646", "205", "1647", "1645", "897", "896", "895", "894", "1810", "1813",
		 * "1743", "1814", "7747", "1736", "1688", "1435", "1437", "10028", "3221",
		 * "1220", "667", "668", "669", "670", "671", "1752", "1403", "1422", "1423",
		 * "1407", "1409", "672", "673", "1249", "1404", "3379", "1406", "1410", "1424",
		 * "1425", "1426", "1427", "1486", "1289", "1559", "7392", "1541", "1482",
		 * "1323", "5966", "1387", "1224", "1225", "1226", "1227", "1261", "5784",
		 * "7390", "5785", "5341", "5974", "1321", "1312", "1314", "1324", "3362",
		 * "1263", "1265", "1264", "3372", "1307", "1308", "1309", "1310", "1443",
		 * "1444", "1445", "1446", "1278", "7435", "1277", "3513", "908(과거)", "902(과거)",
		 * "1449", "1461", "1463", "1465", "1467", "8715", "1479", "1579", "1580",
		 * "1581", "1582", "1368", "1369", "1370", "1371", "1500", "8717", "3455",
		 * "5973", "5967", "1510", "1522", "6698", "1351", "3375", "1352", "1353",
		 * "1399", "1400", "1401", "1402", "1436", "1438", "1439", "1440", "1201",
		 * "1217", "1221", "2123", "2093", "2094", "2092", "2098", "1880", "2101",
		 * "2099", "2191", "5981", "2023", "2022", "5975", "2021", "1878", "2100",
		 * "1879", "2216", "5985", "7461", "7460", "2192", "2194", "2149", "7455",
		 * "5987", "2005", "2007", "5979", "6638", "6639", "2181", "2109", "2174",
		 * "2131", "2133", "2132", "2135", "2137", "2136", "2096", "1931", "2182",
		 * "5986", "2161", "2162", "2163", "2160", "2141", "2151", "2146", "2103",
		 * "2189", "2188", "1935", "1936", "1937", "1934", "2069", "2184", "2185",
		 * "2186", "2183", "2148", "5988", "2164", "2130", "2193", "2013", "2014",
		 * "2015", "2012", "2037", "2036", "1942", "1604", "1940", "1602", "7462",
		 * "2000", "5998", "5999", "6611", "1976", "7464", "1999", "7463", "5994",
		 * "5995", "1939", "6002", "1962", "6000", "2001", "1945", "1943", "6003",
		 * "1984", "1997", "1979", "3323", "1980", "1981", "1982", "3324", "1697",
		 * "6010", "3229", "3456", "1375", "1731", "6009", "1416", "1420", "1417",
		 * "6006", "1610", "1405", "1774", "6008", "3377", "3411", "3433", "3376",
		 * "6012", "3435", "1600", "3701", "2079", "2063", "2080", "3222", "3702",
		 * "1886", "1884", "1823", "1824", "1825", "1826", "1605", "1594", "3223",
		 * "2057", "2060", "2059", "2061", "1751", "3322", "1595", "2178", "2179",
		 * "2180", "2177", "2058", "2010", "2009", "2011", "2008", "2018", "2019",
		 * "2020", "2017", "2401", "1932", "226", "227", "6230", "2400", "2399", "2423",
		 * "2426", "2429", "2403", "2430", "2404", "2402", "2411", "6217", "1509",
		 * "2358", "2415", "2410", "2412", "2413", "2553", "2461", "2462", "2463",
		 * "2369", "2310", "2368", "1617", "1616", "2398", "2405", "2397", "2503",
		 * "2504", "2506", "2416", "2518", "2519", "2520", "2521", "2522", "2523",
		 * "2524", "2525", "2526", "2527", "2528", "2529", "6632", "6205", "6206",
		 * "6209", "6633", "6211", "6212", "6210", "2530", "2531", "2532", "2535",
		 * "2533", "2536", "2537", "6195", "2367", "1619", "61", "59", "1618", "58",
		 * "2708", "6218", "6219", "2171", "2631", "2772", "2538", "1768", "3260",
		 * "3259", "6221", "3261", "6222", "2567", "2568", "2173", "2820", "2819",
		 * "2632", "2634", "2633", "2715", "2714", "2710", "3401", "2709", "3400",
		 * "2711", "83", "2707", "2593", "2595", "2347", "2349", "2350", "2570", "2571",
		 * "2573", "2574", "1282", "2575", "2641", "2638", "2639", "2642", "2604",
		 * "2606", "2605", "2603", "2608", "2602", "2596", "2597", "2598", "2599",
		 * "3047", "3250", "2467", "3249", "2200", "2468", "3399", "1828", "1827",
		 * "1770", "6045", "752", "6043", "1599", "1772", "1591", "6050", "2110",
		 * "2147", "1941", "2348", "1771", "3044", "1916", "1907", "1908", "1914",
		 * "1913", "1909", "1912", "1910", "1911", "1915", "3319", "1022", "1598",
		 * "1929", "1808", "1809", "1703", "1023", "1025", "1026", "1027", "1028",
		 * "6062", "6186", "1029", "1039", "1024", "1075", "1860", "1858", "1076",
		 * "1077", "6190", "6188", "1085", "1083", "1080", "1122", "6189", "1120",
		 * "1079", "50", "1597", "2175", "1608", "1634", "1968", "1862", "28", "29",
		 * "2507", "1335", "1441", "1214", "1215", "146", "13", "12", "14", "17", "15",
		 * "16", "10029", "7497", "8899", "8898", "2934", "154", "2938", "2936", "2937",
		 * "1971(19대)/1973(20대)", "1967", "7499", "1975", "1974", "1969", "1973",
		 * "6714", "7502", "7508", "3380", "2196", "2197", "2002", "10032", "7519",
		 * "500", "2652", "2956", "7505", "3300", "2645", "2653", "6717", "2650",
		 * "3008", "3009", "8938", "2955", "3003", "2962", "2961", "3403", "6710",
		 * "2659", "2963", "3002", "3014", "3006", "3027", "3566", "2987", "3028",
		 * "3013", "3005", "2983", "2986", "2954", "1893", "7523", "3000", "3022",
		 * "3023", "3010", "3011", "3024", "3004", "3020", "3025", "3026", "3029",
		 * "2992", "10030", "175", "183", "7639", "184", "7757", "7636", "7638", "7637",
		 * "7631", "7630", "182", "7761", "2660", "3012", "10031", "203", "2942",
		 * "2943", "2944", "2945", "6684", "6685", "6686", "2950", "6687", "2951",
		 * "3393", "3394", "2952", "6683", "3395", "2953", "2913", "2968tmp", "2914",
		 * "2915", "2965", "2918", "2957", "2958", "2959", "2966", "2960", "2967",
		 * "3388", "6278", "2917", "2919", "2920", "2921", "2924", "2927", "3359",
		 * "2040", "2929", "3016", "3389", "3390", "3570", "3031", "3391", "3034",
		 * "3018", "3015", "3017", "3019", "2931", "3200", "2932", "2933", "2041",
		 * "2042", "2055", "2054", "2053", "3232", "2056", "2049", "2078", "8992",
		 * "9116", "2082", "7555", "7552", "8993", "8994", "2083", "2034", "2025",
		 * "2016", "9012", "7559", "9015", "7558", "9020", "7560", "9019", "7562",
		 * "7554", "2086", "3361", "2085", "2039", "2067", "2043", "2030", "2048",
		 * "2066", "2033", "2065", "2064", "2035", "2089", "2998", "2187", "10033",
		 * "2044", "2029", "2077", "2075", "2076", "2074", "2038", "2070", "3320",
		 * "9027", "142", "143", "2071", "2073", "2046", "2072", "2047", "2062", "2032",
		 * "2031", "2045", "2068", "2090", "6316", "2088", "2087", "144", "155", "140",
		 * "164", "165", "173", "166", "167", "7534", "2989", "2970", "2971", "2991",
		 * "2972", "6712", "2941", "2940", "2946", "6349", "6346", "2974", "2975",
		 * "2979", "2977", "2978", "2980", "2923", "2552", "2990", "138", "1990",
		 * "1989", "1994", "1991", "1018", "2996", "2997", "2993", "2994", "2995",
		 * "322", "2999", "2928", "604", "1993", "3520", "7185", "6708", "366", "2859",
		 * "368", "656", "5759", "3341", "626" };
		 */
		
//		List a = new ArrayList();
//		for(int i = 0; i < org.length;i++) {
//			if (adu.adOuSearch(org[i], "") == null || adu.adOuSearch(org[i], "") == "") {
//				System.out.println("없는사지방번호======="+org[i]);
//				a.add(org[i]);
//			}
//		}
//		for(int y =0;y < a.size();y++) {
//			System.out.println("없는사지방번호======="+a.get(y));
//		}

		// computerModify(); //
//	  adComputerSearch("OU=1중대,OU=1대대,OU=3여단,OU=1사단,OU=1군직할,OU=육군,OU=국방부"); //
//	  adComputerSearch("OU=test222,OU=testHome"); // adOuSearch("LukeHan_Fool"); //

//		String ttt = adOuSearch("test222");
//		System.out.println("ttt===" + ttt);
//
//	  String retOU = adComputerSearchUseCn("HAMONIKR-new");
//	   System.out.println("retou===>"+ retOU); // computerModify( retOU, "TEST04VB" ,08:00:27:87:fd:25");
//	  
//	  String str = "OU=444,OU= 1중대,OU= 1대대,OU= 3여단,OU= 1사단,OU= 1군직할,OU= 육군,OU=국방부";
//	  sgbOuModify(str);

//		adOuCreate("OU=군견\\,대공방어대,OU=군견\\,대공방어대,OU=15특수임무비행단,OU=15비,OU=공직,OU=공직,OU=공군,OU=국방부3,OU=testHome");	
		// Name:
		// OU=본부중대\\/천마1\\,2\\,3중대\\/발칸중대,OU=5군단방공단,OU=5군단직할,OU=5군단,OU=3군,OU=육군,OU=국방부6
		// adOuSearch("OU=본부중대*");

//		System.out.println(adOuSearch("test"));
//		adOuCreate("OU=본부\\/1포대,OU=testHome");

//		computerRename("HAMONIKR","HAMONIKR-new");
//		ouRename("test222","test222-new");
//		ouDelete("testHome");
	}
	
	// ou name change
	public  String ouDelete(String delOuName) throws Exception{
		
		String returnVal = "";
		Boolean isWork = false;
		
		initAdConnection();
	
		System.out.println("delOuName==="+delOuName);
		//test(delOuName);
		
		String ouOldName = adOuSearch(delOuName,"path");
		System.out.println("ouOldName===" + ouOldName);
		
		String  comInOuTmp = delBeforeChkComInOu(ouOldName);
		System.out.println("comInOuCnt==="+comInOuTmp);
		
		if(comInOuTmp != "ERROR") {
			int tmpCnt = Integer.parseInt(comInOuTmp);
			if( tmpCnt > 0 ) {
				return "noaction";	//	하위디렉토리에 컴퓨터가 존재하여 삭제할 수 없음.
			}	else {
				isWork = true;
			}
		}else {
			return comInOuTmp;
		}
		
		try {

			String baseDn = AdLdapUtils.baseDn; 
			String serverIP = AdLdapUtils.serverIP;
			
			
			
			// 선택된 하위구조에 컴퓨터가 없을경우 선택한 조직 폴더 삭제 
			if(isWork) {
//				exam
				ctx.unbind(ouOldName+baseDn);
				//ctx.unbind("OU=본부\\/1포대,OU=testHome,DC=adserver,DC=invesume,DC=com");
				//ctx.unbind("OU=333,OU=222,OU=111,OU=test222,OU=testHome,DC=adserver,DC=invesume,DC=com");
				
			}
		    
		} catch (Exception exception) {
			exception.printStackTrace();
		}

		return returnVal;

	}



	public String ouPathMove2(String ouName,String newOuPath,String oldOuPath) throws Exception{
		String resultStr = ""; 
		try {

			initAdConnection();

			String _filterName = "*";
			String returnedAtts[] = { "cn" };

			//String searchBase = "OU=222,OU=111,OU=test222,OU=testHome,dc=adserver,dc=invesume,dc=com";
			String searchBase = AdLdapUtils.searchBase;
			//String searchFilter = "(&(ou="+_filterName+"))";
			String searchFilter = "(&(objectClass=organizationalunit)(ou=" + ouName + "))";

			SearchControls searchCtls = new SearchControls();
			searchCtls.setReturningAttributes(returnedAtts);
			searchCtls.setSearchScope(SearchControls.SUBTREE_SCOPE);
			//System.out.println(baseDn);
			NamingEnumeration answer = ctx.search(searchBase, searchFilter, searchCtls); 
			 ctx.rename("OU=test,OU=해병대사,OU=해병대사,OU=국방부"+baseDn, "OU=test,OU=국방전산정보원,OU=국방부"+baseDn);
			//System.out.println(ctx.bind("test", "test" ));
		
			String chkOu = "";
			int comInOu = 0;
			while (answer.hasMoreElements()) {
				SearchResult sr = (SearchResult) answer.next();
				chkOu = sr.toString();
				Attributes attrs = sr.getAttributes();
				
				String[] tmpOuSplit = chkOu.split(":");
				for (int i = 0; i < tmpOuSplit.length; i++) {
					
					if(tmpOuSplit[i].indexOf("OU=") != -1 ) {
						System.out.println("ou list===" + tmpOuSplit[i]);
						comInOu++;
					}
				}
			}

			System.out.println("comInOu======"+ comInOu);
			
			resultStr = comInOu+"";
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			System.out.println("Connection Fail!");
			e.printStackTrace();
			resultStr = "ERROR";
		}

		return resultStr;
	}

}
