package com.controller.curl;

import java.io.BufferedReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
	@Transactional(rollbackOn = {Exception.class})
	@PostMapping("/setPcInfo")
	public Boolean setpcinfo(@RequestBody String retData, HttpServletRequest request)
			throws Exception {
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
			hdVo.setPc_hostname(tempObj.get("hostname").toString()
					.replaceAll(System.getProperty("line.separator"), ""));
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
			} else if (hdVo.getPc_hostname().toLowerCase().contains("window")) {
				hdVo.setPc_os("W");
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

	@PostMapping("/prcssKill")
	public void prcssKill(HttpServletRequest request) throws Exception {

		StringBuffer json = new StringBuffer();
		String line = null;

		try {
			BufferedReader reader = request.getReader();
			while ((line = reader.readLine()) != null) {
				json.append(line);
			}

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
	public Boolean setVpnUpdate(@RequestBody String retData, HttpServletRequest request) {

		StringBuffer json = new StringBuffer();
		int retVal = 0;

		try {

			JSONParser jsonParser = new JSONParser();
			JSONObject jsonObj = (JSONObject) jsonParser.parse(retData.toString());
			JSONArray hmdArray = (JSONArray) jsonObj.get(EVENTS);

			PcMangrVo hdVo = new PcMangrVo();
			logger.debug("hmdArray.size()==={}", hmdArray.size());
			for (int i = 0; i < hmdArray.size(); i++) {
				JSONObject tempObj = (JSONObject) hmdArray.get(i);

				logger.debug("tempObj.get(\"uuid\").toString()=== {}",
						tempObj.get("uuid").toString());

				logger.debug("tempObj.get(\"vpnipaddr\").toString()==={}",
						tempObj.get("vpnipaddr").toString());

				hdVo.setPc_uuid(tempObj.get("uuid").toString());
				hdVo.setPc_vpnip(tempObj.get("vpnipaddr").toString());
				hdVo.setPc_hostname(tempObj.get("hostname").toString());

			}

			retVal = pcMangrMapper.updateVpnInfo(hdVo);


		} catch (Exception e) {

			logger.error("Error reading JSON string: {}", e.toString(), e);
		}

		Boolean isAddPcInfo = true;
		if (retVal == 1) {
			isAddPcInfo = true;
		} else {
			isAddPcInfo = false;
		}

		logger.debug("isAddPcInfo==={}", isAddPcInfo);

		return isAddPcInfo;
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
	@PostMapping("/commInfoData")
	public String getAgentJob(HttpServletRequest request) throws Exception {

		String output = "";

		JSONObject jsonObject = new JSONObject();
		JSONArray itemList = new JSONArray();


		StringBuffer json = new StringBuffer();
		String line = null;

		try {
			BufferedReader reader = request.getReader();
			while ((line = reader.readLine()) != null) {
				json.append(line);
			}

		} catch (Exception e) {
			logger.error("Error reading JSON string: {}", e.toString(), e);
		}


		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObj = (JSONObject) jsonParser.parse(json.toString());
		JSONArray inetvalArray = (JSONArray) jsonObj.get(EVENTS);
		JSONObject object = (JSONObject) inetvalArray.get(0);

		logger.debug("====> {}", object.get("uuid").toString());
		List<SvrlstVo> svrlstVo = svrlstMapper.getSvrlstDataList();


		for (SvrlstVo svrlstData : svrlstVo) {
			logger.debug("svrlstData===> {}", svrlstData.getSvr_port());
			logger.debug("svrlstData===> {}", svrlstData.getSvr_domain());
			logger.debug("svrlstData===> {}", svrlstData.getSvr_ip());

			JSONObject tmpObject = new JSONObject();

			tmpObject.put("orgname", svrlstData.getSvr_nm());
			tmpObject.put("orgdomain", svrlstData.getSvr_domain());

			if ("N".equals(svrlstData.getSvr_port())) {
				tmpObject.put("pcip", svrlstData.getSvr_ip());
			} else {
				tmpObject.put("pcip", svrlstData.getSvr_ip() + ":" + svrlstData.getSvr_port());
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
	public Boolean getPackageInfo(@RequestBody String retData,
			@RequestParam Map<String, Object> params, HttpServletRequest request) {

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
			while ((line = reader.readLine()) != null) {
				logger.debug("line===> {}", line);
				json.append(line);
			}

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


	@PostMapping(value = "/getOrgData")
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


