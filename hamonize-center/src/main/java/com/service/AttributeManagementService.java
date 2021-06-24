package com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IAttributeMapper;
import com.model.AttributeVo;

@Service
public class AttributeManagementService {

	@Autowired
	private IAttributeMapper attributeDao;

	public void addAttribute(AttributeVo aVo) {

		String attrValueCode = "";
		
		if( "A".equals(aVo.getOptradio()) ){
			aVo.setAttr_value_code("000");
			aVo.setAttr_value_name("선택");
		}else{
			aVo.setAttr_value_code(attributeDao.getMaxAttrCode(aVo));
		}
		
		AttributeVo attributeVo = new AttributeVo();

		attributeVo.setAttr_code(aVo.getAttr_code());
		attributeVo.setAttr_name(aVo.getAttr_name());
		attributeVo.setAttr_value_code(aVo.getAttr_value_code());
		attributeVo.setAttr_value_name(aVo.getAttr_value_name());

		attributeDao.save(attributeVo);

	}

	public void modifyAttribute(String attrCode, String nameValue, List<String> values) {

		int attrValueCode = attributeDao.getMaxAttrValueCode();

		for (String value : values) {

			AttributeVo attributeVo = new AttributeVo();

			if (value.length() != 0 || value != "") {

				attributeVo.setAttr_code(attrCode);
				attributeVo.setAttr_name(nameValue);
				attributeVo.setAttr_value_code(Integer.toString(attrValueCode));
				attributeVo.setAttr_value_name(value);

				attributeDao.save(attributeVo);

				attrValueCode++;
			}
		}
	}
}
