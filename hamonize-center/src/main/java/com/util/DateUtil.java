package com.util;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.StringTokenizer;
import java.util.TimeZone;
import java.util.Vector;

/*
 * <pre> com.skt.tvalley.web.common.DateUtil.java DESC: 클래스설명. </pre>
 * 
 * @author tjkim
 * 
 * @since 2015. 10. 1.
 * 
 * @version 1.0
 *
 */
public class DateUtil {

    private static String WHITE_SPACE = " ";

    public static final String DEFAULT_DATE_FORMAT = "yyyyMMdd";
    public static final String SLASH_DATE_FORMAT = "yyyy/MM/dd";
    public static final String HYPHEN_DATE_FORMAT = "yyyy-MM-dd";
    public static final String HANGEUL_DATE_FORMAT = "yyyy년MM월dd일";
    public static final String HANGEUL_DATE_FORMAT2 = "yyyy년 MM월 dd일";

    public static final String DEFAULT_TIME_FORMAT = "HHmmss";
    public static final String COLON_TIME_FORMAT = "HH:mm:ss";
    public static final String HANGEUL_TIME_FORMAT = "HH시mm분ss초";

    public static final String DEFAULT_DATETIME_FORMAT = DEFAULT_DATE_FORMAT + DEFAULT_TIME_FORMAT;
    public static final String SLASH_DATETIME_FORMAT =
            SLASH_DATE_FORMAT + WHITE_SPACE + COLON_TIME_FORMAT;
    public static final String HYPHEN_DATETIME_FORMAT =
            HYPHEN_DATE_FORMAT + WHITE_SPACE + COLON_TIME_FORMAT;
    public static final String HANGEUL_DATETIME_FORMAT =
            HANGEUL_DATE_FORMAT + WHITE_SPACE + HANGEUL_TIME_FORMAT;

    private DateUtil() {

    }

    /*
     * 주어진 날자를 일자(yyyyMMdd)형 문자열로 변환한다.<br>
     * 
     * ex) 20070912
     * 
     * @param date
     * 
     * @return
     */
    public static String formatDate(Date date) {
        return format(date, DEFAULT_DATE_FORMAT);
    }

    public static String getToday(String fmt) {
        SimpleDateFormat sfmt = new SimpleDateFormat(fmt);
        return sfmt.format(new Date());
    }

    /*
     * 주어진 날자를 일자형 문자열(yyyy/MM/dd)로 변환한다.<br>
     * 
     * ex) 2007/09/12
     * 
     * @param date
     * 
     * @return
     */
    public static String formatDateBySlash(Date date) {
        return format(date, SLASH_DATE_FORMAT);
    }

    /**
     * 주어진 날자를 일자형 문자열(yyyy-MM-dd)로 변환한다.<br>
     * 
     * ex) 2007-09-12
     * 
     * @param date
     * @return
     */
    public static String formatDateByHyphen(Date date) {
        return format(date, HYPHEN_DATE_FORMAT);
    }

    /**
     * 주어진 날자를 일자형 문자열(yyyy년MM월dd일)로 변환한다.<br>
     * 
     * ex) 2007년09월12일
     * 
     * @param date
     * @return
     */
    public static String formatDateByHangeul(Date date) {
        return format(date, DEFAULT_DATE_FORMAT);
    }

    /**
     * 주어진 날자를 시간형 문자열(HHmmss)로 변환한다.(00-23시 표기형)<br>
     * 
     * ex) 202510
     * 
     * @param date
     * @return
     */
    public static String formatTime(Date date) {
        return format(date, DEFAULT_TIME_FORMAT);
    }

    /**
     * 주어진 날자를 시간형 문자열(HH:mm:ss)로 변환한다.<br>
     * 
     * ex) 20:25:10
     * 
     * @param date
     * @return
     */
    public static String formatTimeByColon(Date date) {
        return format(date, COLON_TIME_FORMAT);
    }

    /**
     * 주어진 날자를 시간형 문자열(HH시mm분ss초)로 변환한다.<br>
     * 
     * ex) 20시25분10초
     * 
     * @param date
     * @return
     */
    public static String formatTimeByHangeul(Date date) {
        return format(date, HANGEUL_TIME_FORMAT);
    }

    /**
     * 주어진 날자를 일시형 문자열(yyyyMMddHHmmss)로 변환한다.<br>
     * 
     * ex) 20070912202510
     * 
     * @param date
     * @return
     */
    public static String formatDateTime(Date date) {
        return format(date, DEFAULT_DATETIME_FORMAT);
    }

