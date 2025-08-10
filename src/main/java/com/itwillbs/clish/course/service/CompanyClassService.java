package com.itwillbs.clish.course.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.core.appender.FileManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.clish.admin.dto.InquiryJoinUserDTO;
import com.itwillbs.clish.admin.mapper.AdminClassMapper;
import com.itwillbs.clish.admin.service.AdminClassService;
import com.itwillbs.clish.admin.service.CategoryService;
import com.itwillbs.clish.admin.service.NotificationService;
import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileMapper;
import com.itwillbs.clish.common.file.FileUtils;
import com.itwillbs.clish.course.service.CurriculumService;
import com.itwillbs.clish.myPage.dto.InqueryDTO;
import com.itwillbs.clish.myPage.dto.ReservationDTO;
import com.itwillbs.clish.course.dto.ClassDTO;
import com.itwillbs.clish.course.dto.CurriculumDTO;
import com.itwillbs.clish.course.mapper.CompanyClassMapper;
import com.itwillbs.clish.course.mapper.CurriculumMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
@RequiredArgsConstructor
public class CompanyClassService {
	private final CompanyClassMapper companyClassMapper;
	private final CurriculumService curriculumService;
	private final NotificationService notificationService;
	private final CurriculumMapper curriculumMapper;
	private final FileMapper fileMapper;
	
	@Autowired
	private HttpSession session;
	
	@Transactional
	// 강의 등록 (썸네일 업로드 + 파일정보 DB 저장 포함)
	public int registerClass(ClassDTO companyClass, HttpSession session) {
	    try {
	        // 1. 파일 업로드
	        List<FileDTO> fileList = FileUtils.uploadFile(companyClass, session);
	        companyClass.setFileList(fileList);

	        // ✅ real_file_name 자르기 (50자 제한 맞추기)
	        for (FileDTO file : fileList) {
	            String realName = file.getRealFileName();
	            realName = realName.replaceAll("[\\s()]", "_"); // ✅ 공백/괄호 → 언더스코어
	            if (realName.length() > 50) {
	                realName = realName.substring(0, 50);        // ✅ 너무 길면 잘라
	            }
	            file.setRealFileName(realName);
	        }

	        // 2. 대표 썸네일 설정
	        if (!fileList.isEmpty()) {
	            FileDTO first = fileList.get(0);
	            String thumbPath = "/resources/upload/" + first.getSubDir() + "/" + first.getRealFileName();
	            companyClass.setClassPic1(thumbPath);
	        }

	        // 3. 파일 정보 DB 저장
	        if (!fileList.isEmpty()) {
	            fileMapper.insertFiles(fileList);
	        }

	        // 4. 강의 상태 설정
	        companyClass.setClassStatus(1);

	        // 5. 클래스 등록
	        return companyClassMapper.insertCompanyClass(companyClass);

	    } catch (Exception e) {
	        e.printStackTrace();
	        throw new RuntimeException("클래스 등록 중 오류 발생", e);
	    }
	}
	
	// 등록한 강의 상세 조회
	public ClassDTO getClassInfo(String classIdx) {
		ClassDTO classdto = companyClassMapper.selectClassByIdx(classIdx);

	    // ✅ 파일 목록도 함께 세팅
	    if (classdto != null) {
	        List<FileDTO> fileList = fileMapper.selectAllFile(classIdx);
	        classdto.setFileList(fileList); // ← 여기에서 세팅

	        // 요일 문자열 세팅
	        if (classdto.getClassDays() != null) {
	            classdto.setClassDayNames(convertDaysToString(classdto.getClassDays()));
	        }
	    }

	    return classdto;
	}

	// 숫자(비트 조합) → "월,수,금" 형태 문자열로 변환하는 함수
	private List<String> convertDaysToString(int days) {
	    String[] dayNames = {"월", "화", "수", "목", "금", "토", "일"};
	    int[] values = {1, 2, 4, 8, 16, 32, 64};

	    List<String> result = new ArrayList<>();
	    for (int i = 0; i < values.length; i++) {
	        if ((days & values[i]) != 0) {
	            result.add(dayNames[i]);
	        }
	    }
	    return result;
	}
	
	// 로그인된 userId를 기반으로 해당 회원의 고유 userIdx 반환(기업회원 식별용)
	public String getUserIdxByUserId(String userId) {
		return companyClassMapper.selectUserIdxByUserId(userId);
	}
	
	// classIdx를 기준으로 클래스별 예약된 인원 수 확인
	public int getReservedCount(String classIdx) {
		return companyClassMapper.selectReservedCountByClassIdx(classIdx);
	}
	
