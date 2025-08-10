<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 이벤트</title>
<link rel="preconnect" href="https://fonts.googleapis.com" >
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
<!-- 강의 사이드바 css 활용 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/sidebar.css">
<style type="text/css">
 	#detail { 
		padding: 20px;
		width: 500px;
		height: 60px;
 	} 
	.event-table {
	width: 1400px;
	margin: 200px auto;
	text-align: center;
	}
	main.main {
	padding: none;
	max-width: 80%;
	}
	#main {
		margin: 0 auto;
	
	}
</style>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	</header>
<!-- 	only one link so removed for now -->
<!-- 	<nav> -->
<%-- 		<jsp:include page="/WEB-INF/views/event/sidebar.jsp" /> --%>
<!-- 	</nav> -->
	<main id="main" class="main">
	<div class="main">
		<div class="main-content">
			
			<table class="table event-table">
				<thead>
					<tr>
						<th colspan="6"><h2>현재 가의 이벤트</h2></th>
					</tr>
					<tr>
						<th>썸네일</th>
						<th>제목</th>
						<th rowspan="2">이벤트 설명</th>
						<th>일자</th>
						<th>진행 상태</th>
						
					</tr>
				</thead>
				<tbody>
					
					<c:forEach var="i" begin="0" end="${eventSize -1}">
					
							<tr>
								<td>
									<c:choose>
									    <c:when test="${empty fileDTO.get(i).fileId}">
											<a href="/event/event_detail/${eventList.get(i).eventIdx}">
												<img src="/resources/images/logo4-2.png" alt="썸네일" style="width: 100px; height: auto;">
											</a>
									    </c:when>
									    <c:otherwise>
											<a href="/event/event_detail/${eventList.get(i).eventIdx}">
<%-- 											<a href="/event/event_detail/${eventList.get(i).thumbnailFile}"> --%>
<%-- 												<img src="/file/${fileDTO.get(i).fileId}?type=0" alt="썸네일" style="width: 100px; height: auto;"> --%>
												<img src="/file/${fileDTO.get(i).fileId}?type=2" alt="썸네일" style="width: 100px; height: auto;">
											</a>
									    </c:otherwise>
									</c:choose>
								</td>
								<td>
									<a href="/event/event_detail/${eventList.get(i).eventIdx}">${eventList.get(i).eventTitle}</a>
								</td>
								<td id="detail"><a href="/event/event_detail/${eventList.get(i).eventIdx}">${eventList.get(i).eventDescription}</a></td>
								<td>${eventList.get(i).eventStartDate} ~ ${eventList.get(i).eventEndDate}</td>
								<td>
									<c:choose>
										<c:when test="${eventList.get(i).eventInProgress == 1}">
											진행중  
										</c:when>
										<c:otherwise>
											예정 
										</c:otherwise>
									</c:choose>
								</td>
		
							</tr>
					</c:forEach>
					
				</tbody>
			</table>
		</div>
	</div>
	
	</main>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>