    /**
     * 주어진 날자를 일시형 문자열(yyyy/MM/dd HH:mm:ss)로 변환한다.<br>
     * 
     * ex) 2007/09/12 20:25:10
     * 
     * @param date
     * @return
     */
    public static String formatDateTimeBySlash(Date date) {
        return format(date, SLASH_DATETIME_FORMAT);
    }

    /**
     * 주어진 날자를 일시형 문자열(yyyy-MM-dd HH:mm:ss)로 변환한다.<br>
     * 
     * ex) 2007-09-12 20:25:10
     * 
     * @param date
     * @return
     */
    public static String formatDateTimeByHyphen(Date date) {
        return format(date, HYPHEN_DATETIME_FORMAT);
    }

    /**
     * 주어진 날자를 일시형 문자열(yyyy년MM월dd일 HH시mm분ss초)로 변환한다.<br>
     * 
     * ex) 2007년09월12일 20시25분10초
     * 
     * @param date
     * @return
     */
    public static String formatDateTimeByHangeul(Date date) {
        return format(date, HANGEUL_DATETIME_FORMAT);
    }

    /**
     * 주어진 날자를 특정 패턴형식으로 변환한다.<br>
     * 
     * <pre>
     * DateUtil.format(new Date(), "yyyy/MM/dd")          = 2007/09/12
     * DateUtil.format(new Date(), "yyyy/MM/dd HH:mm:ss") = 2007/09/12 20:25:10
     * </pre>
     * 
     * @param date
     * @return
     */
    public static String format(Date date, String pattern) {
        SimpleDateFormat df = new SimpleDateFormat();
        df.applyPattern(pattern);

        return df.format(date);
    }

    /**
     * 주어진 일자형 문자열(yyyyMMdd)을 날자타입으로 변환한다.
     * 
     * ex) 20070912
     * 
     * @param src
     * @return
     */
    public static Date parseDate(String src) {
        return parseDate(src, DEFAULT_DATE_FORMAT);
    }

    /**
     * 주어진 일자형 문자열(yyyy/MM/dd)을 날자타입으로 변환한다.
     * 
     * ex) 2007/09/12
     * 
     * @param src
     * @return
     */
    public static Date parseDateBySlash(String src) {
        return parseDate(src, SLASH_DATE_FORMAT);
    }

    /**
     * 주어진 일자형 문자열(yyyy-MM-dd)을 날자타입으로 변환한다.
     * 
     * ex) 2007-09-12
     * 
     * @param src
     * @return
     */
    public static Date parseDateByHyphen(String src) {
        return parseDate(src, HYPHEN_DATE_FORMAT);
    }

    /**
     * 주어진 일자형 문자열(yyyy년MM월dd일)을 날자타입으로 변환한다.
     * 
     * ex) 2007년09월12일
     * 
     * @param src
     * @return
     */
    public static Date parseDateByHangeul(String src) {
        return parseDate(src, HANGEUL_DATE_FORMAT);
    }

    /**
     * 주어진 일시형 문자열(yyyyMMddHHmmss)을 날자타입으로 변환한다.
     * 
     * ex) 20070912092025
     * 
     * @param src
     * @return
     */
    public static Date parseDateTime(String src) {
        return parseDate(src, DEFAULT_DATETIME_FORMAT);
    }

    /**
     * 주어진 일시형 문자열(yyyy/MM/dd HH:mm:ss)을 날자타입으로 변환한다.
     * 
     * ex) 2007/09/12 09:20:25
     * 
     * @param src
     * @return
     */
    public static Date parseDateTimeBySlash(String src) {
        return parseDate(src, SLASH_DATETIME_FORMAT);
    }

    /**
     * 주어진 일시형 문자열(yyyy-MM-dd HH:mm:ss)을 날자타입으로 변환한다.
     * 
     * ex) 2007-09-12 09:20:25
     * 
     * @param src
     * @return
     */
    public static Date parseDateTimeByHyphen(String src) {
        return parseDate(src, HYPHEN_DATETIME_FORMAT);
    }

    /**
     * 주어진 일시형 문자열(yyyy년MM월dd일 HH시mm분ss초)을 날자타입으로 변환한다.
     * 
     * ex) 2007년09월12일 09시20분25초
     * 
     * @param src
     * @return
     */
    public static Date parseDateTimeByHangeul(String src) {
        return parseDate(src, HANGEUL_DATETIME_FORMAT);
    }

