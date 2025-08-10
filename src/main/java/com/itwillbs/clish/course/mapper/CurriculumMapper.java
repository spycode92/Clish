package com.itwillbs.clish.course.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.clish.course.dto.CurriculumDTO;

@Mapper
public interface CurriculumMapper {
	
	// 커리큘럼 등록
	void insertCurriculum(CurriculumDTO curri);
	
	// 상세페이지에서 커리큘럼 목록 조회
	List<CurriculumDTO> selectCurriculumList(String classIdx);
	
	// 수정페이지에서 커리큘럼 내용 수정
	int updateCurriculum(@Param("idx") String idx, @Param("curriculumInfo") CurriculumDTO curriculumInfo);
	
	// 클래스수정페이지 - 커리큘럼 추가
	void insertCurriculumModify(CurriculumDTO dto);
	
	// 기존 커리큘럼 삭제
	void deleteCurriculumByClassIdx(String classIdx);
	

}
