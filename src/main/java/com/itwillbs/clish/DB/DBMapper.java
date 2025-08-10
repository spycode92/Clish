package com.itwillbs.clish.DB;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.clish.user.dto.UserDTO;

@Mapper
public interface DBMapper {

	void insertUserData(UserDTO user);

	void insertReservation(DBReservationPaymentDTO payment);

	void insertPaymentInfo(DBReservationPaymentDTO payment);

}
