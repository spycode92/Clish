package com.itwillbs.clish.company.controller;

import java.util.List;
import java.util.Map;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;  // ← 날짜 포맷용
import java.util.Date;              // ← 시간 객체
import java.util.HashMap;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.clish.admin.dto.InquiryJoinUserDTO;
import com.itwillbs.clish.admin.dto.NotificationDTO;
import com.itwillbs.clish.common.dto.PageInfoDTO;
import com.itwillbs.clish.common.file.FileUtils;
import com.itwillbs.clish.common.utils.PageUtil;
import com.itwillbs.clish.company.service.CompanyInfoService;
import com.itwillbs.clish.course.service.CompanyClassService;
import com.itwillbs.clish.myPage.dto.InqueryDTO;
import com.itwillbs.clish.user.dto.CompanyDTO;
import com.itwillbs.clish.user.dto.UserDTO;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/company")
@RequiredArgsConstructor
public class CompanyInfoController {
	private final CompanyInfoService companyInfoService;
	
	// 정보 수정 전 비밀번호 확인페이지
	@GetMapping("/myPage/companyCheckPw")
	public String companyCheckPwForm(HttpSession session) {
		return "company/companyCheckPw";
	}
	
	// 비밀번호 확인 일치시 수정페이지로 불일치시 비밀번호가 틀렸습니다 메시지
	@PostMapping("/myPage/companyInfo")
	public String companyInfoForm(UserDTO user, HttpSession session, Model model) {
		// 로그인한 기업회원 정보 조회
		String inputPw = user.getUserPassword();
		
		// 세션에서 userId 설정
		user.setUserId((String) session.getAttribute("sId"));
		
		// DB에서 암호화된 비번 포함한 기업회원 정보 조회
		user = companyInfoService.getUserInfo(user);
		
		
		// 비밀번호 검증 (암호화된 비번 비교)
		if (user != null && companyInfoService.matchesPassword(inputPw, user.getUserPassword())) {
			model.addAttribute("user", user);
			
			CompanyDTO company = companyInfoService.getCompanyInfo(user.getUserIdx());
			model.addAttribute("company", company);
			
			return "company/companyInfo";
		}
		
		model.addAttribute("msg", "비밀번호가 틀렸습니다.");
		model.addAttribute("targetUrl", "/company/myPage/companyCheckPw");
		return "commons/result_process";
	}
	
