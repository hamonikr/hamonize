package com.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.model.AnswerVo;
import com.model.TchnlgyVo;

public interface ITchnlgyMapper {

	public void tchnlgyInsert(TchnlgyVo vo);

	public TchnlgyVo countMngrListInfo(TchnlgyVo vo);

	public List<TchnlgyVo> tchnlgyListInfo(HashMap<String, Object> paramMap);
	
	public TchnlgyVo tchnlgyViewInfo(TchnlgyVo vo);

	public int tchnlgyUpdateProc(TchnlgyVo nVo) throws Exception;

	public int tchnlgyDeleteProc(TchnlgyVo vo) throws Exception;

	public int tchnlgyAnswerInsertProc(AnswerVo vo) throws Exception;

	public int tchnlgyAnswerDeleteProc(AnswerVo vo) throws Exception;

	public List<AnswerVo> tchnlgyAnswerList(TchnlgyVo vo);
	
	public List<Map<String, Object>> mngrListExcel(TchnlgyVo vo);
}