    /**
     * 주어진 문자열을 특정 패턴으로 날자타입으로 변환한다.
     * 
     * <pre>
     * DateUtil.parseDate("2007/09/12", "yyyy/MM/dd") 
     * DateUtil.parseDate("2007/09/12 20:25:10", "yyyy/MM/dd HH:mm:ss")
     * </pre>
     * 
     * @param src
     * @return
     */
    public static Date parseDate(String src, String pattern) {
        try {
            SimpleDateFormat df = new SimpleDateFormat();
            df.applyPattern(pattern);

            return df.parse(src);
        } catch (ParseException e) {
            throw new RuntimeException("can not parse string date : " + src + ":" + pattern);
        }
    }

    /**
     * 현재 일시를 string형으로 리턴한다.
     * 
     * @return
     */
    public static String getCurrentDateString() {
        return formatDate(getCurrentDateTime());
    }

    /**
     * 현재 일시를 slash가 있는 string형으로 리턴한다.
     * 
     * @return
     */
    public static String getCurrentDateStringBySlash() {
        return formatDateBySlash(getCurrentDateTime());
    }

    /**
     * 현재 일시를 hyphen이 있는 string형으로 리턴한다.
     * 
     * @return
     */
    public static String getCurrentDateStringByHyphen() {
        return formatDateByHyphen(getCurrentDateTime());
    }

    /**
     * 현재 일시를 한글 string형으로 리턴한다.
     * 
     * @return
     */
    public static String getCurrentDateStringByHangeul() {
        return formatDateByHangeul(getCurrentDateTime());
    }

    /**
     * 주어진 문자열을 특정 패턴의 날자타입으로 변환한다.
     * 
     * 
     * @param pattern
     * @return
     */
    public static String getCurrentDateString(String pattern) {
        return format(getCurrentDateTime(), pattern);
    }

    /**
     * 현재 일시를 일시형 문자열(yyyyMMddHHmmss)로 변환한다.<br>
     * 
     * @return
     */
    public static String getCurrentDateTimeString() {
        return formatDateTime(getCurrentDateTime());
    }

    /**
     * 현재 일시를 date형으로 리턴한다.
     * 
     * @return
     */
    public static Date getCurrentDateTime() {
        return Calendar.getInstance().getTime();
    }

    /**
     * 현재 일시를 slash가 있는 일시형 문자열(yyyyMMddHHmmss)로 변환한다.<br>
     * 
     * @return
     */
    public static String getCurrentDateTimeStringBySlash() {
        return formatDateTimeBySlash(getCurrentDateTime());
    }

    /**
     * 현재 일시를 hyphen이 있는 일시형 문자열(yyyyMMddHHmmss)로 변환한다.<br>
     * 
     * @return
     */
    public static String getCurrentDateTimeStringByHyphen() {
        return formatDateTimeByHyphen(getCurrentDateTime());
    }

    /**
     * 현재 일시를 한글 일시형 문자열(yyyyMMddHHmmss)로 변환한다.<br>
     * 
     * @return
     */
    public static String getCurrentDateTimeStringByHangeul() {
        return formatDateTimeByHangeul(getCurrentDateTime());
    }

    /**
     * 두 날짜의 크기를 비교하여 date1이 크면 1, 같으면 0, 작으면 -1을 반환
     *
     * @param date1
     * @param date2
     * @return
     */
    public static int compareDate(String date1, String date2) {

        for (int i = 0; i < date1.length(); i++) {
            if (date1.charAt(i) > date2.charAt(i)) {
                return 1;
            } else if (date1.charAt(i) < date2.charAt(i)) {
                return -1;
            } else {
                continue;
            }
        }

        return 0;

    }


    /**
     * 특정문자형 날짜형식의 특별한 타입의 일정량을 증가하거나 감소한 문자열을 반환( yyyymmdd )
     *
     * @param date
     * @param type
     * @param amt
     * @return
     */
    public static String getAddDate(String date, int type, int amt) {

        // 캘린더 객체 생성
        Calendar cal = Calendar.getInstance();

        // 문자열 날짜로 변환하여 시간 세팅
        cal.setTime(getDate(date));
        // 더함
        cal.add(type, amt);

        return getDate(cal.getTime());

    }


