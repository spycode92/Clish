package com.itwillbs.clish.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.clish.admin.dto.CategoryDTO;

@Mapper
public interface CategoryMapper {

	// depth별 카테고리 리스트
	List<CategoryDTO> selectCategoryByDepth(int depth);

	// 카테고리 상세 정보
	CategoryDTO selecCategoryByIdx(String categoryIdx);

	// 카테고리 등록
	int insertCategory(CategoryDTO category);

	// 카테고리 수정
	int updateCategory(CategoryDTO category);

	// 카테고리 삭제
	int deleteCategory(String categoryIdx);

	// 카테고리 이름 중복검사
	int countCategoryName(@Param("categoryName") String categoryName, @Param("parentIdx") String parentIdx, @Param("currentIdx") String currentIdx);

	// 카테고리 순서 중복검사
	int countSortOrder(@Param("sortOrder") int sortOrder, @Param("parentIdx") String parentIdx, @Param("currentIdx") String currentIdx);


}
