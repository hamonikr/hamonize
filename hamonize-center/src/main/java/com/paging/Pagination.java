package com.paging;


import java.io.Serializable;



/**
 * <pre>
 *  com.museo.base.mybatis Pagination
 *
 * class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author song
 * @see
 * @since 2015-12-16 오후 7:00
 */

public class Pagination implements Serializable {

	private static final long serialVersionUID = -674276250054474888L;

	public static final String PAGINATION_KEY = "pagination";

	private double max = 0;
	private double page = 1;
	private double totalCount = 0;


	public int getBegin() {
		return (int) Math.floor((page - 1) / max * max + 1);
	}


	public int getEnd() {
		return Math.min(getBegin() + 9, getTotalPage());
	}


	public int getPrev() {
		return Math.max(getBeginPage() - 1, 1);
	}


	public int getNext() {
		return Math.min(getEnd() + 1, getTotalPage());
	}


	public int getTotalPage() {
		return (int) Math.ceil((totalCount + (max - 1)) / max);
	}


	public int getBeginPage() {
		return (int) Math.floor((page - 1) / 10) * 10 + 1;
	}


	public int getEndPage() {
		return (int) Math.min(getBeginPage() + 9, getTotalPage());
	}


	public int getBeginList() {
		return (int) (totalCount - (page - 1) * max);
	}


	public boolean isEnded() {
		return page * max >= totalCount;
	}


}
