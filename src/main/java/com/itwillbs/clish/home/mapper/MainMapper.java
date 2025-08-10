package com.itwillbs.clish.home.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.clish.admin.dto.SupportDTO;
import com.itwillbs.clish.course.dto.ClassDTO;
import com.itwillbs.clish.admin.dto.EventDTO;

@Mapper
public interface MainMapper {
	

	List<ClassDTO> selectClassInfo();
	List<ClassDTO> selectClassInfo2();
	List<ClassDTO> selectClassLongLatest();
	List<ClassDTO> selectClassInfoShortLatest();
	int selectClassListCount(@Param("searchKeyword") String searchKeyword);
	List<ClassDTO> selectClassListSearch(@Param("startRow") int startRow, @Param("listLimit") int listLimit, @Param("searchKeyword") String searchKeyword);
	List<SupportDTO> selectAnnouncements(@Param("startRow") int startRow,@Param("listLimit") int listLimit,@Param("searchKeyword") String searchKeyword);
	int selectAnnouncementsCount(@Param("searchKeyword") String searchKeyword);
	
}
