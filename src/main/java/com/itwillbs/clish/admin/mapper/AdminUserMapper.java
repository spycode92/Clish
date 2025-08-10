package com.itwillbs.clish.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.clish.admin.dto.NotificationDTO;
import com.itwillbs.clish.user.dto.CompanyDTO;
import com.itwillbs.clish.user.dto.UserDTO;


@Mapper
public interface AdminUserMapper {
	// 일반 유저 리스트(필터, 검색기능, 페이징)
	List<UserDTO> selectUserList(
			@Param("startRow") int startRow, @Param("listLimit") int listLimit, 
			@Param("filter") String filter, @Param("searchKeyword") String searchKeyword);
	
	// 일반 유저 수(검색 기능 포함)
	int selectUserListCount(String searchKeyword);
	
	// 일반 유저 상세 정보 
	UserDTO selectUserInfo(String idx);
	
	// 일반 유저 정보 수정
	int updateUserInfo(@Param("idx") String idx, @Param("user") UserDTO user);
	
	// 기업회원 리스트(필터, 검색기능, 페이징)
	List<UserDTO> selectCompanyList(
			@Param("startRow") int startRow, @Param("listLimit") int listLimit, 
			@Param("filter") String filter, @Param("searchKeyword") String searchKeyword);
	
	// 기업 회원 수 (검색기능 포함)
	int selectCompanyListCount(String searchKeyword);

	// 기업 상세 정보
	UserDTO selectCompanyInfo(String idx);
	
	// 기업 정보 수정
	int updateCompanyInfo(@Param("idx") String idx, @Param("company") UserDTO company);

	// 회원 상태 변경
	int updateUserStatus(@Param("idx") String idx, @Param("status") int status);

	// 알림 추가
	int insertNotificatoin(NotificationDTO notification);

	// 기업회원 사업자번호 정보
	CompanyDTO selectCompanyBizReg(String idx);
}
