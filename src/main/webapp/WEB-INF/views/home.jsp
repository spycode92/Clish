<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
	<title>Home</title>
	<link rel="preconnect" href="https://fonts.googleapis.com" >
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/home.js"></script>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<c:choose>
	<c:when test="${empty sessionScope.sId || sessionScope.sId == '' }">
		<form action="/member/login" method="post">
			<input type="text" placeholder="아이디입력" name="userId">
			<input type="text" placeholder="비밀번호입력" name="userPassword">
			<input type="submit" value="로그인" >
		</form>
	</c:when>
	<c:otherwise>
	<a href="/myPage/main">${sessionScope.sId}</a>
</c:otherwise>
</c:choose>
</body>
</html>
