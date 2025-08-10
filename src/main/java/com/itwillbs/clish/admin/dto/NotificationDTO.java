package com.itwillbs.clish.admin.dto;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class NotificationDTO {
	private String noticeIdx;
	private String userIdx;
	private int userNoticeType; // 1: 프로모션 2:문의 3:클래스 4:로그인 5:알림
	private String userNoticeMessage;
	private Timestamp userNoticeCreatedAt;
	private int userNoticeReadStatus; // 1: 읽음 / 2: 안읽음
	private String userNoticeLink;
}
