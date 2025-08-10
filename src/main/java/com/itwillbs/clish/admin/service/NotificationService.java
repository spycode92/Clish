package com.itwillbs.clish.admin.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.clish.admin.dto.NotificationDTO;
import com.itwillbs.clish.admin.mapper.AdminUserMapper;
import com.itwillbs.clish.admin.mapper.NotificationMapper;

import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NotificationService {
	private final AdminUserMapper adminMapper;
	private final NotificationMapper notificationMapper;
	
	// 알림 등록
	public void send(String idx, int noticeType, String message) {
		// idx 생성 로직
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		String timestamp = LocalDateTime.now().format(formatter);
		String noticeIdx = "no" + timestamp + UUID.randomUUID().toString().substring(0, 8);
		
		NotificationDTO notification = new NotificationDTO();
		notification.setNoticeIdx(noticeIdx);
		notification.setUserIdx(idx);
		notification.setUserNoticeType(noticeType);
		notification.setUserNoticeMessage(message);
		notification.setUserNoticeLink(resolveLink(notification.getUserNoticeType(), notification.getUserIdx()));
		
		adminMapper.insertNotificatoin(notification);
	}

	// 사용자 알림 리스트
	public List<NotificationDTO> getNotifications(String userIdx) {
		return notificationMapper.selectNotifications(userIdx);
	}
	
	// 페이지 이동 링크 생성
	private String resolveLink(int type, String userIdx) {
		switch (type) {
			case 1 : // 프로모션
				return "/event/eventHome";
			case 2 : // 문의
				return isCompany(userIdx) ? "/company/myPage/myQuestion" : "/myPage/myQuestion";
			case 3 : // 클래스
				return isCompany(userIdx) ? "/company/myPage/classManage" : "/myPage/notification";
			case 5 : // 가입 승인 or 결제,결제취소 알림
				return isCompany(userIdx) ? "/company/myPage" : "/myPage/payment_info";
			default :
				return isCompany(userIdx) ? "/company/myPage/notification" : "/myPage/notification";
		}
	}
	
	// 기업 회원인지 일반 회원인지 확인
	private boolean isCompany(String userIdx) {
		return userIdx != null && userIdx.startsWith("comp");
	}

	// 읽음 상태 변경
	public void modifyStatus(String userIdx, String notiIdx) {
		notificationMapper.updateStatus(userIdx, notiIdx);
	}
	
	public String readAll(String userIdx) {
		//읽지않은 알림 목록
		List<NotificationDTO>notificationList = notificationMapper.selectUnreadNotifications(userIdx);
		//읽지않은 알림 전체 읽음처리
		if (notificationList != null && !notificationList.isEmpty()) {
			for(NotificationDTO notification : notificationList) {
				notificationMapper.updateStatus(userIdx, notification.getNoticeIdx());
			}
			return "모든 알림을 읽음 처리했습니다";
		}
		
		return "더 이상 읽을 알림이 없습니다.";
	}
}
