window.onload = () => {
	var IMP = window.IMP;
		IMP.init("imp55304474"); // 포트원에서 발급받은 식별코드 입력
}

	function requestPay() {
 		var privacyChecked = document.getElementById('privacy').checked;
		var policyChecked = document.getElementById('policy').checked;
		
		
		if (!privacyChecked || !policyChecked) {
			alert("개인정보 수집·이용 동의와 결제 및 환불 정책 동의를 모두 체크해주세요.");
			return false; // 결제 동작 중단
		}
		
		IMP.request_pay({
		    pg: "kakaopay", // 고정
		    pay_method: "card", // 고정
			storeId: "Clish",
		    merchant_uid: reservation_idx, // 예약번호 필수 
//		    merchant_uid: randomStr, // 테스트때문에바꿈
		    name: class_title, // 강의명 필수
		    amount: price , // 결제금액 필수 
		    buyer_name: user_name, // 결제 유저이름
	//	    m_redirect_url:"",// 모바일 결제 완료 후리다이렉트 할 주소
		    m_redirect_url: "http://localhost:8081/clish/myPage/payment_info/payResult",// 모바일 결제 완료 후리다이렉트 할 주소
		}, function(rsp) {
		    if (rsp.success) {
			    // 결제 성공 시 서버에 결제정보 전달
			    $.post("/myPage/payment/verify", { imp_uid: rsp.imp_uid }, function(data) {
					let safeClassTitle = data.classTitle.replace(/(\r\n|\n|\r)/gm, ' ').trim();
	//			      // 서버 검증 후 처리
					if (!isMobile()) {
			        	window.location.href =
			          		"/myPage/payment_info/payResult"
			            	+ "?impUid=" + data.impUid
			            	+ "&reservationIdx=" + data.merchantUid
							+ `&amount=`+ data.amount 
				            + `&status=` + data.status 
				            + `&userName=` + data.userName 
							+ `&payMethod=` + data.payMethod
				            + `&payTime=`+ data.payTime 
							+ `&receiptUrl=` + encodeURIComponent(data.receiptUrl);
		        	}
	//			
			    });
		    } else {
		      alert("결제에 실패하였습니다: " + rsp.error_msg);
		    }
		  });
	}
	
	// PC/모바일 환경 구분 함수
	// navigator.userAgent : 사용자의 브라우저, 운영체제, 기기 정보
	// /Mobi|Android|iPhone|iPad/i "Mobi","Android", "iPhone", "iPad" 이라는 단어가 들어있는지 검사 /i
	// .test() navigator.userAgent에 위의 단어가 포함되어있는지 검사, true false 리턴
	function isMobile() {
	  return /Mobi|Android|iPhone|iPad/i.test(navigator.userAgent);
	}
	
	//테스트를 위한 난수생성
	function getRandomString(length) {
	  return Math.random().toString(36).substr(2, length);
	}
	
	const randomStr = getRandomString(8);