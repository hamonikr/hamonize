package com.service;

import java.util.List;

import javax.naming.NamingException;

import com.GlobalPropertySource;
import com.mapper.IOrgMapper;
import com.mapper.IPcMangrMapper;
import com.mapper.ITenantconfigMapper;
import com.model.OrgVo;
import com.model.PcMangrVo;
import com.model.PolicyRestoreVo;
import com.model.RecoveryVo;
import com.model.TenantconfigVo;
import com.util.AuthUtil;
import com.util.LDAPConnection;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import reactor.core.publisher.Mono;

@Service
@Transactional(rollbackFor = NamingException.class)
public class OrgService {
	@Autowired
	GlobalPropertySource gs;

	@Autowired
	private IOrgMapper orgMapper;
	@Autowired
	private IPcMangrMapper pcMapper;
	@Autowired
	private ITenantconfigMapper tenantconfigMapper;

	@Autowired
	RestApiService restApiService;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	public JSONArray orgList(OrgVo orgvo) throws NamingException {
		List<OrgVo> orglist = null;
		JSONArray jsonArray = new JSONArray();

		orgvo.setDomain(AuthUtil.getLoginSessionInfo().getDomain());
		orglist = orgMapper.orgList(orgvo);

		for (int i = 0; i < orglist.size(); i++) {
			JSONObject data = new JSONObject();
			data.put("domain", orglist.get(i).getDomain());
			data.put("seq", orglist.get(i).getSeq());
			data.put("p_seq", orglist.get(i).getP_seq());
			data.put("org_nm", orglist.get(i).getOrg_nm());
			data.put("org_ordr", orglist.get(i).getOrg_ordr());
			data.put("section", orglist.get(i).getSection());
			data.put("level", orglist.get(i).getLevel());
			data.put("inventory_id", orglist.get(i).getInventory_id());
			data.put("group_id", orglist.get(i).getGroup_id());
			jsonArray.add(i, data);
		}
		return jsonArray;

	}

	public OrgVo orgView(OrgVo orgvo) {
		return orgMapper.orgView(orgvo);
	}

	public int orgSave(OrgVo orgvo) throws NamingException, ParseException {
		// 수정전 이름 불러오기
		OrgVo oldOrgVo = new OrgVo();
		OrgVo orgPath = new OrgVo();
		OrgVo newOrgPath = new OrgVo();

		OrgVo newAllOrgName = new OrgVo();
		String newAllOrgNm = "";

		if (orgvo.getSeq() != null) {
			oldOrgVo = orgMapper.orgOldNm(orgvo);
			orgPath = orgMapper.groupUpperCode(orgvo);
			newOrgPath = orgMapper.groupNewUpperCode(orgvo);
		}

		if (orgvo.getP_seq() == null) {// 최상위 회사의 부서일 경우
			orgvo.setP_seq(0L);
		}
		int result = orgMapper.orgSave(orgvo);

		LDAPConnection con = new LDAPConnection();
		con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		int snf = 0;
		if (result == 1)
		{ // 신규저장
			try
			{
				// ansible awx 저장
				if(orgvo.getP_seq() == 0)
				{
					snf = restApiService.addRootOrg(orgvo);
					tenantInsert(orgvo);
				}else
				{
					snf = restApiService.addDownOrg(orgvo);
				}
				if(snf == 1)
				{
					// ldap 저장
					con.addOu(orgvo);
					

				}
			} catch (Exception e)
			{
				logger.error(e.getMessage(), e);
			}

		} else if (result == 0)
		{
			if (oldOrgVo.getOrg_nm() != null)
			{ // 수정
				List<OrgVo> list = orgMapper.searchChildDept(orgvo);

				for (int i = 0; i < list.size(); i++)
				{
					newAllOrgNm = list.get(i).getAll_org_nm().replaceFirst(oldOrgVo.getOrg_nm(),
							orgvo.getOrg_nm());
					newAllOrgName.setAll_org_nm(newAllOrgNm);
					newAllOrgName.setSeq(list.get(i).getSeq());
					orgMapper.allOrgNmUpdate(newAllOrgName);
				}
				restApiService.updateOrg(orgvo);
				// ldap 서버 업데이트
				con.updateOu(oldOrgVo, orgvo);
			} else
			{
				logger.info("수정할 사항 없음");
			}
		}

		return result;

	}

