package com.itwillbs.clish.course.controller;

import java.sql.Date;
//import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.clish.admin.dto.CategoryDTO;
import com.itwillbs.clish.admin.dto.InquiryJoinUserDTO;
import com.itwillbs.clish.admin.service.AdminClassService;
import com.itwillbs.clish.admin.service.CategoryService;
import com.itwillbs.clish.admin.service.NotificationService;
import com.itwillbs.clish.common.dto.PageInfoDTO;
import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.file.FileMapper;
import com.itwillbs.clish.common.file.FileUtils;
import com.itwillbs.clish.common.utils.PageUtil;
import com.itwillbs.clish.course.dto.ClassDTO;
import com.itwillbs.clish.course.dto.CurriculumDTO;
import com.itwillbs.clish.course.service.CompanyClassService;
import com.itwillbs.clish.course.service.CurriculumService;
import com.itwillbs.clish.user.dto.CompanyDTO;
import com.itwillbs.clish.user.dto.UserDTO;
import com.itwillbs.clish.myPage.dto.InqueryDTO;
import com.itwillbs.clish.myPage.dto.ReservationDTO;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/company")
@RequiredArgsConstructor
public class CompanyClassController {
	private final CompanyClassService companyClassService;
	private final AdminClassService adminClassService;
	private final CurriculumService curriculumService;
	private final CategoryService categoryService;
	private final NotificationService notificationService;
	
	
	// 기업 마이페이지
	@GetMapping("/myPage")
	public String comMyPage() {
		return "company/myPage"; 
	}
	
	// 클래스 관리 페이지
	@GetMapping("/myPage/classManage")
	// @RequestParam(required = false) String type - 쿼리스트링 type=short|regular 없으면 전체강의 조회
    public String classManageForm(@RequestParam(required = false) String type, Model model, HttpSession session) {
		// 1. 로그인된 기업회원의 userIdx 조회
		 String userId = (String) session.getAttribute("sId");
	     String userIdx = companyClassService.getUserIdxByUserId(userId);
	     
		// 클래스 개설되는지 확인용(임시) - adminClassService => companyClassService 로 잠시 변경
//		List<Map<String , Object>> classList = companyClassService.getAllClassList();
		// 관리자 승인 후 목록 확인이 되게 adminClassSerive 로 적음
	     // 2. 클래스 목록 조회 (type 유무에 따라 분기)
	     List<Map<String, Object>> classList;

	     if (type == null || type.isBlank()) {
	         classList = companyClassService.getAllClassList(userIdx);
	     } else if (type.equals("short") || type.equals("regular")) {
	         classList = companyClassService.getClassListByType(userIdx, type);
	     } else {
	         classList = companyClassService.getAllClassList(userIdx);
	     }

	     // 3. 각 클래스에 대해 예약자 수 조회해서 Map에 넣기
	     for (Map<String, Object> classItem : classList) {
	         String classIdx = (String) classItem.get("class_idx");

	         // 예약자 수 조회
	         int reservedCount = companyClassService.getReservedCount(classIdx);

	         // JSP에서 ${classItem.reservedCount}로 사용할 수 있도록 Map에 추가
	         classItem.put("reservedCount", reservedCount);
	     }
		
		model.addAttribute("classList", classList);
		
        return "/company/companyClass/classManage"; 
    }
	
	
	// 클래스 개설 페이지
	@GetMapping("/myPage/registerClass")
    public String registerClassForm(Model model) {
		List<CategoryDTO> parentCategories = categoryService.getCategoriesByDepth(1); // 대분류
	    List<CategoryDTO> subCategories = categoryService.getCategoriesByDepth(2);    // 소분류

	    model.addAttribute("parentCategories", parentCategories);
	    model.addAttribute("subCategories", subCategories);
	    
        return "/company/companyClass/registerClass"; 
    }
	
	// 클래스 개설 로직
	@PostMapping("/myPage/registerClass")
	public String registerClassSubmit(ClassDTO companyClass, Model model, HttpServletRequest request, HttpSession session) {
		// 로그인된 기업 회원의 고유번호를 조회해서 클래스 작성자 정보에 설정
		String userId = (String) session.getAttribute("sId");
		String userIdx = companyClassService.getUserIdxByUserId(userId);
		companyClass.setUserIdx(userIdx);
		
		// 클래스 고유 번호 생성 - 등록 시점에서 class_idx를 직접 만들어 넣기 (예: CLS202507132152)
		String classIdx = "CLS" + new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());
		companyClass.setClassIdx(classIdx);
		
