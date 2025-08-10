package com.itwillbs.clish.common.emailAuth;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

@Controller
@RequiredArgsConstructor
@RequestMapping("/email")
@Log4j2
public class EmailAuthController {

    private final EmailAuthService emailAuthService;

    @PostMapping("/send")
    @ResponseBody
    public Map<String, Object> sendEmailAuth(@RequestBody EmailAuthDTO dto) {
    	Map<String, Object> res = new HashMap<>();
    	String token = emailAuthService.createAndSendToken(dto.getUserEmail(), dto.getPurpose());

    	if(token != null) {
			res.put("status", "이메일 발송 성공");
			res.put("token", token);
		} else {
			res.put("status", "이메일 발송 실패");
		}
    	
		return res;
    }

    @GetMapping("/verify")
    public String verifyToken(
            @RequestParam("token") String token,
            @RequestParam(value = "purpose", required = false) String purpose,
            Model model) {
    	
        // EmailAuthResultDTO 타입으로 결과 받기
        EmailAuthResultDTO resultDTO = emailAuthService.verifyToken(token, purpose);

        // 인증 메시지와 이메일 전달
        model.addAttribute("authResult", resultDTO.getMessage());
        model.addAttribute("verifiedEmail", resultDTO.getVerifiedEmail());

        return "email/verify";
    }
    
    @GetMapping("/check")
    @ResponseBody
    public Map<String, Object> checkEmailAuth(@RequestParam String email) {
    	boolean verified = emailAuthService.isEmailVerified(email);

    	Map<String, Object> result = new HashMap<>();
    	result.put("verified", verified);
    	return result;
    }
}