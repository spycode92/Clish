<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style type="text/css">
	.sortable {
		cursor: pointer;	
	}
	
	.filterButton {
		display: inline-block;
		background: #f6f7fb;        /* 밝은 배경 */
		border: none;               /* 테두리 없음 */
		border-radius: 10px;        /* 둥근 모서리 */
		padding: 12px 26px;         /* 넉넉한 여백 */
		font-size: 16px;
		font-weight: 600;
		margin-right: 8px;          /* 버튼 사이 간격 */
		color: #222;                /* 글씨 색 */
		box-shadow: 0 1px 3px rgba(0,0,0,.04);
		cursor: pointer;
		transition: background 0.2s, color 0.2s;
	}

	.filterButton:hover {
		background-color: #2478ff; /* 어두운 파란색 호버 효과 */
		color: #fff; 
	}

	.filterButton:active {
		background-color: #004080; /* 클릭 시 더 어두운 파란색 */
	}
	
	#reservationTable th, #reservationTable td,
	#paymentTable th, #paymentTable td {
		max-width: 150px; /* 셀 최대 너비 설정 (필요시 조절) */
		white-space: nowrap; /* 텍스트를 한 줄로 유지 */
		overflow: hidden; /* 넘치는 텍스트 숨김 */
		text-overflow: ellipsis; /* 줄임표 ... 표시 */
		vertical-align: middle;
		word-wrap: normal;
	}

	#reservationTable, #paymentTable {
		table-layout: fixed; /* 테이블 전체 너비 고정 */
		width: 1000px;
		
	}
	
