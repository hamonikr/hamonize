package com.service;

import java.util.HashMap;
import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IGetAgentJobMapper;
import com.mapper.IHmSecurityMapper;
import com.model.HmSecurityVo;
import com.paging.PagingVo;

@Service
public class HmSecurityService {

	@Autowired
	private IHmSecurityMapper hmSecurityMapper;

	@Autowired
	private IGetAgentJobMapper getAgentJobMapper;

	public List<HmSecurityVo> ListHmSecurity(HmSecurityVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("hmProgrmUpdtVo", vo);
		paramMap.put("pagingVo", pagingVo);

		List<HmSecurityVo> listVal = hmSecurityMapper.ListHmSecurity(paramMap);

		return listVal;
	}

	@Transactional
	public void InsertHmSecurity(HmSecurityVo nVo) throws Exception {

		String tmpPcmSeqVal = "{" + nVo.getProgrmCheckedList().toString() + "}";
		nVo.setPpa_pcm_seq(tmpPcmSeqVal);

		getAgentJobMapper.getAgentJobDelete();

		hmSecurityMapper.deleteHmSecurity(nVo);
		int tt = hmSecurityMapper.InsertHmSecurity(nVo);
	}

	/**
	 * 업데이트 정책 정보 가저오기
	 * 
	 * @param vo
	 * @return
	 */
	public String selectHmSecurity(HmSecurityVo vo) {
		String securityListStr = null;

		HmSecurityVo securityList = hmSecurityMapper.selectHmSecurity(vo);

		if (null != securityList && null != securityList.getPpa_pcm_seq()) {
			securityListStr = securityList.getPpa_pcm_seq();
		}

		return securityListStr;
	}

}