<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Clish - 정보변경</title>
	<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
	
	
	<style type="text/css">
	.pw-check-form {
	  width: 320px;               /* 적당한 고정 너비 */
	  margin: 60px auto 0 80px;   /* 위쪽:60px, 좌:80px(사이드바와 띄우기), 가운데정렬(auto) */
	  padding: 32px 28px;
	  box-shadow: 0 2px 10px #eee;
	  border-radius: 14px;
	  background: #fff;
	  text-align: center;
	}
	
	/* input password 너비 넓히기 */
	.pw-check-form input[type="password"] {
	  width: 90%;
	  font-size: 1.1em;
	  padding: 10px 12px;
	  margin-bottom: 24px;
	  margin-top: 12px;
	  border-radius: 10px;
	  border: 1px solid #ccc;
	}
	
	/* 버튼 우측정렬용 래퍼 */
	.pw-btn-wrap {
	  width: 100%;
	  display: flex;
	  justify-content: flex-end;
	}
	
	.pw-btn-wrap input[type="submit"] {
	  width: 90px;
	  padding: 8px 0;
	  border-radius: 10px;
	  background: #FF7601;
	  color: #fff;
	  border: none;
	  font-weight: bold;
	  cursor: pointer;
	}
	.pw-btn-wrap input[type="submit"]:hover {
	  background: #FF8C00;
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
		<form action="/myPage/change_user_info_form" method="post" class="form pw-check-form">
			<h3>비밀번호를 입력하세요</h3><br>
			<input type="password" placeholder="pw" name="userPassword">
			<div class="pw-btn-wrap">
				<input type="submit" value="확인">	
			</div>		
		</form>
	
	</div>
	
	</main>
	
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>
