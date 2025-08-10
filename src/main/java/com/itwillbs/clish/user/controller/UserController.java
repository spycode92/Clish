package com.itwillbs.clish.user.controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileUtils;
import com.itwillbs.clish.user.dto.CompanyDTO;
import com.itwillbs.clish.user.dto.UserDTO;
import com.itwillbs.clish.user.service.UserService;
import com.wf.captcha.SpecCaptcha;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/user")
public class UserController {
	
	private final UserService userService;
	
	//회원가입
	@GetMapping("/join")
	public String showJoinTypePage() {
	    return "/user/join_way";
	}
	
	//일반-기업 분류 회원가입
	@GetMapping("/join/form")
	public String joinForm(HttpSession session, @RequestParam(required = false) String from) {
	    if("general".equals(from)) {
	        session.setAttribute("userType", 1);
	    } else if("company".equals(from)) {
	        session.setAttribute("userType", 2);
	    }
	    return "user/join_form";
	}
	
	// 회원가입 완료
	@PostMapping("/register")
	public String processJoin( 
			@ModelAttribute UserDTO userDTO,
		    @RequestParam(required = false) MultipartFile bizFile, // 회사일 때만 들어옴
		    @RequestParam(required = false) String bizRegNo,
		    HttpSession session, Model model, RedirectAttributes redirect) throws IOException {

	    String prefix = (userDTO.getUserType() == 1) ? "user" : "comp";
	    String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
	    String userIdx = prefix + now;
	    userDTO.setUserIdx(userIdx);
	    
	    CompanyDTO companyDTO = null;
	    if(userDTO.getUserType() == 2) {
	    	companyDTO = new CompanyDTO();
	        companyDTO.setUserIdx(userIdx);
	        companyDTO.setBizRegNo(bizRegNo);

	        // 파일 업로드 처리
	        if(bizFile != null && !bizFile.isEmpty()) {
	            List<FileDTO> files = FileUtils.uploadFile(
	                new FileUtils.FileUploadHelpper() {
	                    public MultipartFile[] getFiles() { return new MultipartFile[]{bizFile}; }
	                    public String getIdx() { return userIdx; }
	                }, session
	            );
	            
	            if(!files.isEmpty()) {
	                FileDTO file = files.get(0);
	                companyDTO.setBizFileName(file.getOriginalFileName());
	                companyDTO.setBizFilePath(file.getSubDir() + "/" + file.getRealFileName());
	            }
	        }
	    }

	    int result = (userDTO.getUserType() == 2)
	        ? userService.registerCompanyUser(userDTO, companyDTO)
	        : userService.registerGeneralUser(userDTO);

	    if(result > 0) {
	    	return "redirect:/user/login";
	    } else {
	        redirect.addFlashAttribute("errorMsg", "회원가입 실패");
	        return "redirect:/";
	    }
	}
	
	@GetMapping("/join_success")
	public String joinSuccess() {
		return "/user/join_success";
	}
	
	@GetMapping("/login")
//	public String showLoginForm(HttpServletRequest request, HttpSession session) {
	public String showLoginForm(HttpSession session, 
			@RequestParam(value="prevURL", required=false) String prevURL, 
		    @RequestParam(value="params", required=false) String params) {
//		String lastAddress =  request.getHeader("Referer");
//		
//		// 세션에 로그인 클릭한 페이지 저장
//		if(lastAddress != null
//	        && !lastAddress.contains("/user/login")
//	        && !lastAddress.contains("/user/join")) {
//	        session.setAttribute("lastAddress", lastAddress);
//	    }
		
		if(prevURL != null) session.setAttribute("prevURL", prevURL);
	    if(params != null) session.setAttribute("params", params);

	    return "user/login_form";
	}
	
	@PostMapping("/login")
	public String login(
	        @ModelAttribute UserDTO userDTO,
	        @RequestParam(value = "captcha", required = false) String inputCaptcha,
	        @RequestParam(value = "rememberId", required = false) String rememberId,
	        HttpServletResponse response, HttpSession session, RedirectAttributes redirect) {
		
	    UserDTO dbUser = userService.selectUserId(userDTO.getUserId());
//	    String lastAddress = (String) session.getAttribute("lastAddress");
	    String prevURLParams = (String)session.getAttribute("params");
	    String lastAddress = (String)session.getAttribute("prevURL") + (prevURLParams.length() > 0 ? "?" + prevURLParams : "");
	    String sessionCaptcha = (String) session.getAttribute("captcha");
	    Integer failCount = (Integer) session.getAttribute("loginFailCount"); // 세션에 로그인 시도 횟수
	    
	    if(failCount == null) failCount = 0;
	    
	    if(dbUser == null || !userService.matchesPassword(userDTO.getUserPassword(), dbUser.getUserPassword())) {
	    	redirect.addFlashAttribute("errorMsg", "아이디 비밀번호를 확인해주세요");
	    	session.setAttribute("loginFailCount", failCount + 1);
	    	return "redirect:/user/login";
	    }

	    if(Objects.equals(dbUser.getUserStatus(), 3)) {
	        redirect.addFlashAttribute("errorMsg", "탈퇴한 회원입니다.");
	        session.setAttribute("loginFailCount", failCount + 1);
	        return "redirect:/user/login";
	    }
	    
	    if(failCount >= 3) {
	    	// 캡차 검증
		    if(sessionCaptcha == null || !sessionCaptcha.equals(inputCaptcha.trim().toLowerCase())) {
		    	redirect.addFlashAttribute("errorMsg", "자동입력방지 문자가 올바르지 않습니다.");
		    	session.setAttribute("loginFailCount", failCount + 1);
		    	return "redirect:/user/login";
		    }
		    // 캡차 사용 후 값 삭제
		    session.removeAttribute("captcha");
	    }
	    
	    // 세션 값 저장
	    session.setAttribute("sUT", dbUser.getUserType());
	    session.setAttribute("sId", dbUser.getUserId());
	    session.setAttribute("sIdx", dbUser.getUserIdx());
	    session.setAttribute("loginUser", dbUser);
	    session.setMaxInactiveInterval(60 * 60 * 24);
	    
	    // 쿠키에 아이디 기억하기
	    Cookie cookie = new Cookie("rememberId", dbUser.getUserId());
	    cookie.setPath("/");
	    if(rememberId != null) {
	        cookie.setMaxAge(60 * 60 * 24 * 30); 
	    } else {
	        cookie.setMaxAge(0);
	    }
	    response.addCookie(cookie);
	    
	    session.setAttribute("loginFailCount", 0); // 로그인 성공시 failCount 리셋
	    
	    return "redirect:" + lastAddress;
	}
	
