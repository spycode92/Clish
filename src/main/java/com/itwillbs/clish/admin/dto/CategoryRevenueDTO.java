package com.itwillbs.clish.admin.dto;

import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CategoryRevenueDTO {
	private String categoryName;
	private BigDecimal total;
}