    /**
     * 첫번째 인자의 날짜를 기준으로 두 번째 인자의 일 수를 더한 yyyymmdd 형태의 날짜를 반환
     *
     * @param ymd
     * @param day
     * @return
     */
    public static String getAddDateByDay(String ymd, int day) {
        return getAddDate(ymd, Calendar.DATE, day);
    }


    /**
     * 첫번째 인자의 날짜를 기준으로 두 번째 인자의 개월 수를 더한 yyyymmdd 형태의 날짜를 반환
     *
     * @param ymd
     * @param month
     * @return
     */
    public static String getAddDateByMonth(String ymd, int month) {
        return getAddDate(ymd, Calendar.MONTH, month);
    }


    /**
     * 첫번째 인자의 날짜를 기준으로 두 번째 인자의 연 수를 더한 yyyymmdd 형태의 날짜를 반환
     *
     * @param ymd
     * @param year
     * @return
     */
    public static String getAddDateByYear(String ymd, int year) {
        return getAddDate(ymd, Calendar.YEAR, year);
    }


    /**
     * 
     * 현재 시간을 문자열로 변환하여 반환함<br>
     * hh24miss0 형태로 반환.
     * 
     * @return
     */
    public static String getCurrentTime() {
        Calendar v_date = Calendar.getInstance(TimeZone.getTimeZone("JST"));
        String v_hour = Integer.toString(v_date.get(Calendar.HOUR_OF_DAY));

        if (v_hour.length() == 1)
            v_hour = "0" + v_hour;

        String v_minute = Integer.toString(v_date.get(Calendar.MINUTE));

        if (v_minute.length() == 1)
            v_minute = "0" + v_minute;

        String v_second = Integer.toString(v_date.get(Calendar.SECOND));

        if (v_second.length() == 1)
            v_second = "0" + v_second;

        return new StringBuffer().append(v_hour).append(v_minute).append(v_second).append("0")
                .toString();
    }

    /**
     * 현재 날짜를 스트링 형태로 반환 예) 20031010
     *
     * @return 현재날짜
     */
    public static String getCurrDate() {
        return getCurrDate("");
    }

    /**
     * 
     * 현재 날짜를 문자열로 변환하여 반환함<br>
     * yyyy/mm/dd 형태로 반환
     * 
     * @return
     */
    public static String getCurrentDate() {
        Calendar v_date = Calendar.getInstance(TimeZone.getTimeZone("JST"));
        String v_year = Integer.toString(v_date.get(Calendar.YEAR));
        String v_month = Integer.toString(v_date.get(Calendar.MONTH) + 1);

        if (v_month.length() == 1)
            v_month = "0" + v_month;

        String v_day = Integer.toString(v_date.get(Calendar.DAY_OF_MONTH));

        if (v_day.length() == 1)
            v_day = "0" + v_day;

        return new StringBuffer().append(v_year).append("/").append(v_month).append("/")
                .append(v_day).toString();
    }

    /**
     * 지금 현 시점의 Date형 객체를 반환
     *
     * @return
     */
    public static java.sql.Date getCurrSqlDate() {
        return new java.sql.Date(System.currentTimeMillis());
    }


    /**
     * 전달받은 토큰으로 형식화 한 현재 날짜를 스트링 형태로 반환 예) 2003-10-10
     *
     * @param tok
     * @return 형식화된 현재날짜
     */
    public static String getCurrDate(String tok) {
        return new SimpleDateFormat("yyyy" + tok + "MM" + tok + "dd").format(new Date());
    }


    /**
     * 현재 시간 및 날짜를 스트링 형태로 반환 예) 20031010100333
     *
     * @return 현재날짜 및 시간
     */
    public static String getCurrDateTime() {
        return new SimpleDateFormat("yyyyMMddkkmmss").format(new Date());
    }


    /**
     * 현재 날짜 및 시간, 밀리초를 스트링 형태로 반환<br>
     * 예) 20031010100333862
     *
     * @return
     */
    public static String getCurrDateTimeMillis() {
        return new SimpleDateFormat("yyyyMMddkkmmssS").format(new Date());
    }


    /**
     * 전달받은 토큰으로 형식화 한 현재 시간 및 날짜를 스트링 형태로 반환 예) 2003-10-10 10:03:33
     *
     * @return 현재날짜 및 시간
     */
    public static String getCurrDateTime(String tokDate, String tokTime) {
        return new SimpleDateFormat(
                "yyyy" + tokDate + "MM" + tokDate + "dd" + " kk" + tokTime + "mm" + tokTime + "ss")
                        .format(new Date());
    }


