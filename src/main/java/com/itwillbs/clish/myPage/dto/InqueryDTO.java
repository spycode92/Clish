package com.itwillbs.clish.myPage.dto;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileUtils.FileUploadHelpper;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@AllArgsConstructor
@NoArgsConstructor
public class InqueryDTO implements FileUploadHelpper{
	private String inqueryIdx;
	private String userIdx;
	private String inqueryTitle;
	private String inqueryDetail;
	private String inqueryAnswer;
	private String classIdx;
	private int inqueryType;
	private Timestamp inqueryDatetime;
	private Timestamp inqueryAnswerDatetime;
	private Timestamp inqueryModifyDatetime;
	private int inqueryStatus;
	private String classTitle;
	// 파일업로드
	private MultipartFile[] files;
	private List<FileDTO> fileList;
	
	@Override
	public MultipartFile[] getFiles(){
		return files;
	}
	
	@Override
	public String getIdx() {
		return inqueryIdx;
	}
	
}
