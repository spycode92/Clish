package com.itwillbs.clish.user.dto;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileUtils.FileUploadHelpper;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class CompanyDTO implements FileUploadHelpper{
    private String userIdx;               
    private String bizRegNo;             
    private String bizFileName;        
    private String bizFilePath;
    
	private List<FileDTO> fileList;
	private MultipartFile[] files;
	
	@Override
	public MultipartFile[] getFiles() {
		return files;
	}
	
	@Override
	public String getIdx() {
		return userIdx;
	}
}