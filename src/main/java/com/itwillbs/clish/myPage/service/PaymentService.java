package com.itwillbs.clish.myPage.service;
 
import java.math.BigDecimal;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import com.itwillbs.clish.myPage.dto.PaymentCancelDTO;
import com.itwillbs.clish.myPage.dto.PaymentInfoDTO;
import com.itwillbs.clish.myPage.mapper.PaymentMapper;
import com.siot.IamportRestClient.IamportClient;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PaymentService {
	@Value("${portone.imp_code}")
	private String impCode;
	@Value("${portone.rest_api_key}")
	private String restApiKey;
	@Value("${portone.rest_api_secret}")
	private String restApiSecret;
	
	private final PaymentMapper paymentMapper;
	// ------------------------------------------------------------
	// 결제에 필요한 정보 반환
	public IamportClient getkey() {
		IamportClient iamportClient = new IamportClient(restApiKey, restApiSecret);
		return iamportClient;
	}
	// 결제 정보 db에 저장, 예약정보 업데이트 
	@Transactional
	public void putPayInfo(PaymentInfoDTO paymentInfoDTO) {
		paymentMapper.insertPayInfo(paymentInfoDTO);
		paymentMapper.updateReservationStatus(paymentInfoDTO);
	}
	// 결제정보 불러오기
	public PaymentInfoDTO getPayResult(PaymentInfoDTO paymentInfoDTO) {
		return paymentMapper.selectPayResult(paymentInfoDTO);
	}
	// 결제 취소에 필요한 Access토큰을 발급
	public String getAccessToken() {
		// ResetTemplate 객체 생성
		RestTemplate restTemplate = new RestTemplate();
		String tokenUrl = "https://api.iamport.kr/users/getToken";
		// 토큰요청 정보 저장
		Map<String, String> tokenRequest = new HashMap<>();
		tokenRequest.put("imp_key", restApiKey);
		tokenRequest.put("imp_secret", restApiSecret);
		// restTemplate사용하여 tockenUrl로 tockenRequest 요청, Map 형태로 리스폰받아 tokenResponse에저장
		ResponseEntity<Map> tokenResponse = restTemplate.postForEntity(tokenUrl, tokenRequest, Map.class);
		// 리스폰받은 tokenResponse객체안의 response.access_token을 String타입으로 변환 후 리턴
		return (String)((Map)tokenResponse.getBody().get("response")).get("access_token");
	}
	
	// 취소정보입력, 결제정보업데이트
	@Transactional
	public void cancelComplete(PaymentCancelDTO paymentCancelDTO) {
		paymentMapper.insertCancelInfo(paymentCancelDTO);
		paymentMapper.updatePaymentInfo(paymentCancelDTO);
	}
	
	// 결제 취소 정보 불러오기
	public PaymentCancelDTO getCancelResult(PaymentCancelDTO paymentCancelDTO) {
		return paymentMapper.selectCancelResult(paymentCancelDTO);
	}
	
	// long타입의 unix타임을 스트링 타임의 DateTime으로 변환 
	public String convertUnixToDateTimeString(Long unixTime) {
		if (unixTime == null || unixTime == 0) return null; // 값이 없을 때 처리
		return Instant.ofEpochSecond(unixTime)
				.atZone(ZoneId.of("Asia/Seoul")) // 한국 시간대
				.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	}
	// 취소전 필요 정보 
	public Map<String, Object> getCancelBefore(PaymentInfoDTO paymentInfoDTO) {

		Map<String,Object> paymentCancelClassInfo = paymentMapper.selectCancelBefore(paymentInfoDTO);
		
		// 받아온 예약일 정보를 현재와 비교
		LocalDateTime reservationClassDate = (LocalDateTime)paymentCancelClassInfo.get("reservationClassDate");
		LocalDateTime now = LocalDateTime.now();
	    // 남은시간을 long타입으로 바꿔 일자 계산
		Duration remainTime = Duration.between(now, reservationClassDate);
		
		long remainDay = remainTime.getSeconds()/60/60/24;
		// 정기 = 0 / 단기 =1
		int classType = (int)paymentCancelClassInfo.get("classType");
		double ableCancel;
		if(classType == 0) { // 정기강의 환불 규정
			if(remainDay >= 10 ) {
				ableCancel = 1;
			} else if(remainDay < 10 && remainDay >= 5) {
				ableCancel = 0.7;
			} else if(remainDay < 5 && remainDay >= 3) {
				ableCancel = 0.5;
			} else if(remainDay < 3 && remainDay >= 1) {
				ableCancel = 0.3;
			} else {
				ableCancel = 0;
			}
		} else {
			if(remainDay >= 5 ) { // 단기강의 환불규정
				ableCancel = 1;
			} else if(remainDay < 5 && remainDay >= 3) {
				ableCancel = 0.7;
			} else if(remainDay < 3 && remainDay >= 1) {
				ableCancel = 0.5;
			} else {
				ableCancel = 0;
			}
		}
		// 환불규정에 따른 환불금액 계산
		long amount = ((BigDecimal) paymentCancelClassInfo.get("amount")).longValue();
		
		double cancelAmountDouble = amount * ableCancel;
		// 10의자리에서 올림
		int cancelAmount = (int)(Math.ceil(cancelAmountDouble / 10.0) * 10);
		
		paymentCancelClassInfo.put("cancelAmount", cancelAmount);
		
		return paymentCancelClassInfo;
	}

	
}
