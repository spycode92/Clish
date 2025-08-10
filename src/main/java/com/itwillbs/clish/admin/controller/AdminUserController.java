package com.itwillbs.clish.admin.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.clish.admin.dto.CategoryRevenueDTO;
import com.itwillbs.clish.admin.dto.DashboardSummaryDTO;
import com.itwillbs.clish.admin.dto.RevenueDTO;
import com.itwillbs.clish.admin.service.AdminDashboardService;
import com.itwillbs.clish.admin.service.AdminUserService;
import com.itwillbs.clish.common.dto.PageInfoDTO;
import com.itwillbs.clish.common.utils.PageUtil;
import com.itwillbs.clish.user.dto.CompanyDTO;
import com.itwillbs.clish.user.dto.UserDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequestMapping("admin")
@RequiredArgsConstructor
public class AdminUserController {
	private final AdminUserService adminService;
	private final AdminDashboardService adminDashboardService;
	
	// 관리자 메인 페이지
	@GetMapping("/main")
	public String adminIndex(DashboardSummaryDTO summaryDTO, Model model) {
		adminDashboardService.getSummary(summaryDTO);
		
		model.addAttribute("summary", summaryDTO);

		return "/admin/admin_page";
	}
	
	// 일별 매출
	@GetMapping("/revenue/daily")
	@ResponseBody
	public List<RevenueDTO> getDailyRevenue() {
		return adminDashboardService.getDailyRevenue();
	}
	
	// 월별 매출
	@GetMapping("/revenue/monthly")
	@ResponseBody
	public List<RevenueDTO> getMonthlyRevenue() {
		return adminDashboardService.getMonthlyRevenue();
	}
	
	// 카테고리별 매출
	@GetMapping("/revenue/category")
	@ResponseBody
	public List<CategoryRevenueDTO> getCategoryRevenue() {
		return adminDashboardService.getCategoryRevenue();
	}
	
	// 일반 회원 정보 리스트
	@GetMapping("/user")
	public String userList(
			@RequestParam(defaultValue = "1") int pageNum, 
			@RequestParam(defaultValue = "all") String filter,
			@RequestParam(defaultValue = "") String searchKeyword,
			Model model) {
		
		searchKeyword = searchKeyword.trim();
		
		int listLimit = 10;
		int listCount = adminService.getUserListCount(searchKeyword);
		
		if (listCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, listCount, pageNum, 5);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/admin/user");
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
			
			List<UserDTO> userList = adminService.getUserList(pageInfoDTO.getStartRow(), listLimit, filter, searchKeyword);
			model.addAttribute("users", userList);
		}
		return "/admin/user/user_list";
	}
	
	// 일반 회원 상세 정보
	@GetMapping("/user/{idx}")
	public String userInfo(@PathVariable("idx") String idx, Model model) {
		UserDTO userInfo = adminService.getuserInfo(idx);
		String phone = masktedPhone(userInfo.getUserPhoneNumber());
		String phoneSub = masktedPhone(userInfo.getUserPhoneNumberSub());
		
		model.addAttribute("user", userInfo);
		model.addAttribute("phone", phone);
		model.addAttribute("phoneSub", phoneSub);
		return "/admin/user/user_info";
	}
	
	private String masktedPhone(String phone) {
		String maskedPhone = "";
		if (phone != null && phone.length() == 13) {
		    maskedPhone = phone.substring(0, 4) + 
		                  phone.substring(4, 8) + 
		                  "****";
		} else {
		    maskedPhone = "";
		}
		
		return maskedPhone;
	}
	
	
	// 일반 회원 탈퇴처리
	@PostMapping("/user/{idx}/withdraw")
	public String userWithdraw(@PathVariable("idx") String idx, Model model) {
		int count = adminService.setUserStatus(idx, 3);
		
		if (count > 0) {
			model.addAttribute("msg", "탈퇴를 처리했습니다.");
			model.addAttribute("targetURL", "/admin/user");
		} else {
			model.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "commons/result_process";
	}
	
	
	// 기업 정보 리스트
	@GetMapping("/company")
	public String companyList(
			@RequestParam(defaultValue = "1") int pageNum, 
			@RequestParam(defaultValue = "all") String filter,
			@RequestParam(defaultValue = "") String searchKeyword,
			Model model) {
		searchKeyword = searchKeyword.trim();
		
		int listLimit = 10;
		int listCount = adminService.getCompanyListCount(searchKeyword);
		
		if (listCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, listCount, pageNum, 5);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/admin/company");
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
			
			List<UserDTO> companyList = adminService.getCompanyList(pageInfoDTO.getStartRow(), listLimit, filter, searchKeyword);
			model.addAttribute("companys", companyList);
		}
		return "/admin/user/company_list";
	}
	
	// 기업 상세 정보
	@GetMapping("/company/{idx}")
	public String companyInfo(@PathVariable("idx") String idx, Model model) {
		UserDTO companyInfo = adminService.getcompanyInfo(idx);
		CompanyDTO comDto = adminService.getCompanyBizReg(idx);
		
		String phone = masktedPhone(companyInfo.getUserPhoneNumber());
		String phoneSub = masktedPhone(companyInfo.getUserPhoneNumberSub());
		
		model.addAttribute("company", companyInfo);
		model.addAttribute("phone", phone);
		model.addAttribute("phoneSub", phoneSub);
		model.addAttribute("comDto", comDto);
		
		return "/admin/user/company_info";
	}
	
	// 기업 승인
	@PostMapping("/company/{idx}/approve")
	public String approveCompany(@PathVariable("idx") String idx, Model model) {
		int success = adminService.modifyStatus(idx, 1);
		
		if (success > 0) {
			model.addAttribute("msg", "승인 완료되었습니다.");
			model.addAttribute("targetURL", "/admin/company");
		} else {
			model.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "commons/result_process";
	}
	
	// 일반 회원 탈퇴처리
	@PostMapping("/company/{idx}/withdraw")
	public String companyWithdraw(@PathVariable("idx") String idx, Model model) {
		int count = adminService.modifyStatus(idx, 3);
		
		if (count > 0) {
			model.addAttribute("msg", "탈퇴 처리했습니다.");
			model.addAttribute("targetURL", "/admin/company");
		} else {
			model.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "commons/result_process";
	}
	
	
}
