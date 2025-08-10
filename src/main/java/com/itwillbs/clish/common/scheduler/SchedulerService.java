package com.itwillbs.clish.common.scheduler;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.itwillbs.clish.admin.service.NotificationService;
import com.itwillbs.clish.myPage.dto.ReservationDTO;
import com.itwillbs.clish.myPage.mapper.MyPageMapper;
import com.itwillbs.clish.user.dto.UserDTO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class SchedulerService {
	private final SchedulerMapper schedulerMapper;
	private final MyPageMapper myPageMapper;
	private final NotificationService notificationService;
	
	public void checkReservation() {
		List<ReservationDTO> toDeleteReservationList = schedulerMapper.SelectDeleteReservationList();
		
		for(ReservationDTO reservation: toDeleteReservationList) {
			UserDTO user = new UserDTO();
			user.setUserIdx(reservation.getUserIdx());
			List<Map<String, Object>> toCancelList = myPageMapper.selectCancel(user);
		
			for(Map<String, Object> cancelList: toCancelList) {
				ReservationDTO reservationDTO = new ReservationDTO();
				// 삭제하는데 필요한 reservationIdx를 설정
				reservationDTO.setReservationIdx((String)cancelList.get("reservationIdx"));
				
				int deleteCount = myPageMapper.deleteReservation(reservationDTO);
				// 삭제한 예약이 있다면 알림 발송
				if(deleteCount > 0) {
					String userIdx = (String)cancelList.get("userIdx");
							
					// 알림 발송 메세지 작성
					String classTitle = (String)cancelList.get("classTitle");
	//						System.out.println("강의명 : " + classTitle);
					String reservationMembers = cancelList.get("reservationMembers").toString();
	//						System.out.println("예약인원 : " + reservationMembers);
					String reservationCom = ((LocalDateTime)cancelList.get("reservationCom")).format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
	//						System.out.println("예약한시간 : " + reservationCom);
					String reservationClassDate = ((LocalDateTime)cancelList.get("reservationClassDate")).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	//						System.out.println("예약일 : " + reservationClassDate );
					notificationService.send(userIdx, 3, 
							reservationCom + "에 예약한 " + classTitle + "의 " + reservationClassDate + "수업 " + reservationMembers + "명 예약이 예약시간이 만료되어 자동으로 삭제됩니다" );
				}
			}
		}
	}
	
	// 강의 마감 안내
	public void checkClassEndDate() {
		List<Map<String, Object>> endClassList = schedulerMapper.selectEndClasses();
		
		for (Map<String, Object> classInfo: endClassList) {
			String userIdx = (String) classInfo.get("user_idx");
			String classTitle = (String) classInfo.get("class_title");
			String classEndDate = (String) classInfo.get("end_date");
			
			notificationService.send(userIdx, 3,  "등록하신 강의 \"" + classTitle + "\"가 " + classEndDate + "에 마감되었습니다.");
		}
	}
	
	// 3개월 지난 알림 삭제
	public void checkNotification() {
		schedulerMapper.DeleteNotification();
	}

	// 이벤트 날짜 확인
	public void checkEventDate() {
		schedulerMapper.updateAllEventStatus();
		
	}

	public void toStartClass() {
		List<Map<String,Object>> toStartReserveInfo = schedulerMapper.selectToStartReservation();
		
		if (toStartReserveInfo != null && !toStartReserveInfo.isEmpty()) {
		
			for(Map<String,Object> toStartReserve: toStartReserveInfo) {
				ReservationDTO reservation = new ReservationDTO();
				reservation.setReservationIdx((String) toStartReserve.get("reservation_idx"));
				
				toStartReserve = myPageMapper.ReservationDetailInfo(reservation);
				
				String userIdx = (String)toStartReserve.get("user_idx");
				String classTitle = (String)toStartReserve.get("class_title");
				
				String reservationMembers = toStartReserve.get("reservation_members").toString();
				String reservationCom = ((LocalDateTime)toStartReserve.get("reservation_com")).format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
				String reservationClassDate = ((LocalDateTime)toStartReserve.get("reservation_class_date")).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
				notificationService.send(userIdx, 5, 
					"예약하신 " + classTitle + "강의가 " + reservationClassDate + "에 시작합니다."  );
			}
		}
		
	}

}