    /**
     * 현재의 연도를 int형태로 반환
     * 
     * @return
     */
    public static int getCurrYear() {
        return Integer.parseInt(getCurrDate().substring(0, 4));
    }


    /**
     * 현재의 월을 int 형태로 반환
     *
     * @return
     */
    public static int getCurrMonth() {
        return Integer.parseInt(getCurrDate().substring(4, 6));
    }


    /**
     * 설정된 날자정보의 yyyymmdd형의데이타를 반환
     *
     * @return
     */
    public static String getDate(Date date) {
        return new SimpleDateFormat("yyyyMMdd").format(date);
    }


    /**
     * 설정된 날짜정보의 yyyymmddhh24miss 형의 데이타를 반환
     *
     * @return
     */
    public static String getDateTime(Date date) {
        return new SimpleDateFormat("yyyyMMddkkmmss").format(date);
    }


    /**
     * 설정된 TimeStamp정보의 yyyymmddhh24miss 형의 데이타를 반환
     *
     * @param Timestamp
     * @return
     */
    public static String getDateTime(Timestamp ts) {
        return new SimpleDateFormat("yyyyMMddkkmmss").format(ts);
    }


    /**
     * 설정된 날짜정보의 hh24miss형태의 데이타를 반환
     *
     * @return
     */
    public static String getTime(Date date) {
        return new SimpleDateFormat("kkmmss").format(date);
    }


    /**
     *
     * <pre>
     * 넘겨받은 hh24miss 시간 포맷 스트링으로 Date 형태로 변환하여 반환
     * </pre>
     *
     * @param time
     * @return
     */
    public static Date getTime(String time) {

        // 연월일 분리
        int hour = Integer.parseInt(time.substring(0, 2));
        int minuite = Integer.parseInt(time.substring(2, 4));
        int second = Integer.parseInt(time.substring(4, 6));

        // 캘린더 객체 생성 및 세팅
        Calendar cal = Calendar.getInstance();
        cal.set(0, 0, 0, hour, minuite, second);

        return cal.getTime();

    }


    /**
     * 현재 설정된 날짜를 포맷팅하여 반환 예) 2003/10/10
     *
     * @return
     */
    public static String getFormatDate(Date date) {
        return format(date, SLASH_DATE_FORMAT);
    }


    /**
     * 전달받은 날자와 토큰으로 형식화한 문자열 형태의 날짜정보를 반환
     *
     * @param date
     * @param tok
     * @return
     */
    public static String getFormatDate(Date date, String tok) {
        return new SimpleDateFormat("yyyy" + tok + "MM" + tok + "dd").format(date);
    }


    /**
     * 현재 설정된 일시를 포맷팅하여 반환 예) 20031010100333
     *
     * @return
     */
    public static String getFormatDateTime(Date date) {
        return getFormatDateTime(date, "/", ":");
    }


    /**
     * 전달받은 날짜와 토큰들로써 포맷팅한 날짜정보를 반환
     *
     * @param date
     * @param tokDate
     * @param tokTime
     * @return
     */
    public static String getFormatDateTime(Date date, String tokDate, String tokTime) {
        return new SimpleDateFormat(
                "yyyy" + tokDate + "MM" + tokDate + "dd" + " kk" + tokTime + "mm" + tokTime + "ss")
                        .format(date);
    }


    /**
     * 현재 설정된 일시를 포맷팅하여 반환 예) 20031010100333
     *
     * @return
     */
    public static String getFormatDateTime(Timestamp date) {
        return getFormatDateTime(date, "/", ":");
    }


    /**
     * 전달받은 날짜와 토큰들로써 포맷팅한 날짜정보를 반환
     *
     * @param date
     * @param tokDate
     * @param tokTime
     * @return
     */
    public static String getFormatDateTime(Timestamp date, String tokDate, String tokTime) {
        return new SimpleDateFormat(
                "yyyy" + tokDate + "MM" + tokDate + "dd" + " kk" + tokTime + "mm" + tokTime + "ss")
                        .format(date);
    }


    /**
     * 문자열형태의 날짜정보를 형식화하여 반환
     *
     * @param date yyyymmdd형의 날짜정보
     * @return
     */
    public static String getFormatDate(String date) {
        return getFormatDate(date, "/");
    }


    /**
     * 전달받은 문자열 날짜를 토큰으로 형식화해서 반환 예) 2003-10-10
     *
     * @param date 형식화된 날짜
     */
    public static String getFormatDate(String date, String tok) {
        return date.substring(0, 4) + tok + date.substring(4, 6) + tok + date.substring(6, 8);
    }


