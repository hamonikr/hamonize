package com.controller.curl;

import java.io.BufferedReader;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.GlobalPropertySource;
import com.mapper.IEqualsHwMapper;
import com.mapper.IGetAgentJobMapper;
import com.mapper.IOrgMapper;
import com.model.EqualsHwVo;
import com.model.GetAgentJobVo;
import com.model.OrgVo;
import com.model.PcMangrVo;
import com.util.LDAPConnection;

@RestController
@RequestMapping("/hmsvc")
public class CurlEqualsHwController {

	@Autowired
	GlobalPropertySource gs;

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	IEqualsHwMapper equalsHwMapper;

	@Autowired
	IOrgMapper orgMapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 하드웨어 변경로그 : 에이전트에서 하드웨어의 변경사항이 있을경우 센터로 보냄
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eqhw", method = RequestMethod.POST)
	public String getAgentJob(HttpServletRequest request) throws Exception {
		StringBuffer json = new StringBuffer();
		String line = null;

		try {
			BufferedReader reader = request.getReader();
			while ((line = reader.readLine()) != null) {
				json.append(line);
			}
			reader.close();

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}


		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObj = (JSONObject) jsonParser.parse(json.toString());
		JSONArray inetvalArray = (JSONArray) jsonObj.get("events");
		logger.debug(" envents ====> {}", jsonObj.get("events"));

		EqualsHwVo setEqualsHwVo = new EqualsHwVo();
		for (int i = 0; i < inetvalArray.size(); i++) {
			JSONObject tempObj = (JSONObject) inetvalArray.get(i);

			setEqualsHwVo.setPc_hostname(tempObj.get("hostname").toString());
			setEqualsHwVo.setPc_memory(tempObj.get("memory").toString());
			setEqualsHwVo.setPc_cpu_id(tempObj.get("cpuid").toString());
			setEqualsHwVo.setPc_disk(tempObj.get("hddinfo").toString());
			setEqualsHwVo.setPc_disk_id(tempObj.get("hddid").toString());
			setEqualsHwVo.setPc_ip(tempObj.get("ipaddr").toString());
			setEqualsHwVo.setPc_uuid(tempObj.get("uuid").toString());
			setEqualsHwVo.setPc_user(tempObj.get("user").toString());
			setEqualsHwVo.setPc_macaddress(tempObj.get("macaddr").toString());
			setEqualsHwVo.setPc_cpu(tempObj.get("cpuinfo").toString());

		}

		setEqualsHwVo.setOrg_seq(pcUUID(setEqualsHwVo.getPc_uuid()));
		int retVal = equalsHwMapper.pcHWInfoInsert(setEqualsHwVo);

		LDAPConnection con = new LDAPConnection();
		con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		PcMangrVo newPvo = new PcMangrVo();

		newPvo.setOrg_seq(pcUUID(setEqualsHwVo.getPc_uuid()));
		newPvo.setPc_hostname(setEqualsHwVo.getPc_hostname());

		OrgVo allOrgNameVo = orgMapper.getAllOrgNm(newPvo.getOrg_seq());

		newPvo.setAlldeptname(allOrgNameVo.getAll_org_nm());
		PcMangrVo oldPvo = equalsHwMapper.getPCinfo(newPvo);

		if (retVal == 1) {
			// pc정보 db 업데이트
			equalsHwMapper.pcMngrModify(setEqualsHwVo);
			// pc 정보 ldap 업데이트 hostname
			con.updatePc(newPvo, oldPvo);

			return "Y";
		} else {
			return "N";
		}
	}



	/**
	 * 부서 UUID로 부서 seq 가져오기
	 * 
	 * @param uuid
	 * @return 부서seq
	 */
	public int pcUUID(String uuid) {
		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(uuid);
		agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);
		int segSeq = agentVo.getSeq();
		return segSeq;
	}

}
