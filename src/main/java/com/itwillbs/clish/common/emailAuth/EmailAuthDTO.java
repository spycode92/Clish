package com.itwillbs.clish.common.emailAuth;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class EmailAuthDTO {
	private String userEmail;
    private String userEmailToken;
    private LocalDateTime userEmailTokenExpire;
    private String userEmailAuthYn;
    private String purpose;
}
