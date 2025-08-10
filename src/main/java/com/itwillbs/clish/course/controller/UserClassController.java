package com.itwillbs.clish.course.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.itwillbs.clish.admin.service.AdminCustomerService;
import com.itwillbs.clish.common.dto.PageInfoDTO;
import com.itwillbs.clish.common.utils.PageUtil;
import com.itwillbs.clish.course.dto.ClassDTO;
import com.itwillbs.clish.course.dto.CurriculumDTO;
import com.itwillbs.clish.course.service.CompanyClassService;
import com.itwillbs.clish.course.service.CurriculumService;
import com.itwillbs.clish.course.service.UserClassService;
import com.itwillbs.clish.myPage.dto.InqueryDTO;
import com.itwillbs.clish.myPage.dto.ReservationDTO;
import com.itwillbs.clish.myPage.dto.ReviewDTO;
import com.itwillbs.clish.user.dto.UserDTO;
import com.itwillbs.clish.user.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/course")
@RequiredArgsConstructor
public class UserClassController {
	private final CompanyClassService companyClassService;
	private final UserClassService userClassService;
	private final UserService userService;
	private final CurriculumService curriculumService;
	private final AdminCustomerService adminCustomerService;
	
	// 클래스 리스트
	@GetMapping("/user/classList")
	public String classListForm(Model model, HttpSession session,
			@RequestParam(defaultValue = "0") int classType,
			@RequestParam(defaultValue = "1") int pageNum,
			@RequestParam(required = false)String categoryIdx,
			@RequestParam(defaultValue = "") String searchType,
			@RequestParam(defaultValue = "") String searchClassKeyword) {
		
		// 세션 객체에 있는 유저정보를 UserDTO에 저장
		String userId = (String)session.getAttribute("sId");
		UserDTO userInfo = userService.selectUserId(userId);
		
		// 검색어 앞 뒤 공백 제거
		searchClassKeyword = searchClassKeyword.trim();
		
		int listLimit = 3; // 한 페이지에 보이는 최대 갯수
		int listCount = userClassService.getClassListCount(searchType, searchClassKeyword, categoryIdx, classType); // 총 조회된 클래스 갯수
		
		System.out.println("searchType : " + searchType);
		
		if(listCount > 0) {
			// 페이징 정보를 관리하는 PageInfoDTO 객체 생성 및 계산 결과 저장
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, listCount, pageNum, 3);
			if(pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/user/classList"); // 기본 페이지가 1페이지이므로 페이지 파라미터 불필요
				return "commons/result_process";
			}
			
			// Model 객체에 PageInfoDTO 객체 저장
			model.addAttribute("pageInfoDTO", pageInfoDTO);
			
			// 클래스 리스트를 불러올 List<ClassDTO> 객체 생성
			List<ClassDTO> classList = userClassService.getClassList(pageInfoDTO.getStartRow(), listLimit, searchType, searchClassKeyword, categoryIdx, classType);
			
			// Model 객체에 조회된 게시물 목록 정보(List 객체) 저장
			model.addAttribute("classList", classList);
		}
		
		// model 객체에 담아서 뷰 페이지로 이동
		model.addAttribute("userInfo", userInfo);
		
