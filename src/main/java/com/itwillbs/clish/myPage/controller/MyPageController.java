package com.itwillbs.clish.myPage.controller;

import java.beans.PropertyEditorSupport;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.clish.admin.dto.NotificationDTO;
import com.itwillbs.clish.common.dto.PageInfoDTO;
import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileService;
import com.itwillbs.clish.common.utils.PageUtil;
import com.itwillbs.clish.course.dto.ClassDTO;
import com.itwillbs.clish.myPage.dto.InqueryDTO;
import com.itwillbs.clish.myPage.dto.PaymentInfoDTO;
import com.itwillbs.clish.myPage.dto.ReservationDTO;
import com.itwillbs.clish.myPage.dto.ReviewDTO;
import com.itwillbs.clish.myPage.service.MyPageService;
import com.itwillbs.clish.user.dto.UserDTO;
import com.itwillbs.clish.user.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/myPage")
public class MyPageController {
	private final MyPageService myPageService;
	private final UserService userService;
	private final FileService fileService;
	
	// 폼 submit시 DTO에 주입할 데이터 변경[SQL : DATETIME -> DTO TIMESTAMP]
	@InitBinder
    public void initBinder(WebDataBinder binder) {
	    
		binder.registerCustomEditor(LocalDateTime.class, new PropertyEditorSupport() {
	        @Override
	        public void setAsText(String text) throws IllegalArgumentException {
	            if (text == null || text.trim().isEmpty()) {
	                setValue(null);
	            } else {
	                String value = text.trim();
	                if (value.length() == 10) {  // 날짜만 있는 경우
	                    value = value + "T00:00:00";  // 기본 시간 세팅
	                } else {
	                    value = value.replace('T', ' ');  // "T"를 공백으로 치환
	                }
	                setValue(LocalDateTime.parse(value));
	            }
	        }
	    });
	}
	
	//마이페이지프로필이미지
	@GetMapping("/profileImg")
	@ResponseBody
	public Map<String, Object> sidebarProfileImg(HttpSession session) {
		UserDTO user = getUserFromSession(session);
		FileDTO file = myPageService.getUserProfileImg(user);
		Map<String, Object> result = new HashMap<>();
		
		if (file != null && (Integer)file.getFileId() != null ) {
	        result.put("result", "success");
	        result.put("src", "/file/" + file.getFileId() + "?type=0");
	    } else {
	        result.put("result", "default");
	        result.put("src", "/resources/images/default_profile_photo.png");
	    }
		
		return result;
	}
		
	
	// 마이페이지 메인
	@GetMapping("/main")
	public String myPage_main(HttpSession session, Model model
			, @RequestParam(defaultValue = "1") int recentReservePageNum
			, @RequestParam(defaultValue = "1") int recentSiteInqueryPageNum
			, @RequestParam(defaultValue = "1") int recentClassInqueryPageNum
			) {
		UserDTO user = new UserDTO();
		//유저정보 불러오기
		user = getUserFromSession(session);
		model.addAttribute("user",user);
		// 삭제할 예약목록 삭제
		myPageService.reservationCheck(user);
		// 메인페이지에 정보 전달할 리스트 객체생성
		List<Map<String,Object>> mainList = new ArrayList<>();
		// 페이징에 필요한 변수선언
		int listLimit = 2;
		// 나의 최근 예약 목록 수
		int myRecentReservationCount = myPageService.getRecentReservationCount(user);
		// 나의 최근 예약 목록 수 가 1개 이상일 때
		if(myRecentReservationCount > 0 ) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, myRecentReservationCount, recentReservePageNum, 3);
			// pageNum에 이상한 파라미터가 넘어올 때
			if(recentReservePageNum < 1 || recentReservePageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/myPage/payment_info"); 
				return "commons/result_process";
			}
			model.addAttribute("recentReservePageInfo", pageInfoDTO);
			