	public int pcMove(PcMangrVo vo) throws NamingException, ParseException {
		int result = 0;
		result = pcMapper.moveTeam(vo);
		OrgVo orgVo = new OrgVo();
		orgVo = pcMapper.getOrgInfoParamPCUUID(vo);
		System.out.println("vo====="+vo.toString());
		System.out.println("orgVo====="+orgVo.toString());
		//ansible 삭제 재등록
		restApiService.deleteHost(vo);
		restApiService.addHost(vo, orgVo);

		LDAPConnection con = new LDAPConnection();
		con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		
		OrgVo orgPath = orgMapper.getAllOrgNm(vo);
		
		//Long org_seq = vo.getOrg_seq();
		vo.setMove_org_nm(orgPath.getAll_org_nm());
		vo.setOrg_seq(vo.getOld_org_seq());
		orgPath = orgMapper.getAllOrgNm(vo);
		
		vo.setOrg_seq(vo.getOrg_seq());
		vo.setAlldeptname(orgPath.getAll_org_nm());
		
		con.movePc(vo);
		
		// 백업 파일 들도 org_seq 변경 tbl_backup_recovery_mngr
		PolicyRestoreVo rvo = new PolicyRestoreVo();
		rvo.setBr_org_seq(vo.getOrg_seq());
		rvo.setPc_seq(vo.getSeq());
		//logger.info("pc seq : "+Integer.toString(vo.getSeq()));
		logger.info("update org seq : "+vo.getOrg_seq());

		int rcovresult = pcMapper.updateRcovPolicyOrgseq(rvo);		
	
		logger.info("rcovresult : "+rcovresult);

		if(rcovresult >= 1){
			logger.info("업데이트 완료");
			// delete 이전 부서의 일반 백업본
			pcMapper.deleteBackupAIfMoveOrg(rvo);
		}else{
			logger.info("업데이트 실패");
		}

		return result;

	}

	public int deletePc(PcMangrVo vo) throws NamingException, ParseException {
		int result = 0;
		result = pcMapper.deletePc(vo);
		if(result == 1){
			restApiService.deleteHost(vo);
		}
		LDAPConnection con = new LDAPConnection();
		con.connection(gs.getLdapUrl(), gs.getLdapPassword());
//		vo.setOrg_seq(vo.getOld_org_seq());
		OrgVo orgPath = orgMapper.getAllOrgNm(vo);
		vo.setAlldeptname(orgPath.getAll_org_nm());
		con.deletePc(vo);

		return result;

	}

	public int orgDelete(OrgVo orgvo) throws NamingException, ParseException {
		LDAPConnection con = new LDAPConnection();
		con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		
		int result = 0;
		result = orgMapper.pcDelete(orgvo);
		if(result > 0){
			result = orgMapper.orgDelete(orgvo);
			restApiService.deleteOrg(orgvo);
			con.deleteOu(orgvo);
		}

		return result;
	}
	public List<OrgVo> searchChildDept(OrgVo orgvo)
	{
		List<OrgVo> list = orgMapper.searchChildDept(orgvo);
		return list;
	}

