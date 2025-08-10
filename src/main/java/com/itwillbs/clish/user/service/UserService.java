package com.itwillbs.clish.user.service;

import java.io.IOException;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.clish.user.dto.CompanyDTO;
import com.itwillbs.clish.user.dto.UserDTO;
import com.itwillbs.clish.user.mapper.UserMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {
	
	private final UserMapper userMapper;
	private final BCryptPasswordEncoder passwordEncoder;

	@Transactional
    public int registerCompanyUser(UserDTO userDTO, CompanyDTO companyDTO) {
    	userDTO.setUserPassword(encodePassword(userDTO.getUserPassword()));
        int userResult = userMapper.insertUser(userDTO);
        int companyResult = userMapper.insertCompany(companyDTO);
        return (userResult > 0 && companyResult > 0) ? 1 : 0;
    }

    public int registerGeneralUser(UserDTO userDTO) {
    	userDTO.setUserPassword(encodePassword(userDTO.getUserPassword()));
        return userMapper.insertUser(userDTO);
    }
    
    // 패스워드 암호화
    public String encodePassword(String plainPassword) {
        return passwordEncoder.encode(plainPassword);
    }
    
    // 패스워드 확인
    public boolean matchesPassword(String plainPassword, String encodedPassword) {
        return passwordEncoder.matches(plainPassword, encodedPassword);
    }
    
    // 유저 정보 체크
	public UserDTO selectUserId(String userId) {
		return userMapper.selectUserId(userId);
	}
	//===========================================================================
	
	public boolean isValueExists(String value, String type) {
		 switch(type) {
	        case "nickname":
	        	return userMapper.countByNickname(value) > 0;
	        case "userId":
	        	return userMapper.countByUserId(value) > 0;
	        case "userPhone":
	        	return userMapper.countByUserPhoneMatch(value) > 0;
	        default:
	            throw new IllegalArgumentException("지원하지 않는 타입: " + type);
	    }
	}
	
	// 닉네임 중복 체크
	public boolean isNickExists(String nickname) {
		return userMapper.countByNickname(nickname) > 0;
	}
	
	// 유저 아이디 중복 체크
	public boolean isUserIdExists(String userId) {
		 return userMapper.countByUserId(userId) > 0;
	}
	
	// 전화1 중복 체크
	public boolean isUserPhoneExists(String userPhone) {
		return userMapper.countByUserPhoneMatch(userPhone) > 0;
	}
	
	//==========================================================================
	
	// 이메일로 아이디 찾기
	public String findUserIdByEmail(String email) {
		return userMapper.selectUserIdByEmail(email);
	}

	public boolean foundByIdEmail(String userId, String email) {
		return userMapper.countByIdAndEmail(userId, email) > 0;
	}

	public boolean chekingExists(String type, String value) {
		
		
		return false;
	}


}