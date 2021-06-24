package com.mapper;

import java.util.List;

import com.model.AttributeVo;

public interface IAttributeMapper {

	
	
	String getMaxAttrCode( AttributeVo avo);
	
	
	List<AttributeVo> commcodeListInfo(AttributeVo vo);
	
	
	// ========================
	
	
	
	
	
	
	List<AttributeVo> listCategoryMultipleAttribute();

	/**
	 * 상품속성 상세속성 호출
	 */
	List<String> getDetailAttribute(String attrCode);

	/**
	 * 상품속성 기본속성 호출
	 */
	AttributeVo getAttrName(String attrCode);

	/*
	 * 상품속성 등록 및 수정
	 */
	int save(AttributeVo attributeVo);

	

	/**
	 * 상품속성 attrValueCode 이어서 발급
	 */
	int getMaxAttrValueCode();

}
