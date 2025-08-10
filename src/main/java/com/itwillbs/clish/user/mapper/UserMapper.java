package com.itwillbs.clish.user.mapper;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.clish.user.dto.CompanyDTO;
import com.itwillbs.clish.user.dto.UserDTO;

public interface UserMapper {

	int insertUser(UserDTO userDTO);

	int insertCompany(CompanyDTO companyDTO);

	UserDTO selectUserId(String userId);
	
	boolean existsByEmail(String email);
	
	// 중복체크 =============================================================================
	
	// 닉네임 중복체크
	int countByNickname(@Param("nickname") String nickname);
	
	// 아이디 중복체크
	int countByUserId(@Param("userId") String userId);
	
	// 핸드폰 중복체크
	int countByUserPhoneMatch(@Param("userPhone") String userPhone);
	
	// ======================================================================================
	
	
	// 이메일로 아이디 찾기
	String selectUserIdByEmail(String email);
	
	// 아이디와 이메일로 유저 존재 유무 검색
	int countByIdAndEmail(@Param("userId")String userId, @Param("email")String email);

}
