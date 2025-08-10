package com.itwillbs.clish.admin.dto;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileUtils.FileUploadHelpper;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class EventDTO  implements FileUploadHelpper{
	private String eventIdx;
	private String eventTitle;
	private String eventDescription;
	
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private LocalDate eventStartDate;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private LocalDate eventEndDate;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private LocalDate eventCreatedAt;
	
	// 0 : 종료 1: 진행중 2: 예정
	private int eventInProgress;
	
	private List<FileDTO> fileList;
	private List<String> fileTypes;

	private MultipartFile thumbnailFile;
	private MultipartFile contentFile;
	
	@Override
	public MultipartFile[] getFiles() {
	    List<MultipartFile> validFiles = new ArrayList<>();
	    if (fileTypes != null) {
	        for (String type : fileTypes) {
	            if (type.equals("thumbnail") && thumbnailFile != null && !thumbnailFile.isEmpty()) {
	                validFiles.add(thumbnailFile);
	            } else if (type.equals("content") && contentFile != null && !contentFile.isEmpty()) {
	                validFiles.add(contentFile);
	            }
	        }
	    }
	    return validFiles.toArray(new MultipartFile[0]);
	}
	
   
	@Override
	public String getIdx() {
		return eventIdx;
	}
	
	
	
	
}
