package com.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.model.PcMangrVo;

public interface IPcMangrMapper {
	
	
	public List<PcMangrVo> pcMntrngListInfo(PcMangrVo vo);

	public List<PcMangrVo> pcListInfo(HashMap<String, Object> map);
	
	public int countPcListInfo(PcMangrVo vo);
	
	public int changeStts(PcMangrVo vo);
	
	public int requestCount();
	
	public PcMangrVo pcMoveInfo(PcMangrVo vo);
	
	public PcMangrVo chkPcinfo(PcMangrVo vo);
	
	public int updatePcinfo(PcMangrVo vo);

	public int pcIpchnLog(PcMangrVo vo);
	
	public PcMangrVo maxSgbPcCntByorgSeq(PcMangrVo vo);

	public PcMangrVo selectPcHostName(PcMangrVo hdVo);
	
	public int changeInsertHistory(PcMangrVo vo);
	
	public int insertMoveInfo(PcMangrVo vo);
	
	public int updateHistory(PcMangrVo vo);
	
	public int deleteMoveInfo(PcMangrVo vo);
	
	public List<Map<String, Object>> pcMngrListExcel(PcMangrVo vo);
	
	public int insertPcAmtJson(Map<String, Object> map);
	
	public int insertWindowPc(Map<String, Object> map);
	
	public PcMangrVo pcDetailInfo(PcMangrVo vo);
	
	public List<PcMangrVo> pcBlockListInfo(HashMap<String, Object> map);
	
	public int updateBlock(PcMangrVo vo);
	
	public int updateUnblock(PcMangrVo vo);
	
	//pcBlockStatus
	public PcMangrVo getPcBlockStatus(PcMangrVo vo);
	
	//정책배포결과 카운트
	public List<Map<String, Object>> pcPolicyList(Map<String, Object> map);
	
	public int inserPcInfo(PcMangrVo vo);

	public int inserPcInfoChk(PcMangrVo vo);

	public int updateVpnInfo(PcMangrVo vo);

	public PcMangrVo chkPcOrgNum(PcMangrVo vo);
	
	

	
}