    /**
     * 전달받은 문자열을 기본값으로 형식화한 후 반환
     *
     * @param date
     * @return
     */
    public static String getFormatDateTime(String date) {
        return getFormatDateTime(date, "/", ":");
    }


    /**
     * 전달받은 문자열 날짜를 토큰으로 형식화해서 반환 예) 2003-10-10 10:03:33
     *
     * @param date 형식화된 날짜
     */
    public static String getFormatDateTime(String date, String tokDate, String tokTime) {
        StringBuffer sb = new StringBuffer();

        sb.append(date.substring(0, 4)).append(tokDate).append(date.substring(4, 6)).append(tokDate)
                .append(date.substring(6, 8));
        sb.append(" ").append(date.substring(8, 10)).append(tokTime).append(date.substring(10, 12))
                .append(tokTime).append(date.substring(12, 14));

        return sb.toString();
    }


    /**
     * 해당 년월의 1일의 요일정수를 반환
     *
     * @param year 연
     * @param month 월
     * @return
     */
    public static int getFirstDayOfWeek(int year, int month) {
        Calendar cal = Calendar.getInstance();
        cal.set(year, month - 1, 1);

        return cal.get(Calendar.DAY_OF_WEEK);
    }


    /**
     * 해당 년월의 마지막 날짜를 반환
     *
     * @param year 연
     * @param month 월
     * @return
     */
    public static int getLastDay(int year, int month) {
        Calendar cal = Calendar.getInstance();
        cal.set(year, month - 1, 1);

        return cal.getActualMaximum(Calendar.DATE);
    }


    /**
     * 해당 년월의 마지막 날짜를 반환함 - 인자로 yyyymmdd 형의 스트링을 받음
     *
     * @param ymd
     * @return
     */
    public static int getLastDay(String ymd) {
        int year = Integer.parseInt(ymd.substring(1, 4));
        int month = Integer.parseInt(ymd.substring(4, 6));

        return getLastDay(year, month);
    }


    /**
     * 해당 년월의 주의 수를 반환함
     *
     * @param year 년
     * @param month 월
     * @return
     */
    public static int getWeekCnt(int year, int month) {
        int lastDay = getLastDay(year, month);

        Calendar cal = Calendar.getInstance();
        cal.set(year, month - 1, lastDay);

        return cal.get(Calendar.WEEK_OF_MONTH);
    }


    /**
     * 주말이면 참을 반환
     *
     * @param date yyyymmdd형태의 날짜문자열
     * @return
     */
    public static boolean isWeekend(String date) {

        int dayOfWeek = getDayOfWeek(date);

        return (dayOfWeek == 7 || dayOfWeek == 1) ? true : false;

    }


    /**
     * YYYYMMDD 스트링형 날짜의 요일코드를 반환
     *
     * @param date
     * @return
     */
    public static int getDayOfWeek(String date) {

        // 캘린더 객체생성하여 날짜세팅
        Calendar cal = Calendar.getInstance();
        cal.setTime(getDate(date));

        // 요일코드를 받고 토요일/일요일이면 참
        return cal.get(Calendar.DAY_OF_WEEK);

    }


    /**
     * yyyymmdd형식에 맞는 스트링 형식의 날짜를 Date 객체로 생성하여 반환함
     *
     * @param date yyyymmdd형식의 날자스트링
     * @return
     */
    public static Date getDate(String date) {

        // 연월일 분리
        int year = Integer.parseInt(date.substring(0, 4));
        int month = Integer.parseInt(date.substring(4, 6)) - 1;
        int day = Integer.parseInt(date.substring(6, 8));

        // 캘린더 객체 생성 및 세팅
        Calendar cal = Calendar.getInstance();
        cal.set(year, month, day, 0, 0, 0);

        return cal.getTime();

    }


    /**
     * 두 날짜타입의 차이나는 일수를 구하여 반환함
     *
     * @param date1 대상날짜 1
     * @param date2 대상날짜 2
     * @return
     */
    public static long getDateGap(Date date1, Date date2) {

        // 첫번째 날짜의 타임스탬프 구함
        long time1 = date1.getTime();
        long time2 = date2.getTime();
        double d = Math.ceil((double) (time1 - time2) / 1000 / 60 / 60 / 24);

        BigDecimal bd = BigDecimal.valueOf(d);

        return bd.longValue();

    }


