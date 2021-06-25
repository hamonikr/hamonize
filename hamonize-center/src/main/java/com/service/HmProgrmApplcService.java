package com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IHmProgrmApplcMapper;
import com.model.HmprogramapplcVo;
import com.paging.PagingVo;

@Service
public class HmProgrmApplcService {

	@Autowired
	private IHmProgrmApplcMapper hmProgrmApplcMapper;

	public List<HmprogramapplcVo> ListHmProgrmUpdt(HmprogramapplcVo vo, PagingVo pagingVo) {

		List<HmprogramapplcVo> listVal = hmProgrmApplcMapper.ListHmProgrmApply(vo);

		return listVal;
	}

	

}