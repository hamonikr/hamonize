package com.util;


public class Constant {
	
	
    public static class Board{
        public static final String NUM="num";
        public static final String NAME="name";
        public static final String PASS="pass";
        public static final String CONTENT="content";
        public static final String EMAIL="email";
        public static final String READCOUNT="readCount";
        public static final String WRITEDATE="writedate";
        public static final String TITLE="title";
        public static final String SUCCESS_FAIL = "등록중 오류가 발생하였습니다. 이용에 불편을 드려서 죄송합니다.";
        public static final String SUCCESS_QUEST = "문의하신내용이 정상적으로 등록되었습니다. 이메일로 문의내용을 알려드리겠습니다.";
        public static final String SUCCESS_GROUP_BOARD = "정상적으로 등록되었습니다.";
        public static final String SUCCESS_DELETE = "정상적으로 삭제되었습니다.";
        public static final String SUCCESS_DELETE_FAIL = "삭제중 오류가 발생하였습니다. 이용에 불편을 드려서 죄송합니다.";
    }
    public static class Member{
    	public static final String SUCCESS_LOGIN = "정상적으로 회원가입이 완료되었습니다. 로그인을 해주시기바랍니다.";
    	public static final String SUCCESS_FAIL = "회원가입시 오류가 발생하였습니다. 다시 회원가입 해주시기 바랍니다.";
    	public static final String DUP_EMAIL = "이미 사용중인 이메일이거나 탈퇴한 이메일입니다.";
    	public static final String USER_PW_ERROR = "비밀번호 오류";
    	public static final String NOT_HOTEL_ERROR = "호텔정보가 입력되지 않았습니다.";
    	public static final String DUP_GRUOP_TITLE_ERROR = "중복된 그룹명입니다.";
    }
    
    public static class Group{
    	public static final String FAIL_GET_LIST= "목록을 불러올 수 없습니다.";
    	public static final String SUCCESS_DELETE= "그룹을 삭제하였습니다.";
    	public static final String FAIL_DELETE= "그룹 삭제 시 오류가 발생하였습니다.";
    	public static final String SUCCESS_CREATE = "그룹 생성에 성공하였습니다.";
    	public static final String FAIL_CREATE = "그룹 생성 시 오류가 발생하였습니다.";
    	public static final String ERROR_PW = "비밀번호가 일치 하지 않습니다. 다시 과정을 진행해 주시기 바랍니다.";
    }
    
    
    public static class Persion{
    	public static final String PERSION_INFO_SECCESS = "그룹 생성에 성공하였습니다.";
    	public static final String PERSION_INFO_FAIL = "그룹 생성 시 오류가 발생하였습니다.";
    	public static final String PERSION_INFO_ERROR = "비밀번호가 일치 하지 않습니다. 다시 과정을 진행해 주시기 바랍니다.";
    	public static final String PERSION_INFO_DONTCHANGE = "DONTCHANGE";
    }
    
    
    public static class Reserve{
    	public static final String Reserve_INFO_SECCESS = "예약문의 등록이 완료되었습니다. ";
    	public static final String Reserve_INFO_FAIL = "예약문의 등록중 오류가 발생하였습니다. ";
    	public static final String RESERVE_ADDITIONAL_INFO_SUCCESS =  "추가정보를 등록하였습니다.";
    	public static final String RESERVE_ADDITIONAL_INFO_FAIL =  "추가정보를 등록에 실패하였습니다.";
    }
}