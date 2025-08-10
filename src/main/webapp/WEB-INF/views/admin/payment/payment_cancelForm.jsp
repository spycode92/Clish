<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/png" href="/favicon.png" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>결제취소신청</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.portone.io/v2/browser-sdk.js" async defer></script>
    <link href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" rel="stylesheet" type="text/css">
    <link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
  </head>
  <body>
		<form action="/admin/payment/cancel" method="post" id="cancelRequest" onsubmit="confirm('정말 취소 하시겠습니까?')">
		<h1>${message }</h1>
		<h1>${paymentCancelClassInfo.reservationClassDate }</h1>
		<h1>${paymentCancelClassInfo.cancelAmount }</h1>
		<fmt:formatNumber var="formattedAmount" value="${paymentCancelClassInfo.amount}" pattern="#,##0" />
		<fmt:formatNumber var="formattedAmountCancel" value="${paymentCancelClassInfo.cancelAmount }" pattern="#,##0" />
		<table>
			<tr>
				<th>결제 번호</th>
				<td><input type="text" value="${paymentCancelClassInfo.impUid }" name="impUid" readonly></td>
			</tr><tr>
				<th>상품 이름</th>
				<td><input type="text" value="${paymentCancelClassInfo.classTitle}" name="classTitle" readonly></td>
			</tr><tr>
			</tr><tr>
				<th>예약 일자</th>
				<td><input type="text" value="${paymentCancelClassInfo.reservationClassDate }" readonly></td>
			</tr><tr>
				<th>주문 번호</th>
				<td><input type="text" value="${paymentCancelClassInfo.reservationIdx}"name="reservationIdx" readonly></td>
			</tr><tr>
				<th>결제 금액</th>
				<td><input type="text" value="${formattedAmount }" readonly></td>
			</tr><tr>
			</tr><tr>
				<th>환불 가능 금액</th>
				<td>
					<input type="number" name="amount"  step="1" required/>
				</td>
					
			</tr><tr>
				<th>구매 I  D</th>
				<td><input type="text" value="${paymentCancelClassInfo.userName}"name="userName" readonly></td>
			</tr><tr>
				<th>구매 상태</th>
				<td><input type="text" value="${paymentCancelClassInfo.status }" readonly></td>
			</tr><tr>
				<th>결제 시각</th>
				<td><input type="text" value="${payTime}" readonly></td>
			</tr><tr>
				<th>변 환</th>
				<td><input type="text" value="${payTime}" readonly></td>
			</tr>
			<tr>
				<th>취소 이유</th>
				<td><textarea rows="15" cols="50" placeholder="취소사유입력" name="cancelReason" required></textarea></td> 
			</tr>
		</table>
		<input type="submit" value="결제취소신청" style="display: block; margin: auto;">
		</form>
  </body>
</html>