	// 기업전화번호 중복 확인 
	@GetMapping("/myPage/checkPhone")
	@ResponseBody
	public String checkPhoneDuplicate(@RequestParam("userPhoneNumber") String userPhoneNumber, @RequestParam("userIdx") String userIdx) {
		// 중복 확인
	    boolean isDuplicate = companyInfoService.isPhoneNumberDuplicate(userPhoneNumber, userIdx);
	    
	    return String.valueOf(isDuplicate); // "true" 또는 "false" 문자열로 반환
	}
	
	
	@PostMapping("/myPage/companyInfoSubmit")
	// 수정정보 UPDATE문 으로 반영 후 메인페이지로 이동
	public String companyInfoSubmit(UserDTO user, CompanyDTO company, HttpSession session,
	        @RequestParam("userPasswordConfirm") String new_password,
	        @RequestParam(value = "files", required = false) MultipartFile file, Model model) {

	    try {
	        // 세션에서 유저 ID 가져오기
	        user.setUserId((String) session.getAttribute("sId"));
	        UserDTO user1 = companyInfoService.getUserInfo(user); // 기존 유저 정보 불러오기

	        // 이메일 변경 여부 체크
	        if (!user1.getUserEmail().equals(user.getUserEmail())) {
	            user.setNewEmail(user.getUserEmail());
	        }

	        // 비밀번호 변경 여부 체크
	        if (!new_password.isEmpty()) {
	            user.setUserPassword(new BCryptPasswordEncoder().encode(new_password));
	        } else {
	            user.setUserPassword(user1.getUserPassword());
	        }

	        // 사업자등록증 파일 업로드 처리
	        if (file != null && !file.isEmpty()) {
	            try {
	                String uploadDirPath = "/usr/local/tomcat/webapps/resources/upload/biz";
	                String subDir = FileUtils.createDirectories(uploadDirPath);
//	                File uploadDir = new File(uploadDirPath);
//	                if (!uploadDir.exists()) uploadDir.mkdirs();

	                String originName = file.getOriginalFilename();
	                String uuid = UUID.randomUUID().toString();
	                String newFileName = uuid + "_" + originName;
	                File dest = new File(uploadDirPath + "/" + subDir, newFileName);
	                file.transferTo(dest);

	                company.setBizFileName(newFileName);
	                company.setBizFilePath(subDir + newFileName);
	            } catch (IOException e) {
	                e.printStackTrace();
	                throw new RuntimeException("파일 업로드 실패");
	            }
	        } else {
	            // 파일이 없는 경우 -> 기존 정보 유지
	            CompanyDTO existingCompany = companyInfoService.getCompanyInfo(user1.getUserIdx());
	            company.setBizFileName(existingCompany.getBizFileName());
	            company.setBizFilePath(existingCompany.getBizFilePath());
	        }

	        // 회사 정보 업데이트 또는 삽입
	        company.setUserIdx(user1.getUserIdx());
	        companyInfoService.setUserInfo(user);

	        CompanyDTO existingCompany = companyInfoService.getCompanyInfo(user1.getUserIdx());
	        if (existingCompany == null) {
	            companyInfoService.insertCompanyInfo(company);
	        } else {
	            companyInfoService.setCompanyInfo(company);
	        }
	        
	        // 최신 정보 다시 조회해서 JSP에 넘김
	        UserDTO updatedUser = companyInfoService.getUserInfo(user); 
	        CompanyDTO updatedCompany = companyInfoService.getCompanyInfo(updatedUser.getUserIdx());

	        model.addAttribute("user", updatedUser);
	        model.addAttribute("company", updatedCompany);
	        
	        // 성공
	        model.addAttribute("modifySuccess", true);

	    } catch (Exception e) {
	        e.printStackTrace();
	        // 실패 시: 입력했던 값을 그대로 전달
	        model.addAttribute("user", user);         // 입력했던 유저 값 유지
	        model.addAttribute("company", company);   // 입력했던 기업 값 유지
	        model.addAttribute("modifySuccess", false);
	    }

	    return "company/companyInfo"; // JSP로 forward
	}
	// ------------------------------------------------------------------------------------------------------------------
	// 기업 - 나의 문의 목록(리스트) 조회
	@GetMapping("/myPage/myQuestion")
	public String showInquiryForm(HttpSession session, Model model, @RequestParam(defaultValue = "1") int inquiryPageNum) {
		// 세션에서 로그인한 userId 가져오기
		String userId = (String) session.getAttribute("sId"); 
		// userIdx 조회
		String userIdx = companyInfoService.getUserIdxByUserId(userId); 
		
		// 한 페이지에 보여줄 문의 수
		int listLimit = 6;
		// 전체 문의 개수 조회
		int inquiryListCount = companyInfoService.getInquiryCountByUserIdx(userIdx);
		
		// 페이징 처리
		if (inquiryListCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(
				listLimit,                // 한 페이지당 개수
				inquiryListCount,        // 전체 문의 수
				inquiryPageNum,          // 현재 페이지 번호
				3                        // 하단에 보여줄 페이지 번호 수
			);

			// 페이지 번호 유효성 검사
			if (inquiryPageNum < 1 || inquiryPageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/company/myPage");
				return "commons/result_process";
			}

			// 페이징 정보 전달
			model.addAttribute("inquiryPageInfo", pageInfoDTO);
		
			// 페이징 적용된 문의 리스트 가져오기
			List<InquiryJoinUserDTO> inquiryList = companyInfoService.getInquiriesByUserIdx(
				pageInfoDTO.getStartRow(), listLimit, userIdx
			);

			model.addAttribute("test", inquiryList);
		}
	    

        return "company/companyMyQuestion"; 
    }
	
	
	// 문의 등록 폼
	@GetMapping("/myPage/writeInquery")
	public String goWriteInquery(Model model) {
	    // 등록 폼이니까 비어있는 inqueryDTO 넘겨도 됨
	    model.addAttribute("inqueryDTO", null); 
	    return "/company/companyMyQuestionForm";
	}
	
