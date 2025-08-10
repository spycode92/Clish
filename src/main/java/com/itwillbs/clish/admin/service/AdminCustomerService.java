package com.itwillbs.clish.admin.service;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.clish.admin.dto.InquiryJoinUserDTO;
import com.itwillbs.clish.admin.dto.SupportDTO;
import com.itwillbs.clish.admin.mapper.AdminCustomerMapper;
import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileMapper;
import com.itwillbs.clish.common.file.FileUtils;
import com.itwillbs.clish.myPage.dto.InqueryDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminCustomerService {
	private final AdminCustomerMapper adminCustomerMapper;
	private final NotificationService notificationService;
	private final FileMapper fileMapper;
	
	@Autowired
	private HttpSession session;

	// 공지사항 게시물 수 
	public int getAnnouncementCount(String searchKeyword) {
		return adminCustomerMapper.selectCountAnnouncement(searchKeyword);
	}
	
	// 공지사항 리스트 (페이지 기능 추가)
	public List<SupportDTO> getAnnouncementList(int startRow, int listLimit, String searchType, String searchKeyword) {
		return adminCustomerMapper.selectAnnouncementList(startRow, listLimit, searchType, searchKeyword);
	}
	
	// SUPPORT 테이블 등록
	@Transactional
	public void registSupport(SupportDTO supportDTO) throws IllegalStateException, IOException {
		supportDTO.setSupportIdx(createIdx("SUP"));
		
		if (supportDTO.getSupportCategory() == null) {
			supportDTO.setSupportCategory("공지사항");
		}
		
		if (supportDTO.getFiles() != null && supportDTO.getFiles().length > 0) {
			List<FileDTO> supportFileList = FileUtils.uploadFile(supportDTO, session);
			
			if (!supportFileList.isEmpty()) {
				fileMapper.insertFiles(supportFileList);
			}
		}
		
		adminCustomerMapper.insertSupport(supportDTO);
	}
	
	// SUPPORT 테이블 상세 정보
	public SupportDTO getSupport(String idx) {
		return adminCustomerMapper.selectSupport(idx);
	}

	// SUPPORT 테이블 수정
	@Transactional
	public int modifySupport(SupportDTO supportDTO) throws IllegalStateException, IOException {
		supportDTO.setSupportCategory("공지사항");
		
		if(supportDTO.getFiles() != null && supportDTO.getFiles().length > 0) {
			List<FileDTO> fileList = FileUtils.uploadFile(supportDTO, session);
			
			if (!fileList.isEmpty()) {
				fileMapper.insertFiles(fileList);
			}
		}
		
		return adminCustomerMapper.updateSupport(supportDTO);
	}

	// SUPPORT 테이블 삭제
	@Transactional
	public int removeSupport(String idx) {
		List<FileDTO> fileDTOList = fileMapper.selectAllFile(idx);
		FileUtils.deleteFiles(fileDTOList, session);
		
		fileMapper.deleteAllFile(idx);
		
		return adminCustomerMapper.deleteSupport(idx);
	}

	// faq 리스트
	public List<SupportDTO> getFaqList() {
		return adminCustomerMapper.selectFaqList();
	}
	
	// faq 리스트(검색 기능 포함)
	public List<SupportDTO> getFaqListAndSearch(String searchType, String searchKeyword) {
		return adminCustomerMapper.selectFaqListAndSearch(searchType, searchKeyword);
	}
	
	// faq 수정
	public int modifyFaq(SupportDTO supportDTO) {
		return adminCustomerMapper.updateSupport(supportDTO);
	}
	
	// 1:1 문의 게시물 수
	public List<InquiryJoinUserDTO> getInquiryList(int startRow, int listLimit) {
		return adminCustomerMapper.selectInquiries(startRow, listLimit);
	}

	public InquiryJoinUserDTO getInquiry(String idx) {
		return adminCustomerMapper.selectInquiry(idx);
	}
	
	// 문의 답변
	@Transactional
	public int writeAnswer(String idx, String userIdx, String inqueryAnswer) {
		int update = adminCustomerMapper.updateInquiry(idx, inqueryAnswer);
		
		if (update > 0) {
			notificationService.send(userIdx, 2, "문의하신 내용에 답변이 달렸습니다.");
			return update;
		}
		
		return 0;
	}

	// 파일 삭제
	public void removeFile(FileDTO fileDTO) {
		fileDTO = fileMapper.selectFile(fileDTO);
		FileUtils.deleteFile(fileDTO, session);
		
		fileMapper.deleteFile(fileDTO);
	}
	
	// 1:1 문의 등록
	@Transactional
	public int registInquiry(InqueryDTO inqueryDTO) throws IllegalStateException, IOException {
		inqueryDTO.setInqueryIdx(createIdx("INQ"));
		inqueryDTO.setInqueryType(1);
		
		if (inqueryDTO.getFiles() != null && inqueryDTO.getFiles().length > 0) {
			List<FileDTO> supportFileList = FileUtils.uploadFile(inqueryDTO, session);
			
			if (!supportFileList.isEmpty()) {
				fileMapper.insertFiles(supportFileList);
			}
		}
		
		return adminCustomerMapper.insertInquery(inqueryDTO);
	}
	
	// 1:1 문의 게시물 수
	public int getInquiryCount() {
		return adminCustomerMapper.selectInquiryCount();
	}
	
	// 1:1 문의 수정
	@Transactional
	public int modifyInquiry(InqueryDTO inqueryDTO) throws IllegalStateException, IOException {
		List<FileDTO> fileList = FileUtils.uploadFile(inqueryDTO, session);
		
		if(!fileList.isEmpty()) {
			fileMapper.insertFiles(fileList);
		}
		
		return adminCustomerMapper.updateUserInquiry(inqueryDTO);
	}
	
	// 1:1 문의 삭제
	public int removeInquiry(String idx) {
		List<FileDTO> fileDTOList = fileMapper.selectAllFile(idx);
		FileUtils.deleteFiles(fileDTOList, session);
		
		fileMapper.deleteAllFile(idx);
		
		return adminCustomerMapper.deleteInquiry(idx);
	}
	
	// 아이디 생성 로직
	private String createIdx(String name) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		String timestamp = LocalDateTime.now().format(formatter);
		String idx = name + timestamp;
		
		return idx;
	}

}
