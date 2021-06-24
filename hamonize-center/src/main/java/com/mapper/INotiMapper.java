package com.mapper;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.model.NotiVo;

public interface INotiMapper {

	public List<NotiVo> notiListInfo(HashMap<String, Object> map);

	public int countMngrListInfo(NotiVo vo);
	
	public void notiInsert(NotiVo vo);
	
	public NotiVo notiViewInfo(NotiVo vo);
	
	public void increaseHit(int noti_seq);
	
	public int notiUpdateProc(NotiVo vo) throws SQLException;
	
	public void notiDelete(int seq)throws SQLException;
	
	
// ======================================	
	
	public int insertMngeUserInfo(NotiVo vo);

	public int mngeIdDuplicateChk(NotiVo vo);

	public int mngeUpdateCheck(NotiVo vo);
	
	public int saveFile(Map<String, Object> params);

}
