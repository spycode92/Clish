package com.itwillbs.clish.admin.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.itwillbs.clish.admin.mapper.AdminPaymentMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
@RequiredArgsConstructor
public class AdminPaymentService {
	private final AdminPaymentMapper adminPaymentMapper;
	
	// 결제 리스트
	public List<Map<String, Object>> getPaymentList(int startRow, int listLimit, String filter) {
		return adminPaymentMapper.selectPaymentList(startRow, listLimit, filter);
	}

	// 모든 결제 내역 수 
	public int getPaymentCount(String filter) {
		return adminPaymentMapper.selectPaymentCount(filter);
	}

}
