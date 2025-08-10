package com.itwillbs.clish.course.dto;

import lombok.ToString;

import lombok.Setter;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileUtils.FileUploadHelpper;

import lombok.Getter;

@Getter
@Setter
@ToString
public class ClassDTO implements FileUploadHelpper{
	private String classIdx;
	private String classTitle;
	private String categoryIdx;
	private int classStatus;
	private BigDecimal classPrice;
	private int classMember;
	
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private LocalDate startDate;
	
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private LocalDate endDate;
	
	private Integer classDays;
	private String location;
	private List<String> classDayNames;
	private String userIdx;
	private int classType;
	private String classIntro; // 소개글
	private String classContent; // 상세내용
	private String classPic1; // 썸네일
	
	private int classLength; // classLength mySQL = TIMESTAMPDIFF(DAY, start_date, end_date) as class_length
	
	private List<FileDTO> fileList;
	private MultipartFile[] files;
	
	@Override
	public MultipartFile[] getFiles() {
		return files;
	}
	
	@Override
	public String getIdx() {
		return classIdx;
	}
	
	public String getDayString() {
	    int daysValue = this.classDays; // 필드 값
	    String[] dayNames = {"월", "화", "수", "목", "금", "토", "일"};
	    int[] bitValues = {1, 2, 4, 8, 16, 32, 64};

	    StringBuilder sb = new StringBuilder();
	    for (int i = 0; i < bitValues.length; i++) {
	        if ((daysValue & bitValues[i]) != 0) {
	            sb.append(dayNames[i]).append(" ");
	        }
	    }
	    return sb.toString().trim();
	}
}
