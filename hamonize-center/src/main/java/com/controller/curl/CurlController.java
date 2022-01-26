package com.controller.curl;

import java.io.BufferedReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.transaction.Transactional;
import com.GlobalPropertySource;
import com.mapper.IGetAgentJobMapper;
import com.mapper.IHmprogramMapper;
import com.mapper.IOrgMapper;
import com.mapper.IPackageInfoMapper;
import com.mapper.IPcMangrMapper;
import com.mapper.ISvrlstMapper;
import com.model.GetAgentJobVo;
import com.model.OrgVo;
import com.model.PcMangrVo;
import com.model.PcPackageVo;
import com.model.SvrlstVo;
import com.model.UserVo;
import com.service.UserService;
import com.util.LDAPConnection;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

/**
 * connector에서 센터로 데이터를 보내는 컨트롤러
 * 
 */
@RestController
@RequestMapping("/hmsvc")
public class CurlController {

	@Autowired
	GlobalPropertySource gs;

	@Autowired
	private IOrgMapper orgMapper;

	@Autowired
	private IPcMangrMapper pcMangrMapper;

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	private ISvrlstMapper svrlstMapper;

	@Autowired
	private IPackageInfoMapper packageInfoMapper;

	@Autowired
	private IHmprogramMapper hmprogramMapper;

	@Autowired
	private UserService userSerivce;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	private static final String EVENTS = "events";