		// 수강료 기본값 처리
		if(companyClass.getClassPrice() == null) {
			companyClass.setClassPrice(BigDecimal.ZERO);
		}
		
		// 체크박스(요일) 처리: List<String> → int
		int classDaysValue = 0;
		List<String> tempDays = companyClass.getClassDayNames();

		if (tempDays != null) {
		    for (int i = 0; i < tempDays.size(); i++) {
		        String val = tempDays.get(i);
		        classDaysValue += Integer.parseInt(val);
		    }
		}
		companyClass.setClassDays(classDaysValue);
		
		 // 날짜 유효성 검사
	    LocalDate today = LocalDate.now();
	    LocalDate minStartDate = today.plusDays(1);
	    LocalDate startDate = companyClass.getStartDate();
	    LocalDate endDate = companyClass.getEndDate();
	    int classType = companyClass.getClassType(); // 0: 정기, 1: 단기
	    
	    System.out.println("📌 startDate: " + startDate);
	    System.out.println("📌 endDate: " + endDate);
	    System.out.println("📌 isEqual: " + (startDate != null && endDate != null ? startDate.isEqual(endDate) : "null"));


	    if (startDate == null || startDate.isBefore(minStartDate)) {
	        model.addAttribute("msg", "시작일은 개설일 다음 날부터 선택 가능합니다.");
	        model.addAttribute("targetURL", "/company/myPage/registerClass");
	        return "commons/result_process";
	    }

	    if (classType == 1) { // 단기 강의
	        if (startDate == null || endDate == null || !startDate.isEqual(endDate)) {
	            model.addAttribute("msg", "단기 강의는 시작일과 종료일이 같아야 합니다.");
	            model.addAttribute("targetURL", "/company/myPage/registerClass");
	            return "commons/result_process";
	        }
	    } else if (classType == 0) { // 정기 강의
	        if (endDate == null || endDate.isBefore(startDate)) {
	            model.addAttribute("msg", "정기 강의는 종료일이 시작일보다 빠를 수 없습니다.");
	            model.addAttribute("targetURL", "/company/myPage/registerClass");
	            return "commons/result_process";
	        }
	    }

		// ------------------------------------------------------------------------------------------------------
	    // 강좌 등록
		int result = companyClassService.registerClass(companyClass, session); 
	    // ------------------------------------------------------------------------------------------------------
	    // 커리큘럼 등록 로직 (폼에서 여러 개 받아온 값 처리)
	    String[] titles = request.getParameterValues("curriculumTitle");
	    String[] runtimes = request.getParameterValues("curriculumRuntime");

	    if (titles != null && runtimes != null) {
	        for (int i = 0; i < titles.length; i++) {
	            CurriculumDTO curri = new CurriculumDTO();
	            curri.setCurriculumIdx("CURI" + UUID.randomUUID().toString().substring(0, 8));
	            curri.setClassIdx(classIdx); // 외래키 설정
	            curri.setCurriculumTitle(titles[i]);
	            curri.setCurriculumRuntime(runtimes[i]);

	            curriculumService.insertCurriculum(curri);
	        }
	    }
	    
	    if (result > 0) {
	    	model.addAttribute("msg", "강좌 개설이 완료되었습니다.");
	    	model.addAttribute("targetURL", "/company/myPage/classDetail?classIdx=" + companyClass.getClassIdx());
	    } else {
	    	model.addAttribute("msg", "강좌 개설에 실패했습니다. 다시 시도해주세요.");
//	    	model.addAttribute("targetURL", "/company/myPage/classManage");
	    }
	    