	// 전체 강의 조회
	public List<Map<String, Object>> getAllClassList(String userIdx) {
		return companyClassMapper.selectAllClassList(userIdx);
	}

	// 단기 & 정기 강의 조회
	public List<Map<String, Object>> getClassListByType(String userIdx, String type) {
		return companyClassMapper.selectClassListByType(userIdx, type);
	}
	
	// 클래스 수정
	@Transactional
	public int modifyClassInfo(String classIdx, ClassDTO classInfo, List<CurriculumDTO> curriculumList, HttpSession session) throws IllegalStateException, IOException {
		 // 1. 클래스 정보 수정
	    int result = companyClassMapper.updateClassInfo(classIdx, classInfo);
	    
	    // 2. 기존 커리큘럼 전부 삭제
	    curriculumMapper.deleteCurriculumByClassIdx(classIdx);
	    
	    // 3. 현재 form에서 온 커리큘럼들을 다시 insert
	    for (CurriculumDTO dto : curriculumList) {
	        if (dto.getCurriculumTitle() != null && !dto.getCurriculumTitle().trim().isEmpty()) {
	            dto.setClassIdx(classIdx); // 커리큘럼이 어떤 클래스 소속인지 꼭 지정
	            curriculumMapper.insertCurriculumModify(dto);
	        }
	    }
	    
	    // ✅ 4. 썸네일 파일 처리만 추가
	    if (classInfo.getFiles() != null && classInfo.getFiles().length > 0 && !classInfo.getFiles()[0].isEmpty()) {
	        // 기존 파일 삭제 (ref_table='class' AND ref_idx=classIdx 기준)
	        fileMapper.deleteAllFile(classIdx);
	
	        // 새 파일 업로드
	        List<FileDTO> fileList = FileUtils.uploadFile(classInfo, session);
	        
		    // 🔽 파일명이 너무 길면 자르기
	        for (FileDTO file : fileList) {
	            String realName = file.getRealFileName();
	            realName = realName.replaceAll("[\\s()]", "_"); // ✅ 공백/괄호 → 언더스코어
	            if (realName.length() > 50) {
	                realName = realName.substring(0, 50);        // ✅ 너무 길면 잘라
	            }
	            file.setRealFileName(realName);
	        }
	        
	        classInfo.setFileList(fileList);
	
	        if (!fileList.isEmpty()) {
	            fileMapper.insertFiles(fileList);
	
	            // 대표 썸네일 경로 세팅
	            FileDTO first = fileList.get(0);
	            String thumbPath = "/resources/upload/" + first.getSubDir() + "/" + first.getRealFileName();
	            classInfo.setClassPic1(thumbPath);
	        }
	    }
	    
		return result;
	}
		
	// 클래스 삭제
	public void deleteClass(String classIdx) {
		companyClassMapper.deleteClass(classIdx);
		
	}
	
	// 클래스 예약자 목록 조회
	public List<Map<String, Object>> selectReservationList(String classIdx) {
		return companyClassMapper.selectReservationList(classIdx);
	}

	// 파일 삭제
	public void removeFile(FileDTO fileDTO) {
		fileDTO = fileMapper.selectFile(fileDTO);
		FileUtils.deleteFile(fileDTO, session);
		
		fileMapper.deleteFile(fileDTO);
	}
	// -----------------------------------------------------------------------------------------------
	// 클래스 문의 총 개수 조회
	public int getClassInquiryCountByUserIdx(String userIdx) {
		return companyClassMapper.selectClassInquiryCountByUserIdx(userIdx);
	}
	
	// 클래스 문의 리스트 조회 (페이징)
	public List<InquiryJoinUserDTO> getClassInquiryList(int startRow, int listLimit, String userIdx) {
		return companyClassMapper.selectClassInquiryList(startRow, listLimit, userIdx);
	}
	
	// 클래스 문의 페이지 - 문의 상세
	public InquiryJoinUserDTO getClassInquiryDetail(String idx) {
		return companyClassMapper.selectClassInquiryDetail(idx);
	}

	// 클래스 문의 페이지 - 문의 답변
	@Transactional
	public int updateClassInquiry(String idx, String userIdx, String inqueryAnswer) {
		int result = companyClassMapper.updateClassInquiry(idx, userIdx, inqueryAnswer);
		
		// 알림 서비스 없이 바로 return
		return result;
	}
	



	
	
	
	
	
	
}	
	
	 	
	
	