	/**
	 * pc정보 저장 ldap 서버에도 pc정보 저장
	 * 
	 * @param retData
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@Transactional(rollbackOn = { Exception.class })
	@ResponseBody
	@PostMapping("/setPcInfo")
	public Boolean setpcinfo(@RequestBody String retData, HttpServletRequest request) throws Exception {
		LDAPConnection con = new LDAPConnection();

		int retVal = 0;
		JSONParser jsonParser = new JSONParser();

		JSONObject jsonObj = (JSONObject) jsonParser.parse(retData.toString());
		JSONArray hmdArray = (JSONArray) jsonObj.get(EVENTS);

		PcMangrVo hdVo = new PcMangrVo();

		logger.debug("hmdArray.size()==={}", hmdArray.size());
		logger.debug("hmdArray===>> {}", hmdArray.get(0));

		Boolean isAddPcInfo = false;

		for (int i = 0; i < hmdArray.size(); i++) {
			JSONObject tempObj = (JSONObject) hmdArray.get(i);

			hdVo.setPc_os(tempObj.get("pcos").toString().trim());
			hdVo.setPc_memory(tempObj.get("memory").toString().trim());
			hdVo.setPc_cpu(tempObj.get("cpuid").toString().trim());
			hdVo.setPc_disk(tempObj.get("hddinfo").toString().trim());
			hdVo.setPc_disk_id(tempObj.get("hddid").toString().trim());
			hdVo.setPc_vpnip(tempObj.get("vpnipaddr").toString().trim());
			hdVo.setPc_uuid(tempObj.get("uuid").toString());
			hdVo.setPc_macaddress(tempObj.get("macaddr").toString());
			hdVo.setDeptname(tempObj.get("deptname").toString()); // 부서이름
			hdVo.setSabun(tempObj.get("sabun").toString()); // 사번
			hdVo.setPc_hostname(tempObj.get("hostname").toString().replaceAll(System.getProperty("line.separator"), ""));
			hdVo.setPc_ip(tempObj.get("ipaddr").toString());
			hdVo.setUsername(tempObj.get("username").toString()); // 사용자 이름

		}

		OrgVo orgNumChkVo = pcMangrMapper.chkPcOrgNum(hdVo);

		if (orgNumChkVo != null) {
			hdVo.setOrg_seq(orgNumChkVo.getSeq());
			logger.debug("org_seq : {}", hdVo.getOrg_seq());

			int isExistPc = pcMangrMapper.inserPcInfoChk(hdVo);
			logger.debug("isExistPc ? ===={}", isExistPc);

			OrgVo allOrgNameVo = orgMapper.getAllOrgNm(hdVo.getOrg_seq());

			hdVo.setAlldeptname(allOrgNameVo.getAll_org_nm());
			con.connection(gs.getLdapUrl(), gs.getLdapPassword());

			logger.debug("hdVo.getPc_hostname() : {}", hdVo.getPc_hostname());
			logger.debug("hdVo.getPc_os() toLowerCase : {}", hdVo.getPc_os().toLowerCase());

			if (hdVo.getPc_os().toLowerCase().contains("hamonikr")) {
				hdVo.setPc_os("H");
			} else if (hdVo.getPc_os().toLowerCase().contains("window")) {
				hdVo.setPc_os("W");
			} else if (hdVo.getPc_os().toLowerCase().contains("debian")) {
				hdVo.setPc_os("D");
			} else if (hdVo.getPc_os().toLowerCase().contains("gooroom")) {
				hdVo.setPc_os("G");
			} else if (hdVo.getPc_os().toLowerCase().contains("linuxmint")) {
				hdVo.setPc_os("L");
			} else if (hdVo.getPc_os().toLowerCase().contains("ubuntu")) {
				hdVo.setPc_os("U");
			} 
			

			logger.debug("hdvo ==== > {}", hdVo.toString());

			retVal = pcMangrMapper.inserPcInfo(hdVo);
			int chkPc = pcMangrMapper.pchk(hdVo);
			isAddPcInfo = true;

			UserVo sabunChkVo = new UserVo();
			con.addPC(hdVo, sabunChkVo);

		} else {
			logger.debug("존재하지 않는 부서입니다.");
		}

		logger.debug("hamonize Connector setPcInfo result :: {}", isAddPcInfo);
		return isAddPcInfo;
	}

	@ResponseBody
	@GetMapping("/isVpnUsed")
	public String vpnUsed(HttpServletRequest request) throws Exception {
		logger.debug("-------isVpnUsed------");
		JSONArray jsonArr = new JSONArray();

		List<SvrlstVo> vpnSvrList = svrlstMapper.getVpnSvrlstList();
		
		for (SvrlstVo el : vpnSvrList) {

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("svr_nm", el.getSvr_nm());
			jsonObject.put("ip", el.getSvr_ip()+":"+el.getSvr_port());
			jsonObject.put("vip", el.getSvr_vip()+":"+el.getSvr_port());
			jsonObject.put("vpn_used", el.getSvr_used());

			jsonArr.add(jsonObject);
		}

		logger.debug("//== vpnUsed jsonObject  data is : {}", jsonArr);

		return jsonArr.toString();
	}





	@PostMapping("/prcssKill")
	public void prcssKill(HttpServletRequest request) throws Exception {

		StringBuffer json = new StringBuffer();
		String line = null;

		try {
			BufferedReader reader = request.getReader();
//			while ((line = reader.readLine()) != null) {
			while ( !Objects.isNull(line = reader.readLine()) ) {
				json.append(line);
			}
			reader.close();
		} catch (Exception e) {
			logger.error("Error reading JSON string: {}", e.getMessage(), e);
			throw e;
		}

		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObj = (JSONObject) jsonParser.parse(json.toString());
		JSONArray inetvalArray = (JSONArray) jsonObj.get(EVENTS);

		logger.debug("====> {}", jsonObj.get(EVENTS));

		Map<String, Object> prcssList = new HashMap<String, Object>();
		PcMangrVo pcInfo = new PcMangrVo();

		for (int i = 0; i < inetvalArray.size(); i++) {
			JSONObject tempObj = (JSONObject) inetvalArray.get(i);
			prcssList.put("insert_dt", tempObj.get("datetime").toString());
			prcssList.put("prcssname", tempObj.get("name").toString());
			prcssList.put("uuid", tempObj.get("uuid").toString());
			prcssList.put("org_seq", pcUUID(tempObj.get("uuid").toString()));
			pcInfo.setPc_uuid(tempObj.get("uuid").toString());
			pcInfo = pcMangrMapper.pcDetailInfo(pcInfo);
			prcssList.put("hostname", pcInfo.getPc_hostname());
			prcssList.put("vpnipaddr", pcInfo.getPc_vpnip());
		}

		hmprogramMapper.prcssKillLog(prcssList);
	}

	@PostMapping("/pcInfoChkProc")
	public Boolean pcInfoChkProc(@RequestBody String retData, HttpServletRequest request) {
		logger.info("pcInfoChkProc============");
		int retVal = 0;
		Boolean isExistOrg = false;
		Boolean isExistSabun = false;
		Boolean isExist = false;

		try {

			JSONParser jsonParser = new JSONParser();
			JSONObject jsonObj = (JSONObject) jsonParser.parse(retData);
			JSONArray hmdArray = (JSONArray) jsonObj.get(EVENTS);

			PcMangrVo hdVo = new PcMangrVo();

			for (int i = 0; i < hmdArray.size(); i++) {
				JSONObject tempObj = (JSONObject) hmdArray.get(i);

				hdVo.setDeptname(tempObj.get("deptname").toString()); // 부서번호
				hdVo.setSabun(tempObj.get("sabun").toString()); // 사번
				hdVo.setUsername(tempObj.get("username").toString()); // 사용자 이름

			}

			OrgVo orgNumChkVo = pcMangrMapper.chkPcOrgNum(hdVo);
			logger.debug("orgNumChkVo====org seq : {}", orgNumChkVo.getSeq());

			UserVo sabunChkVo = pcMangrMapper.chkUserSabun(hdVo);

			if (orgNumChkVo.getSeq() != null) {
				isExistOrg = true;
				if (sabunChkVo != null) {
					isExistSabun = true;
				} else {
					isExistSabun = false;
				}
			} else {
				isExistOrg = false;
			}

			isExist = isExistSabun && isExistOrg;
			logger.debug("isExist==={}", isExist);

		} catch (Exception e) {
			logger.error("Error reading JSON string: {}", e.toString(), e);
		}

		return isExist;
	}
	
	@PostMapping("/setVpnUpdate")
	public void setVpnUpdate(@RequestBody String retData, HttpServletRequest request) throws NamingException, ParseException {
		int retVal = 0;
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObj = (JSONObject) jsonParser.parse(retData.toString());
		JSONArray hmdArray = (JSONArray) jsonObj.get(EVENTS);
		PcMangrVo hdVo = new PcMangrVo();

		logger.debug("hmdArray.size()==={}", hmdArray.size());

		for (int i = 0; i < hmdArray.size(); i++) {
				logger.debug("hmdArray =={}", hmdArray.get(i).toString());

				JSONObject tempObj = (JSONObject) hmdArray.get(i);

				hdVo.setPc_uuid(tempObj.get("uuid").toString());
				hdVo.setPc_vpnip(tempObj.get("vpnipaddr").toString());
				hdVo.setPc_hostname(tempObj.get("hostname").toString());

			}

		retVal = pcMangrMapper.updateVpnInfo(hdVo);

		
		LDAPConnection con = new LDAPConnection();
		con.connection(gs.getLdapUrl(), gs.getLdapPassword());

		Boolean isAddPcInfo = false;

		PcMangrVo tmpPcVo = pcMangrMapper.chkPcinfo(hdVo);
		hdVo.setOrg_seq(tmpPcVo.getOrg_seq());

		OrgVo allOrgNameVo = orgMapper.getAllOrgNm(hdVo.getOrg_seq());
		hdVo.setAlldeptname(allOrgNameVo.getAll_org_nm());
		
		if (retVal == 1) {			
			con.updatePcVpn(hdVo);
			isAddPcInfo = true;

		} else {
			isAddPcInfo = false;
		}

		logger.debug("isAddPcInfo==={}", isAddPcInfo);

		// return isAddPcInfo;
	}

	/*
	 * 커넥터에서 기본 정보 셋팅 : vpn 연결후 센터 url을 통해 서버정보 get
	 * 
	 * @param request
	 * 
	 * @return
	 * 
	 * @throws Exception
	 */
	@GetMapping("/commInfoData")
	public String getAgentJob(HttpServletRequest request) throws Exception {

		String output = "";

		JSONObject jsonObject = new JSONObject();
		JSONArray itemList = new JSONArray();

		List<SvrlstVo> svrlstVo = svrlstMapper.getSvrlstDataList();

		for (SvrlstVo svrlstData : svrlstVo) {
			JSONObject tmpObject = new JSONObject();
			if(svrlstData.getSvr_used() == 1 && svrlstData.getSvr_vip() != null){	
				svrlstData.setSvr_ip(svrlstData.getSvr_vip().trim());
				if(svrlstData.getSvr_nm().equals("VPNIP")){
					svrlstData.setSvr_ip(svrlstData.getSvr_ip().trim());
				}
			} 

			if ("N".equals(svrlstData.getSvr_port())) {
				tmpObject.put("pcip", svrlstData.getSvr_ip().trim());

			} else {
				String ret = svrlstData.getSvr_ip() + ":" + svrlstData.getSvr_port();
				tmpObject.put("pcip", ret.trim());
			}

			tmpObject.put("svrname", svrlstData.getSvr_nm());
			
			if(svrlstData.getSvr_domain() != null){
				tmpObject.put("svrdomain", svrlstData.getSvr_domain().trim());
			}else{
				tmpObject.put("svrdomain", svrlstData.getSvr_domain());

			}

			itemList.add(tmpObject);
		}

		jsonObject.put("pcdata", itemList);

		output = jsonObject.toJSONString();

		logger.info("//===================================");
		logger.debug("//commInfoData result data is : {}", output);
		logger.info("//===================================");

		return output;
	}

