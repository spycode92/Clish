<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 기업 회원 탈퇴</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home/top.css">
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
  <style>
  	#footer-area {
      margin-top: 0 !important;
    }
  
    .main-container {
      display: flex;
      width: 100%;
      min-height: 600px;
      padding-right: 220px;
    }

    .sidebar {
      width: 200px;
      background-color: #f8f8f8;
      padding: 20px;
    }

    .content-area {
      flex: 1;
      padding: 40px;
      background-color: #ffffff;
    }

    .withdraw-form {
      max-width: 500px;
      margin-top: 30px;
    }

    .withdraw-form h3 {
      font-size: 20px;
      margin-bottom: 15px;
    }

    .withdraw-form input[type="password"] {
      width: 100%;
      padding: 10px;
      font-size: 14px;
      border: 1px solid #ccc;
      border-radius: 4px;
      margin-bottom: 20px;
    }

    .withdraw-form input[type="submit"] {
      background-color: #e74c3c;
      color: white;
      padding: 10px 25px;
      font-size: 15px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }

    .withdraw-form input[type="submit"]:hover {
      background-color: #c0392b;
    }
    
    .form {
    	width: 800px;
    }
  </style>
</head>
<body>

	<!-- 공통 헤더 -->
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp" />
	</header>
	
	<div class="main-container">
    <!-- 사이드바 -->
    <div class="sidebar">
		<jsp:include page="/WEB-INF/views/company/comSidebar.jsp" />
    </div>
	
	<!-- 본문 -->
    <div class="content-area">
		<div class="class-header">
			<h1>${sessionScope.sId} 비밀번호 확인</h1>
		</div>
	
		<form action="${pageContext.request.contextPath}/company/myPage/withdraw" method="post" class="form">
			  <h3>비밀번호를 입력해주세요</h3>
			  <input type="password" placeholder="비밀번호" name="userPassword" required>
			  <input type="submit" value="확인">
		</form>
	</div>
</div>

	<!-- 공통 푸터 -->
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp" />
	</footer>

</body>
</html>