<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${reservationClassInfo.class_title} - 결제</title>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>

<link href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/myPage.css" rel="stylesheet" type="text/css">
<!-- jQuery와 포트원 결제 SDK 로드 -->
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<!-- <script src="https://service.iamport.kr/js/iamport.payment-1.1.5.js"></script> -->
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<script type="text/javascript" src="/resources/js/myPage/myPage_payment.js"></script>

</head>
<body>

	<main id="container">
	
	<div id="main">
		<form action="" method="post">
		<table style="margin-left: auto ; margin-right: auto;">
			<tr>
				<th rowspan="5">
					<img src="/file/${reservationClassInfo.file_id}?type=0"
					 alt="${reservationClassInfo.original_file_name }" width="200px" height="250px" >
				</th>
				<th>${reservationClassInfo.class_title}</th>
			</tr>
			<tr><th>클래스정원</th></tr>
			<tr>
				<th>${reservationClassInfo.class_member}</th>
			</tr>
			<tr><th>남은자리</th></tr> 
			<tr>
				<th>${reservationClassInfo.remainSeats}</th>
			</tr>
			<tr><th>시작일</th><th>종료일</th></tr>
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
				<th>예약요청일</th>
				<th>예약완료일</th>
				<th>잔여좌석</th>
				<th>예약인원</th>
				<th>결제 금액</th>
			</tr>
        	<tr>
        		<td>${reservationClassInfo.reservation_idx}</td>
				<td>${user.userName}</td>
				<td>${reservationClassInfo.class_title}</td>
				<fmt:parseDate var="reservationClassDate" 
					value="${reservationClassInfo.reservation_class_date}"
					pattern="yyyy-MM-dd'T'"
					type="both" />
				<td><fmt:formatDate value="${reservationClassDate}" pattern="yy-MM-dd "/></td>
				<fmt:parseDate var="reservationCom" 
					value="${reservationClassInfo.reservation_com}"
					pattern="yyyy-MM-dd'T'HH:mm:ss"
					type="both" />
				<td><fmt:formatDate value="${reservationCom}" pattern="yy-MM-dd HH:mm"/></td>
				<td>${reservationClassInfo.remainSeats}</td>
				<td>${reservationClassInfo.reservation_members}</td>
				<td><fmt:formatNumber pattern="#,##0">${reservationClassInfo.reservation_members * reservationClassInfo.class_price}</fmt:formatNumber>
				 </td>		
        	</tr>
        	<tr>
        		<td colspan="8" style="text-align: right;">
	        		<a href="#" onclick="window.open('/agreement/privacy', '_blank', 'width=500,height=600,scrollbars=yes'); return false;">[필수]개인정보 수집·이용 동의</a><input type="checkbox" id="privacy"> <br>
	        		<a href="#" onclick="window.open('/agreement/payment_refund', '_blank', 'width=500,height=600,scrollbars=yes'); return false;">결제 및 환불 정책 동의</a><input type="checkbox" id="policy">
        		</td>
        	</tr>
			<tr>
				<td colspan="8" style="text-align: right;">
					<input type="button" value="취소" data-reservation-num="${reservationClassInfo.reservation_idx}"
	         				onclick="cancelPayment(this)">
					<input type="button" value="결제" data-reservation-num="${reservationClassInfo.reservation_idx}"
						onclick="requestPay()" id="paybtn">
       			</td>
       		</tr> 
		</table>
		</form>
	</div>
	
	</main>
	
	<script type="text/javascript">
	
		var reservation_idx = "${reservationClassInfo.reservation_idx}";
		var reservation_class_date = "${reservationClassInfo.reservation_class_date}";
		var reservation_com = "${reservationClassInfo.reservation_com}";
		var class_price = "${reservationClassInfo.class_price}";
		var reservation_members = "${reservationClassInfo.reservation_members}";
		var price = "${reservationClassInfo.reservation_members * reservationClassInfo.class_price}";
		var class_title = "${reservationClassInfo.class_title}";
		var user_name = "${user.userName}";
		var from = "${param.from}";
		
		function cancelPayment(btn) {
			if(confirm("결제를 취소하시겠습니까?")){
			    window.close();
			}
		}	
		
		window.onunload = function() {
		    if (window.opener && !window.opener.closed) {
		        window.opener.location.reload();
		    }
		    if (window.opener.opener && !window.opener.opener.closed) {
		        window.opener.opener.location.reload();
		    }
		};
		
	</script>

</body>
</html>


