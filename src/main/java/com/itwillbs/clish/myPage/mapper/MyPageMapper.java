package com.itwillbs.clish.myPage.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.clish.admin.dto.NotificationDTO;
import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.course.dto.ClassDTO;
import com.itwillbs.clish.myPage.dto.InqueryDTO;
import com.itwillbs.clish.myPage.dto.PaymentInfoDTO;
import com.itwillbs.clish.myPage.dto.ReservationDTO;
import com.itwillbs.clish.myPage.dto.ReviewDTO;
import com.itwillbs.clish.user.dto.UserDTO;


@Mapper
public interface MyPageMapper {
	// 유저 정보 불러오기
	UserDTO selectUserInfo(UserDTO user);
	//유저 프로필사진 불러오기
	FileDTO selectUserProfileImg(UserDTO user);
	// 닉네임중복확인
	UserDTO checkRepName(UserDTO userDTO);
	// 전화번호 중복확인
	UserDTO checkPhoneNumber(UserDTO userDTO);
	// 유저정보 수정
	int updateUserInfo(UserDTO user);
	// 예약목록 수 체크
	int selectReservationCount(UserDTO user);
	// 결제목록 수 확인
	int selectPaymentCount(UserDTO user);
	// 예약시간 만료된 목록
	List<Map<String, Object>> selectCancel(UserDTO user);
	//예약삭제
	int deleteReservation(ReservationDTO reservation);
	//예약목록선택
	List<ReservationDTO> selectAllReservationInfo(
			@Param("startRow")int startRow, @Param("listLimit")int listLimit, @Param("user")UserDTO user
			, @Param("reservationOrderBy")String reservationOrderBy, @Param("reservationOrderDir")String reservationOrderDir);
	//결제목록선택
	List<PaymentInfoDTO> selectAllPaymentInfo(
			@Param("startRow")int startRow,@Param("listLimit")int listLimit, @Param("user")UserDTO user
			, @Param("paymentOrderBy")String paymentOrderBy, @Param("paymentOrderDir")String paymentOrderDir);
	//예약정보, 예약된 수업정보
	Map<String, Object> ReservationDetailInfo(ReservationDTO reservation);
	// 남은자리검색
	int selectRemainSeats(ReservationDTO reservation);
	// 예약 수정 요청
	void updateReservationInfo(ReservationDTO reservation);
	//회원탈퇴
	int withdraw(UserDTO user);
	// 내가한 강의문의수
	int selectCountClassQ(UserDTO user);
	// 내가한 강의문의 목록
	List<InqueryDTO> selectAllClassQ(@Param("startRow")int startRow, @Param("listLimit")int listLimit, @Param("user")UserDTO user, @Param("classQOrderBy")String classQOrderBy, @Param("classQOrderDir")String classQOrderDir);
	// 내가한 사이트문의 수
	int selectCountInquery(UserDTO user);
	//내가한 사이트문의 목록
	List<InqueryDTO> selectAllInquery(@Param("startRow")int startRow, @Param("listLimit")int listLimit, @Param("user")UserDTO user, @Param("inqueryOrderBy")String inqueryOrderBy, @Param("inqueryOrderDir")String inqueryOrderDir);
	// 내가한 문의[사이트, 강의] 상세정보 
	InqueryDTO selectOneInquery(InqueryDTO inqueryDTO);
	//문의 수정
	void updateInquery(InqueryDTO inqueryDTO);
	// 문의 삭제
	void deleteInquery(InqueryDTO inqueryDTO);
	// 내가받은 알림수
	int selectCountNotification(UserDTO user);
	// 내가받은 알림 목록
	List<NotificationDTO> selectAllNotification(@Param("startRow")int startRow, @Param("listLimit")int listLimit, @Param("user")UserDTO user);
	// 작성가능 수강후기 수
	int selectUncompleteReviewCount(UserDTO user);
	// 작성가능 수강후기 목록
	List<Map<String, Object>> selectAllUncompleteReview(@Param("startRow")int startRow, @Param("listLimit")int listLimit, @Param("user")UserDTO user);
	// 작성완료한 수강후기 수
	int selectCompleteReviewCount(UserDTO user);
	// 작성완료 수강후기 목록
	List<ReviewDTO> selectAllCompleteReview(@Param("startRow")int startRow, @Param("listLimit")int listLimit, @Param("user")UserDTO user);
	//예약정보불러오기
	ReservationDTO selectReservationDetail(ReservationDTO reservation);
	// 예약한 예약,수업 상세정보 
	Map<String, Object> selectOneReservationClassInfo(ReservationDTO reservationDTO);
	//후기 작성
	void insertReview(ReviewDTO review);
	// 후기삭제
	int delteReview(ReviewDTO reviewDTO);
	// 후기수정폼 - 후기정보
	ReviewDTO selectOneReview(ReviewDTO reviewDTO);
	// 후기 수정요청
	void updateReview(ReviewDTO reviewDTO);
	// 최근 예약 목록 수
	int countRecentReservationCount(UserDTO user);
	// 최근 예약리스트
	List<Map<String, Object>> selectRecentReservation(@Param("startRow")int startRow, @Param("listLimit")int listLimit, @Param("user")UserDTO user);
	// 최근 1:1문의 답변 수[7일]
	int countRecentSiteInqueryCount(UserDTO user);
	// 최근 1:1문의 답변리스트[7일]
	List<Map<String, Object>> selectRecentSiteInquery(@Param("startRow")int startRow, @Param("listLimit")int listLimit, @Param("user")UserDTO user);
	// 나의 최근 강의문의 답변수[7일]
	int countRecentClassInqueryCount(UserDTO user);
	// 나의 최근 강의문의 답변목록[7일]
	List<Map<String, Object>> selectRecentClassInquery(@Param("startRow")int startRow, @Param("listLimit")int listLimit, @Param("user")UserDTO user);







}