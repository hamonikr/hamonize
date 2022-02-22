package com.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.model.OrgVo;
import com.model.PcMangrVo;
import com.model.RecoveryVo;
import com.model.UserVo;

public interface IPcMangrMapper {
	
	
	public List<PcMangrVo> pcMntrngListInfo(PcMangrVo vo);

	public List<PcMangrVo> pcListInfo(HashMap<String, Object> map);
	
	public int countPcListInfo(PcMangrVo vo);
	
	public int changeStts(PcMangrVo vo);
	
	public int requestCount();
	
	public PcMangrVo pcMoveInfo(PcMangrVo vo);
	
	public PcMangrVo chkPcinfo(PcMangrVo vo);
	
	public UserVo chkUserSabun(PcMangrVo vo);

	public int updatePcinfo(PcMangrVo vo);

	public int moveTeam(PcMangrVo vo);
	
	public int deletePc(PcMangrVo vo);

	public int pcInfoChange(PcMangrVo vo);
	
	public int pcIpchnLog(PcMangrVo vo);
	
	public PcMangrVo maxSgbPcCntByorgSeq(PcMangrVo vo);

	public int pchk(PcMangrVo hdVo);
	
	public int changeInsertHistory(PcMangrVo vo);
	
	public int insertMoveInfo(PcMangrVo vo);
	
	public int updateHistory(PcMangrVo vo);
	
	public int deleteMoveInfo(PcMangrVo vo);
	
	public List<Map<String, Object>> pcMngrListExcel(PcMangrVo vo);
	
	public int insertPcAmtJson(Map<String, Object> map);
	
	public int insertWindowPc(Map<String, Object> map);
	
	public PcMangrVo pcDetailInfo(PcMangrVo vo);
	
	public List<PcMangrVo> pcBlockListInfo(HashMap<String, Object> map);
	
	public List<OrgVo> teamList(PcMangrVo vo);
	
	public int updateBlock(PcMangrVo vo);
	
	public int updateUnblock(PcMangrVo vo);
	
	//pcBlockStatus
	public PcMangrVo getPcBlockStatus(PcMangrVo vo);
	
	//정책배포결과 업데이트
	public List<Map<String, Object>> pcPolicyUpdtList(Map<String, Object> map);

	//정책배포결과 프로그램
	public List<Map<String, Object>> pcPolicyProgrmList(Map<String, Object> map);

	//정책배포결과 방화벽
	public List<Map<String, Object>> pcPolicyFirewallList(Map<String, Object> map);

	//정책배포결과 디바이스
	public List<Map<String, Object>> pcPolicyDeviceList(Map<String, Object> map);
	
	public int inserPcInfo(PcMangrVo vo);

	public int inserPcInfoChk(PcMangrVo vo);

	public int updateVpnInfo(PcMangrVo vo);

	public OrgVo chkPcOrgNum(PcMangrVo vo);

	public OrgVo getOrgInfoParamPCUUID(PcMangrVo vo);

	public OrgVo getOrgInfoParamPCSEQ(PcMangrVo vo);
	
	// 부서 이동시 복구 테이블 org값 업데이트
	public int updateRcovPolicyOrgseq(RecoveryVo vo);

	public int deleteBackupAIfMoveOrg(RecoveryVo vo);

	public int addHostId(PcMangrVo vo);
	
}