package com.itwillbs.clish.myPage.controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.itwillbs.clish.admin.service.NotificationService;
import com.itwillbs.clish.course.dto.ClassDTO;
import com.itwillbs.clish.myPage.dto.PaymentCancelDTO;
import com.itwillbs.clish.myPage.dto.PaymentInfoDTO;
import com.itwillbs.clish.myPage.dto.ReservationDTO;
import com.itwillbs.clish.myPage.service.MyPageService;
import com.itwillbs.clish.myPage.service.PaymentService;
import com.itwillbs.clish.user.dto.UserDTO;
import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.response.IamportResponse;
import com.siot.IamportRestClient.response.Payment;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/myPage")
public class PaymentController {
	private final PaymentService paymentService;
	private final MyPageService myPageService;
	private final MyPageController myPageController;
	private final NotificationService notificationService;
	
	//결제페이지
	@GetMapping("/payment_info/payReservation")
	public String payReservationForm(HttpSession session, Model model,
			ReservationDTO reservation, UserDTO user) {		
		// 세션을 이용한 유저 정보 불러오기
		user = myPageController.getUserFromSession(session);
		
		// 삭제할 예약목록 삭제
		List<Map<String, Object>> toCancelList = myPageService.reservationCheck(user);
		// 삭제한 예약목록이 선택되어 있을떄
		for(Map<String, Object> cancelList: toCancelList) {
			if(((String)cancelList.get("reservationIdx")).equals(reservation.getReservationIdx())) {
				model.addAttribute("msg", "만료된 예약입니다. 다시 예약해주세요");
				model.addAttribute("targetURL", "/error");
				return "commons/result_process";
			}
		}
		
		reservation = myPageService.getReservationDetail(reservation);
		Map<String,Object> reservationClassInfo = myPageService.reservationDetailInfo(reservation);
		ClassDTO claSs1 = new ClassDTO();
		claSs1.setClassDays((Integer) reservationClassInfo.get("class_days"));
		reservationClassInfo.put("classDaysNames",claSs1.getDayString() ); 
		model.addAttribute("reservationClassInfo", reservationClassInfo);
		model.addAttribute("user",user);
		return "/clish/myPage/myPage_payment_payForm";
	}
	