	//	테넌트별 설정값 저장 ( 테넌트 키, 하모나이즈어드민 설정 파일)
	public void tenantInsert(OrgVo orgvo ) {
		

		String hadminConfigData = " {" + 
				"    \"AccessControl\": {" + 
				"        \"DomainGroupsEnabled\": \"true\"," + 
				"        \"UserGroupsBackend\": \"6f0a491e-c1c6-4338-8244-f823b0bf8670\"" + 
				"    }," + 
				"    \"AuthKeys\": {" + 
				"        \"PrivateKeyBaseDir\": \"%GLOBALAPPDATA%/keys/private\"," + 
				"        \"PublicKeyBaseDir\": \"%GLOBALAPPDATA%/keys/public\"" + 
				"    }," + 
				"    \"Authentication\": {" + 
				"        \"EnabledPlugins\": [" + 
				"            \"63611f7c-b457-42c7-832e-67d0f9281085\"," + 
				"            \"0c69b301-81b4-42d6-8fae-128cdd113314\"" + 
				"        ]," + 
				"        \"Method\": \"1\"" + 
				"    }," + 
				"    \"BuiltinDirectory\": {" + 
				"        \"NetworkObjects\": {" + 
				"            \"JsonStoreArray\": [" + 
				"            ]" + 
				"        }" + 
				"    }," + 
				"    \"Core\": {" + 
				"        \"ApplicationVersion\": \"5\"," + 
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
				"        \"ComputerTree\": \"ou="+orgvo.getDomain()+"\",\n" + 
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
		String privateKey = "" + 
				"MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAtKOz0H8bhVqs6efzDju3	\n" + 
				"exPWmx7thfWur5Hhz7bF2UN2Ltlh+DW9CkpX428ASw2NHo+S5fDBR9NTG2pDzGjl \n" +
				"pRRL+ylgPlgpt3SCEkMvwiXOoboCr5RVcxm8jgDSZppul7R1iZNA/1XnTAr3xLEb	\n" + 
				"b06Cwsp7DvvWWu/44NZapS2f5u3EGh+a7VcU4+DSWazJtrutVHqTqCqyoVVRcHXW	\n" + 
				"onjLd/rh9YZLqHNyONmwCLC3N/UBBKhk1is0qxqSChJqESvcUTXFmIra/KON8XLi	\n" + 
				"Mq3GpUfln4luTFl9b+c8O7v+85aiFr3NHZrxfHQo2RIqD4dF9N6MlSokb2DDz28J	\n" + 
				"6wuH8KSNrkjQCeUHeZiMhi64k0Skszt7xYa0PxHrogKQSjwxo6xk254P/txRwLL3	\n" + 
				"LlYMKg18QZECgOtxx3bOjUhgbOmePp94jOX9FEbobY7a/4e2ksYhezfQbRQznvN1	\n" + 
				"XQ8ogb0TIFlquRHYSfIA3m9N5Wv0v6KmrTHuja4VdMEcK7sTHkxFuUKsPd1EJ+Rc	\n" + 
				"A4dxjxpsbg/YjwkyuBcjNuPxNmmfUZb3sK6BU4iOl3AQT+kzEP/s0DdUiS8raVK2	\n" + 
				"nwo6vFzdltCmrDM3iKYKGg2tlpE5arfR6XQP7/Nv0abzLKAk5px/hh0Ace1dSnsb	\n" + 
				"L2HKH/FVfXmvaTA52UbIVbcCAwEAAQ==	\n" + 
				"";
		
		
		String publicKey = "" + 
				"MIIJQQIBADANBgkqhkiG9w0BAQEFAASCCSswggknAgEAAoICAQC0o7PQfxuFWqzp" + 
				"5/MOO7d7E9abHu2F9a6vkeHPtsXZQ3Yu2WH4Nb0KSlfjbwBLDY0ej5Ll8MFH01Mb" + 
				"akPMaOWlFEv7KWA+WCm3dIISQy/CJc6hugKvlFVzGbyOANJmmm6XtHWJk0D/VedM" + 
				"CvfEsRtvToLCynsO+9Za7/jg1lqlLZ/m7cQaH5rtVxTj4NJZrMm2u61UepOoKrKh" + 
				"VVFwddaieMt3+uH1hkuoc3I42bAIsLc39QEEqGTWKzSrGpIKEmoRK9xRNcWYitr8" + 
				"o43xcuIyrcalR+WfiW5MWX1v5zw7u/7zlqIWvc0dmvF8dCjZEioPh0X03oyVKiRv" + 
				"YMPPbwnrC4fwpI2uSNAJ5Qd5mIyGLriTRKSzO3vFhrQ/EeuiApBKPDGjrGTbng/+" + 
				"3FHAsvcuVgwqDXxBkQKA63HHds6NSGBs6Z4+n3iM5f0URuhtjtr/h7aSxiF7N9Bt" + 
				"FDOe83VdDyiBvRMgWWq5EdhJ8gDeb03la/S/oqatMe6NrhV0wRwruxMeTEW5Qqw9" + 
				"3UQn5FwDh3GPGmxuD9iPCTK4FyM24/E2aZ9RlvewroFTiI6XcBBP6TMQ/+zQN1SJ" + 
				"LytpUrafCjq8XN2W0KasMzeIpgoaDa2WkTlqt9HpdA/v82/RpvMsoCTmnH+GHQBx" + 
				"7V1KexsvYcof8VV9ea9pMDnZRshVtwIDAQABAoICAEzKWqKDpltmVKOK6xRd5n33" + 
				"zP9cgnS0IHKafXgjpq/Zsd/woWk2zwoU2I/inClLtXYMatI9Kq0x9N5uqiu3XAh1" + 
				"PGelCzj1maZXbQP+c8sA73po7MNfN4QaqMFlMAxWEjWDjYPSiYsCJbV55CJFd/g1" + 
				"U/kiwnV4MYOvCAnsldQqNROid/7y+JV0s3i8Fi/w+D8qQWDsSuDuZcmXz2sTbQ7c" + 
				"cwKqMGyDjp4plaD9SYwoM3siODCWtWcmLtmeDf8iHNz33EzZowpZ3QYRMUI3KFmK" + 
				"7itNCRxs++qREHYFwuFR5ev/WSB5xzySpZ3Wc5bz1dWMF/0krnaq15pRdGw2M+x0" + 
				"sLKrn19+i7zzd4DlfM8xZPi60O3mR8Pa28skcryZf/BLvi38jDBzuUG1mujadpX+" + 
				"+rQwghPNxXhTrqRfKltkVuZL2neMv7EHo97qLCZvWakTQEFqlsYPfwrxB7PtAjq6" + 
				"oWxKGi9p5Vph15FJXSk+pBuP7deGaj7e3tysW/8NwDO41JYZO+vjzgHjhirm8II0" + 
				"pC+JKQ9se3schorPFKtYfn1aEsdcB1d9eeFhFZ0L+pIoklua4/GMAV3uq6sHVLao" + 
				"ZXg8GHu5g0pADPsk8AItKXYdgyCosJarQI6ebHDH8SOvpkuVua2F4jcKnXFJiAJN" + 
				"gFZTtakGk8rpLYM4b+tBAoIBAQDcxg3JEm6TGtk6+x6bwlROiuLSKobMHtOgTM3L" + 
				"e/AOq2qk4FTMdWLB3+qlexV+kQt5/wzMYIHLQCEP0hOCpw8ghLZEVCtp0L1Ricyq" + 
				"uio4gt/3xUMzaJSQMOZ/41eLErxZkArPOFmkewU+4vBiO0VXdh+nkc1iCAWm2Bdk" + 
				"i/P5d6UiN2PEZ3jaUzfO6OpMthgtHSIg/5kUNiu6TFFzXRVH8Nzr0UctvDJT8ynD" + 
				"UiZ/x1Om8LJPwRK9uUWBf0vOumsr3y6+dF0D0dGoc8Ph+Kkj8jdNO7WVqogOeTMu" + 
				"NmQ8NnpWmXaeBYh783SI63lnkQgCMPqpe2Z/qOC9vdBZntB5AoIBAQDRdkldWwXN" + 
				"ftVx9KUdFPxEMBh3Yx8ZondVhK5llmOD0o2FBwv0iP1KN5nBntoOEYV/BHKbbo5D" + 
				"vpHCyWtrSiEj54ZAIcv8Ns8bs4Ec+sNvCvhfc0VnDirHL4wEuTTNltv802ShH62j" + 
				"lLGps34WdQscDqoge24m3/TnG1rNMCgS0Fx3VbE3BmDBNFOPCS5BWjFvOLXryJFN" + 
				"bLqjdWKCHGkDmPCyeU6Hh9arQdVHnbZtlkx3cHWTP6hN84hWN4yGhg2Yob/1g6eI" + 
				"Zv6a3t1WZfx2NrFGoEGA0uLZodH8zozzC2SK82NjBvQv4kWSa8DENcPvzSfjzerC" + 
				"CjHhOVt176uvAoIBABR94ZuvNUo8LLuXwXCNqgucQo9lWRurJNN1LYjcmRyTdpOV" + 
				"KunLX35FTV9MvGMCDYGmVcbGkmWOL0NrqVnwLaxEBTL0aQ8qS9g8pR2XqAGUzDsQ" + 
				"OTuVUmzLzSlDrcV/2LGreAVh4pgsvwDmSY+klrwWf7urAdg+jF+/IPS5NM0L+Ozj" + 
				"HUSGoiYJoV14Kv8xy66sTJWpg8jnekmReeHuWuJRjf/pbeTl2foG0PKLNn2Xv8D4" + 
				"CGT0s8ueXcA2U4/9p6Lr1UfiPxvyprYvAJiB3xkyC0YE68bXjEdjooeAju8z00kk" + 
				"d2kVdGSk5UUsLhmZ0Zd6elmu1YW15B5YdvVKk2kCggEACGv0GS/OtOtzk4hdlyS/" + 
				"29H/OdWfa31vxN130ZfRWnx9uiqFXYigfnpr0TAc3lHwByJbpUo1qB2iaK2GhyLM" + 
				"4E+vwyZYuERP4XI/L7YZY36Sa+wLj1AvgiC0RYBY0idNowWw1xWZ+qjA1+zile6Q" + 
				"yskAKBwuWpvIkf40kWltQwxjm1yzql20SDBdZ7Pbyz7gG/OwxNEknnNPscDHfCm+" + 
				"QynEC7j64lIg3HPiKmX57sALRQYdhBUcJD41bhn/qWz8YPWn7Swk8UQK2pk5Vv70" + 
				"vqAGUqug1pgkDNIHyl1Xp3H+0eNlTJb7/GzhlTiF4J20yhB6mRsvZCvaw4510fEX" + 
				"+wKCAQAcuxvl086H2OcDS0FcU3Lb2JKJtqd8uN/qToThPqiTuMXGoM2VV5R7gk7m" + 
				"w+Au1biJwbFPj43Fui5LDU771/t99BNbpCV9pc+tFt1IcOuG79OneMewhwAkhkmC" + 
				"AgWxTTDv48BIa4xa6ztScF15X9QrFv01yunS/y/gilR5Re0u9juWJlvDQXOLA/FU" + 
				"sHcPPeru7thn3MxBLKmB/57I6QQFHPjuE8cWr3ACcp9n5p35gQlly2kQul1OM1ly" + 
				"WZdovptTg9FQ/vqU6M40t3GFbsp5+eT0igSZ7QRKNvpCMYOV9499trMSBrW7Lbmu" + 
				"T+9HoP+4UGbXyFlSq/GI9Mrptekb" + 
				"";
		
		TenantconfigVo tenantVo = new TenantconfigVo();
		
		tenantVo.setDomain( orgvo.getDomain());
		System.out.println("tenantVo======++"+tenantVo);
		
		java.util.Random generator = new java.util.Random();
       generator.setSeed(System.currentTimeMillis());
       int authkeyTmp = generator.nextInt(1000000) % 1000000; 
       tenantVo.setTenant_authkey( Integer.toString(authkeyTmp) );
        
       tenantVo.setTenant_hadmin_config(hadminConfigData);
       tenantVo.setTenant_hadmin_public_key(publicKey);
       tenantVo.setTenant_hadmin_private_key(privateKey);
		tenantconfigMapper.tenantInfoSave(tenantVo);
		
	}
}
