package com.itwillbs.clish.company.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.clish.admin.dto.InquiryJoinUserDTO;
import com.itwillbs.clish.admin.dto.NotificationDTO;
import com.itwillbs.clish.myPage.dto.InqueryDTO;
import com.itwillbs.clish.user.dto.CompanyDTO;
import com.itwillbs.clish.user.dto.UserDTO;


@Mapper
public interface CompanyInfoMapper {
	
	// 로그인한 기업회원 정보 조회
	UserDTO selectUserInfo(UserDTO user);
	
	// 기업전화번호 중복 확인
	boolean selectPhoneNumberDuplicate(@Param("userPhoneNumber") String userPhoneNumber, @Param("userIdx") String userIdx);
	
	// 기업 정보 수정
	int updateUserInfo(UserDTO user);
	
	// userIdx로 기업 정보 조회 (company 테이블 SELECT)
	CompanyDTO selectCompanyInfo(String userIdx);
	
	// 기업 사업자등록증 등록
	void insertCompanyInfo(CompanyDTO company);

	// 기업회원 사업자등록증 정보 수정 처리
	int updateCompanyInfo(CompanyDTO company);
	// ---------------------------------------------------------------
	// 기업 - 나의 문의 총 개수 조회
	int selectInquiryCountByUserIdx(String userIdx);
	
	// 기업 - 나의 문의 리스트 조회 (페이징)
	List<InquiryJoinUserDTO> selectInquiriesByUserIdx(@Param("startRow") int startRow, @Param("listLimit") int listLimit, @Param("userIdx") String userIdx);
	
	// 문의 등록버튼 로직
	void insertInquery(InqueryDTO dto);
	
	// user_id로 실제 user_idx 조회 - 문의 등록버튼
	String selectUserIdxByUserId(String userId);
	// inquery_idx를 기반으로 해당 문의글 1건 조회 - 문의 수정 폼
	InqueryDTO selectInqueryByIdx(String inqueryIdx);
	
	// 문의 수정버튼 로직 
	void updateInquery(InqueryDTO dto);
	
	// 문의 삭제버튼 로직
	void deleteInquery(String inqueryIdx);
	// ---------------------------------------------------------------
	// 알림 총 개수 조회	
	int selectCountNotification(UserDTO user);
	
	// 알림 리스트 조회 (페이징)
	List<NotificationDTO> selectAllNotification(@Param("startRow") int startRow, @Param("listLimit") int listLimit, @Param("user") UserDTO user);
	
	// 알림 읽음 처리
	void updateNotificationReadStatus(String noticeIdx);
	
	// 모두 읽음 처리
	int updateAllNotificationReadStatus(String userIdx);
	// ---------------------------------------------------------------
	// 기업 회원 탈퇴
	int updateWithdraw(UserDTO user);



	

}
