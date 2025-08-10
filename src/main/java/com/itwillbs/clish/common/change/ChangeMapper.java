package com.itwillbs.clish.common.change;

import org.apache.ibatis.annotations.Param;

public interface ChangeMapper {
    int updatePassword(
    		@Param("userId") String userId, @Param("userEmail") String userEmail, @Param("newPasswd") String newPasswd);
}