	@PostMapping("/getPackageInfo")
	public Boolean getPackageInfo(@RequestBody String retData, @RequestParam Map<String, Object> params,
			HttpServletRequest request) {

		try {

			JSONParser jsonParser = new JSONParser();
			logger.debug("retData.toString()========++++{}", retData.toString());
			JSONObject jsonObj = (JSONObject) jsonParser.parse(retData.toString());
			JSONArray hmdArray = (JSONArray) jsonObj.get(EVENTS);

			logger.debug("hmdArray.size()==={}", hmdArray.size());

			PcPackageVo[] inputVo = new PcPackageVo[hmdArray.size()];
			for (int i = 0; i < hmdArray.size(); i++) {
				JSONObject tempObj = (JSONObject) hmdArray.get(i);
				inputVo[i] = new PcPackageVo();

				inputVo[i].setUuid(tempObj.get("pcuuid").toString());
				inputVo[i].setPackage_name(tempObj.get("name").toString());
				inputVo[i].setPackage_version(tempObj.get("version").toString());
				inputVo[i].setPackage_status(tempObj.get("status").toString());
				inputVo[i].setPackage_desc("");

			}

			Map<String, Object> insertDataMap = new HashMap<String, Object>();
			insertDataMap.put("list", inputVo);

			int insertRetVal = packageInfoMapper.insertPackageInfo(insertDataMap);

		} catch (Exception e) {
			logger.error("Error reading JSON string: {}", e.toString(), e);
		}

		Boolean isAddPcInfo = true;
		return isAddPcInfo;
	}

