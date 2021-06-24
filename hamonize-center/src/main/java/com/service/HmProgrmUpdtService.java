package com.service;

import java.util.HashMap;
import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IGetAgentJobMapper;
import com.mapper.IHmProgrmUpdtMapper;
import com.model.HmProgrmUpdtVo;
import com.paging.PagingVo;




@Service
public class HmProgrmUpdtService {

	@Autowired
	private IHmProgrmUpdtMapper hmProgrmUpdtMapper;

	@Autowired
	private IGetAgentJobMapper getAgentJobMapper;
	
	public List<HmProgrmUpdtVo> ListHmProgrmUpdt(HmProgrmUpdtVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("hmProgrmUpdtVo", vo);
		paramMap.put("pagingVo", pagingVo);

		List<HmProgrmUpdtVo> listVal = hmProgrmUpdtMapper.ListHmProgrmUpdt(paramMap);

		return listVal;
	}

	@Transactional
	public void InsertHmProgrmUpdt(HmProgrmUpdtVo nVo) throws Exception {

		String tmpPcmSeqVal = "{" + nVo.getProgrmCheckedList().toString() + "}";
		nVo.setPpa_pcm_seq(tmpPcmSeqVal);

		getAgentJobMapper.getAgentJobDelete();
		
		hmProgrmUpdtMapper.deleteHmProgrmUpdt(nVo);
		hmProgrmUpdtMapper.InsertHmProgrmUpdt(nVo);
	}
	
	/**
	 * 업데이트 정책 정보 가저오기
	 * @param vo
	 * @return
	 */
	public String selectHmProgrmUpdt(HmProgrmUpdtVo vo) {
		//log.info("====== vo : " + vo.toString());
		String updateManagementListStr = null;
		
		HmProgrmUpdtVo updateManagementList = hmProgrmUpdtMapper.selectHmProgrmUpdt(vo);
		
		if(null != updateManagementList && null != updateManagementList.getPpa_pcm_seq()) {
			updateManagementListStr = updateManagementList.getPpa_pcm_seq();
		}
		
		//log.info("====== updateManagementList.getPpa_pcm_seq() : " + updateManagementListStr);
		
		return updateManagementListStr;
	}

}