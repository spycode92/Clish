package com.itwillbs.clish.event.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.clish.admin.dto.EventDTO;

@Mapper
public interface EventMapper {
	
	
	 List<EventDTO> selectEventList();

	EventDTO selectEvent(String eventIdx);
}
