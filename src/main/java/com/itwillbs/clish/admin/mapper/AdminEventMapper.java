package com.itwillbs.clish.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.clish.admin.dto.EventDTO;

public interface AdminEventMapper {

	// 이벤트 리스트
	List<EventDTO> selectAllEvent(@Param("startRow") int startRow, @Param("listLimit") int listLimit, @Param("searchType") String searchType, @Param("searchKeyword") String searchKeyword);

	// 이벤트 게시물 수
	int selectCountEvent(@Param("searchType") String searchType, @Param("searchKeyword") String searchKeyword);

	// 이벤트 등록
	int insertEvent(EventDTO eventDTO);

	// 이벤트 상세
	EventDTO selectEvent(String idx);

	// 이벤트 수정
	int updateEvent(EventDTO eventDTO);

	// 이벤트 삭제
	void deletedEvent(String idx);

}
