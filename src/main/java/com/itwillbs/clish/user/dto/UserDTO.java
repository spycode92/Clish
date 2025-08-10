package com.itwillbs.clish.user.dto;

import java.sql.Date;
//import java.util.Date;

import java.sql.Timestamp;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileUtils.FileUploadHelpper;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class UserDTO implements FileUploadHelpper{
	private String userIdx;
	private String userName;
	private String userRepName;
	private Date userBirth;
	private String userGender;
	private String userId;
	private String userPassword;
	private String userEmail;
	private String newEmail;
	private String userPhoneNumber;
	private String userPhoneNumberSub;
	private String userPostcode;
	private String userAddress1;
	private String userAddress2;
	private int userStatus;
	private Date userRegDate;
	private Date userWithdrawDate;
	private int userType;
	private int userPenaltyCount;
	
	// 파일업로드
	private MultipartFile[] files;
	private List<FileDTO> fileList;
	
	@Override
	public MultipartFile[] getFiles(){
		return files;
	}
	
	@Override
	public String getIdx() {
		return userIdx;
	}
}
