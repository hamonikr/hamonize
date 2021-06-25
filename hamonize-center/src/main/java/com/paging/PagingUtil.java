package com.paging;


/**
 * 페이징 관련 유틸
 * @author hskim
 *
 */
public class PagingUtil {

	/**
	 * 기본 페이징 값 recordSize = 5 currentPage = 1 blockSize = 5
	 */
	public static final int DefaultPaging = 0;
	/**
	 * 테스트용 설정 값
	 */
	public static final int TestPaging = 99;

	/**
	 *  페이징 설정값
	 */
	public static final int CustomerPaging = 9;
	/**
	 * 불량회원 이력 페이징 값
	 */
	public static final int BlackUserHistPaging = 10;

	/**
	 * 캐시내역 페이징 값
	 */
	public static final int UserCashPaging = 11;

	/**
	 * 게시글관리 페이징 값
	 */
	public static final int CommunityPaging = 12;

	/**
	 * 댓글관리 페이징 값
	 */
	public static final int CommentPaging = 13;
	
	
	/**
	 * 레이어 팝업 페이징 
	 */
	public static final int LayerPopupPaging = 14;


	/**
	 * 기본 페이징 값 설정 기본 페이징을 표시 형식에 따라 다르게 표현하고 싶을때 구분값 추가
	 * @param div
	 * @param paging
	 * @return
	 */
	public static PagingVo setDefaultPaging(int div, PagingVo paging) {
		int recordSize = 0;
		int currentPage = 0;
		int blockSize = 0;
		switch (div) {
		case DefaultPaging:
			recordSize = 10;
			currentPage = 1;
			blockSize = 10;
			break;
		case TestPaging:
			recordSize = 3;
			currentPage = 1;
			blockSize = 5;
			break;
		case BlackUserHistPaging:
			recordSize = 10;
			currentPage = 1;
			blockSize = 10;
			break;
		case UserCashPaging:
			recordSize = 20;
			currentPage = 1;
			blockSize = 10;
			break;
		case CustomerPaging:
			recordSize = 15;
			currentPage = 1;
			blockSize = 10;
			break;
		case CommunityPaging:
			recordSize = 15;
			currentPage = 1;
			blockSize = 10;
			break;
		case CommentPaging:
			recordSize = 15;
			currentPage = 1;
			blockSize = 10;
			break;
		case LayerPopupPaging:
			recordSize=5;
			currentPage=1;
			blockSize=10;
			break;
		default:
			recordSize = 10;
			currentPage = 1;
			blockSize = 10;
			break;
		}

		// 레코드 갯수 Default 20
		if (paging.getRecordSize() == 0) {
			paging.setRecordSize(recordSize); // 임시 5
		}
		// 현재 페이지 번호 Default 1
		if (paging.getCurrentPage() == 0) {
			paging.setCurrentPage(currentPage);
		}
		// 페이징
		if (paging.getBlockSize() == 0) {
			paging.setBlockSize(blockSize);
		}
		return paging;
	}


	/**
	 * 페이징 정보 설정
	 * @param paging
	 * @return
	 */
	public static PagingVo setPaging(PagingVo paging) {
		System.out.println("setPaging==========================");
		int nBlockGrpSize = (int) Math
				.ceil((float) paging.getTotalRecordSize() / (float) (paging.getRecordSize() * paging.getBlockSize())); //블록 그룹 size
		int nTotalPageSize = (int) Math.ceil((float) paging.getTotalRecordSize() / (float) paging.getRecordSize()); //전체 페이지수
		int nCurrentBlockGrp = (int) Math.ceil((float) paging.getCurrentPage() / (float) paging.getBlockSize()); //현재 페이지가 속한 블록그룹번호

		int nStartPage = 0; //페이징의 시작 페이지 번호
		int nEndPage = 0; //페이징의 끝 페이지 번호
		int nLimitStart = paging.getRecordSize() * (paging.getCurrentPage() == 0 ? 1 : paging.getCurrentPage() - 1);
		
		System.out.println("paging.getRecordSize()===="+ paging.getRecordSize());
		System.out.println("paging.getCurrentPage()===="+ paging.getCurrentPage());
		System.out.println("nLimitStart==============="+ nLimitStart);
		//페이징의 시작페이지와  끝페이지 정의
		if (nCurrentBlockGrp == nBlockGrpSize) {
			//만약 현재 페이지가 속한 그룹이 마지막 그룹이라면 .._10개짜리 페이지블록에서 [11][12][13] 요렇게  3개만 나와야 할경우
			nStartPage = (nCurrentBlockGrp * paging.getBlockSize()) - (paging.getBlockSize() - 1);
			//마지막을 전체 페이지 번호까지
			nEndPage = nTotalPageSize;
		}
		else if (nCurrentBlockGrp < nBlockGrpSize) {
			//만약 현재 페이지가 속한 블록 그룹이 마지막블록그룹보다 작다면
			nStartPage = (nCurrentBlockGrp * paging.getBlockSize()) - (paging.getBlockSize() - 1);
			nEndPage = nCurrentBlockGrp * paging.getBlockSize();
		}

		paging.setBlockGroupSize(nBlockGrpSize);
		paging.setTotalPageSize(nTotalPageSize);
		paging.setCurrentBlockGroup(nCurrentBlockGrp);
		paging.setStartPage(nStartPage);
		paging.setEndPage(nEndPage);
		paging.setLimitStart(nLimitStart);

		return paging;
	}
}
