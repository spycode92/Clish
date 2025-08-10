package com.itwillbs.clish.admin.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DashboardSummaryDTO {
	private int userCount;
	private int companyCount;
	private int pendingClassCount; // 승인 대기 중인 강의 수
	private int pendingCompanyCount; // 승인 대기 중인 기업 수
	private int unAnsweredInquiryCount; // 미답변 게시물 수
}
