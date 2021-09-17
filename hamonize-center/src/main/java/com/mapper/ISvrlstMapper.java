package com.mapper;

import java.util.HashMap;
import java.util.List;

import com.model.HmProgrmUpdtVo;
import com.model.SvrlstVo;

public interface ISvrlstMapper {

	public List<SvrlstVo> getSvrlstList(HashMap<String, Object> map);
	
	public List<SvrlstVo> getVpnSvrlstList();

	public int countSvrlstListInfo(SvrlstVo vo);

	public int svrlstInsert(SvrlstVo vo);

	public List<SvrlstVo> getSvrlstDataList();

	public int svrlstDelete(SvrlstVo vo);

	public int vpnUsedUpdate(SvrlstVo vo);

	public List<HmProgrmUpdtVo> getProgrmList();

	public int updatePollingTime(HmProgrmUpdtVo vo);
}
