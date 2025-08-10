package com.itwillbs.clish.common.controllerAdvice;

import java.util.List;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.itwillbs.clish.admin.dto.CategoryDTO;
import com.itwillbs.clish.admin.service.CategoryService;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@ControllerAdvice
@AllArgsConstructor
public class CommonControllerAdvice {
	private final CategoryService categoryService;
	
	// 모든 요청에 공통으로 모델에 담길 값을 반환하는 메서드 선언
    // 반환값은 'menuList'라는 이름으로 뷰에 전달됨
    @ModelAttribute("parentCategories")  
    public List<CategoryDTO> parentCategories() {
        // 메뉴 목록을 서비스에서 조회하여 반환
		List<CategoryDTO> parentCategories = categoryService.getCategoriesByDepth(1); 
    	
        return parentCategories;
    }
    
    @ModelAttribute("childCategories")  
    public List<CategoryDTO> childCategories() {
    	// 메뉴 목록을 서비스에서 조회하여 반환
    	List<CategoryDTO> childCategories = categoryService.getCategoriesByDepth(2); 
    	
    	return childCategories;
    }
	

}
