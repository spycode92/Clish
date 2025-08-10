<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약수정</title>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>

<link href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/myPage.css" rel="stylesheet" type="text/css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<!-- jquery date picker -->
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/smoothness/jquery-ui.css">

</head>
<body>
	<main id="container">
	
	<div id="main">
		<h1>예약변경</h1>
		<form action="/myPage/payment_info/change" method="post" onsubmit="return validateForm();">
			<table style="margin-left: auto ; margin-right: auto;" >
				<tr>
					<th rowspan="5">
						<img src="/file/${reservationClassInfo.file_id}?type=0" alt="${reservationClassInfo.original_file_name }" width="200px" height="250px" >
					</th>
					<th >${reservationClassInfo.class_title}</th>
				</tr>
				<tr>
					<th>전체 자리</th>
				</tr>
				<tr> 
					<th>${reservationClassInfo.class_member}</th>
				<tr>
					<th>남은 자리</th>
				</tr>
				<tr>
					<th id="remainSeats">${reservationClassInfo.remainSeats}</th>
				</tr>
				<tr>
					<th>${reservationClassInfo.start_date}</th>
					<th>${reservationClassInfo.end_date}</th>
				</tr>
				<tr>
					<th>수업 요일</th>
					<th>${reservationClassInfo.classDaysNames }</th>
				</tr>
				
			</table>
			<table >
				<tr>
					<th>예약번호</th>
					<th>예약자</th>
					<th>클래스명</th>
					<th>예약일</th>
					<th>예약인원</th>
					<th>예약완료일</th>
					<th>결제 금액</th>
					<th>변경 후 금액 </th>				
				</tr>
	        	<tr>
	        		<td>
	        			${reservationClassInfo.reservation_idx}
	        			<input type="hidden" value="${reservationClassInfo.reservation_idx}" name="reservationIdx">
	        		</td>
					<td>${user.userName}</td>
					<td>${reservationClassInfo.class_title}</td>
					
					<fmt:parseDate var="reservationClassDate" 
									value="${reservationClassInfo.reservation_class_date}"
									pattern="yyyy-MM-dd'T'HH:mm"
									type="both" />
					<!-- localdatetime 에서 date타입으로 변환 -->
					<fmt:formatDate value="${reservationClassDate}" pattern="yyyy-MM-dd" var="classDate"/>