	// 문의 등록버튼 로직
	@PostMapping("/myPage/writeInquery")
	public String writeInquery(HttpSession session, InqueryDTO dto) {
		// 로그인 세션에서 user_id(hong)를 가져옴
	    String userId = (String) session.getAttribute("sId");
	    System.out.println("세션 userId: " + userId);
		
	    // user_id로 실제 user_idx 조회
	    String userIdx = companyInfoService.getUserIdxByUserId(userId);
	    System.out.println("조회한 userIdx: " + userIdx);
	    
	    // DTO에 user_idx 세팅
	    dto.setUserIdx(userIdx);
	    
		// inquery_idx 생성
		String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
		int random = new Random().nextInt(1000); // 0~999
		String inqueryIdx = String.format("INQ%s%03d", timestamp, random);
		dto.setInqueryIdx(inqueryIdx); // 직접 세팅
		
		
		companyInfoService.insertInquery(dto);
		return "redirect:/company/myPage/myQuestion";
	}
	
	// 문의 수정 폼
	@GetMapping("/myPage/modifyInquery")
	public String modifyInqueryForm(@RequestParam("inqueryIdx") String inqueryIdx, Model model) {
		
		// 파라미터로 전달받은 inqueryIdx를 이용해서 해당 문의 상세 정보를 조회
	    InqueryDTO dto = companyInfoService.getInqueryByIdx(inqueryIdx);
	    model.addAttribute("inqueryDTO", dto);
	    
	    return "/company/companyMyQuestionForm";
	}
	
	// 문의 수정버튼 로직
	@PostMapping("/myPage/modifyInquery")
	public String modifySubmit(InqueryDTO dto) {
		// 수정된 DTO 데이터를 서비스에 넘겨 DB 업데이트 수행
	    companyInfoService.updateInquery(dto);
	    
	    // 수정 후 문의 목록 페이지로 리다이렉트
	    return "redirect:/company/myPage/myQuestion";
	}
	
	// 문의 삭제 버튼 로직
	@PostMapping("/myPage/delete")
	public String deleteInquery(@RequestParam("inqueryIdx") String inqueryIdx) {
	    companyInfoService.deleteInquery(inqueryIdx);
	    return "redirect:/company/myPage/myQuestion";
	}
	// -----------------------------------------------------------------------------------------------------
	// 기업 - 나의 알림
	@GetMapping("/myPage/notification")
	public String companyNotification(HttpSession session, UserDTO user, Model model,
            							@RequestParam(defaultValue = "1") int notificationPageNum) {
		
		// 1. 세션에서 로그인한 userId 가져오기
	    String userId = (String) session.getAttribute("sId");
	    user.setUserId(userId);

	    // 2. DB에서 userIdx 포함된 전체 유저 정보 조회
	    user = companyInfoService.getUserInfo(user);

	    // 3. 한 페이지에 보여줄 알림 개수 설정
	    int listLimit = 10;

	    // 4. 전체 알림 개수 조회
	    int notificationListCount = companyInfoService.getNotificationCount(user);

	    // 5. 알림이 1개 이상일 경우에만 페이징 처리
	    if (notificationListCount > 0) {

	        // 페이징 계산
	        PageInfoDTO pageInfoDTO = PageUtil.paging(
	                listLimit,                // 한 페이지당 개수
	                notificationListCount,   // 전체 개수
	                notificationPageNum,     // 현재 페이지 번호
	                3                        // 하단에 보여줄 페이지 번호 개수
	        );

	        // 잘못된 pageNum 처리
	        if (notificationPageNum < 1 || notificationPageNum > pageInfoDTO.getMaxPage()) {
	            model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
	            model.addAttribute("targetURL", "/company/myPage");
	            return "commons/result_process";
	        }

	        // 페이징 정보 모델에 추가
	        model.addAttribute("notificationPageInfo", pageInfoDTO);

	        // 알림 리스트 가져오기
	        List<NotificationDTO> notificationList =
	                companyInfoService.selectNotification(pageInfoDTO.getStartRow(), listLimit, user);

	        model.addAttribute("notificationList", notificationList);
	    }

	    return "/company/companyNotification";
	}
	
