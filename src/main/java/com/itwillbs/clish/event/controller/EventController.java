package com.itwillbs.clish.event.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.itwillbs.clish.admin.dto.EventDTO;
import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileService;
import com.itwillbs.clish.event.service.EventService;
import com.itwillbs.clish.user.dto.UserDTO;
import com.itwillbs.clish.user.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller("/event")
@RequiredArgsConstructor
public class EventController {
	private final EventService eventService;
	private final UserService userService;
	private final FileService fileService;
	
	@GetMapping("event/event_detail/{eventIdx}")
	public String eventDetailForm(@PathVariable("eventIdx") String eventIdx, Model model, HttpSession session) {
		String id = (String)session.getAttribute("sId");
		UserDTO dbUser = userService.selectUserId(id);
		if(id == null) {
			
			model.addAttribute("msg", "이벤트는 회원만 참여 가능합니다");
			model.addAttribute("targetURL", "/user/login");
			return "commons/result_process";
		} else if(dbUser.getUserType() == 2) {
			model.addAttribute("msg", "이벤트에는 일반 회원만 참여할 수 있습니다.");
			return "commons/fail";
		}
		EventDTO eventDTO = eventService.getEvent(eventIdx);	
		FileDTO eventBanner = fileService.getFile(eventIdx, "content");	
		model.addAttribute("eventDTO", eventDTO);
		model.addAttribute("eventBanner", eventBanner);
		System.out.println("eventDTO : " + eventDTO);
		return "event/event_detail";
	}
	@GetMapping("/event/eventHome")
	public String eventHome(HttpSession session, Model model) {
		List<EventDTO> eventList = eventService.getEventList();
		model.addAttribute("eventList", eventList);
		int eventSize = eventList.size();
		model.addAttribute("eventSize", eventSize);
		List<FileDTO> fileDTO = new ArrayList<FileDTO>();
		for(int i = 0; i < eventSize; i++) {
			fileDTO.add(fileService.getFile(eventList.get(i).getEventIdx(), "thumbnail"));	
		}
		model.addAttribute("fileDTO", fileDTO);
		
		return "event/event_home";
	}
	@GetMapping("/event/earlyDiscount")
	public String eventEarlyDiscount() {
		
		return "event/early_discount";
	}
	@GetMapping("/event/specialDiscount")
	public String eventSpecialDiscount() {
		
		return "event/special_discount";
	}
}
