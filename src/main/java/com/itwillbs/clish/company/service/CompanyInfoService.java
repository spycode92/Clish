package com.itwillbs.clish.company.service;

import java.util.List;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.itwillbs.clish.admin.dto.InquiryJoinUserDTO;
import com.itwillbs.clish.admin.dto.NotificationDTO;
import com.itwillbs.clish.company.mapper.CompanyInfoMapper;
import com.itwillbs.clish.myPage.dto.InqueryDTO;
import com.itwillbs.clish.user.dto.CompanyDTO;
import com.itwillbs.clish.user.dto.UserDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CompanyInfoService {
	private final CompanyInfoMapper companyInfoMapper;
	
	// 비밀번호 비교 메서드 
	public boolean matchesPassword(String plainPassword, String encodedPassword) {
		 BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
	     return encoder.matches(plainPassword, encodedPassword);
	}
	
	// 로그인한 기업회원 정보 조회
	public UserDTO getUserInfo(UserDTO user) {
		return companyInfoMapper.selectUserInfo(user);
	}
	
	// 기업전화번호 중복 확인
	public boolean isPhoneNumberDuplicate(String userPhoneNumber, String userIdx) {
		return companyInfoMapper.selectPhoneNumberDuplicate(userPhoneNumber, userIdx);
	}
	
	// 기업회원 정보 수정 처리 
	public int setUserInfo(UserDTO user) {
		return companyInfoMapper.updateUserInfo(user);
	}
	
	// userIdx로 기업 정보 조회 (company 테이블 SELECT)
	public CompanyDTO getCompanyInfo(String userIdx) {
		 return companyInfoMapper.selectCompanyInfo(userIdx);
	}
	
	// 기업 사업자등록증 등록
	public void insertCompanyInfo(CompanyDTO company) {
		companyInfoMapper.insertCompanyInfo(company);
	}
	
	// 기업회원 사업자등록증 정보 수정 처리
	public int setCompanyInfo(CompanyDTO company) {
		return companyInfoMapper.updateCompanyInfo(company);
		
	}
	// ------------------------------------------------------------------------
	// 기업 - 나의 문의 총 개수 조회
	public int getInquiryCountByUserIdx(String userIdx) {
		return companyInfoMapper.selectInquiryCountByUserIdx(userIdx);
	}
	
	// 기업 - 나의 문의 리스트 조회 (페이징)
	public List<InquiryJoinUserDTO> getInquiriesByUserIdx(int startRow, int listLimit, String userIdx) {
		return companyInfoMapper.selectInquiriesByUserIdx(startRow, listLimit, userIdx);
	}
	
	// 문의 등록버튼 로직
	public void insertInquery(InqueryDTO dto) {
		companyInfoMapper.insertInquery(dto); 
	}
	
	// user_id로 실제 user_idx 조회 - 문의 등록버튼 
	public String getUserIdxByUserId(String userId) {
		return companyInfoMapper.selectUserIdxByUserId(userId);
	}
	
	// inquery_idx를 기반으로 해당 문의글 1건 조회 - 문의 수정 폼
	public InqueryDTO getInqueryByIdx(String inqueryIdx) {
		return companyInfoMapper.selectInqueryByIdx(inqueryIdx);
	}
	
	// 문의 수정버튼 로직 
	public void updateInquery(InqueryDTO dto) {
		companyInfoMapper.updateInquery(dto);
	}
	
	// 문의 삭제버튼 로직
	public void deleteInquery(String inqueryIdx) {
		companyInfoMapper.deleteInquery(inqueryIdx);
	}
	// ------------------------------------------------------------------------
	// 알림 총 개수 조회
	public int getNotificationCount(UserDTO user) {
		return companyInfoMapper.selectCountNotification(user);
	}
	
	// 알림 리스트 조회 (페이징)
	public List<NotificationDTO> selectNotification(int startRow, int listLimit, UserDTO user) {
		return companyInfoMapper.selectAllNotification(startRow, listLimit, user);
	}
	
	// 알림 읽음 처리
	public void updateNotificationReadStatus(String noticeIdx) {
		companyInfoMapper.updateNotificationReadStatus(noticeIdx);
	}
	
	// 모두 읽음 처리
	public int updateAllNotificationReadStatus(String userIdx) {
		return companyInfoMapper.updateAllNotificationReadStatus(userIdx);
	}
	// ------------------------------------------------------------------------
	// 기업 회원 탈퇴
	public int withdraw(UserDTO user) {
		return companyInfoMapper.updateWithdraw(user);
	}

	
}
