package com.itwillbs.clish.admin.mapper;

import java.util.List;

import com.itwillbs.clish.admin.dto.CategoryRevenueDTO;
import com.itwillbs.clish.admin.dto.RevenueDTO;

public interface AdminDashboardMapper {

	// 유저 수 
	int selectUserCount();

	// 기업 수
	int selectCompanyCount();

	// 승인 대기 중인 강의 수
	int selectPendingClassCount();

	// 승인 대기 중인 기업 수
	int selectPendingCompanyCount();

	// 미답변 문의글 수 
	int selectUnAnsweredInquiryCount();
	
	// 일별 매출
	List<RevenueDTO> selectDailyRevenue();

	// 월별 매출
	List<RevenueDTO> selectMonthlyRevenue();

	// 카테고리별 매출
	List<CategoryRevenueDTO> selectCategoryRevenue();


}
