package com.service;

import java.util.HashMap;
import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IRestoreRecoveryMapper;
import com.model.BackupCycleVo;
import com.model.HmprogramVo;
import com.model.PcMangrVo;
import com.model.RecoveryVo;



@Service
public class BackupRecoveryService {

	private static final int HashMap = 0;

	@Autowired
	private IRestoreRecoveryMapper restoreRecoveryMapper;


	public HashMap<String, Object> restoreRecoveryList(RecoveryVo vo) {
		//log.info("====== backupRecoveryList - vo : " + vo.toString());
		
		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		RecoveryVo[] recoveryList = restoreRecoveryMapper.recoveryList(vo);
		PcMangrVo[] pcList = restoreRecoveryMapper.pcList(vo);
		
		//log.info("====== restoreRecoveryList - recoveryList : " + recoveryList);
		//log.info("====== restoreRecoveryList - pcList : " + pcList);
		
		paramMap.put("recoveryList", recoveryList);
		paramMap.put("pcList", pcList);

		return paramMap;
	}
	
	
	@Transactional
	public void recoveryInfoInsert(RecoveryVo vo) throws Exception {
		restoreRecoveryMapper.recoveryInfoInsert(vo);
	}
}