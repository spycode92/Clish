package com.itwillbs.clish.common.emailAuth;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.clish.user.mapper.UserMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class EmailAuthService {
	
	@Value("${app.base-url}")
	private String baseUrl;
	
	private final UserMapper userMapper;
    private final EmailAuthMapper emailAuthMapper;
    private final EmailClient emailClient;

    @Transactional
    public String createAndSendToken(String email, String purpose) {

    	String token = UUID.randomUUID().toString();
        LocalDateTime expire = LocalDateTime.now().plusMinutes(10);

        EmailAuthDTO dto = new EmailAuthDTO();
        dto.setUserEmail(email);
        dto.setUserEmailToken(token);
        dto.setUserEmailTokenExpire(expire);
        dto.setUserEmailAuthYn("N");

        EmailAuthDTO existing = emailAuthMapper.selectByEmail(email);

        int result = (existing == null)
        		? emailAuthMapper.insertEmailAuth(dto)
        		: emailAuthMapper.updateEmailAuth(dto);

        if(result > 0) {
        	String realPurpose = (purpose != null && !purpose.isBlank()) ? purpose : "user";
        	
            String subject = "[CLISH] 이메일 인증 요청";
            String verifyLink = baseUrl + "/email/verify?token=" + token + "&purpose=" + realPurpose;
            String content = "<h3>아래 링크를 클릭하여 이메일 인증을 완료해주세요.</h3>"
                           + "<a href='" + verifyLink + "'>이메일 인증하기</a>"
                           + "<p>(유효시간: 10분)</p>";

            emailClient.sendMail(email, subject, content);
            return token;
        }

        return null;
    }
    
    @Transactional
    public EmailAuthResultDTO verifyToken(String token, String purpose) {
        EmailAuthDTO auth = emailAuthMapper.selectByToken(token);
        
        if(auth == null) {
            return new EmailAuthResultDTO("유효하지 않은 링크입니다", null);
        }
        
        if(auth.getUserEmailTokenExpire().isBefore(LocalDateTime.now())) {
            return new EmailAuthResultDTO("링크가 만료되었습니다.", null);
        }
        
        if("join".equals(purpose)) {
            if(userMapper.existsByEmail(auth.getUserEmail())) {
                return new EmailAuthResultDTO("이미 가입된 이메일입니다.", null);
            }
        }

        emailAuthMapper.updateAuthYn(auth.getUserEmail());	
        return new EmailAuthResultDTO("이메일 인증이 완료되었습니다!", auth.getUserEmail());
    }


    public boolean isEmailVerified(String email) {                 
        Boolean isVerified = emailAuthMapper.emailAuthYN(email);
        return Boolean.TRUE.equals(isVerified);
    }
}
