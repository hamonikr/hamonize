/* ntels */
package com.paging;


import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;


/**
 * <pre> kr.or.career.mentor.annotation Pageable
 *
 * class의 기능을 설명한다.
 *
 * </pre>
 *
 * @author chaos
 * @see
 * @since 15. 9. 20. 오전 1:32
 */
@Target({ ElementType.PARAMETER })
@Retention(RetentionPolicy.RUNTIME)
public @interface Pageable {

	int size() default 0;

}
