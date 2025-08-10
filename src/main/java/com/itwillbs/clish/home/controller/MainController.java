package com.itwillbs.clish.home.controller;

import java.io.IOException;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.clish.admin.dto.CategoryDTO;
import com.itwillbs.clish.admin.dto.InquiryJoinUserDTO;
import com.itwillbs.clish.admin.dto.NotificationDTO;
import com.itwillbs.clish.admin.dto.SupportDTO;
import com.itwillbs.clish.admin.service.AdminCustomerService;
import com.itwillbs.clish.admin.service.CategoryService;
import com.itwillbs.clish.admin.service.NotificationService;
import com.itwillbs.clish.common.dto.PageInfoDTO;
import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileService;
import com.itwillbs.clish.common.utils.PageUtil;
import com.itwillbs.clish.course.dto.ClassDTO;
import com.itwillbs.clish.home.service.MainService;
import com.itwillbs.clish.myPage.dto.InqueryDTO;
import com.itwillbs.clish.user.dto.UserDTO;
import com.itwillbs.clish.user.service.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MainController {
	private final CategoryService categoryService;
	private final MainService mainService;
	private final AdminCustomerService adminCustomerService;
	private final NotificationService notificationService;
	private final UserService userService;
	private final FileService fileService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		List<CategoryDTO> parentCategories = categoryService.getCategoriesByDepth(1);
		List<CategoryDTO> childCategories = categoryService.getCategoriesByDepth(2);
		
		model.addAttribute("parentCategories", parentCategories);
		model.addAttribute("childCategories", childCategories);
		
		model.addAttribute("serverTime", formattedDate );
		List<ClassDTO> classList = mainService.getClassList();
		List<ClassDTO> classList2 = mainService.getClassList2();
		List<ClassDTO> classListLongLatest = mainService.getClassListLongLatest();
		List<ClassDTO> classListShortLatest = mainService.getClassListShortLatest();
		model.addAttribute("classList", classList);
		model.addAttribute("classList2", classList2);
		model.addAttribute("classListLongLatest", classListLongLatest);
		model.addAttribute("classListShortLatest", classListShortLatest);
		
		int listSize = classList.size();
		int listSize2 = classList2.size();
		int listSize3 = classListLongLatest.size();
		int listSize4 = classListShortLatest.size();
		model.addAttribute("listSize", listSize);
		model.addAttribute("listSize2", listSize2);
		model.addAttribute("listSize3", listSize3);
		model.addAttribute("listSize4", listSize4);
		List<FileDTO> fileDTO = new ArrayList<FileDTO>();
		for(int i = 0; i < listSize; i++) {
			fileDTO.add(fileService.getFile(classList.get(i).getClassIdx(), "image"));	
		}
		List<FileDTO> fileDTO2 = new ArrayList<FileDTO>();
		for(int i = 0; i < listSize2; i++) {
			fileDTO2.add(fileService.getFile(classList2.get(i).getClassIdx(), "image"));	
		}
		List<FileDTO> fileDTO3 = new ArrayList<FileDTO>();
		for(int i = 0; i < listSize3; i++) {
			fileDTO3.add(fileService.getFile(classListLongLatest.get(i).getClassIdx(), "image"));	
		}
		List<FileDTO> fileDTO4 = new ArrayList<FileDTO>();
		for(int i = 0; i < listSize4; i++) {
			fileDTO4.add(fileService.getFile(classListShortLatest.get(i).getClassIdx(), "image"));	
		}
		model.addAttribute("fileDTO", fileDTO);
		model.addAttribute("fileDTO2", fileDTO2);
		model.addAttribute("fileDTO3", fileDTO3);
		model.addAttribute("fileDTO4", fileDTO4);
		System.out.println("fileDto : " + model.getAttribute("fileDTO"));
		
//		return "home";
		return "main";
		
	}
	@GetMapping("/search")
	public String search(@RequestParam(defaultValue = "") String searchKeyword,
			@RequestParam(defaultValue = "1") int pageNum, @RequestParam(defaultValue = "1") int pageNum2, Model model) {
		
		
		searchKeyword = searchKeyword.trim();


		System.out.println("trimmed search keyword : " + searchKeyword);
		
		
		int listLimit = 3;
		int startRow = (pageNum - 1) * listLimit;
		int startRow2 = (pageNum2 - 1) * listLimit;
		
		int listCount = mainService.getClassListCount(searchKeyword);
		int listCountAnn = mainService.getAnnouncementListCount(searchKeyword);
		model.addAttribute("listCount", listCount);
		model.addAttribute("listCountAnn", listCountAnn);
		System.out.println("list count : " + listCount);
		System.out.println("list count : " + listCountAnn);
		
		if(listCount > 0 || listCountAnn > 0) {
			int pageListLimit = 3;
			int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0); 
			int maxPageAnn = listCountAnn / listLimit + (listCountAnn % listLimit > 0 ? 1 : 0); 
			if(maxPage == 0 ) {
				maxPage = 1;
			}
			
			if(maxPageAnn == 0) {
				maxPageAnn = 1;
			}
			int startPage = (pageNum -1) / pageListLimit * pageListLimit + 1;
			int startPageAnn = (pageNum2 -1) / pageListLimit * pageListLimit + 1;
			
			int endPage = startPage + pageListLimit -1;
			int endPageAnn = startPageAnn + pageListLimit -1;
			if(endPage > maxPage) {
				endPage = maxPage;
			}
			if(endPageAnn > maxPageAnn) {
				endPageAnn = maxPageAnn;
			}
			if(pageNum < 1 || pageNum > maxPage ||pageNum2 > maxPageAnn || pageNum2 < 1) {
				model.addAttribute("msg", "error, invalid page number");
				model.addAttribute("targetURL", "/search");
				return "commons/result_process";
			}

			PageInfoDTO pageInfoDTO = new PageInfoDTO(listCount, pageListLimit, maxPage, startPage, endPage, pageNum, 0);
			PageInfoDTO pageInfoDTO2 = new PageInfoDTO(listCountAnn, pageListLimit, maxPageAnn, startPageAnn, endPageAnn, pageNum2, 0);
			System.out.println("pageinfoDTO : " + pageInfoDTO);
			model.addAttribute("pageInfoDTO", pageInfoDTO);
			model.addAttribute("pageInfoDTO2", pageInfoDTO2);
			
			List<SupportDTO> supportList = mainService.getAnnouncementList(startRow2, listLimit, searchKeyword);
			List<ClassDTO> classList = mainService.getClassListSearch(startRow, listLimit, searchKeyword);
			
			model.addAttribute("classList", classList);
			model.addAttribute("supportList", supportList);
			System.out.println("class list count : " + classList);
			System.out.println("support list count : " +supportList);
		}	
		return "course/user/search_list";
	}
	
	@GetMapping("/customer/customerCenter")
	public String notification() {
		
		return "customer/customer_center";
	}
	
	// 공지사항 리스트
	@GetMapping("/customer/announcements")
	public String announcements(Model model, @RequestParam(defaultValue = "1") int pageNum,
			@RequestParam(defaultValue = "") String searchType,
			@RequestParam(defaultValue = "") String searchKeyword) {
		searchKeyword.trim();
		System.out.println("search type : " + searchType);
		System.out.println("search keyword : " + searchKeyword);
		int listLimit = 5;
		int announcementCount = adminCustomerService.getAnnouncementCount(searchKeyword);
		
		if (announcementCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, announcementCount, pageNum, 3);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/customer/announcements");
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
			
			List<SupportDTO> announcementList = adminCustomerService.getAnnouncementList(pageInfoDTO.getStartRow(), listLimit, searchType, searchKeyword);
			model.addAttribute("announcementList", announcementList);
		}
		
		return "customer/announcements";
	}
	
	// 공지사항 작성 페이지
	@GetMapping("/customer/announcements/write")
	public String writeAnnouncementFrom() {
		return "customer/announcement_write_form";
	}
	
	// 공지사항 등록
	@PostMapping("/customer/announcements/write")
	public String writeAnnouncement(SupportDTO supportDTO) throws IllegalStateException, IOException {
		adminCustomerService.registSupport(supportDTO);
		
		return "redirect:/customer/announcements";
	}
	
	// 공지사항 상세페이지
	@GetMapping("/customer/announcement/detail/{idx}")
	public String announcementDetail(@PathVariable("idx") String idx, Model model) {
		SupportDTO supportDTO = adminCustomerService.getSupport(idx);
		
		model.addAttribute("announcement", supportDTO);
		
		return "customer/announcement_detail";
	}
	
	// 공지사항 수정페이지
	@GetMapping("/customer/announcement/modify/{idx}")
	public String modifyAnnouncementFrom(@PathVariable("idx") String idx, Model model) {
		SupportDTO supportDTO = adminCustomerService.getSupport(idx);
		model.addAttribute("announcement", supportDTO);
		
		return "customer/announcement_modify_form";
	}
	
	// 공지사항 수정
	@PostMapping("/customer/announcement/modify")
	public String modifyAnnouncement(SupportDTO supportDTO, Model model) throws IllegalStateException, IOException {
		int update = adminCustomerService.modifySupport(supportDTO);
		
		if (update > 0) {
			model.addAttribute("msg", "공지사항을 수정했습니다.");
			model.addAttribute("targetURL", "/customer/announcement/detail/" + supportDTO.getSupportIdx());
		} else {
			model.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "commons/result_process";
	}
	
	// 공지사항 삭제
	@GetMapping("/customer/announcement/delete/{idx}")
	public String deleteAnnouncement(@PathVariable("idx") String idx, RedirectAttributes rttr) {
		int delete = adminCustomerService.removeSupport(idx);
		
		if (delete > 0) {
			rttr.addFlashAttribute("msg", "공지사항을 삭제했습니다.");
		} else {
			rttr.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "redirect:/customer/announcements";
	}
	
	// 공지사항 파일 삭제
	@GetMapping("/customer/announcement/fileDelete")
	public String deleteAnnouncementFile(@RequestParam("supportIdx") String idx, FileDTO fileDTO) {
		adminCustomerService.removeFile(fileDTO);
		
		return "redirect:/customer/announcement/modify" + idx;
	}
	
	// faq 페이지
	@GetMapping("/customer/FAQ")
	public String faq(Model model) {
		List<SupportDTO> supportDTO = adminCustomerService.getFaqList();
		
		model.addAttribute("faqList", supportDTO);
		
		return "customer/FAQ";
	}
	
	//1:1 문의
	@GetMapping("/customer/inquiry")
	public String inquiry(Model model, @RequestParam(defaultValue = "1") int pageNum) {
		int listLimit = 5;
		int inquiryCount = adminCustomerService.getInquiryCount();
		
		if (inquiryCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, inquiryCount, pageNum, 3);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/customer/inquiry");
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
			
			List<InquiryJoinUserDTO> inquiryList = adminCustomerService.getInquiryList(pageInfoDTO.getStartRow(), listLimit);
			model.addAttribute("inquiryList", inquiryList);
		}
		
		return "customer/inquiry";
	}
	
	// 1:1문의 상세페이지
	@GetMapping("/customer/inquiry/detail/{idx}")
	public String inquiryInfo(@PathVariable("idx") String idx, HttpSession session, Model model) {
		String id = (String)session.getAttribute("sId");
		UserDTO dbUser = userService.selectUserId(id);
	
		InquiryJoinUserDTO inquiryJoinUserDTO = adminCustomerService.getInquiry(idx);
		
		model.addAttribute("inquiry", inquiryJoinUserDTO);
		model.addAttribute("dbUser", dbUser);
		
		return "customer/inquiry_detail";
	}
	
	// 1:1문의 등록 페이지
	@GetMapping("/customer/inquiry/write")
	public String writeInquiryFrom(HttpSession session, Model model) {
		if (session.getAttribute("sId") == null) {
			model.addAttribute("msg","로그인 후 작성 가능합니다..");
			model.addAttribute("targetURL","/user/login");
			return "commons/result_process";
		}
		return "customer/inquiry_write_form";
	}
	
	// 1:1 문의 등록
	@PostMapping("/customer/inquiry/write")
	public String writeInquiry(InqueryDTO inqueryDTO, RedirectAttributes rttr,  HttpSession session) throws IllegalStateException, IOException {
		String id = (String)session.getAttribute("sId");
		UserDTO dbUser = userService.selectUserId(id);
		
		if (dbUser == null) {
			rttr.addFlashAttribute("msg", "로그인 후 작성 가능합니다.");
			return  "redirect:/user/login";
		}
		
		inqueryDTO.setUserIdx(dbUser.getUserIdx());
		
		int insert = adminCustomerService.registInquiry(inqueryDTO);
		if (insert > 0) {
			rttr.addFlashAttribute("msg", "문의를 등록했습니다.");
		} else {
			rttr.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "redirect:/customer/inquiry";
	}
	
	// 1:1 문의 수정 페이지
	@GetMapping("/customer/inquiry/modify/{idx}")
	public String modifyInquiryFrom(@PathVariable("idx") String idx, Model model) {
		InquiryJoinUserDTO inquiryJoinUserDTO = adminCustomerService.getInquiry(idx);
		
		model.addAttribute("inquiry", inquiryJoinUserDTO);
		return "customer/inquiry_modify_form";
	}
	
	// 1:1 문의 수정
	@PostMapping("/customer/inquiry/modify/{idx}")
	public String modifyInquiry(@PathVariable("idx") String idx, InqueryDTO inqueryDTO, Model model ) throws IllegalStateException, IOException {
		int update = adminCustomerService.modifyInquiry(inqueryDTO);
		
		if (inqueryDTO.getInqueryType() == 2) {
			model.addAttribute("msg","이 문의는 수정이 불가능한 상태입니다.");
			model.addAttribute("targetURL","/customer/inquiry");
			return "commons/result_process";
		}
		
		if (update > 0) {
			model.addAttribute("msg", "1:1문의를 수정했습니다.");
			model.addAttribute("targetURL", "/customer/inquiry/detail/" + inqueryDTO.getInqueryIdx());
		} else {
			model.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "commons/result_process";
	}
	
	// 1:1 문의 파일 삭제
	@GetMapping("/customer/inquiry/fileDelete")
	public String deleteInquiryFile(@RequestParam("inqueryIdx") String idx, FileDTO fileDTO) {
		adminCustomerService.removeFile(fileDTO);
		
		return "redirect:/customer/inquiry/modify/" + idx;
	}
	
	// 1:1 문의 삭제
	@GetMapping("/customer/inquiry/delete/{idx}")
	public String deleteInquiry(@PathVariable("idx") String idx, RedirectAttributes rttr) {
		int delete = adminCustomerService.removeInquiry(idx);
		
		if (delete > 0) {
			rttr.addFlashAttribute("msg", "문의글을 삭제했습니다.");
		} else {
			rttr.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "redirect:/customer/inquiry";
	}
	


//	@GetMapping("/admin/main")
//	public String adminMain() {
//		
//		return "admin/user/admin_page";
//	}
	@GetMapping("/company/main")
	public String companyMain() {
		
		return "company/company_main";
	}
	@GetMapping("clish/myPage/main")
	public String myPageMain() {
		
		return "redirect:/myPage/main";
	}
	@GetMapping("/user/joinForm")
	public String userJoin() {
		
		return "user/join_form";
	}
	
	@GetMapping("logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}
	
	@GetMapping("/user/notification")
	@ResponseBody
	public List<NotificationDTO> userNotification(HttpSession session) {
		String id = (String)session.getAttribute("sId");
		UserDTO dbUser = userService.selectUserId(id);
		
		return notificationService.getNotifications(dbUser.getUserIdx());
	}
	
	@PostMapping("/user/notification/{idx}/read")
	@ResponseBody
	public void markRead(@PathVariable("idx") String idx, HttpSession session) {
		String id = (String)session.getAttribute("sId");
		UserDTO dbUser = userService.selectUserId(id);
		notificationService.modifyStatus(dbUser.getUserIdx(), idx);
	}
	
	@PatchMapping("/user/notification/all-read")
	public @ResponseBody Map<String, Object> markAllAsRead(HttpSession session) {
		String id = (String)session.getAttribute("sId");
		UserDTO dbUser = userService.selectUserId(id);
		
		String result = notificationService.readAll(dbUser.getUserIdx());
		
		Map<String, Object> response = new HashMap<>();
		response.put("result", result);
		
		return response;
	}
	@GetMapping("/customer/termsOfService")
	public String termsOfService() {
		return "customer/terms_of_service";
	}
	@GetMapping("/customer/privacyPolicy")
	public String privacyPolicy() {
		return "customer/privacy_policy";
	}
		
}