		return "/course/user/course_list";
	}
	
	// 클래스 상세 페이지
	@GetMapping("/user/classDetail")
	public String classDetailForm(@RequestParam String classIdx, Model model, HttpSession session,
			@RequestParam(defaultValue = "0") int classType,
			@RequestParam(required = false)String categoryIdx,
			@RequestParam(defaultValue = "1") int reviewPageNum) {
		
		String userId = (String)session.getAttribute("sId");
		UserDTO userInfo = userService.selectUserId(userId); // user 정보
		ClassDTO classInfo = companyClassService.getClassInfo(classIdx); // class 정보
		LocalDate start = classInfo.getStartDate(); // LocalDate 타입일 경우
		LocalDate applyEnd = start.minusDays(1);
		
		// 커리큘럼 리스트를 불러올 List<ClassDTO> 객체 생성 
		List<CurriculumDTO> curriculumList = curriculumService.getCurriculumList(classIdx);
		
		// 리뷰목록 페이징
		int listLimit = 2; // 한 페이지에 불러올 최대 리뷰 갯수 
		int reviewListCount = userClassService.getClassReviewCount(classIdx); // 리뷰 갯수 확인
		
		if(reviewListCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, reviewListCount, reviewPageNum, 3);
			if(reviewPageNum < 1 || reviewPageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/myPage/myReview"); 
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
			
			List<ReviewDTO> reviewList = userClassService.getClassReview(pageInfoDTO.getStartRow(), listLimit, classIdx);
			
			model.addAttribute("reviewList", reviewList);
		}
		
		// model 객체에 담아서 뷰 페이지로 이동
		model.addAttribute("classInfo", classInfo); // 클래스 정보
		model.addAttribute("userInfo", userInfo); // 유저 정보
		model.addAttribute("curriculumList", curriculumList); // 커리큘럼 목록
		model.addAttribute("applyEndDate", applyEnd); // 신청 마감일
		
		return "/course/user/course_detail";
	}
	
	// 예약정보 입력 페이지
	@GetMapping("/user/classReservation")
	public String classReservation(@RequestParam String classIdx, Model model, HttpSession session, 
			ClassDTO classDTO, UserDTO userDTO, ReservationDTO reservationDTO,
			@RequestParam(defaultValue = "0") int classType,
			@RequestParam(required = false)String categoryIdx,
			@RequestParam(defaultValue = "1") int reviewPageNum) {
		
		String userId = (String)session.getAttribute("sId");
		UserDTO userInfo = userService.selectUserId(userId); // user 정보
		ClassDTO classInfo = companyClassService.getClassInfo(classIdx); // class 정보
		LocalDate start = classInfo.getStartDate(); // LocalDate 타입일 경우
		LocalDate applyEnd = start.minusDays(1);
		
		int total = classInfo.getClassMember(); // 전체 강의 예약 인원 
	    int reservationMembers = userClassService.selectReservationMembers(classInfo.getClassIdx()); // 현재 예약 인원 
	    int availableMembers = total - reservationMembers; // 예약 가능 인원
	    
		// 비회원이라면 로그인 페이지로 이동
		if(userId == null) {
			return "/user/login";
		}
		
		List<CurriculumDTO> curriculumList = curriculumService.getCurriculumList(classIdx);
		
		// 리뷰목록 페이징
		int listLimit = 2; // 한 페이지에 불러올 최대 리뷰 갯수 
		int reviewListCount = userClassService.getClassReviewCount(classIdx); // 리뷰 갯수 확인
		
		if(reviewListCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, reviewListCount, reviewPageNum, 3);
			if(reviewPageNum < 1 || reviewPageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/myPage/myReview"); 
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
			
			List<ReviewDTO> reviewList = userClassService.getClassReview(pageInfoDTO.getStartRow(), listLimit, classIdx);
			
			model.addAttribute("reviewList", reviewList);
		}
		
		// model 객체에 담아서 뷰 페이지로 이동
		model.addAttribute("classInfo", classInfo); // 클래스 정보
		model.addAttribute("userInfo", userInfo); // 유저 정보
		model.addAttribute("curriculumList", curriculumList); // 커리큘럼 목록
		model.addAttribute("availableMembers", availableMembers); // 예약 가능 인원
		model.addAttribute("applyEndDate", applyEnd); // 신청 마감일
		
		return "/course/user/course_reservation";
	}
	
	// 예약 정보 INSERT 및 myPage 이동
	@GetMapping("/user/reservationInfo")
	public String classReservationSuccess(Model model, HttpSession session, ReservationDTO reservationDTO, ClassDTO classDTO,
			@RequestParam("reservationClassDateRe")@DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
			@RequestParam("reservationMembers")int reservationMembers,
			@RequestParam("availableMembers") int availableMembers) {
		
		classDTO = companyClassService.getClassInfo(classDTO.getClassIdx()); // class 정보
	    LocalDate startDate = classDTO.getStartDate(); // 클래스 시작일
	    LocalDate endDate   = classDTO.getEndDate(); // 클래스 마감일
	    
	    // 신청 가능 날짜인지 검사 
	    if (date.isBefore(startDate) || date.isAfter(endDate)) {
	        model.addAttribute("msg", "선택할 수 없는 날짜입니다.");
	        return "/commons/fail";
	    }
	    
	    // 예약 가능한지 검사
	    if(availableMembers < reservationMembers) {
	    	model.addAttribute("msg", "예약인원이 가득차서 예약할 수 없습니다.");
	    	return "/commons/fail";
	    } 
	    
	    if(reservationMembers <= 0) {
	    	model.addAttribute("msg", "한 명 이상의 예약 인원을 입력해주세요.");
	    	return "/commons/fail";
	    }
	    
	    // LocalDate → LocalDateTime 변환 (시간을 00:00:00 으로 세팅)
	    LocalDateTime localDateTime = date.atStartOfDay();
		
		// reservationIdx 생성
		String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
		String reservationIdx = "RE" + now;
		
		reservationDTO.setReservationClassDate(localDateTime); // 예약일자
		reservationDTO.setReservationIdx(reservationIdx); // 예약번호
		
		// 예약정보 INSERT
		int reservationInsertCount = userClassService.registReservation(reservationDTO);
		System.out.println("reservationInsertCount : " + reservationInsertCount);
		
		return "redirect:/myPage/payment_info";
	}
	
}
