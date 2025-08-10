package com.itwillbs.clish.admin.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.clish.admin.dto.CategoryRevenueDTO;
import com.itwillbs.clish.admin.dto.DashboardSummaryDTO;
import com.itwillbs.clish.admin.dto.RevenueDTO;
import com.itwillbs.clish.admin.mapper.AdminDashboardMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminDashboardService {
	private final AdminDashboardMapper adminDashboardMapper;

	// 회원, 기업, 강의, 문의 미답변 게시물 수 
	@Transactional(readOnly = true)
	public void getSummary(DashboardSummaryDTO summaryDTO) {
		int userCount = adminDashboardMapper.selectUserCount();
		int companyCount = adminDashboardMapper.selectCompanyCount();
		int pendingCompanyCount = adminDashboardMapper.selectPendingCompanyCount();
		int pendingClassCount = adminDashboardMapper.selectPendingClassCount();
		int unAnsweredInquiryCount = adminDashboardMapper.selectUnAnsweredInquiryCount();
		
		summaryDTO.setUserCount(userCount);
		summaryDTO.setCompanyCount(companyCount);
		summaryDTO.setPendingCompanyCount(pendingCompanyCount);
		summaryDTO.setPendingClassCount(pendingClassCount);
		summaryDTO.setUnAnsweredInquiryCount(unAnsweredInquiryCount);
	}

	// 일별 매출
	public List<RevenueDTO> getDailyRevenue() {
		List<RevenueDTO> list = adminDashboardMapper.selectDailyRevenue();
		
		for (RevenueDTO dto : list) {
			dto.setType("daily");
		}
		
		return list;
	}

	// 월별 매출
	public List<RevenueDTO> getMonthlyRevenue() {
		List<RevenueDTO> list = adminDashboardMapper.selectMonthlyRevenue();
		
		for (RevenueDTO dto : list) {
			dto.setType("Monthly");
		}
		
		return list;
	}

	// 카테고리별 매출
	public List<CategoryRevenueDTO> getCategoryRevenue() {
		
		return adminDashboardMapper.selectCategoryRevenue();
	}
	
}
