package com.itwillbs.clish.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.clish.admin.dto.NotificationDTO;

public interface NotificationMapper {
	// 사용자 알림 리스트
	List<NotificationDTO> selectNotifications(String userIdx);

	// 알림 확인
	void updateStatus(@Param("userIdx") String userIdx, @Param("notiIdx") String notiIdx);
	
	//읽지않은 알림 목록
	List<NotificationDTO> selectUnreadNotifications(String userIdx);

}
