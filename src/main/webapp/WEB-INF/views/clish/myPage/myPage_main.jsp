<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 마이페이지</title>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<style type="text/css">
	.main {
		width: 90%;
		max-width: 1200px;
		margin: 15px 30px;
		font-family: 'Arial', sans-serif;
		color: #333;
	}

	/* 각 섹션 공통 스타일 */
	.longMenu, .subSection {
		background: #f0f4f8;
		border-radius: 10px;
		margin-bottom: 10px;
		padding: 0px 10px;
		width: 90%;
	}

	/* 제목 스타일 */
	.subTitle, .longMenu > div:first-child {
		font-size: 12px;
		font-weight: bold;
		color: #2a7ae2;
		border-left: 6px solid #2a7ae2;
		padding-left: 12px;
		margin-bottom: 10px;
	}

	/* 테이블 공통 스타일 */
	.subTable {
		width: 90%;
		margin: 5px 0 !important;
		border-collapse: collapse;
		background-color: #fff;
		box-shadow: inset 0 0 8px rgba(0,0,0,0.04);
		border-radius: 8px;
		overflow: hidden;
		table-layout: fixed; /* 고정 너비 */
	}

	/* 테이블 헤더 */
	.subTable thead {
		background-color: #2a7ae2;
		color: white;
		font-weight: 600;
		user-select: none;
	}

	.subTable th, .subTable td {
		padding: 12px 8px;
		border: 1px solid #dde4ea;
		text-align: center;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		font-size: 12px;
	}

	/* 홀수행 배경 */
	.subTable tbody tr:nth-child(odd) {
		background-color: #f9fbff;
	}

	/* 짝수행 배경 */
	.subTable tbody tr:nth-child(even) {
		background-color: #ffffff;
	}

	/* 행 hover 효과 */
	.subTable tbody tr:hover {
		background-color: #dae6ff;
		cursor: pointer;
	}

	/* 버튼 스타일 */
	.subTable input[type="button"] {
		background-color: #2a7ae2;
		border: none;
		color: white;
		padding: 6px 14px;
		font-size: 10px;
		border-radius: 5px;
		cursor: pointer;
		transition: background-color 0.25s ease;
	}

	.subTable input[type="button"]:hover:not(:disabled) {
		background-color: #1d4fbb;
	}

	.subTable input[type="button"]:disabled {
		background-color: #aab8d9;
		cursor: not-allowed;
	}

	/* 페이징 영역 */
	.pageList {
		margin-top: 5px;
		text-align: center;
		user-select: none;
		border: none;
		color: black; 
	}

	.pageList input[type="button"], .pageList a, .pageList strong {
		display: inline-block;
		margin: 0 6px;
		padding: 3px 5px;
		font-size: 10px;
		border-radius: 5px;
		text-decoration: none;
		color: #2a7ae2;
		border: 1px solid #2a7ae2;
		background-color: white;
		cursor: pointer;
		transition: all 0.3s ease;
	}

	.pageList input[type="button"]:disabled {
		border-color: #ddd;
		color: #181818;
		cursor: default;
	}

	.pageList a:hover {
		background-color: #2a7ae2;
		color: white;
	}

	.pageList strong {
		background-color: #2a7ae2;
		color: white;
		border-color: #2a7ae2;
		cursor: default;
	}
	
	.inquery-toggle { cursor: pointer; background: #f9f9f9; }
	
	.inquery-detail { display: none; background: #fff4d9; }
	
	tr.inquery-detail td {
		text-align: left;
		padding-left: 12px; /* 읽기 편하도록 좌측 여백 추가 */
	}

	/* 반응형 */
	@media (max-width: 1024px) {
		.subTable th, .subTable td {
			font-size: 10px;
			padding: 10px 6px;
		}
		.subTitle, .longMenu > div:first-child {
			font-size: 10px;
		}
	}

	@media (max-width: 700px) {
		.main {
		width: 98%;
		}
		.subTable {
			font-size: 10px;
		}
		.subTable th, .subTable td {
			padding: 6px 4px;
			white-space: normal; /* 작은 화면에선 줄바꿈 허용 */
		}
		.pageList input[type="button"], .pageList a, .pageList strong {
			padding: 6px 10px;
			font-size: 10px;
		}
	}
	
}
	
</style>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<link rel="preconnect" href="https://fonts.googleapis.com" >
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
		<div class="main">
			<section class="subSection">
				<p class="subTitle">알림사항</p>
				<table class="subTable">
					<thead>
						<tr>
							<th>결제가능예약</th>
							<th>최근 1:1 문의 답변</th>
							<th>최근 강의 문의 답변</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>
								${recentReservePageInfo.listCount}
							</td>
							<td>
								${recentSiteInqueryPageInfo.listCount }
							</td>
							<td>
								${recentClassInqueryPageInfo.listCount }
							</td>
						</tr>
					</tbody>
				</table>
			</section>
			
			<c:if test="${ recentReservePageInfo.listCount > 0}">
				<section class="subSection">
				<p class="subTitle">결제가능 예약목록</p>
				
					<table class="subTable">
						<thead>
							<tr>
								<th>예약번호</th>
								<th>결제상태</th>
								<th>예약자</th>
								<th>클래스</th>
								<th>클래스예약</th>
								<th>클래스예약 신청</th>
								<th>취소</th>
								<th>결제</th>
								<th>상세보기</th>
							</tr>
						</thead>
					    <tbody>
						    <c:forEach var="recentReserve" items="${RecentReservation}">
							    <tr>
									<td>${recentReserve.reservation_idx}</td>
									<td>
										<c:if test="${recentReserve.reservation_status eq 1 }">미결제</c:if>
									</td>
									<td>${user.userName}</td>
									<td>${recentReserve.class_title}</td>
									<td>
									<fmt:parseDate var="reservationClassDate" 
										value="${recentReserve.reservation_class_date}"
										pattern="yyyy-MM-dd'T'HH:mm"
										type="both" />
									<fmt:formatDate value="${reservationClassDate}" pattern="MM-dd"/>
									</td>
		<%-- 							<td>${recentReserve.reservation_class_date}</td> --%>
									<td>
									<fmt:parseDate var="reservationCom" 
										value="${recentReserve.reservation_com}"
										pattern="yyyy-MM-dd'T'HH:mm"
										type="both" />
									<fmt:formatDate value="${reservationCom}" pattern="MM-dd HH:mm"/>
									</td>
		<%-- 							<td>${recentReserve.reservation_com}</td> --%>
									<td><input type="button" value="취소" data-reservation-num="${recentReserve.reservation_idx}"
			          				onclick="cancelReservation(this)" <c:if test="${recentReserve.reservation_status eq 2 }">disabled</c:if>></td>
								<td><input type="button" value="결제" data-reservation-num="${recentReserve.reservation_idx}"
			        				onclick="payReservation(this)" <c:if test="${recentReserve.reservation_status eq 2 }">disabled</c:if>> </td>
								<td><input type="button" value="상세보기" data-reservation-num="${recentReserve.reservation_idx}"
			        	  			onclick="reservationInfo(this)"> </td>
							    </tr>
						    </c:forEach>
					    </tbody>
					</table>
					
					<section id="recentReservePageList" class="pageList">
						<c:if test="${not empty recentReservePageInfo.maxPage or recentReservePageInfo.maxPage > 0}">
							<input type="button" value="이전" 
								onclick="location.href='/myPage/main?recentReservePageNum=${recentReservePageInfo.pageNum - 1}&recentSiteInqueryPageNum=${param.recentSiteInqueryPageNum }&recentClassInqueryPageNum=${param.recentClassInqueryPageNum }'" 
								<c:if test="${recentReservePageInfo.pageNum eq 1}">disabled</c:if>
							>
							
							<c:forEach var="i" begin="${recentReservePageInfo.startPage}" end="${recentReservePageInfo.endPage}">
								<c:choose>
									<c:when test="${i eq recentReservePageInfo.pageNum}">
										<strong>${i}</strong>
									</c:when>
									<c:otherwise>
										<a href="/myPage/main?recentReservePageNum=${i}&recentSiteInqueryPageNum=${param.recentSiteInqueryPageNum }&recentClassInqueryPageNum=${param.recentClassInqueryPageNum }">${i}</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							
							<input type="button" value="다음" 
								onclick="location.href='/myPage/main?recentReservePageNum=${recentReservePageInfo.pageNum + 1}&recentSiteInqueryPageNum=${param.recentSiteInqueryPageNum }&recentClassInqueryPageNum=${param.recentClassInqueryPageNum }'" 
								<c:if test="${recentReservePageInfo.pageNum eq recentReservePageInfo.maxPage}">disabled</c:if>
							>
						</c:if>
					</section>
				</section>
			</c:if>
			
			<c:if test="${ recentSiteInqueryPageInfo.listCount > 0}">
				<section class="subSection">
				<p class="subTitle">최근 1:1 문의 답변</p>
				
					<table class="subTable">
						<thead>
							<tr>
								<th>문의번호</th>
								<th>문의시간</th>
								<th>이름</th>
								<th>제목</th>
								<th>상태</th>
							</tr>
						</thead>
					    <tbody>
						    <c:forEach var="recentSite" items="${RecentSiteInquery}">
							    <tr class="inquery-toggle">
									<td>${recentSite.inquery_idx}</td>
									<td>
									<fmt:parseDate var="inqueryDatetime" 
										value="${recentSite.inquery_datetime }"
										pattern="yyyy-MM-dd'T'HH:mm"
										type="both" />
						    			<fmt:formatDate value="${inqueryDatetime }" pattern="MM-dd HH:mm:ss"/>
									</td>
									<td>${user.userName}</td>
									<td>${recentSite.inquery_title}</td>
									<td>
								        <c:choose>
								        	<c:when test="${recentSite.inquery_status == 1}">답변대기</c:when>
								          	<c:when test="${recentSite.inquery_status == 2}">답변완료</c:when>
								       	 	<c:when test="${recentSite.inquery_status == 3}">검토중</c:when>
								        </c:choose>
							     	</td>								
							    </tr>
							    <tr class="inquery-detail">
							      	<td colspan="5">
								        <strong>문의 내용:</strong><br>
								        	${recentSite.inquery_detail}<br><br>
								        <strong>답변 내용:</strong><br>
								        	${recentSite.inquery_answer}
							    	</td>
						    	</tr>
							    
						    </c:forEach>
					    </tbody>
					</table>
					
					<section id="recentSiteInqueryPageList" class="pageList">
						<c:if test="${not empty recentSiteInqueryPageInfo.maxPage or recentSiteInqueryPageInfo.maxPage > 0}">
							<input type="button" value="이전" 
								onclick="location.href='/myPage/main?recentSiteInqueryPageNum=${recentSiteInqueryPageInfo.pageNum - 1}&recentReservePageNum=${param.recentReservePageNum }&recentClassInqueryPageNum=${param.recentClassInqueryPageNum }'" 
								<c:if test="${recentSiteInqueryPageInfo.pageNum eq 1}">disabled</c:if>
							>
							
							<c:forEach var="i" begin="${recentSiteInqueryPageInfo.startPage}" end="${recentSiteInqueryPageInfo.endPage}">
								<c:choose>
									<c:when test="${i eq recentSiteInqueryPageInfo.pageNum}">
										<strong>${i}</strong>
									</c:when>
									<c:otherwise>
										<a href="/myPage/main?recentSiteInqueryPageNum=${i}&recentReservePageNum=${param.recentReservePageNum }&recentClassInqueryPageNum=${param.recentClassInqueryPageNum }">${i}</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							
							<input type="button" value="다음" 
								onclick="location.href='/myPage/main?recentSiteInqueryPageNum=${recentSiteInqueryPageInfo.pageNum + 1}&recentReservePageNum=${param.recentReservePageNum }&recentClassInqueryPageNum=${param.recentClassInqueryPageNum }'" 
								<c:if test="${recentSiteInqueryPageInfo.pageNum eq recentSiteInqueryPageInfo.maxPage}">disabled</c:if>
							>
						</c:if>
					</section>
				</section>
			</c:if>
			
			<c:if test="${ recentClassInqueryPageInfo.listCount > 0}">
				<section class="subSection">
				<p class="subTitle">최근 강의 문의 답변</p>
				
					<table class="subTable">
						<thead>
							<tr>
								<th>문의번호</th>
								<th>문의시간</th>
								<th>이름</th>
								<th>강의명</th>
								<th>제목</th>
								<th>상태</th>
							</tr>
						</thead>
					    <tbody>
						    <c:forEach var="recentClass" items="${RecentClassInquery}">
							    <tr class="inquery-toggle">
									<td>${recentClass.inquery_idx}</td>
									<td>
									<fmt:parseDate var="inqueryDatetime" 
										value="${recentClass.inquery_datetime }"
										pattern="yyyy-MM-dd'T'HH:mm"
										type="both" />
						    			<fmt:formatDate value="${inqueryDatetime }" pattern="MM-dd HH:mm:ss"/>
									</td>
									<td>${user.userName}</td>
									<td>${recentClass.class_title }</td>
									<td>${recentClass.inquery_title}</td>
									<td>
								        <c:choose>
								        	<c:when test="${recentClass.inquery_status == 1}">답변대기</c:when>
								          	<c:when test="${recentClass.inquery_status == 2}">답변완료</c:when>
								       	 	<c:when test="${recentClass.inquery_status == 3}">검토중</c:when>
								        </c:choose>
							     	</td>								
							    </tr>
							    <tr class="inquery-detail">
						      	<td colspan="5">
							        <strong>문의 내용:</strong><br>
							        	${recentClass.inquery_detail}<br><br>
							        <strong>답변 내용:</strong><br>
							        	${recentClass.inquery_answer}
						    	</td>
						    </tr>
							    
						    </c:forEach>
					    </tbody>
					</table>
					
					<section id="recentClassInqueryPageList" class="pageList">
						<c:if test="${not empty recentClassInqueryPageInfo.maxPage or recentClassInqueryPageInfo.maxPage > 0}">
							<input type="button" value="이전" 
								onclick="location.href='/myPage/main?recentClassInqueryPageNum=${recentClassInqueryPageInfo.pageNum - 1}&recentReservePageNum=${param.recentReservePageNum }&recentSiteInqueryPageNum=${param.recentSiteInqueryPageNum }'" 
								<c:if test="${recentClassInqueryPageInfo.pageNum eq 1}">disabled</c:if>
							>
							
							<c:forEach var="i" begin="${recentClassInqueryPageInfo.startPage}" end="${recentClassInqueryPageInfo.endPage}">
								<c:choose>
									<c:when test="${i eq recentClassInqueryPageInfo.pageNum}">
										<strong>${i}</strong>
									</c:when>
									<c:otherwise>
										<a href="/myPage/main?recentClassInqueryPageNum=${i}&recentReservePageNum=${param.recentReservePageNum }&recentSiteInqueryPageNum=${param.recentSiteInqueryPageNum }">${i}</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							
							<input type="button" value="다음" 
								onclick="location.href='/myPage/main?recentClassInqueryPageNum=${recentClassInqueryPageInfo.pageNum + 1}&recentReservePageNum=${param.recentReservePageNum }&recentSiteInqueryPageNum=${param.recentSiteInqueryPageNum }'" 
								<c:if test="${recentClassInqueryPageInfo.pageNum eq recentClassInqueryPageInfo.maxPage}">disabled</c:if>
							>
						</c:if>
					</section>
				</section>
			</c:if>

		</div>
	</main>
	
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
	<script type="text/javascript">
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
	
	$(document).ready(function () {
	   $(".inquery-toggle").click(function () {
	     const detailRow = $(this).next(".inquery-detail");
	
	     $(".inquery-detail").not(detailRow).slideUp(200);
	
	     if (!detailRow.is(":visible")) {
	       detailRow.slideDown();
	     } else {
	       detailRow.slideUp();
	     }
	   });
	 });
	</script>
</body>
</html>