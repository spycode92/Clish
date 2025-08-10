package com.itwillbs.clish.admin.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
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

import com.itwillbs.clish.admin.dto.CategoryDTO;
import com.itwillbs.clish.admin.service.AdminClassService;
import com.itwillbs.clish.admin.service.CategoryService;
import com.itwillbs.clish.admin.service.NotificationService;
import com.itwillbs.clish.common.dto.PageInfoDTO;
import com.itwillbs.clish.common.file.FileDTO;
import com.itwillbs.clish.common.utils.PageUtil;
import com.itwillbs.clish.course.dto.ClassDTO;
import com.itwillbs.clish.course.dto.CurriculumDTO;
import com.itwillbs.clish.course.service.CompanyClassService;
import com.itwillbs.clish.course.service.CurriculumService;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;

@Log4j2
@Controller
@RequestMapping("admin")
@RequiredArgsConstructor
public class AdminClassController {
	private final CompanyClassService classService;
	private final CurriculumService curriculumService;
	private final AdminClassService adminClassService;
	private final CategoryService categoryService;
	private final NotificationService notificationService;
	
	// 카테고리 리스트
	@GetMapping("/category")
	public String categoryList(Model model) {		
		List<CategoryDTO> parentCategories = categoryService.getCategoriesByDepth(1);
		List<CategoryDTO> childCategories = categoryService.getCategoriesByDepth(2);
		
		model.addAttribute("parentCategories", parentCategories);
		model.addAttribute("childCategories", childCategories);
		
		return "/admin/class/category_list";
	}
	
	// 카테고리 수정
	@ResponseBody
	@GetMapping("/category/modify")
	public CategoryDTO getCategoryJson(@RequestParam("cId") String categoryId) {
	    return categoryService.getCategoryByIdx(categoryId);
	}
	