    /**
     * 두 스트링형 날짜 사이에 차이나는 일수를 구하여 반환함
     *
     * @param date1 날짜스트링1
     * @param date2 날짜스트링2
     * @return
     */
    public static long getDateGap(String date1, String date2) {
        return getDateGap(getDate(date1), getDate(date2));
    }


    /**
     * 두 스트링형 날짜가 현재일시를 포함하는지 여부를 반환
     *
     * @param date1 yyyymmdd형의 날짜
     * @param date2 yyyymmdd형의 날짜
     * @return
     */
    public static boolean isInPeriod(String startDate, String endDate) {

        boolean flag = false;
        // 현재날짜
        String currDate = getCurrDate();

        // 날짜범위 내에 있으면 참
        if (compareDate(currDate, startDate) >= 0 && compareDate(currDate, endDate) <= 0) {
            flag = true;
        }

        return flag;

    }


    /**
     * 요일코드에서 요일의 이름을 반환
     *
     * @param dayOfWeek
     * @return
     */
    public static String getDayOfWeekName(int dayOfWeek) {

        String[] dayNm = {" ", "일", "월", "화", "수", "목", "금", "토"};

        return dayNm[dayOfWeek];

    }


    /**
     * YYYYMMDD형 날짜에서 요일 이름을 추출하여 반환
     *
     * @param date
     * @return dayNm[dayOfWeek] 요일명
     */
    public static String getDayOfWeekName(String date) {

        String[] dayNm = {" ", "일", "월", "화", "수", "목", "금", "토"};
        int dayOfWeek = getDayOfWeek(date);

        return dayNm[dayOfWeek];

    }


    /**
     *
     * <pre>
     * 6자리, 혹은 4자리의 시간을 입력 받아서 이를 다음과 같이 포매팅하여 반환.
     *
     * getFmtTimeString( "1022" ) => 10:22 AM
     *
     * </pre>
     *
     * @param time String값
     * @return
     */
    public static String getFmtTimeString(String time) {
        DateFormat df = new SimpleDateFormat("h:mm a", Locale.US);
        return df.format(getTime((time.length() == 4) ? time + "00" : time));
    }

    /**
     * 
     * 현재의 날짜와 시간을 (yyyymmddhh24miss) 형태로 변환하여 반환함
     * 
     * @return currentTime.toString() yyyymmddhh24miss형태의 현재의 날짜와 시간
     */
    public static String getCurrentTimeString() {

        Calendar cal = Calendar.getInstance();

        StringBuffer currentTime = new StringBuffer();
        String stryear = null;
        String strmonth = null;
        String strday = null;

        String strhour = null;
        String strminute = null;
        String strsecond = null;

        stryear = String.valueOf(new Integer(cal.get(Calendar.YEAR)));
        currentTime.append(stryear);

        strmonth = "00" + Integer.toString(cal.get(Calendar.MONTH) + 1);
        strmonth = strmonth.substring(strmonth.length() - 2, strmonth.length());
        currentTime.append(strmonth);

        strday = "00" + Integer.toString(cal.get(Calendar.DAY_OF_MONTH));
        strday = strday.substring(strday.length() - 2, strday.length());
        currentTime.append(strday);

        strhour = "00" + Integer.toString(cal.get(Calendar.HOUR_OF_DAY));
        strhour = strhour.substring(strhour.length() - 2, strhour.length());
        currentTime.append(strhour);

        strminute = "00" + Integer.toString(cal.get(Calendar.MINUTE));
        strminute = strminute.substring(strminute.length() - 2, strminute.length());
        currentTime.append(strminute);

        strsecond = "00" + Integer.toString(cal.get(Calendar.SECOND));
        strsecond = strsecond.substring(strsecond.length() - 2, strsecond.length());
        currentTime.append(strsecond);

        return currentTime.toString();

    }

    /**
     * 
     * 특정 문자열을 날짜포맷(yyyy.mm.dd)으로 변환하여 반환하되, 문자열 길이가 8자리 미만이면 그냥 반환
     * 
     * @param m_sDate
     * @return
     */
    public static String getShortToDate(String m_sDate) {
        if (m_sDate == null)
            return "";
        else if (m_sDate.length() < 8)
            return m_sDate;
        else
            return m_sDate.substring(0, 4) + "." + m_sDate.substring(4, 6) + "."
                    + m_sDate.substring(6, 8);
    }

