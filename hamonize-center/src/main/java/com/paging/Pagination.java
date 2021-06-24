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

	private int max = 0;
	private int page = 1;
	private int totalCount = 0;
	private boolean enable = false;


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
		return Math.min(getBeginPage() + 9, getTotalPage());
	}


	public int getBeginList() {
		return (totalCount - (page - 1) * max);
	}


	public boolean isEnded() {
		return page * max >= totalCount;
	}


	/*public static void main(String... args) {
		Pagination p = new Pagination();
		p.setMax(10);
		p.setTotalCount(182);
		p.setPage(18);

		System.out.println(p);
		System.out.println(p.getBeginPage());
		System.out.println(p.getPrev());
		System.out.println(p.getBegin());
		System.out.println(p.getEnd());
		System.out.println(p.getBeginList());
		System.out.println(p.isEnded());
	}*/

}
