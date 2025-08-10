package com.itwillbs.clish.course.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.clish.admin.dto.InquiryJoinUserDTO;
import com.itwillbs.clish.course.dto.ClassDTO;
import com.itwillbs.clish.myPage.dto.InqueryDTO;
import com.itwillbs.clish.myPage.dto.ReservationDTO;


@Mapper
public interface CompanyClassMapper {


	// 클래스 등록
	int insertCompanyClass(ClassDTO companyClass);
	
	// 등록한 강의 상세 조회
	ClassDTO selectClassByIdx(String classIdx);

	// 로그인된 userId를 기반으로 해당 회원의 고유 userIdx 반환(기업회원 식별용)
	String selectUserIdxByUserId(String userId);

	// classIdx를 기준으로 클래스별 예약된 인원 수 확인
	int selectReservedCountByClassIdx(String classIdx);
	
	// 전체 강의 조회
	List<Map<String, Object>> selectAllClassList(String userIdx);
	
	// 단기 & 정기강의 조회
	List<Map<String, Object>> selectClassListByType(@Param("userIdx") String userIdx,@Param("type") String type);
	
	// 클래스수정페이지 - 클래스 정보 수정
	int updateClassInfo(@Param("classIdx") String classIdx, @Param("classInfo") ClassDTO classInfo);
	
	// 클래스 삭제
	void deleteClass(String classIdx);
	
	// 클래스 예약자 목록 조회
	List<Map<String, Object>> selectReservationList(String classIdx);
	// -----------------------------------------------------------------------------------------------------------------------------
	// // 클래스 문의 총 개수 조회
	int selectClassInquiryCountByUserIdx(String userIdx);
	
	// 클래스 문의 페이지 - 문의 리스트
	List<InquiryJoinUserDTO> selectClassInquiryList(@Param("startRow") int startRow, @Param("listLimit") int listLimit, @Param("userIdx") String userIdx);
	
	// 클래스 문의 페이지 - 문의 상세 
	InquiryJoinUserDTO selectClassInquiryDetail(String idx);
	
	// 클래스 문의 페이지 - 문의 답변
	int updateClassInquiry(@Param("idx") String idx, @Param("userIdx") String userIdx, @Param("inqueryAnswer") String inqueryAnswer);

	
	

	
	

}