			// 나의 최근 예약 목록리스트
			mainList = myPageService.getRecentReservation(pageInfoDTO.getStartRow(), listLimit, user);
			model.addAttribute("RecentReservation",mainList);
		} else {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, myRecentReservationCount, recentReservePageNum, 3);
			
			model.addAttribute("recentReservePageInfo", pageInfoDTO);
			
		}
		
		// 나의 최근 1:1 문의 답변[7일]
		int myRecentSiteInqueryCount = myPageService.getRecentSiteInqueryCount(user);
		// 나의 최근 1:1 문의 답변 수 가 1개 이상일 때
		if(myRecentSiteInqueryCount > 0 ) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, myRecentSiteInqueryCount, recentSiteInqueryPageNum, 3);
			// pageNum에 이상한 파라미터가 넘어올 때
			if(recentReservePageNum < 1 || recentReservePageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/myPage/payment_info"); 
				return "commons/result_process";
			}
			
			model.addAttribute("recentSiteInqueryPageInfo", pageInfoDTO);
			
			// 나의 최근 1:1문의 답변리스트
			mainList = myPageService.getRecentSiteInquery(pageInfoDTO.getStartRow(), listLimit, user);
			model.addAttribute("RecentSiteInquery",mainList);
		} else {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, myRecentSiteInqueryCount, recentReservePageNum, 3);
			
			model.addAttribute("recentSiteInqueryPageInfo", pageInfoDTO);
		} 
		
		// 나의 최근 강의 문의 답변[7일]
		int myRecentClassInqueryCount = myPageService.getRecentClassInqueryCount(user);
		// 나의 최근 1:1 문의 답변 수 가 1개 이상일 때
		if(myRecentClassInqueryCount > 0 ) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, myRecentClassInqueryCount, recentClassInqueryPageNum, 3);
			// pageNum에 이상한 파라미터가 넘어올 때
			if(recentReservePageNum < 1 || recentReservePageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/myPage/payment_info"); 
				return "commons/result_process";
			}
			
			model.addAttribute("recentClassInqueryPageInfo", pageInfoDTO);
			
			// 나의 최근 1:1문의 답변리스트
			mainList = myPageService.getRecentClassInquery(pageInfoDTO.getStartRow(), listLimit, user);
			model.addAttribute("RecentClassInquery",mainList);
		} else {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, myRecentClassInqueryCount, recentReservePageNum, 3);
			
			model.addAttribute("recentClassInqueryPageInfo", pageInfoDTO);
		}
		
		
		
		
		return "/clish/myPage/myPage_main";
	}
	
	// ------------------------------------------------------------------------------------
	
	// 마이페이지 정보변경
	@GetMapping("/change_user_info")
	public String mypage_change_user_info_main(HttpSession session) {
		return "/clish/myPage/myPage_change_user_info";
	}
	
	// 비밀번호 확인 일치시 수정페이지로 불일치시 비밀번호가 틀렸습니다 메시지
	@PostMapping("/change_user_info_form")
	public String mypage_change_user_info_form(UserDTO user, HttpSession session, Model model) {
		String inputPw = user.getUserPassword(); // 입력받은 pw
			
		user.setUserId((String)session.getAttribute("sId"));
		user = myPageService.getUserInfo(user); // 세션id 유저 정보
		FileDTO userProfileImg = myPageService.getUserProfileImg(user);
		System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
		System.out.println(userProfileImg);
		System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
		if (user == null || !userService.matchesPassword(inputPw, user.getUserPassword())) { // 비밀번호 불일치 할때
			model.addAttribute("msg","비밀번호가 틀렸습니다.");
			model.addAttribute("targetURL","/myPage/change_user_info");
			return "commons/result_process";
	    }

		model.addAttribute("userProfileImg", userProfileImg);
		model.addAttribute("user", user);
		return "clish/myPage/myPage_change_user_info_form"; //비밀번호 일치시 이동페이지
	}
	
	//닉네임 중복확인
	@GetMapping("/check/repName")
	public ResponseEntity<Map<String, String>> checkRepName(UserDTO userDTO) { // userDTO에 userRepName, userIdx 주입
		Map<String, String> response = new HashMap<>(); // 리턴할 response객체생성
		// 입력받은 userRepName과 일치하는 user정보 받기
		UserDTO user = myPageService.checkRepName(userDTO);  
		// 유저서비스 닉네임 중복 있는지 카운트 체크
		if(userService.isNickExists(userDTO.getUserRepName())) {
			// 닉네임이 중복인데 idx가 동일할 경우
			if(user.getUserIdx().equals(userDTO.getUserIdx())) {
				System.out.println("idx일치");
				response.put("msg", "사용가능 닉네임");
				response.put("status", "success");
				response.put("repName", userDTO.getUserRepName());
				return ResponseEntity.ok(response);
			}
			// 닉네임이 존재하는데 idx가 일치하지않음
			response.put("msg", "사용불가능 닉네임");
			response.put("status", "fail");
			return ResponseEntity.ok(response);
		} else { // 닉네임 중복이 없는 경우
			response.put("msg", "사용가능 닉네임");
			response.put("status", "success");
			response.put("repName", userDTO.getUserRepName());
			return ResponseEntity.ok(response);
		}
	}
	
	//핸드폰중복 확인 
	@GetMapping("/check/userPhoneNumber")
	@ResponseBody
	public ResponseEntity<Map<String, String>> checkPhoneNumber(UserDTO userDTO) {
		// 리턴받을 맵객체
		Map<String, String> response = new HashMap<>(); 
		// 입력받은 번호로 유저정보 검색
		UserDTO user = myPageService.checkPhoneNumber(userDTO);
		// 핸드폰번호 중복확인
		if(userService.isUserPhoneExists(userDTO.getUserPhoneNumber())) {
			// 중복일경우
			if(user.getUserIdx().equals(userDTO.getUserIdx())) { // 현재 내가 사용중인 번호인 경우
				System.out.println("idx일치");
				response.put("msg", "사용가능 번호");
				response.put("status", "success");
				return ResponseEntity.ok(response);
			}
			
			response.put("msg", "사용불가능 번호");
			response.put("status", "fail");
			return ResponseEntity.ok(response);
		} else { // 중복이 없을때
			response.put("msg", "사용가능 번호");
			response.put("status", "success");
			return ResponseEntity.ok(response);
		}
	}
	
	// 수정정보 UPDATE문 으로 반영후 정보변경 메인페이지로 이동
	@PostMapping("/change_user_info")
	public String mypage_change_user_info(UserDTO user, HttpSession session,
			@RequestParam("newPasswordConfirm") String new_password
			, @RequestParam("profileImageAction") String profileImageAction
			, @RequestParam("deleteProfileImgFlag") String deleteProfileImgFlag) throws IOException {
		
		user.setUserId((String)session.getAttribute("sId"));
		UserDTO user1 = getUserFromSession(session);// 기존 유저 정보 불러오기
		//기존 프로필사진 유무정보
		FileDTO userProfileImg = myPageService.getUserProfileImg(user);
		
		//입력받은 이메일과 기존의 이메일이 일치한다면
		if(!user1.getUserEmail().equals(user.getUserEmail())){
			user.setNewEmail(user.getUserEmail()); //새이메일에 기존이메일 정보 추가
		}
		
		if(!new_password.isEmpty()) { // 새비밀번호가 있다면 비밀번호 새로지정
			user.setUserPassword(userService.encodePassword(new_password));
		}else { // 아니면 기존 비밀번호 유지
			user.setUserPassword(user1.getUserPassword());
		}
				
		myPageService.setUserInfo(user, userProfileImg, profileImageAction, deleteProfileImgFlag);
		
		return "redirect:/myPage/change_user_info";
	}
	
	//------------------------------------------------------------------------------------
	//예약/결제내역
		
	// 예약/결제 목록 불러오기
	@GetMapping("/payment_info")
	public String payment_info(HttpSession session, Model model,UserDTO user
		,@RequestParam(defaultValue = "1") int reservationPageNum
		,@RequestParam(defaultValue = "reservation_class_date") String reservationOrderBy
		,@RequestParam(defaultValue = "desc") String reservationOrderDir
		,@RequestParam(defaultValue = "1") int paymentPageNum
		,@RequestParam(defaultValue = "pay_time") String paymentOrderBy
		,@RequestParam(defaultValue = "desc") String paymentOrderDir) {
		
		model.addAttribute("reservationOrderBy", reservationOrderBy);
		model.addAttribute("reservationOrderDir", reservationOrderDir);
		model.addAttribute("paymentOrderBy", paymentOrderBy);
		model.addAttribute("paymentOrderDir", paymentOrderDir);
		//세션에 저장된 sId이용 유저정보 불러오기
		user = getUserFromSession(session);
		
		// 페이징에 필요한 변수선언
		int listLimit = 5;
		int reservationListCount = myPageService.getReservationCount(user);
		int paymentListCount = myPageService.getPaymentCount(user);
		
		// 예약목록이 존재한다면
		if(reservationListCount > 0 ) {
			// 예약페이지 정보 저장
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, reservationListCount, reservationPageNum, 3);
			// pageNum에 이상한 파라미터가 넘어올 때
			if(reservationPageNum < 1 || reservationPageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/myPage/payment_info"); 
				return "commons/result_process";
			}
			 
			model.addAttribute("reservationPageInfo", pageInfoDTO);
			// 삭제할 예약목록 삭제
			myPageService.reservationCheck(user);
			// 예약목록 불러오기
			List<ReservationDTO> reservationList =
				myPageService.getReservationInfo(pageInfoDTO.getStartRow(), listLimit, user, reservationOrderBy, reservationOrderDir);
			// 예약목록 정보 저장
			model.addAttribute("reservationList",reservationList);

		}
		// 결제목록이 존재한다면
		if(paymentListCount > 0) {
			//결제페이지정보 저장
			PageInfoDTO pageInfoDTO = PageUtil.paging(5, paymentListCount, paymentPageNum, 3);
			
			// pageNum에 이상한 파라미터가 넘어올 때
			if(paymentPageNum < 1 || paymentPageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/myPage/payment_info"); 
				return "commons/result_process";
			}
			
			model.addAttribute("paymentPageInfo", pageInfoDTO);
			
			//결제 정보 불러오기
			List<PaymentInfoDTO> paymentList = 
				myPageService.getPaymentList(pageInfoDTO.getStartRow(), listLimit, user, paymentOrderBy, paymentOrderDir);
			
			//결제시간정보 보기좋게 바꾸기
			for(PaymentInfoDTO payment : paymentList) {
				payment.setPayTime(payment.getPayTime());
			}
			
			model.addAttribute("paymentList",paymentList);
		}
		model.addAttribute("today", LocalDate.now().toString());
		model.addAttribute("user",user);
		
		return "/clish/myPage/myPage_payment";

	}
	
	//마이페이지 - 필터 : 예약/결제
			@GetMapping("/payment_info/reservation_payment")
			public String paymentFilter(Model model, UserDTO user, HttpSession session
					, @RequestParam(defaultValue = "1") int reservationPageNum
					, @RequestParam(defaultValue = "reservation_class_date") String reservationOrderBy
					, @RequestParam(defaultValue = "desc") String reservationOrderDir
					, @RequestParam(defaultValue = "1") int paymentPageNum
					, @RequestParam(defaultValue = "pay_time") String paymentOrderBy
					, @RequestParam(defaultValue = "desc") String paymentOrderDir
					, @RequestParam("filterType") int filterType) {
				
				model.addAttribute("reservationOrderBy", reservationOrderBy);
				model.addAttribute("reservationOrderDir", reservationOrderDir);
				model.addAttribute("paymentOrderBy", paymentOrderBy);
				model.addAttribute("paymentOrderDir", paymentOrderDir);
				model.addAttribute("filterType",filterType);
				//세션에 저장된 sId이용 유저정보 불러오기
				user = getUserFromSession(session);
				
				// 페이징에 필요한 변수선언
				int listLimit = 10;
				int reservationListCount = myPageService.getReservationCount(user);
				int paymentListCount = myPageService.getPaymentCount(user);
				
				if(filterType == 0 ) { // 필터 : 예약선택
					if(reservationListCount > 0 ) {
						// 예약페이지 정보 저장
						PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, reservationListCount, reservationPageNum, 3);
						// pageNum에 이상한 파라미터가 넘어올 때
						if(reservationPageNum < 1 || reservationPageNum > pageInfoDTO.getMaxPage()) {
							model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
							model.addAttribute("targetURL", "/myPage/payment_info"); 
							return "commons/result_process";
						}
						 
						model.addAttribute("reservationPageInfo", pageInfoDTO);
						// 삭제할 예약목록 삭제
						myPageService.reservationCheck(user);
						// 예약목록 불러오기
						List<ReservationDTO> reservationList =
							myPageService.getReservationInfo(pageInfoDTO.getStartRow(), listLimit, user, reservationOrderBy, reservationOrderDir);
						// 예약목록 정보 저장
						model.addAttribute("reservationList",reservationList);

					}
				} else if(filterType == 1) {
					// 결제목록이 존재한다면
					if(paymentListCount > 0) {
						//결제페이지정보 저장
						PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, paymentListCount, paymentPageNum, 3);
						
						// pageNum에 이상한 파라미터가 넘어올 때
						if(paymentPageNum < 1 || paymentPageNum > pageInfoDTO.getMaxPage()) {
							model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
							model.addAttribute("targetURL", "/myPage/payment_info"); 
							return "commons/result_process";
						}
						
						model.addAttribute("paymentPageInfo", pageInfoDTO);
						
						//결제 정보 불러오기
						List<PaymentInfoDTO> paymentList = 
							myPageService.getPaymentList(pageInfoDTO.getStartRow(), listLimit, user, paymentOrderBy, paymentOrderDir);
						
						//결제시간정보 보기좋게 바꾸기
						for(PaymentInfoDTO payment : paymentList) {
							payment.setPayTime(payment.getPayTime());
						}
						
						model.addAttribute("paymentList",paymentList);
					}
				}
				model.addAttribute("today", LocalDate.now().toString());
				model.addAttribute("user",user);
				
				return "/clish/myPage/myPage_payment_filter";
			}
	
	//예약 취소
	@PostMapping(value="/payment_info/cancel", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public String cancelReservation(HttpSession session, ReservationDTO reservation) {
	    
		int count = myPageService.cancelReservation(reservation);
	    
		if(count == 0) {
	    	return "예약취소 실패";
	    }
	    
		return "예약이 취소되었습니다!";
	}
	
	
	//예약상세보기
	@GetMapping("/payment_info/detail")
	public String reservationDetail(HttpSession session, Model model, ReservationDTO reservation, UserDTO user, ClassDTO claSs) {
		// 세션을 이용한 유저 정보 불러오기
		user = getUserFromSession(session);
		// 남은자리 확인을 위해 예약정보 불러오기
		reservation = myPageService.getReservationDetail(reservation);
		
		// 삭제할 예약목록 삭제
		List<Map<String, Object>> toCancelList = myPageService.reservationCheck(user);
		// 삭제한 예약목록이 선택되어 있을떄
		for(Map<String, Object> cancelList: toCancelList) {
			if(((String)cancelList.get("reservationIdx")).equals(reservation.getReservationIdx())) {
				model.addAttribute("msg", "만료된 예약입니다. 다시 예약해주세요");
				model.addAttribute("targetURL", "/error");
				return "commons/result_process";
			}
		}
		
		// 예약상세정보 불러오기
		Map<String,Object> reservationDetailInfo = myPageService.reservationDetailInfo(reservation);
		ClassDTO claSs1 = new ClassDTO();
		claSs1.setClassDays((Integer) reservationDetailInfo.get("class_days"));
		reservationDetailInfo.put("classDaysNames",claSs1.getDayString() ); 
		
		
		model.addAttribute("user", user);
		model.addAttribute("reservationClassInfo", reservationDetailInfo);
		
		return "/clish/myPage/myPage_reservation_detail";
	}

	//예약 수정페이지
	@GetMapping("/payment_info/change")
	public String reservationChangeForm(HttpSession session, Model model, ReservationDTO reservation, UserDTO user) {
		
		// 세션을 이용한 유저 정보 불러오기
		user = getUserFromSession(session);
		// 남은자리 확인을 위해 예약정보 불러오기
		reservation = myPageService.getReservationDetail(reservation);
		
		// 삭제할 예약목록 삭제
		List<Map<String, Object>> toCancelList = myPageService.reservationCheck(user);
		// 삭제한 예약목록이 선택되어 있을떄
		for(Map<String, Object> cancelList: toCancelList) {
			if(((String)cancelList.get("reservationIdx")).equals(reservation.getReservationIdx())) {
				model.addAttribute("msg", "만료된 예약입니다. 다시 예약해주세요");
				model.addAttribute("targetURL", "/error");
				return "commons/result_process";
			}
		}

		Map<String,Object> reservationClassInfo = myPageService.reservationDetailInfo(reservation); 
		
		ClassDTO claSs1 = new ClassDTO();
		claSs1.setClassDays((Integer) reservationClassInfo.get("class_days"));
		reservationClassInfo.put("classDaysNames",claSs1.getDayString() ); 
		
		model.addAttribute("reservationClassInfo", reservationClassInfo);
		model.addAttribute("user",user);
		
		return "/clish/myPage/myPage_reservation_change";
	}
	
	//예약 수정 날짜변경응답
	@ResponseBody
	@GetMapping("/changeReservation/changeClassDate")
	public  Map<String, Object> changeReservationChangeClassDate(@RequestParam String classIdx,
		    @RequestParam String reservationClassDate) {

		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		LocalDateTime formateedClassDate = LocalDateTime.parse(reservationClassDate, formatter);

		ReservationDTO reservation = new ReservationDTO();
		reservation.setClassIdx(classIdx);
		reservation.setReservationClassDate(formateedClassDate);
		
		int remainSeats = myPageService.getRemainSeats(reservation);
		Map<String, Object> result = new HashMap<>();
		result.put("success", true);
		result.put("remainSeats", remainSeats);
		return result;
	}
		
	//예약 수정 폼 submit시 수행
	@PostMapping("/payment_info/change")
	public String resrvationChange(ReservationDTO reservation, Model model, HttpSession session) {
		// 세션을 이용한 유저 정보 불러오기
		UserDTO user = new UserDTO();

		user = getUserFromSession(session);
		
		// 삭제할 예약목록 삭제
		List<Map<String, Object>> toCancelList = myPageService.reservationCheck(user);
		// 삭제한 예약목록이 선택되어 있을떄
		for(Map<String, Object> cancelList: toCancelList) {
			if(((String)cancelList.get("reservationIdx")).equals(reservation.getReservationIdx())) {
				model.addAttribute("msg", "만료된 예약입니다. 다시 예약해주세요");
				model.addAttribute("targetURL", "/error");
				return "commons/result_process";
			}
		}
		myPageService.changeReservation(reservation);

		return "redirect:/myPage/payment_info/detail?reservationIdx=" + reservation.getReservationIdx();
	}
	
	//---------------------------------------------------------------------------------------
	// 회원 탈퇴페이지
	@GetMapping("/withdraw")
	public String withdraw() {
		return "/clish/myPage/myPage_withdraw";
	}
	
	// 탈퇴시 비밀번호 입력확인
	@PostMapping("/withdraw")
	public String withdrawForm(HttpSession session, UserDTO user, Model model) {
		String inputPw = user.getUserPassword(); // 입력받은 비밀번호 저장

		// 세션을 이용한 유저 정보 불러오기
		user = getUserFromSession(session);
		
		
		if (user == null || !userService.matchesPassword(inputPw, user.getUserPassword())) {
			model.addAttribute("msg","비밀번호가 틀렸습니다.");
			return "/commons/fail";
	    }
		
		return "/clish/myPage/myPage_withdraw_withdrawResult";
	}
	
	// 회원탈퇴동의 후 최종탈퇴
	@PostMapping(value="/withdrawFinal", produces="application/json; charset=UTF-8")
	@ResponseBody
	public String withdrawFinal(HttpSession session, UserDTO user) {
		// 세션을 이용한 유저 정보 불러오기
		user = getUserFromSession(session);
		
		int withdrawResult = myPageService.withdraw(user);
		if(withdrawResult >0) {
			session.invalidate();
			return "탈퇴완료";
		} else {
			return "탈퇴실패";
		}
	}
	
	// --------------------------------------------------------------------------------
	// 나의 문의
	@GetMapping("/myQuestion")
	public String myQuestion(HttpSession session, Model model, UserDTO user
		, @RequestParam(defaultValue = "1") int classQuestionPageNum
		, @RequestParam(defaultValue = "inquery_datetime") String classQOrderBy
		, @RequestParam(defaultValue = "desc") String classQOrderDir 
		, @RequestParam(defaultValue = "1") int inqueryPageNum
		, @RequestParam(defaultValue = "inquery_datetime") String inqueryOrderBy
		, @RequestParam(defaultValue = "desc") String inqueryOrderDir ){
		
		model.addAttribute("classQOrderBy",classQOrderBy);
		model.addAttribute("classQOrderDir",classQOrderDir);
		model.addAttribute("inqueryOrderBy",inqueryOrderBy);
		model.addAttribute("inqueryOrderDir",inqueryOrderDir);
		
		// 세션을 이용한 유저 정보 불러오기
		user = getUserFromSession(session);
		// 페이징위한 변수 저장
		int listLimit = 5;
		int classQCount = myPageService.getclassQCount(user);
		if(classQCount > 0 ) {
			// 페이지 정보 저장
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, classQCount, classQuestionPageNum, 3);
			
			// 이상한pageNum 파라미터 대처
			if(classQuestionPageNum < 1 || classQuestionPageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/myPage/myQuestion");
				return "commons/result_process";
			}
			
			model.addAttribute("classQPageInfo", pageInfoDTO);
			
			// 강의문의 목록 불러오기 
			List<InqueryDTO> classQDTOList = myPageService.getMyclassQ(pageInfoDTO.getStartRow(), listLimit, user, classQOrderBy, classQOrderDir);
			
			model.addAttribute("classQDTOList",classQDTOList);
			model.addAttribute("user", user);

		}
		// 사이트문의
		int inqueryCount = myPageService.getInqueryCount(user);
		if(inqueryCount > 0 ) {
			// 페이지 정보 저장
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, inqueryCount, inqueryPageNum, 3);
			
			// 이상한pageNum 파라미터 대처
			if(inqueryPageNum < 1 || inqueryPageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/myPage/myQuestion"); 
				return "commons/result_process";
			}
			
			model.addAttribute("inqueryPageInfo", pageInfoDTO);

			// 사이트 문의 목록 불러오기
			List<InqueryDTO> inqueryDTOList = myPageService.getMyInquery(pageInfoDTO.getStartRow(), listLimit, user, inqueryOrderBy, inqueryOrderDir);
			
			model.addAttribute("inqueryDTOList",inqueryDTOList);
			model.addAttribute("user", user);

		}
		
		return "/clish/myPage/myPage_question";
	}
	
	// 문의 필터링
	@GetMapping("/myQuestion/question_inquery")
	public String myQuestionFilter(HttpSession session, Model model, UserDTO user
		, @RequestParam(defaultValue = "1") int classQuestionPageNum
		, @RequestParam(defaultValue = "inquery_datetime") String classQOrderBy
		, @RequestParam(defaultValue = "desc") String classQOrderDir 
		, @RequestParam(defaultValue = "1") int inqueryPageNum
		, @RequestParam(defaultValue = "inquery_datetime") String inqueryOrderBy
		, @RequestParam(defaultValue = "desc") String inqueryOrderDir
		, @RequestParam("filterType") int filterType){
		
		model.addAttribute("classQOrderBy",classQOrderBy);
		model.addAttribute("classQOrderDir",classQOrderDir);
		model.addAttribute("inqueryOrderBy",inqueryOrderBy);
		model.addAttribute("inqueryOrderDir",inqueryOrderDir);
		model.addAttribute("filterType",filterType);
		// 세션을 이용한 유저 정보 불러오기
		user = getUserFromSession(session);
		// 페이징위한 변수 저장
		int listLimit = 10;
		int classQCount = myPageService.getclassQCount(user);
		int inqueryCount = myPageService.getInqueryCount(user);
		
		if (filterType == 0) { // 강의 문의 일때
			if(classQCount > 0 ) {
				// 페이지 정보 저장
				PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, classQCount, classQuestionPageNum, 3);
				
				// 이상한pageNum 파라미터 대처
				if(classQuestionPageNum < 1 || classQuestionPageNum > pageInfoDTO.getMaxPage()) {
					model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
					model.addAttribute("targetURL", "/myPage/myQuestion");
					return "commons/result_process";
				}
				
				model.addAttribute("classQPageInfo", pageInfoDTO);
				// 강의문의 목록 불러오기 
				List<InqueryDTO> classQDTOList = myPageService.getMyclassQ(pageInfoDTO.getStartRow(), listLimit, user, classQOrderBy, classQOrderDir);
				
				model.addAttribute("classQDTOList",classQDTOList);
				model.addAttribute("user", user);
			}
		}
		if (filterType == 1) {
			// 사이트문의
			if(inqueryCount > 0 ) {
				// 페이지 정보 저장
				PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, inqueryCount, inqueryPageNum, 3);
				
				// 이상한pageNum 파라미터 대처
				if(inqueryPageNum < 1 || inqueryPageNum > pageInfoDTO.getMaxPage()) {
					model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
					model.addAttribute("targetURL", "/myPage/myQuestion"); 
					return "commons/result_process";
				}
				model.addAttribute("inqueryPageInfo", pageInfoDTO);

				// 사이트 문의 목록 불러오기
				List<InqueryDTO> inqueryDTOList = myPageService.getMyInquery(pageInfoDTO.getStartRow(), listLimit, user, inqueryOrderBy, inqueryOrderDir);
				
				model.addAttribute("inqueryDTOList",inqueryDTOList);
				model.addAttribute("user", user);
			}
		}
		return "/clish/myPage/myPage_question_filter";
	}
	
	
	// 문의 수정폼
	@GetMapping("/myQuestion/inquery/modify")
	public String inqueryModifyForm(InqueryDTO inqueryDTO, Model model, HttpSession session, UserDTO user) {
		// 세션을 이용한 유저 정보 불러오기
		user = getUserFromSession(session);
		// inqueryIdx를 이용, inquery정보 불러오기
		inqueryDTO = myPageService.getInqueryInfo(inqueryDTO);
		
		model.addAttribute("inqueryDTO", inqueryDTO);
		model.addAttribute("user",user);
		
		return "/clish/myPage/myPage_question_inqueryForm";
	}
	
	// 문의수정 완료
	@PostMapping("/myQuestion/inquery/modify")
	public String inqueryModify(InqueryDTO inqueryDTO, Model model, HttpSession session, UserDTO user) throws IOException {
		// 세션을 이용한 유저 정보 불러오기
		user = getUserFromSession(session);
		
		InqueryDTO oriInqueryDTO = myPageService.getInqueryInfo(inqueryDTO);
		
		if (oriInqueryDTO.getInqueryStatus() == 2) { // 문의상태가 답변완료 인 경우
			
			model.addAttribute("msg","이 문의는 수정이 불가능한 상태입니다.");
			model.addAttribute("targetURL","/myPage/myQuestion");
			
			return "commons/result_process";
		} 
				
		myPageService.modifyInquery(inqueryDTO);

		return "redirect:/myPage/myQuestion";
	}
	
	// 문의 삭제
	@PostMapping("/myQuestion/inquery/delete")
	public String inqueryDelete(InqueryDTO inqueryDTO) {
		
		myPageService.inqueryDelete(inqueryDTO);
		
		return "redirect:/myPage/myQuestion";
	}
	
	// 문의 수정중 첨부파일 삭제
	@GetMapping("/myQuestion/fileDelete")
	public String deleteFile(InqueryDTO inqueryDTO, FileDTO fileDTO) {
		fileService.removeFile(fileDTO);
		return "redirect:/myPage/myQuestion/inquery/modify?inqueryIdx="+ inqueryDTO.getInqueryIdx();
	}
	
	//------------------------------------------------------------------------------------------------------------------
	// 알림전체보기
	@GetMapping("/notification")
	public String notification(HttpSession session, UserDTO user, Model model
			, @RequestParam(defaultValue = "1") int notificationPageNum) {
		// 세션을 이용한 유저 정보 불러오기
		user = getUserFromSession(session);
		
		// 페이징 변수 선언
		int listLimit = 10;
		int notificationListCount = myPageService.getnotificationCount(user);
		// 알림이 존재할때
		if(notificationListCount > 0) {
			// 페이지 정보 저장
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, notificationListCount, notificationPageNum, 3);
			
			// pageNum 이상한 파라미터 대처
			if(notificationPageNum < 1 || notificationPageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/myPage/payment_info"); 
				return "commons/result_process";
			}
			
			model.addAttribute("notificationPageInfo", pageInfoDTO);
			
			// 알림목록 불러오기
			List<NotificationDTO> notificationList = myPageService.selectNotification(pageInfoDTO.getStartRow(), listLimit, user);
			model.addAttribute("notificationList",notificationList);
		}
		return "/clish/myPage/myPage_notification";
	}
	
	// ------------------------------------------------------------------------------------------------------------
	// 후기 관리
	@GetMapping("/myReview")
	public String myReview(Model model,HttpSession session, UserDTO user,
			@RequestParam(defaultValue = "0") int reviewCom,
			@RequestParam(defaultValue = "1") int reviewPageNum) {
	
		// 세션을 이용한 유저 정보 불러오기
		user = getUserFromSession(session);
		
		// 페이징 변수 저장
		int listLimit = 5;
		
		// 작성가능 리뷰(예약일 부터 수강후기 작성 가능)
		if(reviewCom == 0) {
			int reviewListCount = myPageService.getUncompleteReviewCount(user);
			
			if(reviewListCount > 0) {
				PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, reviewListCount, reviewPageNum, 3);
				
				if(reviewPageNum < 1 || reviewPageNum > pageInfoDTO.getMaxPage()) {
					model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
					model.addAttribute("targetURL", "/myPage/myReview"); 
					return "commons/result_process";
				}
				
				model.addAttribute("pageInfo",pageInfoDTO);
				
				List<Map<String, Object>> uncompleteReviewList = myPageService.getUncompleteReview(pageInfoDTO.getStartRow(), listLimit, user);
				
				model.addAttribute("reviewInfo",uncompleteReviewList);
				
			} 
		} else {
			// 작성한 후기 수
			int reviewListCount = myPageService.getCompleteReviewCount(user);
			
			// 작성한 후기가 1개이상일때
			if(reviewListCount > 0) {
				// 페이지정보저장
				PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, reviewListCount, reviewPageNum, 3);
				// 이상한파라미터 대처
				if(reviewPageNum < 1 || reviewPageNum > pageInfoDTO.getMaxPage()) {
					model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
					model.addAttribute("targetURL", "/myPage/myReview"); 
					return "commons/result_process";
				}
				
				model.addAttribute("pageInfo",pageInfoDTO);
				// 작성완료한 후기 목록
				List<ReviewDTO> completeReviewList = myPageService.getCompleteReview(pageInfoDTO.getStartRow(), listLimit, user);
				
				model.addAttribute("reviewInfo",completeReviewList);

			} 
		}
		
	    model.addAttribute("reviewPageNum", reviewPageNum);
	    model.addAttribute("reviewCom", reviewCom);
	    
		return "/clish/myPage/myPage_myReview";
	}
	
	//수강후기 작성페이지
	@GetMapping("/myReview/writeReviewForm")
	public String writeReviewForm(ReservationDTO reservationDTO, HttpSession session, UserDTO user, Model model) {
		
		Map<String, Object> reservationClassInfo = myPageService.getReservationClassInfo(reservationDTO);
		
		model.addAttribute("reservationClassInfo",reservationClassInfo);
		
		return "/clish/myPage/myPage_myReview_writeReviewForm";
	}
	
	// 수강후기 작성완료처리
	@PostMapping("/myReview/writeReview")
	public String writeReview(ReviewDTO review, HttpSession session) throws IOException {
		UserDTO user = new UserDTO();
		// 세션을 이용한 유저 정보 불러오기
		user = getUserFromSession(session);
		
		myPageService.writeReview(review, user);
		
		return "redirect:/myPage/myReview";
	}
	
	// 작성된 후기 삭제
	@ResponseBody
	@PostMapping("/myReview/deleteReview")
	public Map<String, Object> deleteReview(ReviewDTO reviewDTO) {
		Map<String,Object> result = new HashMap<>();
		
		int delCount = myPageService.deleteReview(reviewDTO);
		
		if (delCount > 0) {
			result.put("msg", "후기 삭제 완료.");
		} else {
			result.put("msg", "삭제 실패");
		}
		
		return result;
	}
	
	// 작성된 후기 수정폼
	@GetMapping("/myReview/modifyReviewForm")
	public String modifyReviewForm(ReviewDTO reviewDTO, Model model) {
		reviewDTO = myPageService.getReviewInfo(reviewDTO);
		
		model.addAttribute("reviewDTO", reviewDTO);
		
		return "/clish/myPage/myPage_myReview_modifyReviewForm";
	}
	
	// 수정시 첨부 파일삭제
	@GetMapping("myReview/removeFile")
	public String removeFile(FileDTO fileDTO, ReviewDTO reviewDTO) {
		
		fileService.removeFile(fileDTO);
		
		return "redirect:/myPage/myReview/modifyReviewForm?reviewIdx="+ reviewDTO.getReviewIdx();
	}
	
	// 후기 수정 완료
	@PostMapping("/myReview/modifyReview")
	public String modifyReview(ReviewDTO reviewDTO, Model model) throws IOException {
		
		myPageService.modifyReview(reviewDTO);
		
		return "redirect:/myPage/myReview";
	}
	
	// 세션을 이용한 유저 정보 불러오기
	public UserDTO getUserFromSession(HttpSession session) {
	    String id = (String) session.getAttribute("sId");
	    UserDTO user = new UserDTO();
	    user.setUserId(id);
	    return myPageService.getUserInfo(user);
	}
	
}









