</style>
<link rel="preconnect" href="https://fonts.googleapis.com" >
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>

	<main id="container">
	
	<jsp:include page="/WEB-INF/views/clish/myPage/side.jsp"></jsp:include>
	<div id="main">
		<div>
			<a href="/myPage/payment_info" class="filterButton">전체</a>
			<a href="/myPage/payment_info/reservation_payment?filterType=0" class="filterButton">예약</a>
			<a href="/myPage/payment_info/reservation_payment?filterType=1" class="filterButton">결제</a>
		</div>
		<c:if test="${filterType eq 0 }">
			<div>
				<h3>예약 목록</h3>
				<table id="reservationTable" style="text-align: center;">
					<tr>
						<th width="90px">결제상태</th>
						<th width="180px">예약번호</th>
						<th width="85px">예약자</th>
						<th>클래스</th>
						<th class="sortable" data-column="reservation_class_date" width="140">
							클래스예약일
							<c:choose>
								<c:when test="${reservationOrderBy eq 'reservation_class_date' }">
										<c:if test="${reservationOrderDir eq 'desc' }">▼</c:if>
										<c:if test="${reservationOrderDir eq 'asc' }">▲</c:if>
								</c:when>
								<c:otherwise>↕</c:otherwise>
							</c:choose>
						</th>
						<th class="sortable" data-column="reservation_com" width="160">
							예약완료일
							<c:choose>
								<c:when test="${reservationOrderBy eq 'reservation_com' }">
										<c:if test="${reservationOrderDir eq 'desc' }">▼</c:if>
										<c:if test="${reservationOrderDir eq 'asc' }">▲</c:if>
								</c:when>
								<c:otherwise>↕</c:otherwise>
							</c:choose>
						</th>
						<th width="60px">취소</th>
						<th width="60px">결제</th>
						<th width="90px">상세보기</th>
					</tr>
					<!-- 예약  -->
					<c:forEach var="reserve" items="${reservationList }" >
			        	<tr>
			        		<td>
			        			<c:if test="${reserve.reservationStatus eq 1 }">미결제</c:if>
			        			<c:if test="${reserve.reservationStatus eq 2 }">결제완료</c:if>
			        		</td>
			        		<td>${reserve.reservationIdx}</td>
							<td>${user.userName}</td>
							<td>${reserve.classTitle}</td>
							<td>
								<fmt:parseDate var="reservationClassDate" 
									value="${reserve.reservationClassDate}"
									pattern="yyyy-MM-dd'T'HH:mm"
									type="both" />
								<fmt:formatDate value="${reservationClassDate}" pattern="yy-MM-dd"/>
							</td>
	<%-- 							<td>${reserve.reservationClassDate}</td> --%>
							<td>
								<fmt:parseDate var="reservationCom" 
									value="${reserve.reservationCom}"
									pattern="yyyy-MM-dd'T'HH:mm"
									type="both" />
								<fmt:formatDate value="${reservationCom}" pattern="yy-MM-dd HH:mm"/>
							</td>
	<%-- 							<td>${reserve.reservationCom}</td> --%>
							<td><input type="button" value="취소" data-reservation-num="${reserve.reservationIdx}"
		          				onclick="cancelReservation(this)" <c:if test="${reserve.reservationStatus eq 2 }">disabled</c:if>></td>
							<td><input type="button" value="결제" data-reservation-num="${reserve.reservationIdx}"
		        				onclick="payReservation(this)" <c:if test="${reserve.reservationStatus eq 2 }">disabled</c:if>> </td>
							<td><input type="button" value="상세보기" data-reservation-num="${reserve.reservationIdx}"
		        	  			onclick="reservationInfo(this)"> </td>
			        	</tr>
	
		       		</c:forEach>
					<tr>
						<td colspan="9" align="center">			
							<c:if test="${not empty reservationPageInfo.maxPage or reservationPageInfo.maxPage > 0}">
								<input type="button" value="이전" 
									onclick="location.href='/myPage/payment_info/reservation_payment?filterType=0&reservationPageNum=${reservationPageInfo.pageNum - 1}&reservationOrderBy=${reservationOrderBy }&reservationOrderDir=${reservationOrderDir }'" 
									<c:if test="${reservationPageInfo.pageNum eq 1}">disabled</c:if>
								>
								
								<c:forEach var="i" begin="${reservationPageInfo.startPage}" end="${reservationPageInfo.endPage}">
									<c:choose>
										<c:when test="${i eq reservationPageInfo.pageNum}">
											<strong>${i}</strong>
										</c:when>
										<c:otherwise>
											<a href="/myPage/payment_info/reservation_payment?filterType=0&reservationPageNum=${i}&reservationOrderBy=${reservationOrderBy }&reservationOrderDir=${reservationOrderDir }">${i}</a>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								
								<input type="button" value="다음" 
									onclick="location.href='/myPage/payment_info/reservation_payment?filterType=0&reservationPageNum=${reservationPageInfo.pageNum + 1}&reservationOrderBy=${reservationOrderBy }&reservationOrderDir=${reservationOrderDir }'" 
									<c:if test="${reservationPageInfo.pageNum eq reservationPageInfo.maxPage}">disabled</c:if>
								>
							</c:if>
						</td>
					</tr>
				</table>
			</div>
		</c:if>
		<c:if test="${filterType eq 1 }" >
			<div>
				<h3 >결제 목록</h3>
				<table id="paymentTable" style="text-align: center; overflow: hidden;">
					<tr>
						<th width="120px">결제 번호</th>
						<th class="sortable" data-column="status" width="120px">
							결제 상태
							<c:choose>
								<c:when test="${paymentOrderBy eq 'status' }">
										<c:if test="${paymentOrderDir eq 'desc' }">▼</c:if>
										<c:if test="${paymentOrderDir eq 'asc' }">▲</c:if>
								</c:when>
								<c:otherwise>↕</c:otherwise>
							</c:choose>
						</th>
						<th width="85px">이름</th>
						<th>클래스명</th>
						<th class="sortable" data-column="reservation_class_date" width="140px">
							예약일
							<c:choose>
								<c:when test="${paymentOrderBy eq 'reservation_class_date' }">
										<c:if test="${paymentOrderDir eq 'desc' }">▼</c:if>
										<c:if test="${paymentOrderDir eq 'asc' }">▲</c:if>
								</c:when>
								<c:otherwise>↕</c:otherwise>
							</c:choose>
						</th>
						<th class="sortable" data-column="pay_time" width="160px">
							결제완료시간
							<c:choose>
								<c:when test="${paymentOrderBy eq 'pay_time' }">
										<c:if test="${paymentOrderDir eq 'desc' }">▼</c:if>
										<c:if test="${paymentOrderDir eq 'asc' }">▲</c:if>
								</c:when>
								<c:otherwise>↕</c:otherwise>
							</c:choose>
						</th>
						<th width="90px">취소</th>
						<th width="90px">상세보기</th>
					</tr>
					<jsp:useBean id="now" class="java.util.Date" scope="page" />
					<c:set var="nowTime" value="${now.time}" />
					<c:forEach var="payment" items="${paymentList }" >
			        	<tr>
			        		<td>${payment.impUid }</td>
			        		<td>
			        			<c:if test="${payment.status  eq 'cancelled'}">취소완료 </c:if>
		        				<c:if test="${payment.status  eq 'paid'}">결제완료 </c:if>
			        		</td>
							<td>${payment.userName}</td>
							<td>${payment.classTitle}</td>
	<%-- 						<td>${payment.reservationClassDate }</td> --%>
							<fmt:parseDate var="reservationClassDate" 
										value="${payment.reservationClassDate }"
										pattern="yyyy-MM-dd'T'HH:mm"
										type="both" />
							<td><fmt:formatDate value="${reservationClassDate}" pattern="yy-MM-dd"/></td>
							<fmt:parseDate var="payTimeFormatted" 
										value="${payment.payTimeFormatted}"
										pattern="yyyy-MM-dd HH:mm"
										type="both" />
							<td><fmt:formatDate value="${payTimeFormatted}" pattern="yy-MM-dd HH:mm"/></td>
							<td>
								<fmt:formatDate value="${reservationClassDate}" pattern="yyyy-MM-dd" var="reservationClassDateStr" />
								<input type="button" value="결제취소" data-imp-num="${payment.impUid}" onclick="cancelPayment(this)" 
									<c:if test="${payment.status eq 'cancelled' or reservationClassDateStr <= today}"> disabled </c:if>></td>
							<td><input type="button" value="상세보기" data-imp-num="${payment.impUid}" data-status="${payment.status }"
		          onclick="paymentInfo(this)"> </td>
			        	</tr>
		       		</c:forEach>
					<tr>
						<td colspan="8" align="center">
							<c:if test="${not empty paymentPageInfo.maxPage or paymentPageInfo.maxPage > 0}">
								<input type="button" value="이전" 
									onclick="location.href='/myPage/payment_info/reservation_payment?filterType=1&paymentPageNum=${paymentPageInfo.pageNum - 1}&paymentOrderBy=${paymentOrderBy }&paymentOrderDir=${paymentOrderDir }'" 
									<c:if test="${paymentPageInfo.pageNum eq 1}">disabled</c:if>
								>
								
								<c:forEach var="i" begin="${paymentPageInfo.startPage}" end="${paymentPageInfo.endPage}">
									<c:choose>
										<c:when test="${i eq paymentPageInfo.pageNum}">
											<strong>${i}</strong>
										</c:when>
										<c:otherwise>
											<a href="/myPage/payment_info/reservation_payment?filterType=1&paymentPageNum=${i}&paymentOrderBy=${paymentOrderBy }&paymentOrderDir=${paymentOrderDir }">${i}</a>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								
								<input type="button" value="다음" 
									onclick="location.href='/myPage/payment_info/reservation_payment?filterType=1&paymentPageNum=${paymentPageInfo.pageNum + 1}&paymentOrderBy=${paymentOrderBy }&paymentOrderDir=${paymentOrderDir }'" 
									<c:if test="${paymentPageInfo.pageNum eq paymentPageInfo.maxPage}">disabled</c:if>
								>
							</c:if>
						</td>
					</tr>
				</table>
			</div>
		</c:if>
	
	</div>
	
	</main>
	
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
<script type="text/javascript">
	// 정렬방법 선택
	$(document).ready(() => {
		const initialReservationOrderBy = "${reservationOrderBy}"; //예약정렬 컬럼
		const initialReservationOrderDir = "${reservationOrderDir}";// 정렬방법
		const initialPaymentOrderBy = "${paymentOrderBy}"; // 결제정렬 컬럼
		const initialPaymentOrderDir = "${paymentOrderDir}"; // 정렬방법
		
		// 예약목록 정렬방법 선택
		$('#reservationTable th.sortable').click(function () {
			// 클릭한 sortable 클래스를 가지고 있는 th태그의 data-column속성 값을 정렬기준으로 요청   
			const column = $(this).data('column');
			// 요청할 정렬방법
			let newOrderDir = 'desc';
			// 요청한 정렬기준이 기존의 정렬기준과 같고 기존의 정렬방법이 'desc'라면 요청방법은 'asc'이다
			if (initialReservationOrderBy === column && initialReservationOrderDir === 'desc') {
				newOrderDir = 'asc';	
			}
			
			const urlParams = new URLSearchParams(window.location.search);
			
			urlParams.set('reservationOrderBy', column);
			urlParams.set('reservationOrderDir', newOrderDir);
			// 결제 파라미터 세팅
			if (urlParams.has('paymentOrderBy') === false) {
		      urlParams.set('paymentOrderBy', initialPaymentOrderBy);
		    }
		    if (urlParams.has('paymentOrderDir') === false) {
		      urlParams.set('paymentOrderDir', initialPaymentOrderDir);
		    }
			// 파라미터 추가해서 페이지로 이동
			window.location.search = urlParams.toString();
		});
		
		// 결제목록 정렬방법 선택
		$('#paymentTable th.sortable').click(function () {
			// 클릭한 sortable 클래스를 가지고 있는 th태그의 data-column속성 값을 정렬기준으로 요청   
			const column = $(this).data('column');
			// 요청할 정렬방법
			let newOrderDir = 'desc';
			// 요청한 정렬기준이 기존의 정렬기준과 같고 기존의 정렬방법이 'desc'라면 요청방법은 'asc'이다
			if (initialPaymentOrderBy === column && initialPaymentOrderDir === 'desc') {
				newOrderDir = 'asc';	
			}
			
			const urlParams = new URLSearchParams(window.location.search);
			
			urlParams.set('paymentOrderBy', column);
			urlParams.set('paymentOrderDir', newOrderDir);
			// 결제 파라미터 세팅
			if (urlParams.has('reservationOrderBy') === false) {
		      urlParams.set('reservationOrderBy', initialReservationOrderBy);
		    }
		    if (urlParams.has('reservationOrderDir') === false) {
		      urlParams.set('reservationOrderDir', initialReservationOrderDir);
		    }
			// 파라미터 추가해서 페이지로 이동
			window.location.search = urlParams.toString();
		});
	});
	
	//취소버튼 함수
	function cancelReservation(btn) {
		if(confirm("정말로 예약을 취소하시겠습니까?")){
		    // 1. 버튼의 data- 속성에서 예약번호 읽기
		    var reservationIdx = btn.getAttribute('data-reservation-num');
// 			console.log(reservationIdx);
		    // 2. 필요하면 같은 행의 다른 정보도 읽을 수 있음
		    // var row = btn.closest('tr');
		    // var userId = row.cells[1].innerText;
		
		    // 3. 서버로 AJAX 전송 (fetch 사용)
		    fetch('/myPage/payment_info/cancel', {
		        method: 'POST',
		        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
		        body: 'reservationIdx=' + encodeURIComponent(reservationIdx)
		    })
		    .then(response => response.text())
		    .then(result => {
		        alert(result); // 서버에서 받은 결과 메시지 표시
		        location.reload(); // 필요하다면 새로고침
		    })
		    .catch(error => {
		        alert("오류 발생: " + error);
		    });
		}
	}
	
	//상세보기 버튼 함수
	function reservationInfo(btn) {
    	//예약번호 읽기
	    var reservationIdx = btn.getAttribute('data-reservation-num');
		//팝업창 열기
	    window.open(
	        '/myPage/payment_info/detail?reservationIdx=' + encodeURIComponent(reservationIdx),
	        'reservationDetail',
	        `width=1345,height=670,resizable=yes,scrollbars=yes`
	    );
	}
	
	//결제버튼 함수
	function payReservation(btn) {
	    var reservationIdx = btn.getAttribute('data-reservation-num'); 
	    window.open(
	        '/myPage/payment_info/payReservation?from=list&reservationIdx=' + encodeURIComponent(reservationIdx),
	        'payReservation',
	        `width=1085,height=555,resizable=yes,scrollbars=yes`
	    );
	}
	//결제취소버튼
	function cancelPayment(btn) {
		var impUid = btn.getAttribute('data-imp-num');
		window.open(
			'/myPage/payment_info/cancelPayment?impUid=' + encodeURIComponent(impUid),			
			'paymentInfo',
			`width=650,height=900, resizable=yes, scrollbars=yes`
		);
	}
	//결제상세정보
	function paymentInfo(btn) {
		var impUid = btn.getAttribute('data-imp-num');
		var status = btn.getAttribute('data-status');
		console.log(status);
		if(status == 'paid'){
			window.open(
				'/myPage/payment_info/paymentDetail?impUid=' + encodeURIComponent(impUid),			
				'paymentInfo',
				'width=600,height=600, resizable=yes, scrollbars=yes'
			);
		}
		if(status == 'cancelled'){
			window.open(
					'/myPage/payment_info/cancelDetail?impUid=' + encodeURIComponent(impUid),			
					'paymentInfo',
					'width=600,height=600, resizable=yes, scrollbars=yes'
				);
		}
	}
	
	
</script>
</body>
</html>
