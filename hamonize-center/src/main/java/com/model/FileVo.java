package com.model;

import java.sql.Timestamp;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Size;

import org.hibernate.annotations.Comment;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@Table(name="tbl_files")
public class FileVo {
    @Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼넘버")
	private Long seq;

	@Size(max=50)
	private String domain;

    @Size(max=300)
    @Comment("관리파일명")
    private String filename;

    @Size(max=300)
    @Comment("실제파일명")
    private String filerealname;

    @Comment("파일크기")
    private long filesize;

    @Size(max=100)
    @Comment("파일경로")
    private String filepath;

    @Size(max=20)
    @Comment("관리파일명")
    private String kind;

    @Comment("부모시리얼넘버")
	private Long p_seq;

    private Timestamp rgstr_date;
	
	private Timestamp updt_date;

    /**
     * 파일 크기를 정형화하기.
     */
    public String size2String() {
        Integer unit = 1024;
        if (filesize < unit) {
            return String.format("(%d B)", filesize);
        }
        int exp = (int) (Math.log(filesize) / Math.log(unit));

        return String.format("(%.0f %s)", filesize / Math.pow(unit, exp), "KMGTPE".charAt(exp - 1));
    }
    
}
