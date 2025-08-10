<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>joinWay</title>
<link rel="preconnect" href="https://fonts.googleapis.com" >
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/join_way.css">
</head>
<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp" />
</header>
<body>
  <div class="join-type-select">
    <h2>회원가입 유형 선택</h2>
    <div class="join-type-buttons">
      <a href="${pageContext.request.contextPath}/user/join/form?from=general" class="btn-join">일반회원</a>
      <a href="${pageContext.request.contextPath}/user/join/form?from=company" class="btn-join">기업회원</a>
    </div>
  </div>
</body>
</html>