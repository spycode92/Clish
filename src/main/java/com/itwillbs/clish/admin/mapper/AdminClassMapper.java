package com.itwillbs.clish.admin.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.clish.course.dto.ClassDTO;

@Mapper
public interface AdminClassMapper {
	// 강의 리스트(페이징, 필터, 검색)
	List<Map<String, Object>> selectClassList(@Param("startRow") int startRow, @Param("listLimit") int listLimit, @Param("filter") String filter, @Param("searchKeyword") String searchKeyword);
	
	// 등록된 강의 수 (필터, 검색)
	int selectClassCount(String searchKeyword);
	
	// 대기 중인 강의 리스트
	List<Map<String, Object>> selectpendingClassList();
	
	// 강의 승인
	int updateClassStatus(@Param("idx") String idx, @Param("status") int status);

	// 강의 정보 변경
	int updateClassInfo(@Param("idx") String idx, @Param("classInfo") ClassDTO classInfo);

	// 하위 카테고리 확인
	boolean existsByCategory(@Param("categoryIdx") String categoryIdx, @Param("depth") int depth);

	boolean existsReservationByClassIdx(String idx);
}
