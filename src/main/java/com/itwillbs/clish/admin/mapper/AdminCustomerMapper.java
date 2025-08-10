package com.itwillbs.clish.admin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.clish.admin.dto.InquiryJoinUserDTO;
import com.itwillbs.clish.admin.dto.SupportDTO;
import com.itwillbs.clish.myPage.dto.InqueryDTO;

public interface AdminCustomerMapper {

	// 공지사항 또는 faq 등록
	void insertSupport(SupportDTO supportDTO);

	// 공지사항 또는 faq 상세보기
	SupportDTO selectSupport(String idx);

	// 공지사항 또는 faq 수정
	int updateSupport(SupportDTO supportDTO);

	// 공지사항 또는 faq 삭제
	int deleteSupport(String idx);

	// faq 리스트
	List<SupportDTO> selectFaqList();
	
	// faq 리스트(검색 기능 포함)
	List<SupportDTO> selectFaqListAndSearch(@Param("searchType") String searchType, @Param("searchKeyword") String searchKeyword);

	// 1:1 문의 리스트(페이지네이션)
	List<InquiryJoinUserDTO> selectInquiries(@Param("startRow") int startRow, @Param("listLimit") int listLimit);

	// 1:1 문의 상세
	InquiryJoinUserDTO selectInquiry(String idx);

	// 관리자 문의 답변
	int updateInquiry(@Param("idx") String idx, @Param("inqueryAnswer") String inqueryAnswer);

	// 공지사항 전체 게시물 수
	int selectCountAnnouncement(@Param("searchKeyword")String searchKeyword);

	// 공지사항 리스트 (페이징)
	List<SupportDTO> selectAnnouncementList(@Param("startRow") int startRow, @Param("listLimit") int listLimit, @Param("searchType") String searchType, @Param("searchKeyword") String searchKeyword);

	// 1:1 문의 등록
	int insertInquery(InqueryDTO inqueryDTO);

	// 1:1 문의 게시글 수
	int selectInquiryCount();

	// 1:1 문의 삭제
	int deleteInquiry(String idx);

	// 1:1 문의 수정
	int updateUserInquiry(InqueryDTO inqueryDTO);

}
