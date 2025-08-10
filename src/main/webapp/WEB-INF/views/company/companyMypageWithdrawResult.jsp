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

	/* 왼쪽 사이드바 */
	.sidebar {
	    width: 200px; /* 필요에 따라 조절 */
	    background-color: #f8f8f8;
	    padding: 20px;
	    overflow: hidden;          /* ✅ 내부 넘치는 거 잘라냄 */
	   	white-space: nowrap;
	}

	html, body {
		height: 100%;
		margin: 0;
	}
	
	main {
		flex: 1;
		display: flex;
	}
	
	/* ?사이드바 포함하는 flex 구조 */
	.withdraw-container {
		display: flex;
		width: 100%;
		min-height: calc(100vh - 120px); /* 헤더+푸터 높이 제외한 전체 높이 */
	}
	
	.sidebar {
		width: 220px;
		background-color: #f9f9f9;
	}
	
	/* 본문을 수직 수평 중앙 정렬 */
	.main-content {
		flex: 1;
		display: flex;
		justify-content: center;
		align-items: center;
		padding: 30px;
	}
	
	.withdraw-box {
		width: 100%;
		max-width: 600px;
		padding: 30px;
		border: 1px solid #ddd;
		border-radius: 10px;
		background-color: #fff;
		text-align: center;
	}
	
	.withdraw-box h2 {
		font-size: 24px;
		margin-bottom: 20px;
	}
	
	.withdraw-box p {
		font-size: 16px;
		margin-bottom: 20px;
	}
	
	.withdraw-box label {
		font-size: 15px;
	}
	
	.withdraw-box input[type="submit"] {
		margin-top: 20px;
		padding: 10px 25px;
		font-size: 16px;
		background-color: #e74c3c;
		color: #fff;
		border: none;
		border-radius: 5px;
		cursor: pointer;
	}
	
	.withdraw-box input[type="submit"]:hover {
		background-color: #c0392b;
	}
</style>
</head>
<body>

	<!-- 공통 헤더 -->
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp" />
	</header>

	<main>
		<div class="withdraw-container">
			
			<!-- 사이드바 -->
			<div class="sidebar">
				<jsp:include page="/WEB-INF/views/company/comSidebar.jsp" />
	      	</div>
	      	
	      	<!-- 본문 영역 -->
	      	<div class="main-content">
        		<div class="withdraw-box">

					<c:choose>
						<%-- 비밀번호 확인 후 탈퇴 안내 페이지 --%>
						<c:when test="${step eq 'confirm'}">
							<h2>정말 탈퇴하시겠습니까?</h2>
							<p>탈퇴 시 모든 정보가 삭제되며 복구가 불가능합니다.<br> 탈퇴를 원하신다면 아래에 동의 후 버튼을 눌러주세요.</p>
			
							<form action="${pageContext.request.contextPath}/company/myPage/withdrawFinal" method="post" onsubmit="return confirmWithdraw();">
								<label>
									<input type="checkbox" required> 위 내용을 모두 확인하였습니다.
								</label><br><br>
								<input type="submit" value="탈퇴하기">
							</form>
			
							<script>
							function confirmWithdraw() {
							  return confirm("정말 탈퇴하시겠습니까?");
							}
							</script>
						</c:when>
						
						<%-- 탈퇴 완료 또는 실패 시 --%>
						<c:otherwise>
							<script>
								alert("${msg}");
								location.href = "${pageContext.request.contextPath}${targetUrl}";
							</script>
						</c:otherwise>
					</c:choose>	
				</div>
			</div>
		</div>
	</main>
	
	<!-- 공통 푸터 -->
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp" />
	</footer>
	
</body>
</html>