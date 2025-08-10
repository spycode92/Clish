<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 나의문의</title>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>

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
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="preconnect" href="https://fonts.googleapis.com" >
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap" rel="stylesheet">
<style>
	.inquery-toggle { cursor: pointer; background: #f9f9f9; }
	.inquery-detail { display: none; background: #fff4d9; }
	.btn-wrap {
		display: flex;
		gap: 16px;
		margin-top: 10px;
		justify-content: flex-end;
	}
	.btn-wrap form {
		margin: 0;
		padding: 0;
		border: none;        
		background: none;     
		box-shadow: none;     
		display: inline;   
	    
	}
	.btn-wrap button:hover {
		background: #ff9c34;
	}
	
	.pageSection {
		text-align: center;
		border: none;
	}

</style>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	
	<main id="container">
	
	<jsp:include page="/WEB-INF/views/clish/myPage/side.jsp"></jsp:include>
	
	<div id="main">
		<div>
			<a href="/myPage/myQuestion" class="filterButton">전체</a>
			<a href="/myPage/myQuestion/question_inquery?filterType=0" class="filterButton">강의 문의</a>
			<a href="/myPage/myQuestion/question_inquery?filterType=1" class="filterButton">고객센터 문의</a>
		</div>
		<div>
			<h3>강의 문의</h3>
			<table id="classQTable"border="1" style="width: 100%; border-collapse: collapse;">
				<thead style="background-color: #f5f5f5;">
	   			<tr>
	      			<th>문의 번호</th>
				    <th>상태</th>
	      			<th class="sortable" data-column="inquery_datetime">
	      				문의 시간
	      				<c:choose>
							<c:when test="${classQOrderBy eq 'inquery_datetime' }">
									<c:if test="${classQOrderDir eq 'desc' }">▼</c:if>
									<c:if test="${classQOrderDir eq 'asc' }">▲</c:if>
							</c:when>
							<c:otherwise>↕</c:otherwise>
						</c:choose>
	      			</th>
				    <th>이름</th>
				    <th>강의명</th>
				    <th>제목</th>
			    </tr>
			    </thead>
			  	<tbody>
				  	<c:forEach var="classQ" items="${classQDTOList}">
					    <tr class="inquery-toggle">
					    	<td>${classQ.inqueryIdx}</td>
					      	<td>
						        <c:choose>
						        	<c:when test="${classQ.inqueryStatus == 1}">답변 대기</c:when>
						          	<c:when test="${classQ.inqueryStatus == 2}">답변 완료</c:when>
						       	 	<c:when test="${classQ.inqueryStatus == 3}">검토중</c:when>
						        </c:choose>
					     	</td>
					    	<td><fmt:formatDate value="${classQ.inqueryDatetime }" pattern="MM-dd HH:mm"/></td>
					      	<td>${user.userName}</td>
					      	<td>${classQ.classTitle }</td>
					      	<td>${classQ.inqueryTitle}</td>
					    </tr>
					
					    <tr class="inquery-detail">
					      	<td colspan="6">
					      		<strong>답변 시간 : <fmt:formatDate value="${classQ.inqueryAnswerDatetime }" pattern="MM-dd HH:mm"/></strong><br><br>
						        <strong>문의 내용</strong><br>
						        	${classQ.inqueryDetail}<br><br>
						        <strong>답변 내용</strong><br>
						        <c:if test="${not empty classQ.inqueryAnswer}">
						        	  ${classQ.inqueryAnswer}
						        </c:if>
						        <c:if test="${empty classQ.inqueryAnswer}">
						         	 아직 답변이 등록되지 않았습니다.
						        </c:if>
						
						        <c:if test="${classQ.inqueryStatus == 1}">
						          	<div class="btn-wrap" style="text-align: right;">
							            <form action="/myPage/myQuestion/inquery/modify" method="get" style="display:inline; text-align: right;">
							            	<input type="hidden" name="inqueryIdx" value="${classQ.inqueryIdx}">
							            	<button type="submit">수정</button>
							            </form>
							            <form action="/myPage/myQuestion/inquery/delete" method="post" style="display:inline; text-align: right;">
							              	<input type="hidden" name="inqueryIdx" value="${classQ.inqueryIdx}">
							              	<button type="submit" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
							            </form>
						          	</div>
						        </c:if>
					    	</td>
					    </tr>
				  	</c:forEach>
					<tr>
						<td colspan="6" align="center">
						<c:if test="${not empty classQPageInfo.maxPage or classQPageInfo.maxPage > 0}">
							<input type="button" value="이전" 
								onclick="location.href='/myPage/myQuestion?classQuestionPageNum=${classQPageInfo.pageNum - 1 }&inqueryPageNum=${inqueryPageInfo.pageNum}&classQOrderBy=${classQOrderBy }&classQOrderDir=${classQOrderDir }&inqueryOrderBy=${inqueryOrderBy }&inqueryOrderDir=${inqueryOrderDir }'" 
								<c:if test="${classQPageInfo.pageNum eq 1}">disabled</c:if>
							>
							
							<c:forEach var="i" begin="${classQPageInfo.startPage}" end="${classQPageInfo.endPage}">
								<c:choose>
									<c:when test="${i eq classQPageInfo.pageNum}">
										<strong>${i}</strong>
									</c:when>
									<c:otherwise>
										<a href="/myPage/myQuestion?classQuestionPageNum=${i}&inqueryPageNum=${inqueryPageInfo.pageNum}&classQOrderBy=${classQOrderBy }&classQOrderDir=${classQOrderDir }&inqueryOrderBy=${inqueryOrderBy }&inqueryOrderDir=${inqueryOrderDir }">${i}</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							
							<input type="button" value="다음" 
								onclick="location.href='/myPage/myQuestion?classQuestionPageNum=${classQPageInfo.pageNum + 1}&inqueryPageNum=${inqueryPageInfo.pageNum}&classQOrderBy=${classQOrderBy }&classQOrderDir=${classQOrderDir }&inqueryOrderBy=${inqueryOrderBy }&inqueryOrderDir=${inqueryOrderDir }'" 
								<c:if test="${classQPageInfo.pageNum eq classQPageInfo.maxPage}">disabled</c:if>
							>
						</c:if>
						</td>
					</tr>
			  	</tbody>
		  	</table>
		</div>
		<div>
			<h3>고객센터 문의</h3>
			<table id="inqueryTable" border="1" style="width: 100%; border-collapse: collapse;">
				<thead style="background-color: #f5f5f5;">
	   			<tr>
	      			<th>문의 번호</th>
				    <th>상태</th>
	      			<th class="sortable" data-column="inquery_datetime">
	      				문의 시간
      					<c:choose>
							<c:when test="${inqueryOrderBy eq 'inquery_datetime' }">
									<c:if test="${inqueryOrderDir eq 'desc' }">▼</c:if>
									<c:if test="${inqueryOrderDir eq 'asc' }">▲</c:if>
							</c:when>
							<c:otherwise>↕</c:otherwise>
						</c:choose>
	      			</th>
				    <th>이름</th>
				    <th>제목</th>
			    </tr>
			    </thead>
			  	<tbody>
				  	<c:forEach var="inquery" items="${inqueryDTOList}">
					    <tr class="inquery-toggle">
					    	<td>${inquery.inqueryIdx}</td>
					      	<td>
						        <c:choose>
						        	<c:when test="${inquery.inqueryStatus == 1}">답변 대기</c:when>
						          	<c:when test="${inquery.inqueryStatus == 2}">답변 완료</c:when>
						       	 	<c:when test="${inquery.inqueryStatus == 3}">검토중</c:when>
						        </c:choose>
					     	</td>
					    	<td><fmt:formatDate value="${inquery.inqueryDatetime }" pattern="MM-dd HH:mm"/></td>
					      	<td>${user.userName}</td>
					      	<td>${inquery.inqueryTitle}</td>
					    </tr>
					
					    <tr class="inquery-detail">
					      	<td colspan="5">
					      		<strong>답변 시간 : <fmt:formatDate value="${inquery.inqueryAnswerDatetime }" pattern="MM-dd HH:mm"/></strong><br><br>
						        <strong>문의 내용</strong><br>
						        	${inquery.inqueryDetail}<br><br>
						        <strong>답변 내용</strong><br>
						        <c:if test="${not empty inquery.inqueryAnswer}">
						        	  ${inquery.inqueryAnswer}
						        </c:if>
						        <c:if test="${empty inquery.inqueryAnswer}">
						         	 아직 답변이 등록되지 않았습니다.
						        </c:if>
						
						        <c:if test="${inquery.inqueryStatus == 1}">
						          	<div class="btn-wrap">
							            <form action="/myPage/myQuestion/inquery/modify" method="get" style="display:inline;">
							            	<input type="hidden" name="inqueryIdx" value="${inquery.inqueryIdx}">
							            	<button type="submit">수정</button>
							            </form>
							            <form action="/myPage/myQuestion/inquery/delete" method="post" style="display:inline;">
							              	<input type="hidden" name="inqueryIdx" value="${inquery.inqueryIdx}">
							              	<button type="submit" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
							            </form>
						          	</div>
						        </c:if>
					    	</td>
					    </tr>
				  	</c:forEach>
					<tr>
						<td colspan="6" align="center">
						<c:if test="${not empty inqueryPageInfo.maxPage or inqueryPageInfo.maxPage > 0}">
							<input type="button" value="이전" 
								onclick="location.href='/myPage/myQuestion?classQuestionPageNum=${classQuestionPageInfo.pageNum }&inqueryPageNum=${inqueryPageInfo.pageNum - 1}&classQOrderBy=${classQOrderBy }&classQOrderDir=${classQOrderDir }&inqueryOrderBy=${inqueryOrderBy }&inqueryOrderDir=${inqueryOrderDir }'" 
								<c:if test="${inqueryPageInfo.pageNum eq 1}">disabled</c:if>
							>
							
							<c:forEach var="i" begin="${inqueryPageInfo.startPage}" end="${inqueryPageInfo.endPage}">
								<c:choose>
									<c:when test="${i eq inqueryPageInfo.pageNum}">
										<strong>${i}</strong>
									</c:when>
									<c:otherwise>
										<a href="/myPage/myQuestion?classQuestionPageNum=${classQuestionPageInfo.pageNum}&inqueryPageNum=${i}&classQOrderBy=${classQOrderBy }&classQOrderDir=${classQOrderDir }&inqueryOrderBy=${inqueryOrderBy }&inqueryOrderDir=${inqueryOrderDir }">${i}</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							
							<input type="button" value="다음" 
								onclick="location.href='/myPage/myQuestion?classQuestionPageNum=${classQuestionPageInfo.pageNum}&inqueryPageNum=${inqueryPageInfo.pageNum + 1}&classQOrderBy=${classQOrderBy }&classQOrderDir=${classQOrderDir }&inqueryOrderBy=${inqueryOrderBy }&inqueryOrderDir=${inqueryOrderDir }'" 
								<c:if test="${inqueryPageInfo.pageNum eq inqueryPageInfo.maxPage}">disabled</c:if>
							>
						</c:if>
						</td>
					</tr>
			  	</tbody>
		  	</table>
		</div>
	
	</div>
	
	</main>
	
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
	<script>
		$(document).ready(function () {
			const initialClassQOrderBy = "${classQOrderBy}"; //강의문의렬 컬럼
			const initialClassQOrderDir = "${classQOrderDir}";// 정렬방법
			const initialInqueryOrderBy = "${inqueryOrderBy}"; // 고객센터문의정렬 컬럼
			const initialInqueryOrderDir = "${inqueryOrderDir}"; // 정렬방법
			// 강의문의 정렬
			$('#classQTable th.sortable').click(function () {
				// 클릭한 sortable 클래스를 가지고 있는 th태그의 data-column속성 값을 정렬기준으로 요청   
				const column = $(this).data('column');
				// 요청할 정렬방법
				let newOrderDir = 'desc';
				// 요청한 정렬기준이 기존의 정렬기준과 같고 기존의 정렬방법이 'desc'라면 요청방법은 'asc'이다
				if (initialClassQOrderBy === column && initialClassQOrderDir === 'desc') {
					newOrderDir = 'asc';	
				}
				
				const urlParams = new URLSearchParams(window.location.search);
				
				urlParams.set('classQOrderBy', column);
				urlParams.set('classQOrderDir', newOrderDir);
				// 결제 파라미터 세팅
				if (urlParams.has('inqueryOrderBy') === false) {
			      urlParams.set('inqueryOrderBy', initialInqueryOrderBy);
			    }
			    if (urlParams.has('inqueryOrderDir') === false) {
			      urlParams.set('inqueryOrderDir', initialInqueryOrderDir);
			    }
				// 파라미터 추가해서 페이지로 이동
				window.location.search = urlParams.toString();
			});
			
			// 고객센터문의 정렬
			$('#inqueryTable th.sortable').click(function () {
				// 클릭한 sortable 클래스를 가지고 있는 th태그의 data-column속성 값을 정렬기준으로 요청   
				const column = $(this).data('column');
				// 요청할 정렬방법
				let newOrderDir = 'desc';
				// 요청한 정렬기준이 기존의 정렬기준과 같고 기존의 정렬방법이 'desc'라면 요청방법은 'asc'이다
				if (initialInqueryOrderBy === column && initialInqueryOrderDir === 'desc') {
					newOrderDir = 'asc';	
				}
				
				const urlParams = new URLSearchParams(window.location.search);
				
				urlParams.set('inqueryOrderBy', column);
				urlParams.set('inqueryOrderDir', newOrderDir);
				// 결제 파라미터 세팅
				if (urlParams.has('classQOrderBy') === false) {
			      urlParams.set('classQOrderBy', initialClassQOrderBy);
			    }
			    if (urlParams.has('classQOrderDir') === false) {
			      urlParams.set('classQOrderDir', initialClassQOrderDir);
			    }
				// 파라미터 추가해서 페이지로 이동
				window.location.search = urlParams.toString();
			});
			
			
			
			
			// 문의창 토글
			$(".inquery-toggle").click(function () {
				const detailRow = $(this).next(".inquery-detail");
	
				$(".inquery-detail").not(detailRow).slideUp(0);
	
				if (!detailRow.is(":visible")) {
					detailRow.slideDown(100);
				} else {
					detailRow.slideUp(10);
				}
			});
			
			// 강의문의 정렬
			
		});
	</script>
</body>
</html>