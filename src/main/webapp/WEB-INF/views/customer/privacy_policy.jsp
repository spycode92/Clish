<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="preconnect" href="https://fonts.googleapis.com" >
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<style type="text/css">
	h1 {
		font-size: 48px;
	}
	#privacy-body {
		width: 1200px;
		margin: 100px auto;
		padding: 100px;
	}
	#privacy-body > h2 {
		margin: 30px 0;
	}
	#privacy-body > p {
/* 		text-indent: 2em; */
		line-height: 1.5em;
		font-size: large;
	}
	#privacy-body > ul > li {
		list-style: square;
	}
	p:first-child {
		text-align: right;
	}
	p:last-child {
	text-indent: none;
}
</style>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	</header>
		<section id="privacy-body">
		 <h1>개인정보 처리방침</h1>
	    <p><strong>최종 수정일:</strong> 2025년 8월 4일</p>
	
	    <h2>1. 수집하는 개인정보 항목</h2>
	    <ul>
	        <li>이름, 연락처, 이메일 주소</li>
	        <li>수강 신청 내역 및 결제 정보</li>
	        <li>IP 주소, 브라우저 정보 등 이용자 접속 정보</li>
	    </ul>
	
	    <h2>2. 개인정보 수집 및 이용 목적</h2>
	    <ul>
	        <li>수업 등록 및 결제 처리를 위한 정보 확인</li>
	        <li>고객 상담 및 서비스 개선</li>
	        <li>공지사항 전달 및 마케팅 활용 (동의한 경우)</li>
	    </ul>
	
	    <h2>3. 개인정보 보유 및 이용 기간</h2>
	    <p>이용자가 회원 탈퇴를 하거나 개인정보 삭제를 요청할 경우, 관련 법령에 따라 보관 기간 이후 안전하게 파기됩니다.</p>
	
	    <h2>4. 개인정보 제3자 제공</h2>
	    <p>당사는 이용자의 동의 없이 개인정보를 제3자에게 제공하지 않으며, 아래의 경우에만 예외로 제공될 수 있습니다:</p>
	    <ul>
	        <li>법령에 의한 요청이 있는 경우</li>
	        <li>서비스 제공에 필요한 최소한의 범위 내에서 제휴 업체와 공유 시 (사전 동의)</li>
	    </ul>
	
	    <h2>5. 개인정보 처리 위탁</h2>
	    <p>당사는 서비스 운영을 위해 일부 업무를 외부 업체에 위탁할 수 있으며, 이 경우 개인정보 보호를 위한 계약을 체결합니다.</p>
	
	    <h2>6. 이용자 권리와 행사 방법</h2>
	    <ul>
	        <li>개인정보 열람, 수정, 삭제 요청 가능</li>
	        <li>처리정지 및 동의 철회 요청 가능</li>
	    </ul>
	    <p>요청은 이메일 또는 고객센터를 통해 접수 가능합니다.</p>
	
	    <h2>7. 쿠키(Cookie)의 운영</h2>
	    <p>웹사이트는 사용자 편의 향상을 위해 쿠키를 사용할 수 있습니다. 이용자는 브라우저 설정을 통해 쿠키 저장을 거부하거나 삭제할 수 있습니다.</p>
	
	    <h2>8. 개인정보 보호 책임자</h2>
	    <ul>
	        <li>성명: 홍길동</li>
	        <li>직책: 개인정보 보호 책임자</li>
	        <li>이메일: info@clish.com</li>
	        <li>전화번호: 1588-1234</li>
	    </ul>
	
	    <h2>9. 정책 변경 안내</h2>
	    <p>본 개인정보 처리방침은 관련 법령 및 서비스 정책에 따라 변경될 수 있으며, 변경 시 웹사이트를 통해 공지합니다.</p>
	</section>
	</section>
		<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include> 
	</footer>
</body>
</html>