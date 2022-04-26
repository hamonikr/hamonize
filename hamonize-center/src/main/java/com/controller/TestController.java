package com.controller;


import java.util.Map;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.GlobalPropertySource;
import com.mapper.IGetAgentJobMapper;
import com.mapper.INotiMapper;
import com.model.GetAgentJobVo;
import com.model.NotiVo;
import com.model.OrgVo;
import com.service.OrgService;
import com.util.LDAPConnection;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
@RequestMapping("/test")
public class TestController {
	@Autowired
	private OrgService oService;
	@Autowired
	GlobalPropertySource gs;

	@Autowired
	INotiMapper notiMapper;
	
	

	@Autowired
	private IGetAgentJobMapper agentJobMapper;
	

	private Logger logger = LoggerFactory.getLogger(this.getClass());


	@ResponseBody
	@RequestMapping("/saveTchnlgyIngry")
	public int save(HttpServletRequest request, NotiVo notivo, ModelMap model,
			@RequestParam Map<String, Object> params) throws Exception {
		int retVal = 0;
		try {
			// 질문등록
			notivo.setOrg_seq(pcUUID_Domain(notivo.getPc_uuid(), notivo.getDomain()));
			retVal = notiMapper.saveQuestion(notivo);
			
		} catch (Exception e) {
			// TODO: handle exception
			retVal = 4;
		}

		return retVal;
	}	

