package com.itwillbs.clish.admin.dto;

import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class RevenueDTO {
	private String date; // yyyy-MM-dd
	private BigDecimal total;
	private String type; // daily weekly
}
