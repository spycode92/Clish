package com.itwillbs.clish.myPage.dto;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileUtils.FileUploadHelpper;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@ToString
@NoArgsConstructor
public class ReviewDTO implements FileUploadHelpper{
	private String reviewIdx;             
    private String reservationIdx;         
    private String userIdx;                   
    private String classIdx;                  
    private String reviewTitle;            
    private String reviewDetail;           
    private int reviewScore;               
    private LocalDateTime reviewCreatedAt;   
    private LocalDateTime reviewModifiedAt;   
    private int reviewReportedCount = 0;
    
    //DB저장없이 받아오는값들
    private String classTitle;
    private String categoryIdx;
    private String classType;
    private LocalDateTime reservationClassDate;
    private String userId;
    private String userName;
    
    
    // 파일업로드
	private MultipartFile[] files;
	private List<FileDTO> fileList;
	
	@Override
	public MultipartFile[] getFiles(){
		return files;
	}
	
	@Override
	public String getIdx() {
		return reviewIdx;
	}
}
