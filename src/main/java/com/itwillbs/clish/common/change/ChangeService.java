package com.itwillbs.clish.common.change;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChangeService {
	
    private final ChangeMapper changeMapper;
    private final PasswordEncoder passwordEncoder;

    public boolean resetPassword(String userId, String userEmail, String newPasswd) {
        String encPasswd = passwordEncoder.encode(newPasswd);
        int updated = changeMapper.updatePassword(userId, userEmail, encPasswd);
        return updated > 0;
    }
}