	public Long pcUUID_Domain(String uuid, String domain) {
		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(uuid);
		agentVo.setDomain(domain);
		agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);
		Long segSeq = agentVo.getSeq();
		return segSeq;
	}
	
	
	
	@RequestMapping("/layout3")
	public String test3(HttpSession session, Model model, HttpServletRequest request) {

		JSONArray jsonArray = new JSONArray();

		try {
			// 저장된 조직 정보 출력
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		LDAPConnection con = new LDAPConnection();

		try {
			con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		} catch (NamingException e1) {
			logger.error(e1.getMessage(), e1);
		}

		model.addAttribute("oList", jsonArray);
		
		return "/test3";
//		return "/test";

	}
	
	@RequestMapping("/layout")
	public String test(HttpSession session, Model model, HttpServletRequest request) {

		JSONArray jsonArray = new JSONArray();

		try {
			// 저장된 조직 정보 출력
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		LDAPConnection con = new LDAPConnection();

		try {
			con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		} catch (NamingException e1) {
			logger.error(e1.getMessage(), e1);
		}

		model.addAttribute("oList", jsonArray);
		
		return "/test2";
//		return "/test";

	}

	@RequestMapping("/layout2")
	public String test2(HttpSession session, Model model, HttpServletRequest request) {

		JSONArray jsonArray = new JSONArray();

		try {
			// 저장된 조직 정보 출력
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		LDAPConnection con = new LDAPConnection();

		try {
			con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		} catch (NamingException e1) {
			logger.error(e1.getMessage(), e1);
		}

		model.addAttribute("oList", jsonArray);
		
		return "/test";

	}
	
	// public static void main(String[] args)  {
	// 	test();
  //   }
	
	
	public static void test() {
		String tmp = " {\n" + 
				"    \"AccessControl\": {\n" + 
				"        \"DomainGroupsEnabled\": \"true\",\n" + 
				"        \"UserGroupsBackend\": \"6f0a491e-c1c6-4338-8244-f823b0bf8670\"\n" + 
				"    },\n" + 
				"    \"AuthKeys\": {\n" + 
				"        \"PrivateKeyBaseDir\": \"%GLOBALAPPDATA%/keys/private\",\n" + 
				"        \"PublicKeyBaseDir\": \"%GLOBALAPPDATA%/keys/public\"\n" + 
				"    },\n" + 
				"    \"Authentication\": {\n" + 
				"        \"EnabledPlugins\": [\n" + 
				"            \"63611f7c-b457-42c7-832e-67d0f9281085\",\n" + 
				"            \"0c69b301-81b4-42d6-8fae-128cdd113314\"\n" + 
				"        ],\n" + 
				"        \"Method\": \"1\"\n" + 
				"    },\n" + 
				"    \"BuiltinDirectory\": {\n" + 
				"        \"NetworkObjects\": {\n" + 
				"            \"JsonStoreArray\": [\n" + 
				"            ]\n" + 
				"        }\n" + 
				"    },\n" + 
				"    \"Core\": {\n" + 
				"        \"ApplicationVersion\": \"5\",\n" + 
				"        \"InstallationID\": \"44f5fa39-0112-4fa9-9d8d-cf80096d932d\",\n" + 
				"        \"PluginVersions\": {\n" + 
				"            \"JsonStoreObject\": {\n" + 
				"                \"{0c69b301-81b4-42d6-8fae-128cdd113314}\": \"2.0\",\n" + 
				"                \"{14bacaaa-ebe5-449c-b881-5b382f952571}\": \"1.1\",\n" + 
				"                \"{1b08265b-348f-4978-acaa-45d4f6b90bd9}\": \"1.1\",\n" + 
				"                \"{1bdb0d1c-f8eb-4d21-a093-d555a10f3975}\": \"1.1\",\n" + 
				"                \"{2917cdeb-ac13-4099-8715-20368254a367}\": \"1.1\",\n" + 
				"                \"{2ad98ccb-e9a5-43ef-8c4c-876ac5efbcb1}\": \"1.1\",\n" + 
				"                \"{387a0c43-1355-4ff6-9e1f-d098e9ce5127}\": \"1.1\",\n" + 
				"                \"{39d7a07f-94db-4912-aa1a-c4df8aee3879}\": \"1.1\",\n" + 
				"                \"{4122e8ca-b617-4e36-b851-8e050ed2d82e}\": \"1.2\",\n" + 
				"                \"{4790bad8-4c56-40d5-8361-099a68f0c24b}\": \"1.1\",\n" + 
				"                \"{63611f7c-b457-42c7-832e-67d0f9281085}\": \"1.0\",\n" + 
				"                \"{63928a8a-4c51-4bfd-888e-9e13c6f3907a}\": \"1.1\",\n" + 
				"                \"{67dfc1c1-8f37-4539-a298-16e74e34fd8b}\": \"1.1\",\n" + 
				"                \"{6f0a491e-c1c6-4338-8244-f823b0bf8670}\": \"1.2\",\n" + 
				"                \"{73430b14-ef69-4c75-a145-ba635d1cc676}\": \"1.0\",\n" + 
				"                \"{80580500-2e59-4297-9e35-e53959b028cd}\": \"1.2\",\n" + 
				"                \"{85f6c631-e75a-4c78-8cb2-a7f3f502015a}\": \"1.1\",\n" + 
				"                \"{8ae6668b-9c12-4b29-9bfc-ff89f6604164}\": \"1.1\",\n" + 
				"                \"{a54ee018-42bf-4569-90c7-0d8470125ccf}\": \"1.1\",\n" + 
				"                \"{a8a84654-40ca-4731-811e-7e05997ed081}\": \"1.0\",\n" + 
				"                \"{b47bcae0-24ff-4bf5-869c-484d64af5c4c}\": \"1.1\",\n" + 
				"                \"{d4bb9c42-9eef-4ecb-8dd5-dfd84b355481}\": \"1.0\",\n" + 
				"                \"{e11bee03-b99c-465c-bf90-7e5339b83f6b}\": \"1.0\",\n" + 
				"                \"{ee322521-f4fb-482d-b082-82a79003afa7}\": \"1.1\"\n" + 
				"            }\n" + 
				"        }\n" + 
				"    },\n" + 
				"    \"LDAP\": {\n" + 
				"        \"BaseDN\": \"dc=hamonize,dc=com\",\n" + 
				"        \"BindDN\": \"cn=admin,dc=hamonize,dc=com\",\n" + 
				"        \"BindPassword\": \"00e89ff2759790c1c7b69aa264b52b6fd626792c85c283c69d0f4f964b2250f476820923bac3842a4074b00b0268d439e09809870b475c2399565fddabb36d7f0a6ba65585ba4d38943146b2128dc073d3754280765b30a59ac121c849322efcc3a2104aa8a7b4f40a6b6bb3c0a80f040103057fe9f93181d7e5ba796b33ff68b2853e9efae6b3c7d5b3cc98b5aafa8e84155708d399477cfed3c06fb5a41715883576d6956241768758dc7b6788a47fb6ce1c5f9a19d58763bb390e7b53bd11a1feea7d0a9b3b8ac01c2aa22097fb48504fc4307cd16eb5bd8bb2dce98d099cffe7315f55e14311b68ee44a5cd57e4d72c13868c11f1d309b7584e5653533c786da076afabe322b619245bde28de546785991ae122a7d3719c09a8434bfbb4c0494628ecdef6c1c00fd755860e8001ef9a9adbd30afb44aa09082cbd12825ce65f3b974bff0ac7b8da767f4482493c3b6fa0a37fa9879d380a2a56ccb67412d1273c0941cf3810a5e904270a93a42725a2dd71895aef8494894ff637361eb9b2b631c89601fe1d5d4003bb55ce5486679606a2bd97f77d5e7fda92532b3df7e0f2ef16637e5607a9923137837f8d391d4697db97c5dbc7f70e80cbc05d8f8b3e884c1a80acced03de1c0c9369a02ca7e3018332bcf5d8cb51a06117d58ff99e12b28642e92213effbd7a13d2f543750931c71601d11e90826db86f6751bbb0e\",\n" + 
				"        \"ComputerContainersFilter\": \"\",\n" + 
				"        \"ComputerDisplayNameAttribute\": \"name\",\n" + 
				"        \"ComputerGroupTree\": \"ou=hosts\",\n" + 
				"        \"ComputerGroupsFilter\": \"\",\n" + 
				"        \"ComputerHostNameAsFQDN\": \"false\",\n" + 
				"        \"ComputerHostNameAttribute\": \"ipHostNumber\",\n" + 
				"        \"ComputerLocationAttribute\": \"\",\n" + 
				"        \"ComputerLocationsByAttribute\": \"false\",\n" + 
				"        \"ComputerLocationsByContainer\": \"true\",\n" + 
				"        \"ComputerMacAddressAttribute\": \"\",\n" + 
				"        \"ComputerTree\": \"ou=invesume\",\n" + 
				"        \"ComputersFilter\": \"\",\n" + 
				"        \"GroupMemberAttribute\": \"\",\n" + 
				"        \"GroupTree\": \"\",\n" + 
				"        \"IdentifyGroupMembersByNameAttribute\": \"true\",\n" + 
				"        \"LocationNameAttribute\": \"description\",\n" + 
				"        \"RecursiveSearchOperations\": \"true\",\n" + 
				"        \"ServerHost\": \"192.168.0.2\",\n" + 
				"        \"UseBindCredentials\": \"true\",\n" + 
				"        \"UserGroupsFilter\": \"\",\n" + 
				"        \"UserLoginNameAttribute\": \"\",\n" + 
				"        \"UserTree\": \"\",\n" + 
				"        \"UsersFilter\": \"\"\n" + 
				"    },\n" + 
				"    \"Logging\": {\n" + 
				"        \"LogLevel\": \"5\"\n" + 
				"    },\n" + 
				"    \"Master\": {\n" + 
				"        \"AllowAddingHiddenLocations\": \"false\",\n" + 
				"        \"AutoAdjustMonitoringIconSize\": \"false\",\n" + 
				"        \"AutoOpenComputerSelectPanel\": \"false\",\n" + 
				"        \"AutoSelectCurrentLocation\": \"false\",\n" + 
				"        \"ComputerDisplayRoleContent\": \"0\",\n" + 
				"        \"ComputerMonitoringSortOrder\": \"0\",\n" + 
				"        \"ConfirmUnsafeActions\": \"false\",\n" + 
				"        \"HideComputerFilter\": \"false\",\n" + 
				"        \"HideEmptyLocations\": \"false\",\n" + 
				"        \"HideLocalComputer\": \"false\",\n" + 
				"        \"ShowCurrentLocationOnly\": \"false\"\n" + 
				"    },\n" + 
				"    \"Network\": {\n" + 
				"        \"DemoServerPort\": \"11400\",\n" + 
				"        \"VeyonServerPort\": \"11100\"\n" + 
				"    },\n" + 
				"    \"NetworkObjectDirectory\": {\n" + 
				"        \"Plugin\": \"6f0a491e-c1c6-4338-8244-f823b0bf8670\"\n" + 
				"    },\n" + 
				"    \"Service\": {\n" + 
				"        \"RemoteConnectionNotifications\": \"false\"\n" + 
				"    },\n" + 
				"    \"UI\": {\n" + 
				"        \"Language\": \"Korean - 한국어 (ko_KR)\"\n" + 
				"    },\n" + 
				"    \"VncServer\": {\n" + 
				"        \"Plugin\": \"39d7a07f-94db-4912-aa1a-c4df8aee3879\"\n" + 
				"    }\n" + 
				"}\n" + 
				"";
		System.out.println(tmp);
	}
}
