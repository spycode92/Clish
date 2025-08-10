package com.itwillbs.clish.myPage.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.clish.myPage.dto.PaymentCancelDTO;
import com.itwillbs.clish.myPage.dto.PaymentInfoDTO;


@Mapper
public interface PaymentMapper {
	// 결제정보 저장
	void insertPayInfo(PaymentInfoDTO paymentInfoDTO);
	// 예약 정보 업데이트
	void updateReservationStatus(PaymentInfoDTO paymentInfoDTO);
	// 결제정보 불러오기
	PaymentInfoDTO selectPayResult(PaymentInfoDTO paymentInfoDTO);
	// 결제 취소 정보 저장
	void insertCancelInfo(PaymentCancelDTO paymentCancelDTO);
	// 결제 정보 업데이트
	void updatePaymentInfo(PaymentCancelDTO paymentCancelDTO);
	// 결제취소정보 불러오기
	PaymentCancelDTO selectCancelResult(PaymentCancelDTO paymentCancelDTO);
	// 결제 취소 전 필요정보
	Map<String, Object> selectCancelBefore(PaymentInfoDTO paymentInfoDTO);

}
