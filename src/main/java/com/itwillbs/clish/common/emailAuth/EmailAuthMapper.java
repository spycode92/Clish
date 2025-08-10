package com.itwillbs.clish.common.emailAuth;

public interface EmailAuthMapper {

	EmailAuthDTO selectByEmail(String email);

	int insertEmailAuth(EmailAuthDTO dto);

	int updateEmailAuth(EmailAuthDTO dto);

	EmailAuthDTO selectByToken(String token);

	void updateAuthYn(String userEmail);

	Boolean emailAuthYN(String email);

}
