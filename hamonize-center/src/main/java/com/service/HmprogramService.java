package com.service;

import java.util.HashMap;
import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IGetAgentJobMapper;
import com.mapper.IHmprogramMapper;
import com.model.HmprogramVo;
import com.paging.PagingVo;

@Service
public class HmprogramService {

	private static final int HashMap = 0;

	@Autowired
	private IHmprogramMapper hmprogramMapper;

	@Autowired
	private IGetAgentJobMapper getAgentJobMapper;

	public List<HmprogramVo> soliderList(HmprogramVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("hmprogramVo", vo);
		paramMap.put("pagingVo", pagingVo);

		List<HmprogramVo> listVal = hmprogramMapper.hmPcProgramListInfo(paramMap);

		return listVal;
	}

	@Transactional
	public void programManagementInsert(HmprogramVo nVo) throws Exception {

		String tmpPcmSeqVal = "{" + nVo.getProgrmCheckedList().toString() + "}";
		nVo.setPpa_pcm_seq(tmpPcmSeqVal);

		getAgentJobMapper.getAgentJobDelete();

		hmprogramMapper.deleteHmProgrm(nVo);
		hmprogramMapper.save(nVo);
	}

	public String programManagementList(HmprogramVo vo) {

		String programManagementListStr = null;

		HmprogramVo programManagementList = hmprogramMapper.selectHmProgrm(vo);

		if (null != programManagementList && null != programManagementList.getPpa_pcm_seq()) {
			programManagementListStr = programManagementList.getPpa_pcm_seq();
		}

		return programManagementListStr;
	}
}