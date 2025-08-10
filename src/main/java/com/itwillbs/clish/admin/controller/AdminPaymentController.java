package com.itwillbs.clish.admin.controller;

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
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.itwillbs.clish.admin.service.AdminPaymentService;
import com.itwillbs.clish.admin.service.NotificationService;
import com.itwillbs.clish.common.dto.PageInfoDTO;
import com.itwillbs.clish.common.utils.PageUtil;
import com.itwillbs.clish.myPage.controller.MyPageController;
import com.itwillbs.clish.myPage.dto.PaymentCancelDTO;
import com.itwillbs.clish.myPage.dto.PaymentInfoDTO;
import com.itwillbs.clish.myPage.service.PaymentService;
import com.itwillbs.clish.user.dto.UserDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequestMapping("admin")
@RequiredArgsConstructor
public class AdminPaymentController {
	private final AdminPaymentService adminPaymentService;
	private final PaymentService paymentService;
	private final MyPageController myPageController;
	private final NotificationService notificationService;
	
	// 결제관리 페이지
	@GetMapping("/paymentList")
	public String paymentList(
			@RequestParam(defaultValue = "1") int pageNum, 
			@RequestParam(defaultValue = "all") String filter, 
			Model model) {
		
		int listLimit = 10;
		int listCount = adminPaymentService.getPaymentCount(filter);
		
		if (listCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, listCount, pageNum, 5);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/admin/paymentList");
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
			
			List<Map<String, Object>> paymentList = adminPaymentService.getPaymentList(pageInfoDTO.getStartRow(), listLimit, filter);
			
			model.addAttribute("paymentList", paymentList);
		}
		
		return "/admin/payment/payment_list";
	}
	
	// 결제 상세 내역
	@GetMapping("/payment_info/paymentDetail")
	public String paymentInfo(PaymentInfoDTO paymentInfoDTO, Model model) {
		paymentInfoDTO = paymentService.getPayResult(paymentInfoDTO);
		String payTime = paymentService.convertUnixToDateTimeString(paymentInfoDTO.getPayTime()/1000L);
		String requestTime = paymentService.convertUnixToDateTimeString(paymentInfoDTO.getRequestTime()/1000L);
		
		model.addAttribute("paymentInfoDTO",paymentInfoDTO);
		model.addAttribute("requestTime",requestTime);
		model.addAttribute("payTime",payTime);
		return "/clish/myPage/myPage_payment_payResult";
	}
	
	// 취소 상세 내역
	@GetMapping("/payment_info/cancelDetail")
	public String cancelPayment(PaymentCancelDTO paymentCancelDTO, Model model) {
		paymentCancelDTO = paymentService.getCancelResult(paymentCancelDTO);
    	String requestTime = paymentService.convertUnixToDateTimeString(paymentCancelDTO.getCancelRequestTime()/1000L);
    	
    	model.addAttribute("requestTime",requestTime);
    	model.addAttribute("paymentCancel", paymentCancelDTO);
    	model.addAttribute("message", "결제 취소가 정상 처리되었습니다.");
		
		return "/clish/myPage/myPage_payment_cancelResult";
	}
	
	// 취소 요청
	@GetMapping("/payment/cancel")
	public String cancelPaymentForm(PaymentInfoDTO paymentInfoDTO, Model model) {
		
		Map<String,Object> paymentCancelClassInfo = paymentService.getCancelBefore(paymentInfoDTO);

		String payTime = paymentService.convertUnixToDateTimeString((long)paymentCancelClassInfo.get("payTime")/1000L);
		
		model.addAttribute("paymentCancelClassInfo",paymentCancelClassInfo);
		model.addAttribute("payTime",payTime);
		
		return "/admin/payment/payment_cancelForm";
	}
	
	// 결제 취소 요청맵핑
		@PostMapping("/payment/cancel")
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
				return "redirect:/admin/payment_info/cancelDetail";
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

}
