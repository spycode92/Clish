package com.itwillbs.clish.event.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.clish.event.mapper.EventMapper;
import com.itwillbs.clish.admin.dto.EventDTO;
import com.itwillbs.clish.admin.dto.SupportDTO;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class EventService {
	private final EventMapper eventMapper;
	
	public EventService(EventMapper eventMapper) {
		this.eventMapper = eventMapper;
	}
	
	public List<EventDTO> getEventList() {
		// TODO Auto-generated method stub
		return eventMapper.selectEventList();
	}
	public EventDTO getEvent(String eventIdx) {
		return eventMapper.selectEvent(eventIdx);
	}
	
}
