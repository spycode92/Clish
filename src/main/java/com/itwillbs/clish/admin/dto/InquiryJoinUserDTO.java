package com.itwillbs.clish.admin.dto;

import com.itwillbs.clish.myPage.dto.InqueryDTO;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class InquiryJoinUserDTO {
	private InqueryDTO inquiry;
	private String classIdx;
	private int inqueryType; // 1: 1:1문의 2: 강의 문의
	private String userName;
}
