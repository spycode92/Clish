<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 폼</title>
<link rel="preconnect" href="https://fonts.googleapis.com" >
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
<style type="text/css">
	#login-form {
		width: 50%;
		margin: 200px auto 0;
		align-content: center;
	}
	
	#login-form > form {
		border: none;
	}
	
	#login-form > input[type="submit"] {
		margin: 10 auto;
	}
	
	#login-form .remember-area {
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    width: 100%;
	    margin-bottom: 14px;
	    gap: 5px;
	}
	
	#login-form .login-btn-area {
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    width: 100%;
	    margin-bottom: 14px;
	    gap: 5px;
	}
	
	#login-form .info-links {
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    width: 100%;
	    margin-top: 10px;
	    margin-bottom: 10px;
	    gap: 8px; 
	}
	
	#login-form .info-links a {
   		color: #222 !important;
	}
	
	#login-form .info-links a:visited {
	    color: #222 !important;
	}
	
	#login-form .captcha-area {
	    display: flex;
	    flex-direction: column;
	    margin-top: 10px;
    	padding: 8px 12px;
   		gap: 4px;
	    justify-content: center;
	    align-items: center;
	    width: 100%;
	    margin-top: 10px;
	    gap: 8px;
	}
	
</style>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp" />
	</header>
	<main>
		<section id="login-form">
			<h1>로그인</h1>
			<c:if test="${not empty errorMsg}">
			    <script>
			        alert("${errorMsg}");
			    </script>
			</c:if>
			<form action="${pageContext.request.contextPath}/user/login" method="post">
				<input type="text" name="userId" value = "${cookie.rememberId.value }" placeholder="아이디"><br>
				<input type="password" name="userPassword" placeholder="패스워드"><br>
				<div class="remember-area">
				    <input type="checkbox" name="rememberId" <c:if test="${not empty cookie.rememberId}">checked</c:if>>
				    <label for="rememberId">아이디 기억하기</label>
				</div>
				<div class="login-btn-area">
				    <input type="submit" value="로그인">
				</div>
				<c:if test="${sessionScope.loginFailCount >= 3}">
					<div class="captcha-area" style="margin-top: 24px; padding: 12px; border: 1px solid #ddd; border-radius: 8px; background: #f9f9f9;">
						<div class="captcha-image">
						    <label for="captcha">자동입력방지</label><br>
						    <img src="${pageContext.request.contextPath}/user/captcha" id="captchaImg" alt="CAPTCHA 이미지"
						         onclick="this.src='${pageContext.request.contextPath}/user/captcha?'+Math.random();" />
						</div>
					    <input type="text" id="captcha" name="captcha" placeholder="위의 문자 입력(이미지 클릭시 새로고침)" required style="width:250px;">
					</div>
				</c:if>
			</form>
			<div class="info-links" >
			    <a href="#" id="findIdLink">아이디 찾기</a>
			    <span class="divider">|</span>
			    <a href="#" id="findPwLink">비밀번호 찾기</a>
			    <span class="divider">|</span>
			    <a href="${pageContext.request.contextPath}/user/join" id="joinLink">회원가입</a>
			</div>
		</section>
	</main>
</body>

<script>
	// 아이디 찾기 이벤트
	document.getElementById("findIdLink").addEventListener("click", function(e) {
	    e.preventDefault();
	    window.open(
	        '/user/findLoginIdForm',
	        'findIdPopup',
	        'width=600,height=500,scrollbars=no,resizable=no'
	    );
	});
	
	// 패스워드 찾기 이벤트
	document.getElementById("findPwLink").addEventListener("click", function(e) {
	    e.preventDefault();
	    window.open(
	        '/user/findPasswdForm',
	        'findIdPopup',
	        'width=600,height=500,scrollbars=no,resizable=no'
	    );
	});
</script>

</html>




















