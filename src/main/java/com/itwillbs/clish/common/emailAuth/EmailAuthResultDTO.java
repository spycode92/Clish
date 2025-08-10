package com.itwillbs.clish.common.emailAuth;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class EmailAuthResultDTO {
    private String message;
    private String verifiedEmail;
}