<%-- 					<td><input type="date" value="${classDate}" name="reservationClassDate" min="${reservationClassInfo.start_date}" max="${reservationClassInfo.end_date}" --%>
<%-- 					<c:if test="${reservationClassInfo.class_type eq 0 }">readonly</c:if>></td> --%>
					<td>
						<input type="text" id="datepicker" value="${classDate}" name="reservationClassDatePic"
							required <c:if test="${reservationClassInfo.class_type eq 0 }">readonly</c:if>>
						<input type="hidden" name="reservationClassDate" id="hiddenReservationClassDate" value="${classDate}">
					</td>
					<td><input type="text" value="${reservationClassInfo.reservation_members}" name="reservationMembers" id="reservationMembers"></td>
					<fmt:parseDate var="reservationCom" 
										value="${reservationClassInfo.reservation_com}"
										pattern="yyyy-MM-dd'T'HH:mm"
										type="both" />
					<td><fmt:formatDate value="${reservationCom}" pattern="yy-MM-dd HH:mm"/></td>
	<%-- 				<td>${reservationClassInfo.reservation_com}</td> --%>
					<%-- 가격 * 예약인원 해서 총 가격 계산  --%>
					<td><fmt:formatNumber value="${reservationClassInfo.class_price * reservationClassInfo.reservation_members}" pattern="#,##0" /></td>
					<td><div name="changePrice"></div></td>
	        	</tr>
	        	<tr>
					<td colspan="8" style="text-align: right; ">
							<input type="button" value="취소" data-reservation-num="${reservationClassInfo.reservation_idx}"
			         onclick="history.back()" >
							<input type="submit" value="수정완료" >
	         		</td>        		
	        	</tr>
			</table>
		</form>
		
	
	</div>
	
	</main>
	<script>
		var maxMembers = ${reservationClassInfo.remainSeats + reservationClassInfo.reservation_members};
		
		$(function() {
			const classIdx = "${reservationClassInfo.class_idx}"; // 강의idx 
			const price = ${reservationClassInfo.class_price}; // 강의 가격 
			const initialMembers = Number($('[name="reservationMembers"]').val());//예약인원 입력값
			const originalReservationMembers = '${reservationClassInfo.reservation_members}'; //처음 예약한 인원수
			var originalReservationDateTime = '${reservationClassInfo.reservation_class_date}';//처음예약한날
			const normalizedOriginal = originalReservationDateTime.replace('T', ' ') + ':00';
			var selectedReservationDateTime = originalReservationDateTime;//선택한예약날자 초기값:처음예약한날
			const today = new Date(); //오늘날짜
		    const yyyy = today.getFullYear();
		    const mm = String(today.getMonth() + 1).padStart(2, '0'); // 월은 0부터 시작하니 +1 필요
		    const dd = String(today.getDate()).padStart(2, '0');

		    const todayStr = yyyy + '-' + mm + '-' + dd;
		    const $dateInput = $('input[name="reservationClassDate"]');
		    
		  	//datepicker
			var allowedDaysMask = Number("${reservationClassInfo.class_days}"); //가능한 요일
			
			var startDateStr = "${reservationClassInfo.start_date}"; // 수업 시작일
			var startDate = new Date(startDateStr);
			var endDateStr = "${reservationClassInfo.end_date}"; // 수업 마감일
			var endDate = new Date(endDateStr);
			today.setHours(0,0,0,0);
			
			var minDate = startDate > today ? startDate : today;
			
			$("#datepicker").datepicker({
				
				minDate: new Date(minDate),
				maxDate: new Date("${reservationClassInfo.end_date}"),
				
				//지정 요일만 보여주기
				beforeShowDay: function(date) {
					var day = date.getDay();     // 0:일, 1:월, ..., 6:토
					var bitIndex = day === 0 ? 6 : day - 1;
					var dayBit = 1 << bitIndex;  // 2^(day+1) 계산
					
					var allowed = (allowedDaysMask & dayBit) !== 0; // 해당 요일 비트 체크
					return [allowed, "", allowed ? "선택 가능 날짜" : "선택 불가 날짜"];
				},
				
				dateFormat: 'yy-mm-dd', // 날짜 형식 설정 (선택)
				onSelect: function(dateText) {
					$("#hiddenReservationClassDate").val(dateText);
					
					reservationDateChanged();
				}
			});
			
			$("#hiddenReservationClassDate").val($("#datepicker").val());
			
			<c:if test="${reservationClassInfo.class_type eq 0}">
		    	$("#datepicker").datepicker("option", "disabled", true);
	  		</c:if>
			
		 				
			
			// 변경후 금액 표시
		    updatePrice(initialMembers);
		    
		 	// 인원 입력란에서 값 변경되었을 때 가격 업데이트
		    $('[name="reservationMembers"]').on('input', function() {
		        const membersValue = Number($(this).val());
		        updatePrice(membersValue);
		    });
		 	
		 	// 예약날자 변경시 작동
		    function reservationDateChanged() {
		    	selectedReservationDateTime = getSelectedReservationDateTime();
		    	
		    	console.log('예약 날짜/시간 변경:', selectedReservationDateTime);
		    	console.log('예약 날짜/시간 원본:', originalReservationDateTime);
		    	
		    	// 클래스idx, 예약일 정보를 받아서 남은자리 업데이트
		    	fetch('/myPage/changeReservation/changeClassDate?classIdx=' 
		                + encodeURIComponent(classIdx) 
		                + '&reservationClassDate=' + encodeURIComponent(selectedReservationDateTime))
		            .then(function(response) {
		                if (!response.ok) throw new Error('네트워크 문제 발생');
		                return response.json();
		            })
		            .then(function(data) {
		                if (data.success) {
		                    document.getElementById('remainSeats').textContent = data.remainSeats;
		                    
		                 	// 최대 예약 인원 계산
		                    if (selectedReservationDateTime === normalizedOriginal) {
		                    	maxMembers = data.remainSeats + initialMembers;
		                    } else {
	                        	maxMembers = data.remainSeats;
		                    }
		                    // 입력값 속성 조정
		                    const $reservationMembersInput = $('[name="reservationMembers"]');
		                    $reservationMembersInput.attr('max', maxMembers);
		                    // 현재 입력값이 maxMembers보다 더 클때 maxMembers로 자동 조정
		                    var currentVal = Number($reservationMembersInput.val());
		                    if (currentVal > maxMembers) {
		                        $reservationMembersInput.val(maxMembers);
		                        updatePrice(maxMembers); // 인원 변경후 금액
		                    } else {
		                        updatePrice(currentVal); // 인원 변경후 금액
		                    }
		                } else {
		                    alert('남은 좌석 정보를 가져오지 못했습니다.');
		                }
		            })
		            .catch(function(error) {
		                console.error('fetch 에러:', error);
		                alert('서버 통신 중 오류가 발생했습니다.');
		            });
		    };
		 
		 
		 
		 
		 
			// 가격 계산 함수 (인원 수 받아서 가격 표시)
		    function updatePrice(reserveMembers) {
		        if (isNaN(reserveMembers) || reserveMembers < 0) {
		            reserveMembers = 0;
		        }
		        const changePrice = price * reserveMembers;
		        const formattedPrice = changePrice.toLocaleString('en-US');
		        $('[name="changePrice"]').text(formattedPrice);
		    }
			
		 	// 날짜+시간을 DATETIME 형식 문자열로 변환하는 함수
		    function getSelectedReservationDateTime() {
		        const dateVal = $('input[name="reservationClassDate"]').val();  // yyyy-MM-dd
		        const timeVal = $('input[name="reservationTime"]').val();  // HH:mm
				
		        if (dateVal && timeVal) {
		            return dateVal + ' ' + timeVal + ':00';// 초는 00 고정
		        } else if (dateVal) {
		            return dateVal + ' 00:00:00';
		        } else {
		            return null;// 날짜가 없으면 null 반환
		        }
		    }
		 	
		});

		// 수정완료버튼클릭
	 	function validateForm() {
	 		const val = Number($('[name="reservationMembers"]').val());
	 		const minMembers = 1;
	 		
	 		if (val < minMembers) {
	 	        alert('예약 인원은 최소 ' + minMembers + '명 이상이어야 합니다.');
	 	        $('[name="reservationMembers"]').focus();
	 	        return false;
	 	    }
	 		
	 		if (isNaN(val)) {
	 	        alert('숫자만 입력 가능합니다.');
	 	        $('[name="reservationMembers"]').focus();
	 	        return false;
	 	    }
	 		
	 		if (val > maxMembers) {
	 	        alert('예약 인원은 최대 '+ maxMembers + '명을 초과할 수 없습니다.');
	 	        $('[name="reservationMembers"]').focus();
	 	        return false;
	 	    }
	 		
	 		return true;
	 	}
		
		
	</script>

</body>
</html>