<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 기업 정보 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
	<style type="text/css">
		html, body {
		    height: 100%;
		    margin: 0;
		}
		
		#footer-area {
	      margin-top: 0 !important;
	    }
		
		.main-container {
		    display: flex;
		    width: 100%;
		    height: calc(100vh - 120px); /* header/footer 높이에 맞게 조절 */
		    box-sizing: border-box;
		}
		
		.sidebar {
		    width: 220px;
		    background-color: #f5f5f5;
		    padding: 30px 20px;
		    box-sizing: border-box;
		    height: 100%; /* 부모인 main-container에 맞춤 */
		    border-right: 1px solid #ddd;
		    overflow: hidden;
		    white-space: nowrap;
		}
		
		.content-area {
		    flex: 1;
		    padding: 80px;
		    background-color: #ffffff;
		    margin-right: 220px;
		}
		
		.form {
			width: 800px;
		}
	</style>
</head>
<body>

    <!-- 공통 헤더 -->
    <header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	
	<!-- ✅ 메인 콘텐츠 전체를 감싸는 큰 flex 박스 -->
    <div class="main-container">
    	 <!-- 왼쪽 사이드바 -->
        <div class="sidebar">
            <jsp:include page="/WEB-INF/views/company/comSidebar.jsp" />
        </div>
        
	<!-- 오른쪽 본문 영역 -->
	<div class="content-area">
		<div class="class-header">
			<h1>${sessionScope.sId} 비밀번호 확인</h1>
		</div>
		
		<form action="${pageContext.request.contextPath}/company/myPage/companyInfo" method="post" class="form">
		    <h3>비밀번호를 입력하세요</h3><br>
		    <input type="password" name="userPassword" placeholder="pw" required>
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