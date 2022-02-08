package com.service;

import java.util.List;

import javax.naming.NamingException;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;

import reactor.core.publisher.Mono;

import com.GlobalPropertySource;
import com.mapper.IOrgMapper;
import com.mapper.IPcMangrMapper;
import com.model.LoginVO;
import com.model.OrgVo;
import com.model.PcMangrVo;
import com.model.RecoveryVo;
import com.util.AuthUtil;
import com.util.LDAPConnection;

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
	WebClient webClient;

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
			jsonArray.add(i, data);
		}
		return jsonArray;

	}

	public OrgVo orgView(OrgVo orgvo) {
		return orgMapper.orgView(orgvo);
	}

	public int orgSave(OrgVo orgvo) throws NamingException {
		// 수정전 이름 불러오기
		OrgVo oldOrgVo = new OrgVo();
		OrgVo orgPath = new OrgVo();
		OrgVo newOrgPath = new OrgVo();

		OrgVo newAllOrgName = new OrgVo();
		String newAllOrgNm = "";
System.out.println("aaaaaaaaa==========="+orgvo.toString());
		if (orgvo.getSeq() != null) {
			oldOrgVo = orgMapper.orgOldNm(orgvo);
			orgPath = orgMapper.groupUpperCode(orgvo);
			newOrgPath = orgMapper.groupNewUpperCode(orgvo);
		}
		System.out.println("orgvo p_seq > " + orgvo.getP_seq());

		if (orgvo.getP_seq() == null) {// 최상위 회사의 부서일 경우
			orgvo.setP_seq(0);

		}
		int result = orgMapper.orgSave(orgvo);

		LDAPConnection con = new LDAPConnection();
		con.connection(gs.getLdapUrl(), gs.getLdapPassword());

		if (result == 1) { // 신규저장
			try {
				// ldap 저장
				con.addOu(orgvo);
				// ansible awx 저장
				if(orgvo.getP_seq() == 0)
				{
				String request = "{\"name\": \""+orgvo.getOrg_nm()+"\",\"description\": \""+orgvo.getOrg_nm()+"\",\"organization\": 1}";
        Mono<String> response = webClient.post()
        .uri(UriBuilder -> UriBuilder
        .path("/api/v2/inventories/")
        .build())
        .contentType(MediaType.APPLICATION_JSON)
        .body(BodyInserters.fromValue(request))
        //에러 확인
        .exchange().flatMap(clientResponse -> {
          if (clientResponse.statusCode().is5xxServerError()) {
              clientResponse.body((clientHttpResponse, context) -> {
                  return clientHttpResponse.getBody();
              });
              return clientResponse.bodyToMono(String.class);
          }
          else
              return clientResponse.bodyToMono(String.class);
      });
        //.bodyValue(request)
        //.accept(MediaType.APPLICATION_JSON)
        //.retrieve()
        //.bodyToMono(String.class); 
        String objects = response.block();
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
				orgvo.setInventory_id((Long) jsonObj.get("id"));
				request = "{\"name\": \""+orgvo.getOrg_nm()+"\",\"description\": \""+orgvo.getOrg_nm()+"\",\"inventory\": \""+orgvo.getInventory_id()+"\"}";
				response = webClient.post()
        .uri(UriBuilder -> UriBuilder
        .path("/api/v2/groups/")
        .build())
        .contentType(MediaType.APPLICATION_JSON)
        .body(BodyInserters.fromValue(request))
        //에러 확인
        .exchange().flatMap(clientResponse -> {
          if (clientResponse.statusCode().is5xxServerError()) {
              clientResponse.body((clientHttpResponse, context) -> {
                  return clientHttpResponse.getBody();
              });
              return clientResponse.bodyToMono(String.class);
          }
          else
              return clientResponse.bodyToMono(String.class);
      });
			jsonObj = (JSONObject) jsonParser.parse(response.block());
			orgvo.setGroup_id((Long) jsonObj.get("id"));
			orgMapper.addAwxId(orgvo);
				System.out.println("objects======"+jsonObj.get("id"));
				System.out.println("objects======"+jsonObj);
			}else{
				String request = "{\"name\": \""+orgvo.getOrg_nm()+"\",\"description\": \""+orgvo.getOrg_nm()+"\",\"inventory\": \""+orgvo.getInventory_id()+"\"}";
        Mono<String> response = webClient.post()
        .uri(UriBuilder -> UriBuilder
        .path("/api/v2/groups/").path("{id}/").path("children/")
        .build(orgvo.getGroup_id()))
        .contentType(MediaType.APPLICATION_JSON)
        .body(BodyInserters.fromValue(request))
        //에러 확인
        .exchange().flatMap(clientResponse -> {
          if (clientResponse.statusCode().is5xxServerError()) {
              clientResponse.body((clientHttpResponse, context) -> {
                  return clientHttpResponse.getBody();
              });
              return clientResponse.bodyToMono(String.class);
          }
          else
              return clientResponse.bodyToMono(String.class);
      });
        //.bodyValue(request)
        //.accept(MediaType.APPLICATION_JSON)
        //.retrieve()
        //.bodyToMono(String.class); 

        String objects = response.block();
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonObj = (JSONObject) jsonParser.parse(objects);
				System.out.println("aaaaaaaaaa====="+orgvo.getSeq());
				orgvo.setGroup_id((Long) jsonObj.get("id"));
				orgMapper.addAwxId(orgvo);
				System.out.println("objects======"+objects);
			}
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}

		} else if (result == 0) {
			if (oldOrgVo.getOrg_nm() != null) { // 수정
				List<OrgVo> list = orgMapper.searchChildDept(orgvo);

				for (int i = 0; i < list.size(); i++) {
					newAllOrgNm = list.get(i).getAll_org_nm().replaceFirst(oldOrgVo.getOrg_nm(),
							orgvo.getOrg_nm());
					newAllOrgName.setAll_org_nm(newAllOrgNm);
					newAllOrgName.setSeq(list.get(i).getSeq());
					orgMapper.allOrgNmUpdate(newAllOrgName);
				}

				// ldap 서버 업데이트
				con.updateOu(oldOrgVo, orgvo);
			} else {
				System.out.println("수정할 사항 없음");
			}
		}

		return result;

	}

	public int pcMove(PcMangrVo vo) throws NamingException {
		int result = 0;
		result = pcMapper.moveTeam(vo);

		LDAPConnection con = new LDAPConnection();
		con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		
		OrgVo orgPath = orgMapper.getAllOrgNm(vo);
		Long org_seq = vo.getOrg_seq();
		vo.setMove_org_nm(orgPath.getAll_org_nm());
		vo.setOrg_seq(vo.getOld_org_seq());
		orgPath = orgMapper.getAllOrgNm(vo);
		vo.setOrg_seq(org_seq);
		vo.setAlldeptname(orgPath.getAll_org_nm());
		con.movePc(vo);
		
		// 백업 파일 들도 org_seq 변경 tbl_backup_recovery_mngr
		RecoveryVo rvo = new RecoveryVo();
		rvo.setBr_org_seq(vo.getOrg_seq());
		rvo.setDept_seq(vo.getSeq());
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

	public int deletePc(PcMangrVo vo) throws NamingException {
		int result = 0;
		result = pcMapper.deletePc(vo);

		LDAPConnection con = new LDAPConnection();
		con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		vo.setOrg_seq(vo.getOld_org_seq());
		OrgVo orgPath = orgMapper.getAllOrgNm(vo);
		vo.setAlldeptname(orgPath.getAll_org_nm());
		con.deletePc(vo);

		return result;

	}

	public int orgDelete(OrgVo orgvo) throws NamingException {
		LDAPConnection con = new LDAPConnection();
		con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		con.deleteOu(orgvo);

		int result = 0;
		//List<OrgVo> childOrg = orgMapper.searchChildDept(orgvo);

		// for (int i = 0; i < childOrg.size(); i++) {
		// 	// System.out.println("childOrg 삭제할 하위의 seq "+ childOrg.get(i).getSeq());
		// 	orgMapper.deleteChildUser(childOrg.get(i));
		// }
		// orgMapper.deleteChildUser(orgvo);

		result = orgMapper.orgDelete(orgvo);

		return result;
	}


}
