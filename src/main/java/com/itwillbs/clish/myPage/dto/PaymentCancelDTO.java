package com.itwillbs.clish.myPage.dto;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class PaymentCancelDTO {
	@JsonProperty("imp_uid")
	private String impUid;
	@JsonProperty("merchant_uid")
	private String reservationIdx;
	@JsonProperty("name")
	private String classTitle;
	@JsonProperty("amount")
	private BigDecimal amount;
	@JsonProperty("buyer_name")
	private String userName;
	@JsonProperty("cancel_reason")
	private String cancelReason;
	@JsonProperty("status")
	private String status;
	@JsonProperty("pg_provider")
	private String payMethod;
	@JsonProperty("receipt_url")
	private String receiptUrl;
	@JsonProperty("cancel_receipt_urls")
	private List<String> cancelReceiptUrls;
	private String cancelReceiptUrl;
	@JsonProperty("cancelled_at")
	private long cancelledAt;
	private long cancelRequestTime;
	@JsonProperty("cancel_amount")
	private BigDecimal cancelAmount;

}
