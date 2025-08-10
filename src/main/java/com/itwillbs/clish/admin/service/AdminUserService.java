package com.itwillbs.clish.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.clish.admin.mapper.AdminUserMapper;
import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileUtils;
import com.itwillbs.clish.user.dto.CompanyDTO;
import com.itwillbs.clish.user.dto.UserDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
@RequiredArgsConstructor
public class AdminUserService {
	private final AdminUserMapper adminMapper;
	private final NotificationService notificationService;
	// 일반 유저 리스트(필터, 검색기능, 페이징)
	public List<UserDTO> getUserList(int startRow, int listLimit, String filter, String searchKeyword) {
		return adminMapper.selectUserList(startRow, listLimit, filter, searchKeyword);
	}
	
	// 일반 유저 수(검색 기능 포함)
	public int getUserListCount(String searchKeyword) {
		return adminMapper.selectUserListCount(searchKeyword);
	}
	
	// 일반 유저 상세 정보
	public UserDTO getuserInfo(String idx) {
		return adminMapper.selectUserInfo(idx);
	}
	
	// 기업 리스트 (필터, 검색기능, 페이징)
	public List<UserDTO> getCompanyList(int startRow, int listLimit, String filter, String searchKeyword) {
		return adminMapper.selectCompanyList(startRow, listLimit, filter, searchKeyword);
	}
	
	// 기업 회원 수 (검색 기능 포함) 
	public int getCompanyListCount(String searchKeyword) {
		return adminMapper.selectCompanyListCount(searchKeyword);
	}

	// 기업 상세 정보
	public UserDTO getcompanyInfo(String idx) {
		return adminMapper.selectCompanyInfo(idx);
	}

	// 상태 변경
	public int setUserStatus(String idx, int status) {
		return adminMapper.updateUserStatus(idx, status);
	}

	// 기업 상태 변경
	@Transactional
	public int modifyStatus(String idx, int status) {
		int update = adminMapper.updateUserStatus(idx, status);
		
		if (update > 0) {
			if (status == 1) {
				notificationService.send(idx, 5, "가입이 승인되었습니다.");			
			} 
			return update;
		}
		return 0;
	}

	// 기업 사업자등록증 정보 조회
	public CompanyDTO getCompanyBizReg(String idx) {
		return adminMapper.selectCompanyBizReg(idx);
	}
}
