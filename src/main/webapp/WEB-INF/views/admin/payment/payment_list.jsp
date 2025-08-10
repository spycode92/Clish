<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 결제목록</title>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
</head>
<body>
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"></jsp:include>
		</div>
		<div class="main">
			<jsp:include page="/WEB-INF/views/admin/header.jsp"></jsp:include>
			<div class="main_container">
				<div class="bg-light">
					<div>
						<div>
							<h5 class="section-title">결제 목록</h5>
						</div>
						<form id="sortForm" method="get" action="/admin/paymentList" style="background-color: #F3F6F9; border: none; padding: 0;">
						  <div class="sort-buttons">
						    <button class="sort-button" type="submit" name="filter" value="all">전체</button>
						    <button class="sort-button" type="submit" name="filter" value="recent">최신순</button>
						    <button class="sort-button" type="submit" name="filter" value="oldest">과거순</button>
						    <button class="sort-button" type="submit" name="filter" value="long">장기강의</button>
						    <button class="sort-button" type="submit" name="filter" value="short">단기강의</button>
						  </div>
						</form>
					</div>
					<div style="height: 520px;">
						<c:choose>
							<c:when test="${empty paymentList}">
								<div class="list-empty">결제된 강의가 없습니다.</div>
							</c:when>
							<c:otherwise>
								<table id="table">
									<thead>
										<tr>
											<th>결제번호</th>
											<th>결제일시</th>
											<th>결제강의</th>
											<th>회원이름</th>
											<th>결제상태</th>
											<th>결제금액</th>
											<th>환불요청</th>
											<th>상세정보</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="payment" items="${paymentList}">
											<tr>
												<td>${fn:substringAfter(payment.imp_uid, 'imp_')}</td>
												<td>${payment.formatted_pay_time}</td>
												<td>${payment.class_title}</td>
												<td>${payment.user_name}</td>
												<td>
													<c:choose>
														<c:when test="${payment.status eq 'paid'}">
															<span class="status-paid">결제완료</span>
														</c:when>
														<c:otherwise>
															<span class="status-cancelled">결제취소</span>
														</c:otherwise>
													</c:choose>
												</td>
												<td><fmt:formatNumber value="${payment.amount}" type="number" groupingUsed="true"/> 원</td>
												<td>
													<button data-imp-num="${payment.imp_uid}" onclick="cancelPayment(this)" class="blue-button"
													<c:if test="${payment.status eq 'cancelled' }"> disabled </c:if>>결제취소</button>
												</td>
												<td>
													<button onclick="paymentInfo('${payment.imp_uid}', '${payment.status}')">상세정보</button>
												</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</c:otherwise>
						</c:choose>
					</div>
					<div style="display: flex; align-items: center; justify-content: center; margin-top: 30px;">
						<div>
							<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
								<input type="button" value="이전" 
									onclick="location.href='/admin/paymentList?pageNum=${pageInfo.pageNum - 1}&filter=${param.filter}'" 
									<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
								
								<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
									<c:choose>
										<c:when test="${i eq pageInfo.pageNum}">
											<strong>${i}</strong>
										</c:when>
										<c:otherwise>
											<a href="/admin/paymentList?pageNum=${i}&filter=${param.filter}">${i}</a>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								
								<input type="button" value="다음" 
									onclick="location.href='/admin/paymentList?pageNum=${pageInfo.pageNum + 1}&filter=${param.filter}'" 
								<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
							</c:if>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		function paymentInfo(impUid, status) {
			if(status == 'paid'){
				window.open(
					'/admin/payment_info/paymentDetail?impUid=' + encodeURIComponent(impUid),			
					'paymentInfo',
					`width=600,height=1500, resizable=yes, scrollbars=yes`
				);
			}
			if(status == 'cancelled'){
				window.open(
						'/admin/payment_info/cancelDetail?impUid=' + encodeURIComponent(impUid),			
						'paymentInfo',
						`width=600,height=1500, resizable=yes, scrollbars=yes`
				);
			}
		}
		
		function cancelPayment(btn) {
			var impUid = btn.getAttribute('data-imp-num');
			window.open(
				'/admin/payment/cancel?impUid=' + encodeURIComponent(impUid),			
				'paymentInfo',
				`width=600,height=1500, resizable=yes, scrollbars=yes`
			);
		}
	</script>
</body>
</html>