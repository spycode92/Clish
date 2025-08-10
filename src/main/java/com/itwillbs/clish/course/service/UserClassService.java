package com.itwillbs.clish.course.service;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import com.itwillbs.clish.course.dto.ClassDTO;
import com.itwillbs.clish.course.mapper.UserClassMapper;
import com.itwillbs.clish.myPage.dto.ReservationDTO;
import com.itwillbs.clish.myPage.dto.ReviewDTO;
import com.itwillbs.clish.user.dto.UserDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserClassService {
	private final UserClassMapper userClassMapper;

	// 유저 정보 조회 요청
	public UserDTO getUserIdx(String userIdx) {
		return userClassMapper.selectUser(userIdx);
	}
	
	// 예약 인원 조회 요청
	public int getReservationCountByDate(LocalDate date) {
	    return userClassMapper.selectReservationCountByDate(date);
	}
	
	// 예약 정보 입력 요청
	public int registReservation(ReservationDTO reservationDTO) {
		return userClassMapper.insertReservation(reservationDTO);
	}

	// 강의 리스트전체 조회 요청
	public List<ClassDTO> getClassList(int startRow, int listLimit, String searchType, String searchClassKeyword, String categoryIdx, int classType) {
		return userClassMapper.selectClassList(startRow, listLimit, searchType, searchClassKeyword, categoryIdx, classType);
	}
	
	// 강의 리뷰 조회 요청
	public List<ReviewDTO> getClassReview(int startRow, int listLimit, String classIdx) {
		return userClassMapper.selectAllClassReview(startRow, listLimit, classIdx);
	}

	// 강의 리뷰 갯수 조회 요청
	public int getClassReviewCount(String classIdx) {
		return userClassMapper.selectCountClassReview(classIdx);
	}

	// 예약 인원 조회 요청
	public int selectReservationMembers(String classIdx) {
		return userClassMapper.selectCountReservationMembers(classIdx);
	}

	// 강의 리스트 갯수 조회 요청
	public int getClassListCount(String searchType, String searchClassKeyword, String categoryIdx, int classType) {
		return userClassMapper.selectCountClassList(searchType, searchClassKeyword, categoryIdx, classType);
	}


}