	    return "commons/result_process";
	}

	
	// 클래스 상세 페이지
	@GetMapping("/myPage/classDetail")
	public String classDetailForm(@RequestParam String classIdx, Model model) {
		
		ClassDTO classInfo = companyClassService.getClassInfo(classIdx);
		model.addAttribute("classInfo", classInfo);
		
		// 커리큘럼 목록 조회
	    List<CurriculumDTO> curriculumList = curriculumService.getCurriculumList(classIdx);
	    model.addAttribute("curriculumList", curriculumList);
		
		return "company/companyClass/classDetail";
	}
	
	// 클래스 수정 페이지
	@GetMapping("/myPage/modifyClass")
	public String modifyClassForm(@RequestParam String classIdx, Model model) {
		ClassDTO classInfo = companyClassService.getClassInfo(classIdx);
		List<CurriculumDTO> curriculumList = curriculumService.getCurriculumList(classIdx);
		
		// 카테고리 불러오기
	    List<CategoryDTO> parentCategories = categoryService.getCategoriesByDepth(1);
	    List<CategoryDTO> subCategories = categoryService.getCategoriesByDepth(2);
		
		model.addAttribute("classInfo", classInfo);
	    model.addAttribute("curriculumList", curriculumList);
	    model.addAttribute("parentCategories", parentCategories);
	    model.addAttribute("subCategories", subCategories);
		
		return "/company/companyClass/modifyClass";
//	    return "/company/companyClass/classDetail";
	}
	
	// 클래스 수정 로직
	@PostMapping("/myPage/modifyClass")
	public String modifyClassSubmit(@RequestParam("classIdx") String classIdx, @RequestParam(value = "classDays", required = false) String[] classDaysArray,
			Model model, @ModelAttribute ClassDTO classInfo, HttpSession session,
			@RequestParam("curriculumIdx") List<String> curriculumIdxList,
			@RequestParam("curriculumTitle") List<String> curriculumTitleList,
			@RequestParam("curriculumRuntime") List<String> curriculumRuntimeList) throws IllegalStateException, IOException {
		
		List<CurriculumDTO> curriculumList = new ArrayList<>();
		
		if (curriculumIdxList != null && curriculumTitleList != null && curriculumRuntimeList != null &&
			    curriculumIdxList.size() == curriculumTitleList.size() &&
			    curriculumIdxList.size() == curriculumRuntimeList.size()) {

		    for (int i = 0; i < curriculumIdxList.size(); i++) {
		        CurriculumDTO dto = new CurriculumDTO();
		        
		        if (!"0".equals(curriculumIdxList.get(i))) {
		            // 기존 커리큘럼 → PK 유지
		            dto.setCurriculumIdx(curriculumIdxList.get(i));
		        } else {
		            // 새 커리큘럼 → UUID로 고유 PK 생성
		            dto.setCurriculumIdx("CURI" + UUID.randomUUID().toString().substring(0, 8));
		        }
		        
//		        dto.setCurriculumIdx(curriculumIdxList.get(i));
		        dto.setCurriculumTitle(curriculumTitleList.get(i));
		        dto.setCurriculumRuntime(curriculumRuntimeList.get(i));
		        dto.setClassIdx(classIdx);
		        curriculumList.add(dto);
		    }
		}
		
		// 체크된 요일들의 값을 모두 더해 비트마스크 형태의 정수(classDays)로 변환
		int classDays = 0;
		if (classDaysArray != null) {
		    for (String val : classDaysArray) {
		        classDays += Integer.parseInt(val);
		    }
		}
		classInfo.setClassDays(classDays); // DTO에 설정
		
		// 날짜 유효성 검사 추가
	    LocalDate today = LocalDate.now();
	    LocalDate minStartDate = today.plusDays(1);
	    LocalDate startDate = classInfo.getStartDate();
	    LocalDate endDate = classInfo.getEndDate();
	    int classType = classInfo.getClassType(); // 0: 정기, 1: 단기
	    
	    System.out.println("🟡 startDate: " + startDate);  // 실제 서버에 들어온 값
	    System.out.println("🟡 endDate: " + endDate);
	    System.out.println("🟡 isEqual: " + startDate.isEqual(endDate));

	    if (startDate == null || startDate.isBefore(minStartDate)) {
	        model.addAttribute("msg", "시작일은 오늘 이후로만 설정할 수 있습니다.");
	        model.addAttribute("targetURL", "/company/myPage/modifyClass?classIdx=" + classIdx);
	        return "commons/result_process";
	    }

	    if (classType == 1) { // 단기 강의
	        if (startDate == null || endDate == null || !startDate.isEqual(endDate)) {
	            model.addAttribute("msg", "단기 강의는 시작일과 종료일이 같아야 합니다.");
	            model.addAttribute("targetURL", "/company/myPage/modifyClass?classIdx=" + classIdx);
	            return "commons/result_process";
	        }
	    } else if (classType == 0) { // 정기 강의
	    	if (endDate == null || !endDate.isAfter(startDate)) {
	            model.addAttribute("msg", "정기 강의의 종료일은 시작일보다 이후여야 합니다.");
	            model.addAttribute("targetURL", "/company/myPage/modifyClass?classIdx=" + classIdx);
	            return "commons/result_process";
	        }
	    }
		
	    // 강의 정보 + 커리큘럼 수정 반영
		int count = companyClassService.modifyClassInfo(classIdx, classInfo, curriculumList, session);	
		
		if (count > 0) {
			model.addAttribute("msg", "강좌 정보를 수정했습니다.");
			model.addAttribute("targetURL", "/company/myPage/classDetail?classIdx=" + classIdx);
		} else {
			model.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "commons/result_process";
	}
	
	// 클래스 삭제
	@GetMapping("/myPage/deleteClass")
	public String deleteClass(@RequestParam String classIdx) {
	    // 커리큘럼 먼저 삭제 (자식 테이블)
	    curriculumService.deleteCurriculumByClassIdx(classIdx);

	    // 클래스 삭제 (부모 테이블)
	    companyClassService.deleteClass(classIdx);

	    // 삭제 후 다시 클래스 관리 페이지로 이동
	    return "redirect:/company/myPage/classManage";
	}
	
	// 클래스 예약자 목록 조회
	@PostMapping("/myPage/classReservationList")
	public String classReservationList(@RequestParam("classIdx") String classIdx, Model model) {
		// 서비스에서 List<Map<String, Object>>로 받음
	    List<Map<String, Object>> reservationList = companyClassService.selectReservationList(classIdx);
	    
	    // 모델에 예약자 목록 담음
	    model.addAttribute("reservationList", reservationList);
	    
	    return "/company/companyClass/classReservationList";
	}
	
	// ----------------------------------------------------------------------------------------------
	// 클래스 문의 페이지 - 문의 리스트
	@GetMapping("/myPage/classInquiry")
	public String classInquiry(HttpSession session, Model model, @RequestParam(defaultValue = "1") int inquiryPageNum) {
		
		 String userId = (String) session.getAttribute("sId");
		 String userIdx = companyClassService.getUserIdxByUserId(userId);
		 
		// 한 페이지당 보여줄 클래스 문의 수
		int listLimit = 6;
		 // 전체 클래스 문의 수 조회 (inquery_type = 2 만 해당)
	    int inquiryListCount = companyClassService.getClassInquiryCountByUserIdx(userIdx);
	    
		 	// 페이징 처리
		    if (inquiryListCount > 0) {
		        PageInfoDTO pageInfoDTO = PageUtil.paging(
		            listLimit, inquiryListCount, inquiryPageNum, 3 // 한 페이지당 수, 전체수, 현재 페이지, 페이지바 길이
		        );
	
		        // 페이지 번호 유효성 검사
		        if (inquiryPageNum < 1 || inquiryPageNum > pageInfoDTO.getMaxPage()) {
		            model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
		            model.addAttribute("targetURL", "/company/myPage");
		            return "commons/result_process";
		        }
	
		        // 페이징 정보 전달
		        model.addAttribute("inquiryPageInfo", pageInfoDTO);

		    // 클래스 문의 리스트 (조인된 정보 포함)
		    List<InquiryJoinUserDTO> classInquiryList = companyClassService.getClassInquiryList(pageInfoDTO.getStartRow(), listLimit, userIdx);
		    
		    model.addAttribute("classInquiryList", classInquiryList);
		}
	    return "/company/companyClass/classInquiry";
	}
	
	// 클래스 문의 페이지 - 문의 상세
	@GetMapping("/inquiry/detail/{idx}")
	@ResponseBody
	public InquiryJoinUserDTO getClassInquiryDetail(@PathVariable("idx") String idx) {
		
//		System.out.println(">>> 문의 상세 요청 idx: " + idx); // 요청 확인

	    InquiryJoinUserDTO result = companyClassService.getClassInquiryDetail(idx);
//	    System.out.println(">>> 반환된 객체: " + result); // 응답 확인

	    return result;
	}
	
	// 클래스 문의 페이지 - 문의 답변
	@PostMapping("/inquiry/answer")
	public String writeOrUpdateAnswer(@RequestParam("inqueryIdx") String idx,
			 @RequestParam("inqueryAnswer") String inqueryAnswer, @RequestParam("userIdx") String userIdx,  RedirectAttributes rttr) {
	    int result = companyClassService.updateClassInquiry(idx, userIdx, inqueryAnswer);

	    if (result > 0) {
	        rttr.addFlashAttribute("msg", "답변이 등록되었습니다.");
	    } else {
	        rttr.addFlashAttribute("msg", "답변 등록에 실패했습니다.");
	        return "commons/fail";
	    }
	    
	    System.out.println("**idx: " + idx);
	    System.out.println("**userIdx: " + userIdx);
	    System.out.println("**inqueryAnswer: " + inqueryAnswer);
	    
	    return "redirect:/company/myPage/classInquiry";
	}
	
}
