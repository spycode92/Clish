package com.itwillbs.clish.admin.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.clish.admin.dto.EventDTO;
import com.itwillbs.clish.admin.service.AdminEventService;
import com.itwillbs.clish.common.dto.PageInfoDTO;
import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileService;
import com.itwillbs.clish.common.utils.PageUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequestMapping("admin")
@RequiredArgsConstructor
public class AdminEventController {
	private final AdminEventService adminEventService;
	private final FileService fileService;

	// 이벤트 리스트
	@GetMapping("/event")
	public String eventList(Model model, 
			@RequestParam( defaultValue = "1") int pageNum, 
			@RequestParam(defaultValue = "") String searchType,
			@RequestParam(defaultValue = "") String searchKeyword) {
		int listLimit = 10;
		int eventCount = adminEventService.getEventCount(searchType, searchKeyword);
		
		if (eventCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, eventCount, pageNum, 3);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/admin/event/notice_list");
				return "commons/result_process";
			}
			model.addAttribute("pageInfo", pageInfoDTO);
			model.addAttribute("pageNum", pageNum);
			
			List<EventDTO> eventList = adminEventService.getEvents(pageInfoDTO.getStartRow(), listLimit, searchType, searchKeyword);
			model.addAttribute("eventList", eventList);
		}
		
		return "/admin/event/event_list";
	}
	
	// 이벤트 등록 페이지
	@GetMapping("/event/write")
	public String eventWriteForm() {
		return "/admin/event/event_write_form";
	}
	
	// 이벤트 등록
	@PostMapping("/event/write")
	public String eventWrite(EventDTO eventDTO,  RedirectAttributes rttr) throws IllegalStateException, IOException {
		int insert = adminEventService.registEvent(eventDTO);
		
		if (insert > 0) {
			rttr.addFlashAttribute("msg", "이벤트가 등록되었습니다.");
		} else {
			rttr.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "redirect:/admin/event";
	}
	
	// 이벤트 상세 페이지
	@GetMapping("/event/detail/{idx}")
	public String eventInfo(@PathVariable("idx") String idx, Model model) {
		EventDTO eventDTO = adminEventService.getEvent(idx);
		FileDTO thumbnailFile = fileService.getFile(idx, "thumbnail");
		FileDTO contentFile = fileService.getFile(idx, "content");
		
		model.addAttribute("eventDTO", eventDTO);
		model.addAttribute("thumbnailFile", thumbnailFile);
		model.addAttribute("contentFile", contentFile);
		
		return "/admin/event/event_detail";
	}
	
	// 수정 페이지
	@GetMapping("/event/modify/{idx}")
	public String modifyEventForm(@PathVariable("idx") String idx, Model model) {
		EventDTO eventDTO = adminEventService.getEvent(idx);
		FileDTO thumbnailFile = fileService.getFile(idx, "thumbnail");
		FileDTO contentFile = fileService.getFile(idx, "content");
		
		model.addAttribute("eventDTO", eventDTO);
		model.addAttribute("thumbnailFile", thumbnailFile);
		model.addAttribute("contentFile", contentFile);
		
		return "/admin/event/event_modify_form";
	}
	
	// 수정 요청
	@PostMapping("/event/modify")
	public String modifyEvent(EventDTO eventDTO, Model model) throws IllegalStateException, IOException {
		int update = adminEventService.modifyEvent(eventDTO);
		
		if (update > 0) {
			model.addAttribute("msg", "이벤트를 수정했습니다.");
			model.addAttribute("targetURL", "/admin/event/detail/" + eventDTO.getEventIdx());
		} else {
			model.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "commons/result_process";
	}
	
	// 이벤트 삭제
	@GetMapping("/event/delete/{idx}")
	public String deleteEvent(@PathVariable("idx") String idx) {
		adminEventService.removeEvent(idx);
		return "redirect:/admin/event";
	}
	
	// 파일 삭제
	@GetMapping("event/fileDelete")
	public String deleteFile(@RequestParam("idx") String idx,@RequestParam("type") String type,  FileDTO fileDTO) {
			adminEventService.removeOneFile(fileDTO, type);
		
		return "redirect:/admin/event/modify/" + idx;
	}
	
}
