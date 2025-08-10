package com.itwillbs.clish.DB;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.clish.myPage.dto.PaymentInfoDTO;
import com.itwillbs.clish.user.dto.UserDTO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class DBService {
	private final DBMapper dbMapper;
	public void inputUserData(UserDTO user) {
		dbMapper.insertUserData(user);
	}
	
	@Transactional
	public void inputReservationPayment(DBReservationPaymentDTO payment) {
		dbMapper.insertReservation(payment);
		dbMapper.insertPaymentInfo(payment);
		
	}




}