    /**
     * 
     * 날짜 포맷, 지정한 구분자로 날짜 포멧을 만들어준다<br>
     * Ex) getDateFormat( "20020202", "/" ); => 2002/02/02
     * 
     * @param m_sDate
     * @param gubun
     * @return
     */
    public static String getDateFormat(String m_sDate, String gubun) {
        if (m_sDate == null)
            return "";
        else if (m_sDate.length() < 8)
            return m_sDate;
        else
            return m_sDate.substring(0, 4) + gubun + m_sDate.substring(4, 6) + gubun
                    + m_sDate.substring(6, 8);
    }

    /**
     * 
     * COIS형태의 데이터를 날짜데이터로 변환한다 XXXX년 X월X일
     * 
     * @param date
     * @return
     */
    public static String getDateHan(String date) {
        String datestr = null;

        if (date == null || date.trim().equals(""))
            return "";
        date = date.replace(' ', '0');

        if (date.charAt(0) == '1') {
            datestr = "19" + date.substring(1, 3) + "년 " + date.substring(3, 5) + "월 "
                    + date.substring(5) + "일";

        } else {
            datestr = "20" + date.substring(1, 3) + "년 " + date.substring(3, 5) + "월 "
                    + date.substring(5) + "일";
        }

        return datestr;
    }

    /**
     * 
     * COIS의 월 형태를 YYYY/MM형태로 바꿔 줌.
     * 
     * @param s
     * @return
     */
    public static String getMonthString(String s) {
        if (s == null)
            return "";

        s = s.trim();
        if (s.length() < 5)
            return s.trim();

        String tmp = "";
        if (s.charAt(0) == '1')
            tmp = "19";
        else
            tmp = "20";

        return tmp + s.substring(1, 3) + "/" + s.substring(3);
    }

    /**
     * 
     * 두개의 날짜를 받아들여 두 날짜를 포함하며, 두 날짜 사이의 달들을 반환
     * 
     * @param sStartDate
     * @param sEndDate
     * @return months 두 날짜 사이의 달
     */
    public static String[] getPeriodMonth(String sStartDate, String sEndDate) {

        Calendar cal = Calendar.getInstance(Locale.KOREAN);
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMM", Locale.KOREAN);
        Vector vec = new Vector();
        int iStringArrSize = 0;
        Date dStartDate = null;
        Date dEndDate = null;
        // int iPeriodCount = 0;

        // 시작 년월 SET
        cal.set(Integer.parseInt(sStartDate.substring(0, 4)),
                Integer.parseInt(sStartDate.substring(4)) - 1, 1);
        dStartDate = cal.getTime();
        // 시작 년월 SET
        cal.set(Integer.parseInt(sEndDate.substring(0, 4)),
                Integer.parseInt(sEndDate.substring(4)) - 1, 1);
        dEndDate = cal.getTime();

        while (!dEndDate.equals(dStartDate)) {
            vec.addElement(formatter.format(dStartDate));
            cal.add(Calendar.MONTH, 1);
            dStartDate = cal.getTime();
        }
        vec.addElement(formatter.format(dStartDate));
        iStringArrSize = vec.size();

        String[] months = new String[iStringArrSize];
        for (int i = 0; i < vec.size(); i++) {
            months[i] = (String) vec.elementAt(i);
        }

        return months;
    }


    /**
     * 
     * YYYY/MM/DD형태의 날짜를 COIS에서 사용하는 날짜형태로 바꿔 줌.
     * 
     * @param date
     * @return
     */
    public static String getDbDateString(String date) {
        StringBuffer buf = new StringBuffer("");

        if (date != null && !date.equals("") && !date.equals("0")) {
            int i = 0;
            StringTokenizer t = new StringTokenizer(date, "/");

            while (t.hasMoreTokens()) {
                String tmp = t.nextToken().trim();

                if (i == 0)
                    tmp = tmp.substring(0, 1) + tmp.substring(2);
                else if (tmp.length() == 1)
                    tmp = "0" + tmp;

                buf.append(tmp);
                i++;
            }
        } else
            buf.append("0");

        return buf.toString();
    }

    /**
     * 
     * 입력한 날짜를 yyyy년 MM월 dd일 포맷형태로 바꿔줌
     * 
     * @param strDate
     * @return
     */
    public static String getStrDateHan(String strDate) {
        Date date = parseDate(strDate, DEFAULT_DATE_FORMAT);
        return format(date, HANGEUL_DATE_FORMAT2);
    }

}