	// 카테고리 추가
	@PostMapping("/category/add")
	public String addCategory(@ModelAttribute CategoryDTO category, @RequestParam("parentIdx") String parentIdx ,Model model) {
		if (parentIdx.equals("no_parent")) {
			category.setDepth(1);
		} else {
			category.setDepth(2);
		}
		
		int count = categoryService.addCategory(category);
		
		if (count > 0) {
			model.addAttribute("msg", "카테고리를 추가했습니다.");
			model.addAttribute("targetURL", "/admin/category");
		} else {
			model.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "commons/result_process";
	}
	
	// 카테고리 수정
	@PostMapping("/category/update")
	public String modifyCategory(@ModelAttribute CategoryDTO category, Model model) {
		if (category.getParentIdx().equals("no_parent")) {
			category.setDepth(1);
		} else {
			category.setDepth(2);
		}
		
		try {
			int count = categoryService.modifyCategory(category);
			if (count > 0) {
				model.addAttribute("msg", "카테고리를 수정했습니다.");
				model.addAttribute("targetURL", "/admin/category");
			} else {
				model.addAttribute("msg", "다시 시도해주세요!");
				return "commons/fail";
			}
			return "commons/result_process";
	    } catch (IllegalArgumentException e) {
	        model.addAttribute("msg", "중복된 값입니다. 다시 입력해주세요.");
	        model.addAttribute("category", category);
	        return "commons/fail"; 
	    }
	}
	
	// 카테고리 삭제
	@GetMapping("/category/delete")
	public String deleteCategory(@RequestParam("cId") String categoryIdx, @RequestParam("depth") int depth, Model model) {
		int count = adminClassService.removeCategory(categoryIdx, depth);
		
		System.out.println("count : " + count);
		
		if (count > 0) {
			model.addAttribute("msg", "카테고리를 삭제했습니다.");
			model.addAttribute("targetURL", "/admin/category");
		} else {
			model.addAttribute("msg", "하위 카테고리나 관련 강의가 있어 삭제할 수 없습니다!");
			return "commons/fail";
		}
		
		return "commons/result_process";
	}
	
	// 카테고리 중복 검사
	@GetMapping("/category/checkDuplicate")
	@ResponseBody
	public Map<String, Boolean> checkDuplicate(
			@RequestParam String categoryName,
	        @RequestParam int sortOrder,
	        @RequestParam(required = false) String parentIdx,
	        @RequestParam(required = false) String currentIdx) {
		
//		System.out.println("currentIdx : " + currentIdx);
		
		// 중복 검사
		boolean isNameDuplicate = categoryService.isCategoryNameDuplicate(categoryName, parentIdx, currentIdx);
		boolean isOrderDuplicate = categoryService.isSortOrderDuplicate(sortOrder, parentIdx, currentIdx);
		
		System.out.println("isOrderDuplicate :" + isOrderDuplicate);
		
		Map<String, Boolean> result = new HashMap<>();
		
	    result.put("nameDuplicate", isNameDuplicate);
	    result.put("orderDuplicate", isOrderDuplicate);
	    
		return result;
	}
	
	// 강의 리스트
	@GetMapping("/classList")
	public String classList(
			@RequestParam(defaultValue = "1") int pageNum, 
			@RequestParam(defaultValue = "") String filter,  
			@RequestParam(defaultValue = "") String searchKeyword, 
			Model model) {
		searchKeyword = searchKeyword.trim();
		
		int listLimit = 10;
		int listCount = adminClassService.getClassListCount(searchKeyword);
		if (listCount > 0) {
			PageInfoDTO pageInfoDTO = PageUtil.paging(listLimit, listCount, pageNum, 3);
			
			if (pageNum < 1 || pageNum > pageInfoDTO.getMaxPage()) {
				model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
				model.addAttribute("targetURL", "/admin/classList");
				return "commons/result_process";
			}
			
			model.addAttribute("pageInfo", pageInfoDTO);
			
			List<Map<String , Object>> classList = adminClassService.getClassList(pageInfoDTO.getStartRow(),listLimit, filter, searchKeyword);
			List<Map<String , Object>> pendingClassList = adminClassService.getPendingClassList();
			
			model.addAttribute("classList", classList);
			model.addAttribute("pendingClassList", pendingClassList);
		}
		return "/admin/class/class_list";
	}
	
	// 강의 상세 정보
	@GetMapping("/class/{idx}")
	public String classInfo(@PathVariable("idx") String idx, Model model) {
		ClassDTO classInfo = classService.getClassInfo(idx);
		
		List<CategoryDTO> parentCategories = categoryService.getCategoriesByDepth(1);
		List<CategoryDTO> childCategories = categoryService.getCategoriesByDepth(2);
		
		CategoryDTO childCategory = categoryService.getCategoryByIdx(classInfo.getCategoryIdx());
		CategoryDTO parentCategory = null;
		
		if (childCategory != null && childCategory.getParentIdx() != null) {
			parentCategory = categoryService.getCategoryByIdx(childCategory.getParentIdx());
		}
		
		List<CurriculumDTO> curriculumDTO = curriculumService.getCurriculumList(idx);
		
		model.addAttribute("classInfo", classInfo);
		model.addAttribute("parentCategories", parentCategories);
		model.addAttribute("childCategories", childCategories);
		model.addAttribute("selectedParentCategory", parentCategory);
		model.addAttribute("selectedChildCategory", childCategory);
		model.addAttribute("curriculumList", curriculumDTO);
		
		return "/admin/class/class_info";
	}
	
	// 강의 수정
	@PostMapping("/class/{idx}/update")
	public String classInfoModify(@PathVariable("idx") String idx, Model model, 
			@ModelAttribute ClassDTO classInfo,  @RequestParam("curriculumIdx") List<String> curriculumIdxList,
            @RequestParam("curriculumTitle") List<String> curriculumTitleList,
            @RequestParam("curriculumRuntime") List<String> curriculumRuntimeList) throws IllegalStateException, IOException {
		
			List<CurriculumDTO> curriculumList = new ArrayList<>();
		
			    for (int i = 0; i < curriculumIdxList.size(); i++) {
			        CurriculumDTO dto = new CurriculumDTO();
			        
			        // 기존 작성된 커리큘럼 없을 경우 idx 생성 후 등록
			        if (!"0".equals(curriculumIdxList.get(i))) {
			        	 dto.setCurriculumIdx("CURI" + UUID.randomUUID().toString().substring(0, 8));
			        } 
			        
			        dto.setCurriculumTitle(curriculumTitleList.get(i));
			        dto.setCurriculumRuntime(curriculumRuntimeList.get(i));
			        dto.setClassIdx(idx);
			        curriculumList.add(dto);
			    }
			
			int count = adminClassService.modifyClassInfo(idx, classInfo, curriculumList);	
			
			if (count > 0) {
				model.addAttribute("msg", "강의 정보를 수정했습니다.");
				model.addAttribute("targetURL", "/admin/class/" + idx);
			} else if (count == -1 ) {
				model.addAttribute("msg", "예약된 강의는 수정할 수 없습니다.");
				return "commons/fail";
			} else {
				model.addAttribute("msg", "다시 시도해주세요!");
				return "commons/fail";
			}
		
		
		return "commons/result_process";
	}
	
	// 강의 승인
	@PostMapping("/class/{idx}/approve")
	public String approveClass(@PathVariable("idx") String idx, @RequestParam("userIdx") String userIdx, Model model) {
		int success = adminClassService.modifyStatus(userIdx, idx, 2);
		
		if (success > 0) {
			model.addAttribute("msg", "승인 완료되었습니다.");
			model.addAttribute("targetURL", "/admin/classList");
		} else {
			model.addAttribute("msg", "다시 시도해주세요!");
			return "commons/fail";
		}
		
		return "commons/result_process";
	}
	
	// 강의 반려
	@PostMapping("/class/{idx}/reject")
	public String rejectClass (@PathVariable("idx") String idx, @RequestParam("content") String content, Model model) {
		ClassDTO classInfo = classService.getClassInfo(idx);
		
		notificationService.send(classInfo.getUserIdx(), 3, content);
		
		model.addAttribute("msg", "반려되었습니다.");
		model.addAttribute("targetURL", "/admin/classList");
	
		return "commons/result_process";
	}
	
	// 파일 삭제
	@GetMapping("/class/fileDelete")
	public String deleteFile(ClassDTO classDTO, FileDTO fileDTO) {
		classService.removeFile(fileDTO);
		
		return "redirect:/admin/class/" +classDTO.getClassIdx();
	}
}
