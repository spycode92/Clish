package com.itwillbs.clish.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

public interface AdminPaymentMapper {

	// 결제 정보 리스트
	List<Map<String, Object>> selectPaymentList(@Param("startRow") int startRow, @Param("listLimit") int listLimit, @Param("filter") String filter);

	// 모든 결제 내역 수 
	int selectPaymentCount(String filter);

}
