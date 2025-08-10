package com.itwillbs.clish.common.agreement;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/agreement")
public class agreementController {
	
	@GetMapping("/privacy")
	public String privacyAgreement() {
		return "/commons/privacy_policy";
	}
	@GetMapping("/payment_refund")
	public String paymentRefund() {
		return "/commons/payment_refund_policy";
	}
	
}
