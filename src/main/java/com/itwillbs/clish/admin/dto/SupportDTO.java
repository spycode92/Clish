package com.itwillbs.clish.admin.dto;

import lombok.Setter;
import lombok.ToString;

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
public class SupportDTO implements FileUploadHelpper{
	private String supportIdx;
	private String supportTitle;
	private String supportDetail;
	
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private LocalDate supportCreatedAt;
	private String supportCategory;
	private String supportAttach;
	
	private List<FileDTO> fileList;
	private MultipartFile[] files;
	
	@Override
	public MultipartFile[] getFiles() {
		return files;
	}
	
	@Override
	public String getIdx() {
		return supportIdx;
	}
}
