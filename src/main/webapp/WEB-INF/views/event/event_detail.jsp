<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home/main.css" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/sidebar.css">
<title>${eventDTO.eventTitle}</title>
<style>
	h3 {
	padding: 30px 0;
	}
	#event-details {
		width: 1200px;
 		max-width: 80%; 
		margin: 300px auto 0;
		padding: 25px;
	}
	#flex-container1 {
	display: flex;
	justify-content: space-between;
	}
	#flex-container2 {
	display: flex;
	justify-content: space-around;
	}
	.flex-item {
	display: inline-block;
	margin-right: 15px;
	}
	#title {
		font-weight: 300;
		font-size: 1.2rem;
	}
	.img {
		width: 700px;
		height: 1000px;
		
	}
	button {
		margin: 100px auto 300px;
		font-size: 1.2rem;
		
	}
	#description {
		margin: 30px 150px;
		padding: 20px;
		text-align: left;
		text-indent: 2em;
		background-color: #d9d9d9;
		border-radius: 30px;
	}
</style>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	</header>
	<!-- 	only one link so removed for now -->
	
<!-- 	<nav> -->
<%-- 		<jsp:include page="/WEB-INF/views/event/sidebar.jsp" /> --%>
<!-- 	</nav> -->
	<main>
	
		<section id="event-details">
			<hr>
			<div id="flex-container1">
				<div class="flex-item"><h3 class="flex-item">날짜:</h3> <p class="flex-item"> ${eventDTO.eventStartDate} ~ ${eventDTO.eventEndDate}</p></div><div><h3 class="flex-item">작상자명:</h3>  <p class="flex-item">admin</p></div>
			</div>
			<hr>
			<h3>제목: <span id="title">${eventDTO.eventTitle}</span></h3>
			<div id="flex-container2">
				<c:choose>	
				    <c:when test="${empty eventBanner.fileId}">
				        <img class="img" src="${pageContext.request.contextPath}/resources/images/logo4-2.png" alt="${eventDTO.eventTitle}" >
				    </c:when>
				    <c:otherwise>
				        <img class="img" src="/file/${eventBanner.fileId}?type=0" alt="${eventDTO.eventTitle}" >

				    </c:otherwise>
				</c:choose>
			</div> 
			<p id="description">${eventDTO.eventDescription}</p>
		</section>
		<button onclick="location.href='/event/eventHome'">목록</button>
	</main>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include> 
	</footer>
</body>
</html>