<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - ${sessionScope.sId}의 마이페이지</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<style>
	  /* ✅ 왼쪽 사이드바 */
	  .sidebar {
	    width: 200px;
	    background-color: #f8f8f8;
	    padding: 30px 20px;
	    overflow: hidden;
	    white-space: nowrap;
	    box-sizing: border-box;
	  }
	  
	.mypage-container {
	    display: flex;
	    width: 100%;
	    height: 100vh;
	  }
	
	.content-area {
	    flex: 1;
	    padding: 30px;
	    display: flex;
	    justify-content: center;
	    align-items: flex-start;  /* ← 글자를 위쪽 가운데 정렬 */
	  }
</style>
</head>
<body>
	<header>
	    <jsp:include page="/WEB-INF/views/inc/top.jsp" />
	</header>
	
	<div class="mypage-container">
	
		<%-- 🔽 사이드바 포함시키는 부분 --%>
	   <jsp:include page="/WEB-INF/views/company/comSidebar.jsp"></jsp:include>
	
	    <%-- 🔽 본문 내용 영역 --%>
	    <div class="content-area">
	        <h1>${sessionScope.sId}의 마이페이지</h1>
	    </div>
	</div>
	
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp" />
	</footer>
</body>
</html>