	/*
	 * pcVpnInfoChange vpn-auto-connection에서 vpn변경시 체크해서 업데이트
	 *
	 */
	@PostMapping(value = "/pcInfoChange")
	public String pcVpnInfoChange(HttpServletRequest request) throws Exception {
		StringBuffer json = new StringBuffer();
		String line = null;

		try {
			BufferedReader reader = request.getReader();
			while ( !Objects.isNull(line = reader.readLine()) ) {
				logger.debug("line===> {}", line);
				json.append(line);
			}
			reader.close();
		} catch (Exception e) {
			logger.error("Error reading JSON string: {}", e.toString());
		}

		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObj = (JSONObject) jsonParser.parse(json.toString());
		JSONArray hmdArray = (JSONArray) jsonObj.get(EVENTS);

		PcMangrVo hdVo = new PcMangrVo();
		for (int i = 0; i < hmdArray.size(); i++) {
			JSONObject tempObj = (JSONObject) hmdArray.get(i);

			hdVo.setFirst_date(tempObj.get("datetime").toString());
			hdVo.setPc_macaddress(tempObj.get("macaddr").toString());
			hdVo.setPc_ip(tempObj.get("ipaddr").toString());
			hdVo.setPc_vpnip(tempObj.get("vpnipaddr").toString());
			hdVo.setPc_hostname(tempObj.get("hostname").toString());
			hdVo.setPc_cpu_id(tempObj.get("CPUID").toString());
			hdVo.setPc_uuid(tempObj.get("pcuuid").toString());
			hdVo.setStatus(tempObj.get("action").toString());
		}
		hdVo.setOrg_seq(pcUUID(hdVo.getPc_uuid()));

		LDAPConnection con = new LDAPConnection();
		con.connection(gs.getLdapUrl(), gs.getLdapPassword());

		PcMangrVo chkPcMangrVo = pcMangrMapper.chkPcinfo(hdVo);
		OrgVo allOrgNameVo = orgMapper.getAllOrgNm(hdVo.getOrg_seq());
		hdVo.setAlldeptname(allOrgNameVo.getAll_org_nm());

		int retVal = 0;

		hdVo.setOld_pc_ip(chkPcMangrVo.getPc_ip());
		hdVo.setOld_pc_vpnip(chkPcMangrVo.getPc_vpnip());
		hdVo.setOld_pc_macaddr(chkPcMangrVo.getPc_macaddress());

		if (!chkPcMangrVo.getPc_vpnip().equals(hdVo.getPc_vpnip())) {
			logger.debug("pcInfoChange chkPcMangrVo===={}", chkPcMangrVo.toString());

			retVal = pcMangrMapper.updateVpnInfo(hdVo);
			pcMangrMapper.pcIpchnLog(hdVo);

			if (retVal == 1) {
				con.updatePcVpn(hdVo);
			}

		} else {
			logger.debug("vpn ip 변경사항없음...");
		}

		return "retval:" + retVal;
	}

	@GetMapping(value = "/getOrgData")
	public String getOrgData(HttpServletRequest request) throws Exception {

		logger.debug("baseInfo===={}", request.getParameter("aseInfo"));

		OrgVo vo = new OrgVo();
		List<OrgVo> orgList = userSerivce.getOrgList(vo);
		JSONArray jsonArr = new JSONArray();

		for (OrgVo set : orgList) {

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("seq", set.getSeq());
			jsonObject.put("orgnm", set.getOrg_nm());

			jsonArr.add(jsonObject);
		}

		logger.debug("//==getOrgData jsonObject  data is : {}", jsonArr);
		return jsonArr.toString();
	}

	public int pcUUID(String uuid) {
		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(uuid);
		agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);
		int segSeq = agentVo.getSeq();
		return segSeq;
	}

}
