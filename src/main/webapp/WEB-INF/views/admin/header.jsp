<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.contextPath}/resources/css/admin/admin.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/resources/js/home.js"></script>
</head>
<body>
	<div class="navbar-expand">
		<h4 class="pageSubject">CLISH 관리자 대시보드</h4>
		<div class="admin-menu">
		    <span class="admin-name" onclick="toggleDropdown()">${sId}님</span>
		    <div class="dropdown-menu" id="dropdownMenu">
		        <a href="/" class="dropdown-item">홈으로</a>
		        <a href="javascript:void(0)" class="dropdown-item" onclick="logout()">로그아웃</a>
		    </div>
		</div>
	</div>
	<script type="text/javascript">
	function toggleDropdown() {
	    const menu = document.getElementById("dropdownMenu");
	    menu.style.display = (menu.style.display === "block") ? "none" : "block";
	}

	// 화면 클릭 시 드롭다운 닫기
	window.onclick = function(event) {
	    if (!event.target.matches('.admin-name')) {
	        const menu = document.getElementById("dropdownMenu");
	        if (menu.style.display === "block") {
	            menu.style.display = "none";
	        }
	    }
	}
	</script>
</body>
</html>