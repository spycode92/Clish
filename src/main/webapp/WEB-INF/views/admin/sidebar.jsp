<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/admin/admin.css" rel="stylesheet" type="text/css">
</head>
<body>
	<nav class="navbar">
	   <a  href="/"><img id="logo" alt="logo" src="${pageContext.request.contextPath}/resources/images/logo4-2.png"></a>
	   <ul>
	   	   <li class="admin-main">
	   	   		<a href="/admin/main">MAIN</a>
	   	    </li>
	       <li>
	       		<span><a href="/admin/classList" style="color: black;">강의 관리</a></span>
	       		<ul>
	       			<li>
	       				<a href="/admin/category">카테고리 편집</a>
	       				<a href="/admin/classList">강의 목록</a>
	       			</li>
	       		</ul>
	       	</li>
	     	<li>
	           <span><a href="/admin/user" style="color: black;">회원 관리</a></span>
	           <ul>
	             <li>
	               <a href="/admin/user">일반 회원 목록</a>
	               <a href="/admin/company">기업 회원 목록</a>
	             </li>
	           </ul>
			</li>
			<li>
				<span><a href="/admin/paymentList" style="color: black;">결제 관리</a></span>
				<ul>
					<li>
						<a href="/admin/paymentList">결제 목록</a>
					</li>
				</ul>
			</li>
			<li>
				<span>고객센터 관리</span>
				<ul>
					<li>
						<a href="/admin/notice">공지사항 관리</a>
					</li>
					<li>
						<a href="/admin/inquiry">문의 관리</a>
					</li>
					<li>
						<a href="/admin/faq">FAQ 관리</a>
					</li>
				</ul>
			</li>
			<li>
				<span>이벤트 관리</span>
				<ul>
					<li>
						<a href="/admin/event">이벤트 관리</a>
					</li>
				</ul>
			</li>
	   </ul>
	</nav>
</body>
</html>