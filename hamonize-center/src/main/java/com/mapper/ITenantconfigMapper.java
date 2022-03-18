package com.mapper;

import com.model.SvrlstVo;
import com.model.TenantconfigVo;

public interface ITenantconfigMapper {
	
	public int tenantInfoSave(TenantconfigVo vo);

	public TenantconfigVo getTenantRemoteConfig( TenantconfigVo vo);
	
	public SvrlstVo getSvrLdapInfo();


}
