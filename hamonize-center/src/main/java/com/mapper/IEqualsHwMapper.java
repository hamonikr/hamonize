package com.mapper;

import com.model.EqualsHwVo;
import com.model.PcMangrVo;

public interface IEqualsHwMapper {
	
	public int pcHWInfoInsert(EqualsHwVo vo);

	public int pcMngrModify(EqualsHwVo vo);

	public PcMangrVo getPCinfo (EqualsHwVo pvo);

}
