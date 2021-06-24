package com.paging;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

public class PagingVo {

	/**
	 * 한 페이지당 보여줄 record 수
	 */
	private int recordSize;
	/**
	 * 전체 record 수
	 */
	private int totalRecordSize;
	/**
	 * 한 블럭당 보여줄 사이즈 ex) 5 [1] [2] .. [5]
	 */
	private int blockSize;
	/**
	 * 블럭 그룹 사이즈
	 */
	private int blockGroupSize;
	/**
	 * 전체 페이지 수
	 */
	private int totalPageSize;
	/**
	 * 현재 페이지
	 */
	private int currentPage;
	/**
	 * 현재 페이지 블럭 그룹 번호
	 */
	private int currentBlockGroup;
	/**
	 * 페이징의 시작 페이지
	 */
	private int startPage;
	/**
	 * 페이징의 끝 페이지
	 */
	private int endPage;
	/**
	 * 정렬할 컬럼명
	 */
	private String orderByColumn = "";
	/**
	 * 정렬 타입 ASC/DESC
	 */
	private String orderByType = "";

	/**
	 * 페이지 링크시 화면 고정여부
	 */
	private String scrollView = "";
	/**
	 * Limit Start 값
	 */
	private int limitStart;


	public int getRecordSize() {
		return recordSize;
	}


	public void setRecordSize(int recordSize) {
		this.recordSize = recordSize;
	}


	public int getTotalRecordSize() {
		return totalRecordSize;
	}


	public void setTotalRecordSize(int totalRecordSize) {
		this.totalRecordSize = totalRecordSize;
	}


	public int getBlockSize() {
		return blockSize;
	}


	public void setBlockSize(int blockSize) {
		this.blockSize = blockSize;
	}


	public int getBlockGroupSize() {
		return blockGroupSize;
	}


	public void setBlockGroupSize(int blockGroupSize) {
		this.blockGroupSize = blockGroupSize;
	}


	public int getTotalPageSize() {
		return totalPageSize;
	}


	public void setTotalPageSize(int totalPageSize) {
		this.totalPageSize = totalPageSize;
	}


	public int getCurrentPage() {
		return currentPage;
	}


	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}


	public int getCurrentBlockGroup() {
		return currentBlockGroup;
	}


	public void setCurrentBlockGroup(int currentBlockGroup) {
		this.currentBlockGroup = currentBlockGroup;
	}


	public int getStartPage() {
		return startPage;
	}


	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}


	public int getEndPage() {
		return endPage;
	}


	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}


	public String getOrderByColumn() {
		return orderByColumn;
	}


	public void setOrderByColumn(String orderByColumn) {
		this.orderByColumn = orderByColumn;
	}


	public String getOrderByType() {
		return orderByType;
	}


	public void setOrderByType(String orderByType) {
		this.orderByType = orderByType;
	}


	public String getScrollView() {
		return scrollView;
	}


	public void setScrollView(String scrollView) {
		this.scrollView = scrollView;
	}


	public int getLimitStart() {
		return limitStart;
	}


	public void setLimitStart(int limitStart) {
		this.limitStart = limitStart;
	}


	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this, ToStringStyle.MULTI_LINE_STYLE);
	}
}