	// 결제요청 버튼 결제 진행 후 리스폰 리턴맵핑  	
	@PostMapping(value="/payment/verify", produces="application/json; charset=UTF-8")
	@ResponseBody
	public Map<String, Object> verifyPayment(@RequestParam String imp_uid) {
		long requestTime = System.currentTimeMillis();

		Map<String, Object> result = new HashMap<> ();
		try {
			IamportClient iamportClient = paymentService.getkey();
			IamportResponse<Payment> response = iamportClient.paymentByImpUid(imp_uid);
			Payment payment = response.getResponse();
			result.put("impUid", payment.getImpUid()); // 포트원 결제 고유번호
			result.put("merchantUid", payment.getMerchantUid()); // 주문번호(예약번호)
			result.put("amount", payment.getAmount()); // 결제금액
			result.put("status", payment.getStatus()); // 구매상태(paid , ready, cancelled)
			result.put("userName", payment.getBuyerName()); //구매자 이름
			result.put("payMethod", payment.getPayMethod()); // 결제수단
			result.put("payTime", payment.getPaidAt()); // 결제시각
			result.put("classTitle", payment.getName()); // 상품명(강의명)
			result.put("requestTime", requestTime);
			result.put("receiptUrl", payment.getReceiptUrl());
			System.out.println("영수증요청 " + payment.getReceiptUrl());
		} catch (IamportResponseException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	    return result;
	}
	
	// 결제결과데이터 저장
	@GetMapping("/payment_info/payResult")
	public String payResultPage( PaymentInfoDTO paymentInfoDTO, Model model, HttpSession session, RedirectAttributes redirectAttributes) {
		UserDTO user = new UserDTO();
		user = myPageController.getUserFromSession(session);
		System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
		System.out.println(paymentInfoDTO.getReservationIdx());
		System.out.println("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ");
		//결제 결과 데이터 저장
		paymentService.putPayInfo(paymentInfoDTO);
		String payStatus = paymentInfoDTO.getStatus().toString().equals("paid") ? "결제완료 되었습니다" : "결제실패 하셨습니다.";
		
		// 결제 결과알림
		notificationService.send(user.getUserIdx(), 5,
				paymentInfoDTO.getClassTitle() + "강의에 대한 " + paymentInfoDTO.getAmount().toBigInteger() + "원 결제 요청이 " + payStatus);
		redirectAttributes.addAttribute("impUid",paymentInfoDTO.getImpUid());
		
	    return "redirect:/myPage/payment_info/paymentDetail"; // JSP 파일명에 맞게 수정
	}
		
	//결제상세보기페이지
	@GetMapping("/payment_info/paymentDetail")
	public String paymentInfo(PaymentInfoDTO paymentInfoDTO, UserDTO user,Model model) {
		
		paymentInfoDTO = paymentService.getPayResult(paymentInfoDTO);
		
		String payTime = paymentService.convertUnixToDateTimeString(paymentInfoDTO.getPayTime()/1000L);
		
		model.addAttribute("paymentInfoDTO",paymentInfoDTO);
		model.addAttribute("payTime",payTime);
		
		return "/clish/myPage/myPage_payment_payResult";
	}
	
	//결제취소 결제취소창으로이동
	@GetMapping("/payment_info/cancelPayment")
	public String cancelPaymentForm(PaymentInfoDTO paymentInfoDTO, Model model) {
		
		Map<String,Object> paymentCancelClassInfo = paymentService.getCancelBefore(paymentInfoDTO);
		
		String payTime = paymentService.convertUnixToDateTimeString((long)paymentCancelClassInfo.get("payTime")/1000L);
		
		model.addAttribute("paymentCancelClassInfo",paymentCancelClassInfo);
		model.addAttribute("payTime",payTime);
		
		return "/clish/myPage/myPage_payment_cancelForm";
	}
	
	// 결제 취소 요청맵핑
	@PostMapping("/payment_info/cancelPayment")
	public String cancelPayment(PaymentCancelDTO paymentCancelDTO, Model model, RedirectAttributes redirectAttributes, HttpSession session) {
		UserDTO user = new UserDTO();
		user = myPageController.getUserFromSession(session);
		
		//취소요청에 필요한 access토큰 발급
		String accessToken = paymentService.getAccessToken();
		// 취소 요청 url
		String cancelUrl = "https://api.iamport.kr/payments/cancel";
		
		long cancelRequestTime = System.currentTimeMillis(); // 취소요청시간
		
		// 취소 요청시 포함할 데이터 
		Map<String, Object> cancelRequest = new HashMap<>();
		cancelRequest.put("imp_uid", paymentCancelDTO.getImpUid()); // 결제 번호
		cancelRequest.put("reason", paymentCancelDTO.getCancelReason()); // 취소 이유
		cancelRequest.put("amount", paymentCancelDTO.getAmount());
		// HttpHeaders 객체 생성
		HttpHeaders headers = new HttpHeaders();
		// 헤더에 필요정보 입력
		headers.set("Authorization", accessToken);
		headers.setContentType(MediaType.APPLICATION_JSON);
		
		// 본문 데이터와 헤더 데이터를 포함할 HttpEntity 객체 생성
		HttpEntity<Map<String, Object>> request = new HttpEntity<>(cancelRequest, headers);
		
		// RestTemplate 객체 생성하여 HTTP 요청 보내기
		RestTemplate restTemplate = new RestTemplate();
		//post방식으로 cancelUrl에 request객체 보내고 응답을 Map 객체로 받아 ResponseEntity<Map> 객체에 저장 
		ResponseEntity<Map> cancelResponse = restTemplate.postForEntity(cancelUrl, request, Map.class); 
		// .getBody 메서드를 통해 받응 응답 데이터를 responseBody에 저장
		Map<String, Object> responseBody = cancelResponse.getBody();
		// 응답코드 확인(응답코드가 0이면 성공) 
	    int code = (int) responseBody.get("code");
	    // 응답 데이터 중 response 객체를 Map으로 꺼냄 (취소 결과 상세 정보 포함)
	    Map<String, Object> responseMap = (Map<String, Object>) responseBody.get("response");
	    
	   	// responseMap 이 null이 아닌경우    
	    if (responseMap != null) {
	        //Jackson ObjectMapper 객체 생성 (JSON <-> JAVA 객체 변환)
	    	ObjectMapper mapper = new ObjectMapper();
	        // responseMap 데이터를 PaymentCancelDTO 객체로 변환(매핑)
	        paymentCancelDTO = mapper.convertValue(responseMap, PaymentCancelDTO.class);
	        // 취소 요청시간을 DTO에 저장
	    	paymentCancelDTO.setCancelRequestTime(cancelRequestTime);
	    	// 취소영수증은 리스트로 들어오기 때문에 String으로 변환
	    	String cancelReceiptUrl = String.join(",", paymentCancelDTO.getCancelReceiptUrls());
	    	// DTO에 취소 영수증 정보 저장
	    	paymentCancelDTO.setCancelReceiptUrl(cancelReceiptUrl);
	    }
	    // 결제 취소 성공여부
	    if (code == 0) { // 취소성공
	    	//취소정보 저장, 결제정보 업데이트
	    	paymentService.cancelComplete(paymentCancelDTO);
	    	// 결제 취소 성공 알림
	    	notificationService.send(user.getUserIdx(), 5,
					paymentCancelDTO.getClassTitle() + "강의에 대한 " + paymentCancelDTO.getCancelAmount().toBigInteger() + "원 결제가 취소 되셨습니다.");
	    	
	    	//impUid를 리다이렉트할때 파라미터로 전달 
	    	redirectAttributes.addAttribute("impUid",paymentCancelDTO.getImpUid());
	    	// 결제취소 상세정보페이지로 이동
			return "redirect:/myPage/payment_info/cancelDetail";
	    } else { // 취소 실패
	    	// 취소 실패 에러메세지 저장
	        String errorMsg = (String) responseBody.get("message");
	        // 결제 취소 실패 메세지와 에러메시지를 저장
	        model.addAttribute("message", "결제 취소 실패: " + errorMsg);
	     // 결제 취소 알림
	    	notificationService.send(user.getUserIdx(), 5,
					paymentCancelDTO.getClassTitle() + "강의에 대한 " + paymentCancelDTO.getCancelAmount().toBigInteger() + "원 결제가 취소 실패 하였습니다.");
	        
	        // 실패한 결제 취소 정보를 저장
	    	model.addAttribute("paymentCancel", paymentCancelDTO);
	    	// 결제취소 상세정보페이지로 이동
	    	return "/clish/myPage/myPage_payment_cancelResult";
	    }
	}
	
	//취소상세 페이지
	@GetMapping("payment_info/cancelDetail")
	public String cancelInfo(Model model, PaymentCancelDTO paymentCancelDTO, UserDTO user) {
		//전달받은 impUid를 이용 결제 취소 정보 저장
		paymentCancelDTO = paymentService.getCancelResult(paymentCancelDTO);
		// 요청시간, 취소시간 스트링으로 변환
    	String requestTime = paymentService.convertUnixToDateTimeString(paymentCancelDTO.getCancelRequestTime());
    	String cancelTime = paymentService.convertUnixToDateTimeString(paymentCancelDTO.getCancelledAt());

    	model.addAttribute("requestTime",requestTime);
    	model.addAttribute("cancelTime",cancelTime);
    	model.addAttribute("paymentCancel", paymentCancelDTO);
    	model.addAttribute("message", "결제 취소가 정상 처리되었습니다.");
		
		return "/clish/myPage/myPage_payment_cancelResult";
	}
}
