package com.itwillbs.clish.admin.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.clish.admin.dto.InquiryJoinUserDTO;
import com.itwillbs.clish.admin.dto.SupportDTO;
import com.itwillbs.clish.admin.service.AdminCustomerService;
import com.itwillbs.clish.common.dto.PageInfoDTO;
import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.utils.PageUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Controller
@RequestMapping("admin")
@RequiredArgsConstructor
public class AdminCustomerController {
	private final AdminCustomerService adminCustomerService;

	// 공지사항 리스트
	@GetMapping("/notice")
	public String notice(Model model, @RequestParam(defaultValue = "1") int pageNum, 
			@RequestParam(defaultValue = "") String searchType,
			@RequestParam(defaultValue = "") String searchKeyword) {
		int listLimit = 10;
		int announcementCount = adminCustomerService.getAnnouncementCount(searchKeyword);
		
		if (announcementCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, announcementCount, pageNum, 3);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/admin/customer/notice_list");
				return "commons/result_process";
			}
			model.addAttribute("pageInfo", pageInfoDTO);
			
			List<SupportDTO> supportList = adminCustomerService.getAnnouncementList(pageInfoDTO.getStartRow(), listLimit, searchType, searchKeyword);
			
			model.addAttribute("supportList", supportList);
		}
		
		return "/admin/customer/notice_list";
	}
	
	// 공지사항 등록
	@GetMapping("/notice/writeNotice")
	public String noticeWriteForm() {
		return "/admin/customer/notice_write_form";
	}
	
	// 공지사항 등록
	@PostMapping("/notice/writeNotice")
	public String noticeWrite(SupportDTO supportDTO) throws IllegalStateException, IOException {
		adminCustomerService.registSupport(supportDTO);
		
		return "redirect:/admin/notice";
	}
	
	// 공지사항 상세
	@GetMapping("/notice/detail/{idx}")
	public String noticeDetailForm(@PathVariable("idx") String idx, Model model) {
		SupportDTO supportDTO = adminCustomerService.getSupport(idx);
		
		model.addAttribute("support", supportDTO);
		
		return "/admin/customer/notice_detail_form";
	}
	
	// 공지사항 수정
	@PostMapping("/notice/modify")
	public String noticeModify(SupportDTO supportDTO, Model model) throws IllegalStateException, IOException {
		int update = adminCustomerService.modifySupport(supportDTO);
		
		if (update > 0) {
			model.addAttribute("msg", "공지사항을 수정했습니다.");
			model.addAttribute("targetURL", "/admin/notice");
		} else {
			model.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "commons/result_process";
	}
	
	// 공지사항 삭제
	@GetMapping("/notice/delete/{idx}")
	public String noticeDelete(@PathVariable("idx") String idx, RedirectAttributes rttr) {
		int delete = adminCustomerService.removeSupport(idx);
		
		if (delete > 0) {
			rttr.addFlashAttribute("msg", "공지사항을 삭제했습니다.");
		} else {
			rttr.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "redirect:/admin/notice";
	}
	
	// 파일 삭제
	@GetMapping("notice/fileDelete")
	public String deleteFile(@RequestParam("supportIdx") String idx, FileDTO fileDTO) {
		adminCustomerService.removeFile(fileDTO);
		
		return "redirect:/admin/notice/detail/" + idx;
	}
	
	// faq 페이지 리스트
	@GetMapping("/faq")
	public String faqList(Model model,
			@RequestParam(defaultValue = "") String searchType,
			@RequestParam(defaultValue = "") String searchKeyword) {
		List<SupportDTO> supportDTO = adminCustomerService.getFaqListAndSearch(searchType, searchKeyword);
		
		model.addAttribute("faqList", supportDTO);
		
		return "/admin/customer/faq_list";
	}
	
	//faq 등록 페이지
	@GetMapping("/faq/writeFaq")
	public String faqWriteForm() {
		return "/admin/customer/faq_write_form";
	}
	
	// faq 등록
	@PostMapping("/faq/writeFaq")
	public String faqWrite(SupportDTO supportDTO) throws IllegalStateException, IOException {
		adminCustomerService.registSupport(supportDTO);
		
		return "redirect:/admin/faq";
	}
	
	
	// faq 상세
	@GetMapping("/faq/detail/{idx}")
	public String faqDetailForm(@PathVariable("idx") String idx, Model model) {
		SupportDTO supportDTO = adminCustomerService.getSupport(idx);
		
		model.addAttribute("support", supportDTO);
		
		return "/admin/customer/faq_detail_form";
	}
	
	// faq 수정
	@PostMapping("/faq/modify")
	public String faqModify(SupportDTO supportDTO, Model model) throws IllegalStateException, IOException {
		int update = adminCustomerService.modifyFaq(supportDTO);
		
		if (update > 0) {
			model.addAttribute("msg", "FAQ를 수정했습니다.");
			model.addAttribute("targetURL", "/admin/faq");
		} else {
			model.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "commons/result_process";
	}
	
	// faq 삭제
	@GetMapping("/faq/delete/{idx}")
	public String faqDelete(@PathVariable("idx") String idx, RedirectAttributes rttr) {
		int delete = adminCustomerService.removeSupport(idx);
		
		if (delete > 0) {
			rttr.addFlashAttribute("msg", "FAQ를 삭제했습니다.");
		} else {
			rttr.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "redirect:/admin/faq";
	}
	
	// 문의 리스트 
	@GetMapping("/inquiry")
	public String inquiryList(Model model, @RequestParam(defaultValue = "1") int pageNum) {
		int listLimit = 10;
		int inquiryCount = adminCustomerService.getInquiryCount();
		
		if (inquiryCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, inquiryCount, pageNum, 3);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/admin/inquiry");
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
			
			List<InquiryJoinUserDTO> inquiryList = adminCustomerService.getInquiryList(pageInfoDTO.getStartRow(), listLimit);
			model.addAttribute("inquiryList", inquiryList);
		}
		
		return "/admin/customer/inquiry_list";
	}
	
	// 문의 상세
	@GetMapping("/inquiry/detail/{idx}")
	@ResponseBody
	public InquiryJoinUserDTO inquiryDetail(@PathVariable("idx") String idx) {
		return adminCustomerService.getInquiry(idx);
	}
	
	// 문의 등록
	@PostMapping("/inquiry/write")
	public String writeInquiry(@RequestParam("inqueryIdx") String idx, @RequestParam("inqueryAnswer") String inqueryAnswer, 
			@RequestParam("userIdx") String userIdx,  RedirectAttributes rttr) {
		int update = adminCustomerService.writeAnswer(idx, userIdx, inqueryAnswer);
		
		if (update > 0) {
			rttr.addFlashAttribute("msg", "답변이 등록되었습니다.");
		} else {
			rttr.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "redirect:/admin/inquiry";
	}

}