	// 보안이미지
	@GetMapping("/captcha")
	public void captcha(HttpServletResponse response, HttpSession session) throws IOException {
		// 1. 캡차 객체 생성 (width, height, 문자 개수)
		SpecCaptcha captcha = new SpecCaptcha(130, 48, 5);
		
		// 2. 문자값을 세션에 저장
		session.setAttribute("captcha", captcha.text().toLowerCase());
		
		// 3. 응답 헤더 설정
		response.setContentType("image/png");
		response.setHeader("Pragma", "No-cache");
		response.setHeader("Cache-Control", "no-cache");
		response.setDateHeader("Expire", 0);
		
		// 4. 이미지 출력
		captcha.out(response.getOutputStream());
	}
	
	// 아이디 찾기 페이지 열기
	@GetMapping("/findLoginIdForm")
	public String showFindLoginIdForm() {
	    return "user/findLoginIdForm";
	}

	// 아이디 찾기 AJAX 작동
	@GetMapping("/findLoginId")
	@ResponseBody
	public Map<String, Object> findLoginId(@RequestParam String email, HttpSession session) {
		Map<String, Object> result = new HashMap<>();
		
		// 1. 이메일로 아이디 찾기
		String foundId = userService.findUserIdByEmail(email);
		
		// 2. 결과 반환
		if(foundId != null && !foundId.isEmpty()) {
			result.put("foundId", foundId);
			System.out.println("foundId : " + foundId);
		} else {
			result.put("foundId", null);
		}
		
		return result;
	}
	
	// 아이디 찾기 페이지 열기
	@GetMapping("/findPasswdForm")
	public String showFindPasswdForm() {
	    return "user/findPasswdForm";
	}
	
	@GetMapping("/foundByIdEmail")
	@ResponseBody
	public Map<String, Object> foundByIdEmail(@RequestParam String email, @RequestParam String userId) {
		Map<String, Object> result = new HashMap<>();
		boolean exists = userService.foundByIdEmail(userId, email);
		result.put("exists", exists);
		return result;
	}
	
//	@PostMapping("/saveEmailSession")
//	public String saveEmailSession(@RequestParam("user_email") String userEmail,
//	                               HttpSession session, RedirectAttributes redirect) {
//	    session.setAttribute("user_email", userEmail);
//	    redirect.addFlashAttribute("authMsg", "======");
//	    return "redirect:/member/general_join";
//	}
	
	//========================================================================================================
	
	@GetMapping("/checkNname")
	@ResponseBody
	public Map<String, Boolean> checkNickname(@RequestParam String nickname) {
	    boolean nickExists = userService.isNickExists(nickname);
	    Map<String, Boolean> result = new HashMap<>();
	    result.put("exists", nickExists);
	    return result;
	}
	
	@GetMapping("/checkId")
	@ResponseBody
	public Map<String, Boolean> checkId(@RequestParam String userId) {
	    boolean idExists = userService.isUserIdExists(userId);
	    Map<String, Boolean> result = new HashMap<>();
	    result.put("exists", idExists);
	    return result;
	}
	
	@GetMapping("/checkPhone")
	@ResponseBody
	public Map<String, Boolean> checkPhone(@RequestParam String userPhone) {
	    boolean phoneExists = userService.isUserPhoneExists(userPhone);
	    Map<String, Boolean> result = new HashMap<>();
	    result.put("exists", phoneExists);
	    return result;
	}
	//========================================================================================================
	// check 합본
	
	@GetMapping("/checkData")
	@ResponseBody
	public Map<String, Boolean> checkData(@RequestParam String type, @RequestParam String value) {
		Map<String, Boolean> result = new HashMap<>();
		
		boolean exists = userService.isValueExists(type, value);
		
		result.put("exists", exists);
		return result;
	}
	
	//========================================================================================================
}
