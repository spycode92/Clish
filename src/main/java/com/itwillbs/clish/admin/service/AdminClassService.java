package com.itwillbs.clish.admin.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.clish.admin.mapper.AdminClassMapper;
import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileMapper;
import com.itwillbs.clish.common.file.FileUtils;
import com.itwillbs.clish.course.dto.ClassDTO;
import com.itwillbs.clish.course.dto.CurriculumDTO;
import com.itwillbs.clish.course.mapper.CurriculumMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
@RequiredArgsConstructor
public class AdminClassService {
	private final AdminClassMapper adminClassMapper;
	private final CurriculumMapper curriculumMapper;
	private final NotificationService notificationService;
	private final CategoryService categoryService;
	private final FileMapper fileMapper;
	
	@Autowired
	private HttpSession session;
	
	// 강의 리스트(페이징, 검색, 정렬)
	public List<Map<String, Object>> getClassList(int startRow, int listLimit, String filter, String searchKeyword) {
		return adminClassMapper.selectClassList(startRow,listLimit, filter, searchKeyword);
	}
	
	// 등록된 강의 수(검색어 포함)
	public int getClassListCount(String searchKeyword) {
		return adminClassMapper.selectClassCount( searchKeyword);
	}
	
	// 대기 중인 강의 리스트
	public List<Map<String, Object>> getPendingClassList() {
		return adminClassMapper.selectpendingClassList();
	}
	
	// 강좌 승인 요청
	@Transactional
	public int modifyStatus(String userIdx, String idx, int status) {
		
		int update = adminClassMapper.updateClassStatus(idx, status);
		
		if (update > 0) {
		  notificationService.send(userIdx, 3, "등록 요청하신 강좌가 승인되었습니다.");
		  return update;
		} else {
			throw new RuntimeException("다시 시도해주세요.");
		}
	}
	
	// 강좌 정보 수정
	@Transactional
	public int modifyClassInfo(String idx, ClassDTO classInfo, List<CurriculumDTO> curriculumList) throws IllegalStateException, IOException {
		boolean hasRservation = adminClassMapper.existsReservationByClassIdx(idx);
		
		if (hasRservation) {
			return -1;
		}
		
		int update = adminClassMapper.updateClassInfo(idx, classInfo);
		int updateCurriculume = 0;
		
		classInfo.setClassIdx(idx);
		
		// 강좌 파일 업로드 관련 로직
		if (classInfo.getFiles() != null && classInfo.getFiles().length > 0) {
			List<FileDTO> classFileList = FileUtils.uploadFile(classInfo, session);

		    if (!classFileList.isEmpty()) {
		        fileMapper.insertFiles(classFileList);
		    }
		}
		
		curriculumMapper.deleteCurriculumByClassIdx(idx);
		
		// 강좌 커리큘럼 관련 로직
		 for (CurriculumDTO dto : curriculumList) {
		        if (dto.getCurriculumTitle() != null && !dto.getCurriculumTitle().trim().isEmpty()) {
		            dto.setClassIdx(idx);
		            curriculumMapper.insertCurriculumModify(dto);
		            updateCurriculume = 1;
		        }
		    }
		
		if (update > 0 || updateCurriculume > 0) {
			notificationService.send(classInfo.getUserIdx(), 3, "강좌 정보가 수정되었습니다.");
			return update;
		} 
		
		throw new RuntimeException("수정에 실패했습니다.");
	}
	
	// 카테고리 삭제
	public int removeCategory(String categoryIdx, int depth) {
		boolean isReferenced = adminClassMapper.existsByCategory(categoryIdx, depth);
		
		if (isReferenced) {
			return 0;
		} else {
			categoryService.removeCategory(categoryIdx);
			return 1;
		}
	}
}
