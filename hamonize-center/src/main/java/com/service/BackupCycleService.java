package com.service;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IBackupCycleMapper;
import com.model.BackupCycleVo;




@Service
public class BackupCycleService {

	private static final int HashMap = 0;

	@Autowired
	private IBackupCycleMapper backupCycleMapper;


	@Transactional
	public void backupCycleInsert(BackupCycleVo vo) throws Exception {
		backupCycleMapper.deleteBackupCycle(vo);
		backupCycleMapper.backupCycleInsert(vo);
	}

	
	public BackupCycleVo backupCycleList(BackupCycleVo vo) {
		//log.info("====== vo : " + vo.toString());
		
		BackupCycleVo backupCycleList = backupCycleMapper.backupCycleList(vo);
		
		//log.info("====== backupCycleList.getBac_cycle_option() : " + backupCycleList);
		
		return backupCycleList;
	}
}