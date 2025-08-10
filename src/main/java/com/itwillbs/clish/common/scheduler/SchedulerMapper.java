package com.itwillbs.clish.common.scheduler;

import java.util.List;
import java.util.Map;

import com.itwillbs.clish.myPage.dto.ReservationDTO;

public interface SchedulerMapper {

	List<ReservationDTO> SelectDeleteReservationList();

	// 강의 마감 알림
	List<Map<String, Object>> selectEndClasses();

	void DeleteNotification();

	// 이벤트 날짜 확인 및 상태 업데이트
	void updateAllEventStatus();

	List<Map<String, Object>> selectToStartReservation();

}
