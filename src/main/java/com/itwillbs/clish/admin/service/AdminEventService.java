package com.itwillbs.clish.admin.service;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.clish.admin.dto.EventDTO;
import com.itwillbs.clish.admin.mapper.AdminEventMapper;
import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileMapper;
import com.itwillbs.clish.common.file.FileUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminEventService {
	private final AdminEventMapper adminEventMapper;
	private final FileMapper fileMapper;
	
	@Autowired
	private HttpSession session;

	// 이벤트 리스트
	public List<EventDTO> getEvents(int startRow, int listLimit, String searchType, String searchKeyword) {
		return adminEventMapper.selectAllEvent(startRow, listLimit, searchType, searchKeyword);
	}

	// 이벤트 게시물 수
	public int getEventCount(String searchType, String searchKeyword) {
		return adminEventMapper.selectCountEvent(searchType, searchKeyword);
	}

	// 이벤트 등록
	@Transactional
	public int registEvent(EventDTO eventDTO) throws IllegalStateException, IOException {
		eventDTO.setEventIdx(createIdx("EVT"));
		int insert = adminEventMapper.insertEvent(eventDTO);
		
		// 이벤트 등록 성공 시 파일 등록 실행
		if (insert > 0) {
			if (eventDTO.getFiles() != null && eventDTO.getFiles().length > 0) {
				List<FileDTO> eventFileList = FileUtils.uploadFile(eventDTO, session);
				
				for (int i = 0; i < eventFileList.size(); i++) {
					FileDTO file = eventFileList.get(i);
					
					// index 0은 썸네일, index 1은 컨텐츠라고 간주
					if (i == 0) {
						fileMapper.insertThumbnail(file);
					} else if (i == 1) {
						fileMapper.insertOneFile(file);
					}
				}
			}
		} else {
			 throw new RuntimeException("이벤트 등록에 실패했습니다.");
		}
		
		return insert;
	}

	// 이벤트 상세 페이지
	public EventDTO getEvent(String idx) {
		return adminEventMapper.selectEvent(idx);
	}
	
	// 이벤트 수정
	public int modifyEvent(EventDTO eventDTO) throws IllegalStateException, IOException {
		MultipartFile thumbnail = eventDTO.getThumbnailFile();
	    MultipartFile content = eventDTO.getContentFile();
	    
	    // 썸네일 파일 업로드
	    if (thumbnail != null && !thumbnail.isEmpty()) {
	    	eventDTO.setFileTypes(List.of("thumbnail"));
	    	List<FileDTO> files = FileUtils.uploadFile(eventDTO, session);
	    	if (!files.isEmpty()) {
	              fileMapper.insertThumbnail(files.get(0));
	         }
	    }
	    
	    // 콘텐츠 파일 업로드
	    if (content != null && !content.isEmpty()) {
	        eventDTO.setFileTypes(List.of("content"));
	        List<FileDTO> files = FileUtils.uploadFile(eventDTO, session);
	        if (!files.isEmpty()) {
	            fileMapper.insertOneFile(files.get(0));
	        }
	    }
	    
		return adminEventMapper.updateEvent(eventDTO);
	}
	
	// 파일 삭제
	public void removeOneFile(FileDTO fileDTO, String type) {
		FileDTO contentFile = fileMapper.selectContentFile(fileDTO.getIdx());
		FileDTO thumbnailFile = fileMapper.selectThumbnailFile(fileDTO.getIdx());
		
		if (type.equals("thumbnail")) {
			FileUtils.deleteFile(thumbnailFile, session);
			fileMapper.deleteThumbnailFile(thumbnailFile);
		} else {
			FileUtils.deleteFile(contentFile, session);
			fileMapper.deleteFile(contentFile);
		}
		
	}
	
	// 이벤트 삭제
	public void removeEvent(String idx) {
		FileDTO contentFile = fileMapper.selectContentFile(idx);
		FileDTO thumbnailFile = fileMapper.selectThumbnailFile(idx);
		
		// 실제 파일 삭제
		FileUtils.deleteFile(thumbnailFile, session);
		FileUtils.deleteFile(contentFile, session);
		
		// DB 데이터 삭제
		fileMapper.deleteThumbnailFile(thumbnailFile);
		fileMapper.deleteFile(contentFile);
		
		adminEventMapper.deletedEvent(idx);
	}
	
	
	// 아이디 생성 로직
	private String createIdx(String name) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		String timestamp = LocalDateTime.now().format(formatter);
		String idx = name + timestamp;
		
		return idx;
	}
}