	// 알림 읽음 처리
	@PostMapping("/myPage/notification/{noticeIdx}/read")
	@ResponseBody
	public ResponseEntity<String> readNotification(@PathVariable("noticeIdx") String noticeIdx) {
	    companyInfoService.updateNotificationReadStatus(noticeIdx);
	    return ResponseEntity.ok("읽음 처리 완료");
	}
	
	// 모두 읽음 처리
	@PostMapping("/myPage/notification/all-read")
	@ResponseBody
	public Map<String, String> readAllNotification(HttpSession session, UserDTO user) {
	    String userId = (String) session.getAttribute("sId");
	    user.setUserId(userId);

	    user = companyInfoService.getUserInfo(user); // user_idx 가져오기

	    int updateCount = companyInfoService.updateAllNotificationReadStatus(user.getUserIdx());

	    Map<String, String> result = new HashMap<>();
	    result.put("result", updateCount > 0 ? "모두 읽음 처리 완료" : "처리된 알림 없음");
	    return result;
	}
	// -----------------------------------------------------------------------------------------------------
	// 기업 회원 탈퇴
	@GetMapping("/myPage/withdraw")
	public String withdrawPage() {
	    return "/company/companyMypageWithdraw"; 
	}
	
	// 회원 탈퇴 - 비밀번호 확인 일치시 수정페이지로 불일치시 비밀번호가 틀렸습니다 메시지
	@PostMapping("/myPage/withdraw")
	public String withdrawForm(HttpSession session, UserDTO user, Model model) {
//	    String userIdx = (String) session.getAttribute("sId");
//	    user.setUserIdx(userIdx);

	    String inputPw = user.getUserPassword(); // 사용자가 입력한 평문 비번
	    
	    // 세션에서 userId 설정
	    user.setUserId((String) session.getAttribute("sId"));

	    // DB에서 암호화된 비번 포함한 유저 정보 조회
	    user = companyInfoService.getUserInfo(user);

	    if (user != null && companyInfoService.matchesPassword(inputPw, user.getUserPassword())) {
	    	model.addAttribute("step", "confirm");
	        return "company/companyMypageWithdrawResult";
	    } else {
	        model.addAttribute("msg", "비밀번호가 일치하지 않습니다.");
	        return "commons/fail";
	    }
	    
	}
	
	// 회원탈퇴 버튼 로직 
	@PostMapping("/myPage/withdrawFinal")
	public String withdrawFinal(HttpSession session, Model model) {
	    String userId = (String) session.getAttribute("sId");
	    System.out.println("*****세션에서 가져온 userIdx: " + userId);
	    
	    UserDTO user = new UserDTO();
	    user.setUserId(userId);

	    int result = companyInfoService.withdraw(user);
	    
	    // 탈퇴 성공
	    if (result > 0) {
	        session.invalidate(); // 세션 끊기 (로그아웃)
	        model.addAttribute("msg", "탈퇴가 완료되었습니다.");
	        model.addAttribute("targetUrl", "/");
	    } else {
	    	// 탈퇴 실패
	    	model.addAttribute("msg", "탈퇴에 실패했습니다. 다시 시도해주세요.");
	        model.addAttribute("targetUrl", "/company/myPage/withdraw");  // 비밀번호 확인 페이지로 다시
	    }
	    
	    return "company/companyMypageWithdrawResult";
	}
}










