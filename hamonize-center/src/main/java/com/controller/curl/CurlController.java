package com.controller.curl;

import java.io.BufferedReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.transaction.Transactional;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
import com.util.LDAPConnection;


/* connector가 돌때 데이터 가져오는 부분 */
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

	

	private static final String template = "Hello, %s!";
	private final AtomicLong counter = new AtomicLong();

	
	@RequestMapping("/test2")
	public String  ssssrr(@RequestParam(value = "name", required = false) String name) {
		String str = "PROGRM:hamonia, office";
		return str;
	}
	
	@RequestMapping("/test")
	public String  greeqwewqting(@RequestBody HashMap<String, String> map)  {
		System.out.println(map.get("retdata"));
		String str = "PROGRM:hamonia, office";
		return str;
	}
	
	/* pc정보 저장 */
	@Transactional(rollbackOn= {Exception.class})
	@RequestMapping("/setPcInfo")
	public Boolean setpcinfo(@RequestBody String retData, HttpServletRequest request) throws Exception {
		System.out.println("=============setpcinfo================");
		LDAPConnection con = new LDAPConnection();
			
		int retVal = 0;
		JSONParser jsonParser = new JSONParser();
		
		System.out.println("bbbb");
		JSONObject jsonObj = (JSONObject) jsonParser.parse( retData.toString());
		JSONArray hmdArray = (JSONArray) jsonObj.get("events");

		PcMangrVo hdVo = new PcMangrVo();
		System.out.println("hmdArray.size()==="+hmdArray.size());
		System.out.println("hmdArray===>> "+hmdArray.get(0).toString());
		Boolean isAddPcInfo = false;

		for(int i=0 ; i<hmdArray.size() ; i++){
			JSONObject tempObj = (JSONObject) hmdArray.get(i);
			
			hdVo.setPc_os(tempObj.get("pcos").toString().trim());
			hdVo.setPc_memory(tempObj.get("memory").toString().trim() +"G");
			hdVo.setPc_cpu(tempObj.get("cpuid").toString().trim());
			hdVo.setPc_disk(tempObj.get("hddinfo").toString().trim());
			hdVo.setPc_disk_id(tempObj.get("hddid").toString().trim());
			hdVo.setPc_vpnip(tempObj.get("vpnipaddr").toString().trim());
			hdVo.setPc_uuid(tempObj.get("uuid").toString());
			hdVo.setPc_macaddress(tempObj.get("macaddr").toString());
			hdVo.setDeptname(tempObj.get("deptname").toString());	// 부서이름
			hdVo.setSabun(tempObj.get("sabun").toString());	// 사번
			hdVo.setPc_hostname(tempObj.get("hostname").toString().replaceAll(System.getProperty("line.separator"),""));
			hdVo.setPc_ip(tempObj.get("ipaddr").toString());
			hdVo.setUsername(tempObj.get("username").toString());	// 사용자 이름	
		
		}

		OrgVo orgNumChkVo =  pcMangrMapper.chkPcOrgNum(hdVo);
	
		if(orgNumChkVo != null){
			System.out.println("orgNumChkVo===="+orgNumChkVo);
			hdVo.setOrg_seq(orgNumChkVo.getSeq()); 
			System.out.println("org_seq : "+  hdVo.getOrg_seq());
		
			UserVo sabunChkVo = pcMangrMapper.chkUserSabun(hdVo);
				
			if(sabunChkVo != null){
				int isExistPc = pcMangrMapper.inserPcInfoChk(hdVo);
				System.out.println("isExistPc ? ===="+isExistPc );
				Boolean PcDuplicateChk = false;
				
				System.out.println("sabunChkVo user name : "+sabunChkVo.getUser_name());
				System.out.println("orgNumChkVo.getOrg_seq() : "+orgNumChkVo.getSeq());
				System.out.println("orgNumChkVo.getOrg_seq() : "+sabunChkVo.getOrg_seq());
					
				if(hdVo.getUsername().equals(sabunChkVo.getUser_name())){
					if(orgNumChkVo.getSeq() == sabunChkVo.getOrg_seq()){
						if(isExistPc == 0){
							PcDuplicateChk = true;
							OrgVo allOrgNameVo = orgMapper.getAllOrgNm(hdVo.getOrg_seq());
	
							hdVo.setAlldeptname(allOrgNameVo.getAll_org_nm());
							con.connection(gs.getLdapUrl(), gs.getLdapPassword());
				
							System.out.println("hdVo.getPc_hostname() : "+hdVo.getPc_hostname());
							System.out.println("hdVo.getPc_os() toLowerCase : "+hdVo.getPc_os().toLowerCase());
								
							if(hdVo.getPc_os().toLowerCase().contains("hamonikr")){
								hdVo.setPc_os("H");
							} else if(hdVo.getPc_hostname().toLowerCase().contains("window")){
								hdVo.setPc_os("W");
							}	
							System.out.println("hdvo ==== > "+hdVo.toString());
							if(PcDuplicateChk) {
								retVal = pcMangrMapper.inserPcInfo(hdVo);
								if(retVal ==1){
									con.addPC(hdVo, sabunChkVo);
									isAddPcInfo = true;
								}else{
									System.out.println("pc 저장 실패");
								}
								
							}else {
								System.out.println("이미 등록된 PC");
							}
	
						}else{
							PcDuplicateChk = false;
						}	
					}else{
						System.out.println("소속된 부서와 사번이 일치하지않음");
					}
					
									
				}else{
					System.out.println("사용자 이름이 일치하지 않음");
				}

			}else{
				System.out.println("존재하지 않는 사번");
			}

		       
		}else{
			System.out.println("존재하지 않는 부서");	
		}
		
		 
		System.out.println("isAddPcInfo==="+ isAddPcInfo);
		return isAddPcInfo;
	}
	
	@RequestMapping("/prcssKill")
	public void prcssKill(HttpServletRequest request) throws Exception {
		
		StringBuffer json = new StringBuffer();
	    String line = null;
	 
	    try {
	        BufferedReader reader = request.getReader();
	        while((line = reader.readLine()) != null) {
	            json.append(line);
	        }
	 
	    }catch(Exception e) {
	        System.out.println("Error reading JSON string: " + e.toString());
	    }
	    
	    
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObj = (JSONObject) jsonParser.parse( json.toString());
		JSONArray inetvalArray = (JSONArray) jsonObj.get("events");
		System.out.println("====> "+ jsonObj.get("events"));

		Map<String,Object> prcssList = new HashMap<String,Object>();
		PcMangrVo pcInfo =new PcMangrVo();	
	
        for(int i=0 ; i<inetvalArray.size() ; i++){
            JSONObject tempObj = (JSONObject) inetvalArray.get(i);
            prcssList.put("insert_dt",tempObj.get("datetime").toString());
            prcssList.put("prcssname",tempObj.get("name").toString());
            prcssList.put("uuid",tempObj.get("uuid").toString());
            prcssList.put("org_seq",pcUUID(tempObj.get("uuid").toString()));
			pcInfo.setPc_uuid(tempObj.get("uuid").toString());	
			pcInfo = pcMangrMapper.pcDetailInfo(pcInfo);
			prcssList.put("hostname", pcInfo.getPc_hostname());
			prcssList.put("vpnipaddr", pcInfo.getPc_vpnip());
		}
        
        hmprogramMapper.prcssKillLog(prcssList);
	}



	@RequestMapping("/pcInfoChkProc")
	public Boolean pcInfoChkProc(@RequestBody String retData, HttpServletRequest request) {
		System.out.println("pcInfoChkProc============");
		int retVal = 0;
		Boolean isExistOrg = false;
		Boolean isExistSabun = false;
		Boolean isExist = false;

	    try {

	        JSONParser jsonParser = new JSONParser();
	        JSONObject jsonObj = (JSONObject) jsonParser.parse( retData.toString());
	        JSONArray hmdArray = (JSONArray) jsonObj.get("events");

	        PcMangrVo hdVo = new PcMangrVo();
	        System.out.println("hmdArray.size()==="+hmdArray.size());
	        
	        for(int i=0 ; i<hmdArray.size() ; i++){
	            JSONObject tempObj = (JSONObject) hmdArray.get(i);
	        	
	            hdVo.setDeptname(tempObj.get("deptname").toString());	// 부서번호
	            hdVo.setSabun(tempObj.get("sabun").toString());	// 사번
				hdVo.setUsername(tempObj.get("username").toString());	// 사용자 이름
	            
	       }
		   
			System.out.println("user 사번 >> "+ hdVo.getSabun());
			System.out.println("user 이름 >> "+ hdVo.getUsername());
		        
			OrgVo orgNumChkVo =  pcMangrMapper.chkPcOrgNum(hdVo);
			System.out.println("orgNumChkVo====org seq : "+orgNumChkVo.getSeq());

		   UserVo sabunChkVo = pcMangrMapper.chkUserSabun(hdVo);
		   
		   
			if( orgNumChkVo != null  ) {
				isExistOrg = true;
				if(sabunChkVo != null ){
					isExistSabun =true;
				}else{
					isExistSabun =false;
				}
			}else {
				isExistOrg = false;
			}
		
			isExist = isExistSabun && isExistOrg; 
			System.out.println("isExist==="+isExist);
		
		}catch(Exception e) {
	        System.out.println("Error reading JSON string: " + e.toString());
	    }
		
        return isExist;
	}

	@RequestMapping("/setVpnUpdate")
	public Boolean setVpnUpdate(@RequestBody String retData, HttpServletRequest request) {
		
		StringBuffer json = new StringBuffer();
		int retVal = 0;
		
	    try {

	        JSONParser jsonParser = new JSONParser();
	        JSONObject jsonObj = (JSONObject) jsonParser.parse( retData.toString());
	        JSONArray hmdArray = (JSONArray) jsonObj.get("events");

	        PcMangrVo hdVo = new PcMangrVo();
	        System.out.println("hmdArray.size()==="+hmdArray.size());
	        for(int i=0 ; i<hmdArray.size() ; i++){
	            JSONObject tempObj = (JSONObject) hmdArray.get(i);
	        	
	            
	            System.out.println("tempObj.get(\"uuid\").toString()==="+tempObj.get("uuid").toString());
	            System.out.println("tempObj.get(\"vpnipaddr\").toString()==="+tempObj.get("vpnipaddr").toString());
	            
	            hdVo.setPc_uuid(tempObj.get("uuid").toString());
	            hdVo.setPc_vpnip(tempObj.get("vpnipaddr").toString());
	            hdVo.setPc_hostname(tempObj.get("hostname").toString());
	            
	            System.out.println("hdVo==="+ hdVo.toString());
	            
	            
	        }
	        
	    	   retVal = pcMangrMapper.updateVpnInfo(hdVo);
	        	System.out.println("update retVal=== " + retVal);
	        	
	        
	    }catch(Exception e) {
	        System.out.println("Error reading JSON string: " + e.toString());
	    }
		
	    Boolean isAddPcInfo = true;
	    if( retVal == 1 ) {
	    	isAddPcInfo = true;
	    }else {
	    	isAddPcInfo = false;
	    }
        System.out.println("isAddPcInfo==="+isAddPcInfo);
		return isAddPcInfo;
	}
	

	/*
	 * 커넥터에서 기본 정보 셋팅 : vpn 연결후  센터 url을 통해 서버정보 get
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/commInfoData")
	public String getAgentJob(HttpServletRequest request) throws Exception {

		String output = "";
		
		JSONObject jsonObject = new JSONObject();
		JSONObject jsonList = new JSONObject();
		JSONArray itemList = new JSONArray();

		
		StringBuffer json = new StringBuffer();
	    String line = null;
	 
	    try {
	        BufferedReader reader = request.getReader();
	        while((line = reader.readLine()) != null) {
	            json.append(line);
	        }
	 
	    }catch(Exception e) {
	        System.out.println("Error reading JSON string: " + e.toString());
	    }
	    
	    
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObj = (JSONObject) jsonParser.parse( json.toString());
		JSONArray inetvalArray = (JSONArray) jsonObj.get("events");
		JSONObject object = (JSONObject) inetvalArray.get(0);
    	
		System.out.println("====> "+ object.get("uuid").toString());

		List<SvrlstVo> svrlstVo = svrlstMapper.getSvrlstDataList();
		

		for( SvrlstVo svrlstData : svrlstVo ){
			System.out.println("svrlstData===>=="+ svrlstData.getSvr_port()+"=="+ svrlstData.getSvr_domain() +"=="+ svrlstData.getSvr_ip());
			
			JSONObject tmpObject = new JSONObject();
			
			tmpObject.put("orgname", svrlstData.getSvr_nm());
			tmpObject.put("orgdomain", svrlstData.getSvr_domain());
			  
			if( "N".equals(svrlstData.getSvr_port()) ) {
				tmpObject.put("pcip", svrlstData.getSvr_ip());	
			}else {
				tmpObject.put("pcip", svrlstData.getSvr_ip() +":"+ svrlstData.getSvr_port());
			}
			
			
			itemList.add(tmpObject);
		}
		jsonObject.put("pcdata", itemList);

		output = jsonObject.toJSONString();
		
		System.out.println("//===================================");
		System.out.println("//commInfoData result data is : " + output);
		System.out.println("//===================================");
		
		return output;
	}

	
	

	@RequestMapping("/getPackageInfo")
	public Boolean getPackageInfo(@RequestBody String retData, @RequestParam Map<String, Object> params, HttpServletRequest request) {
		
		
		StringBuffer json = new StringBuffer();
		int retVal = 0;
		
	    try {

	        JSONParser jsonParser = new JSONParser();
	        System.out.println("retData.toString()========++++"+retData.toString());
	        JSONObject jsonObj = (JSONObject) jsonParser.parse( retData.toString());
	        JSONArray hmdArray = (JSONArray) jsonObj.get("events");

	        PcPackageVo pcPackageVo = new PcPackageVo();
	        System.out.println("hmdArray.size()==="+hmdArray.size());
	        
	        PcPackageVo[] inputVo = new PcPackageVo[hmdArray.size()];
	        for(int i=0 ; i<hmdArray.size() ; i++){
	        	JSONObject tempObj = (JSONObject) hmdArray.get(i);
	        	inputVo[i] = new PcPackageVo();
	        	
	        	
	        	System.out.println("tempObj.get(\"pcuuid\").toString()==="+tempObj.get("pcuuid").toString());
	        	System.out.println("tempObj.get(\"name\").toString()==="+tempObj.get("name").toString());
	        	System.out.println("tempObj.get(\"version\").toString()==="+tempObj.get("version").toString());
	        	System.out.println("tempObj.get(\"status\").toString()==="+tempObj.get("status").toString());
	        	System.out.println("tempObj.get(\"short_description\").toString()==="+tempObj.get("short_description").toString());
	        	
	        	
	        	inputVo[i].setUuid(tempObj.get("pcuuid").toString());
	        	inputVo[i].setPackage_name(tempObj.get("name").toString());
	        	inputVo[i].setPackage_version(tempObj.get("version").toString());
	        	inputVo[i].setPackage_status(tempObj.get("status").toString());
	        	inputVo[i].setPackage_desc("");
	            
	        	System.out.println("pcPackageVo=========+++"+ pcPackageVo.toString());
	        	        	
	        }
	       
	        Map<String, Object> insertDataMap = new HashMap<String, Object>();
	        insertDataMap.put("list", inputVo);
            
    		
	        int insertRetVal = packageInfoMapper.insertPackageInfo(insertDataMap);
    		
	        
	    }catch(Exception e) {
	        System.out.println("Error reading JSON string: " + e.toString());
	    }
		
	    Boolean isAddPcInfo = true;
		return isAddPcInfo;
	}
	
	/*
	* pcVpnInfoChange
	* vpn-auto-connection에서 vpn변경시 체크해서 업데이트 
	*
	*/	
	@RequestMapping("/pcInfoChange")
	public String  pcVpnInfoChange(HttpServletRequest request) throws Exception {		
		StringBuffer json = new StringBuffer();
	    String line = null;
	 
	    try {
	        BufferedReader reader = request.getReader();
	        while((line = reader.readLine()) != null) {
	        	System.out.println("line===> "+ line);
	            json.append(line);
	        }
	 
	    }catch(Exception e) {
	        System.out.println("Error reading JSON string: " + e.toString());
	    }
	    
        JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse( json.toString());
        JSONArray hmdArray = (JSONArray) jsonObj.get("events");

        PcMangrVo hdVo = new PcMangrVo();
        for(int i=0 ; i<hmdArray.size() ; i++){
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

        if( !chkPcMangrVo.getPc_vpnip().equals(hdVo.getPc_vpnip())) {   
			System.out.println("pcInfoChange chkPcMangrVo===="+chkPcMangrVo.toString());
 
			retVal = pcMangrMapper.updateVpnInfo(hdVo);
			pcMangrMapper.pcIpchnLog(hdVo);

			if(retVal==1){
				con.updatePcVpn(hdVo);
			}
				
       }else{
		System.out.println("vpn ip 변경사항없음...");
	   }

        
        return "retval:"+retVal;
	}

	
	
	public int pcUUID(String uuid) {
		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(uuid);
		agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);
		int segSeq = agentVo.getSeq();
		return segSeq;
	}
	
}


