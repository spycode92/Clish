<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기업 사이드바</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css">
<style>
    .sidebar {
    width: 220px;
    background-color: #f5f5f5;
    padding: 13px;
	}
	
	.sidebar h2 {
        font-size: 20px;
        font-weight: bold;
    }

/* 기본 메뉴 (기업 정보 수정 ~ 회원 탈퇴) */
	.sidebar h3 a {
	    display: block;
	    margin: 15px 0; /* ✅ 간격 통일 */
	    color: #333;
	    text-decoration: none;
	    font-size: 16px; /* ✅ 폰트 크기 통일 */
	    font-weight: normal;
	}
	
	.sidebar h3 a:hover {
	    text-decoration: underline;
	}
	
	/* ✅ 클래스 관리 드롭다운용 스타일 */
	.dropdown {
	    position: relative;
	    margin: 15px 0; /* ✅ 다른 항목과 간격 맞춤 */
	}
	
	.dropdown-toggle {
	    display: block;
	    color: #333;
	    font-size: 16px; /* ✅ 다른 메뉴와 동일하게 */
	    font-weight: normal;
	    cursor: pointer;
	    padding: 0;
	}
	
	/* 드롭다운 하위 항목 */
	.submenu {
	    display: none;
	    margin-left: 15px;
	}
	
	.dropdown:hover .submenu {
	    display: block;
	}
	
	.submenu p {
	    margin: 5px 0;
	}
	
	.submenu a {
	    color: #333;
	    text-decoration: none;
	    font-size: 14px;
	}
	
	.submenu a:hover {
	    text-decoration: underline;
	}
</style>

<!-- ✅ 드롭다운 열고 닫는 토글 기능 -->
<script>
    function toggleDropdown() {
        const submenu = document.getElementById("classSubmenu");
        submenu.style.display = (submenu.style.display === "none") ? "block" : "none";
    }
</script>

</head>
<body>
	<div class="sidebar">
	    <!-- 왼쪽 사이드 메뉴 -->
	    <div class="sidebar">
	        <h2><a href="${pageContext.request.contextPath}/company/myPage"><b>${sessionScope.sId} 마이페이지</b></a></h2>
	        <h3><a href="${pageContext.request.contextPath}/company/myPage/companyCheckPw"><b>기업 정보 수정</b></a></h3>
	        <!-- ✅ 클래스 관리 드롭다운 메뉴 (수정 및 추가한 부분) -->
             <div class="dropdown">
			    <div class="dropdown-toggle"><b>강의 관리 ▼</b></div>
			    <div class="submenu">
			        <p><a href="${pageContext.request.contextPath}/company/myPage/classManage"><b>강의 목록</b></a></p>
			        <p><a href="${pageContext.request.contextPath}/company/myPage/classInquiry"><b>강의 문의</b></a></p>
			    </div>
			</div>
	        <h3><a href="${pageContext.request.contextPath}/company/myPage/myQuestion"><b>나의 문의</b></a></h3>
	        <h3><a href="${pageContext.request.contextPath}/company/myPage/notification"><b>나의 알림</b></a></h3>
	        <h3><a href="${pageContext.request.contextPath}/company/myPage/withdraw"><b>회원 탈퇴</b></a></h3>
	    </div>
	
	</div>

</body>
</html>