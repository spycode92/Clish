<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 이용약관</title>
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
	#terms-body {
		width: 1200px;
		margin: 100px auto;
		padding: 100px;
	}
	#terms-body > h2 {
		margin: 30px 0;
	}
	#terms-body > p {
		text-indent: 2em; 
		line-height: 1.5em;
		font-size: large;
	}
	#terms-body > ul > li {
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
	<section id="terms-body">
	<h1>이용약관</h1>
	
	<p>


	최종 수정일: 2025년 8월 4일
	</p>
	<h2>1. 개요</h2>
		<p>이 이용약관은 Clish("당사")가 운영하는 온라인 및 오프라인 수업 등록 플랫폼(이하 "서비스")을 이용하는 모든 사용자에게 적용됩니다. 서비스를 이용함으로써 본 약관에 동의한 것으로 간주됩니다.
		</p>
	<h2>2. 서비스 제공 내용</h2>
		<ul>
			<li>온라인 및 오프라인 수업 등록, 결제 및 관리 기능</li>
			<li>강의 일정, 강사 정보, 수강료 안내</li>
			<li>사용자 맞춤형 수업 추천 및 알림 기능</li>
		</ul>
		<h2>3. 회원가입 및 계정 관리</h2>
		<ul>
			<li>회원은 반드시 본인의 정보를 정확하게 제공해야 합니다.</li>
			<li>계정 정보의 보안 유지 책임은 회원에게 있습니다.</li>
			<li>당사는 부정확하거나 허위 정보로 인한 손해에 대해 책임지지 않습니다.</li>
		</ul>
		<h2>4. 수강 등록 및 취소</h2>
			<ul>
				<li>수강 등록은 정해진 기간 내에 가능하며, 수강료는 온라인 결제 시스템을 통해 지불합니다.</li>
				<li>수강 취소 및 환불 정책은 각 수업의 안내사항에 따릅니다.</li>
				<li>수업 일정은 강사 및 장소 사정에 따라 변경될 수 있으며, 사전에 공지됩니다.</li>
			</ul> 
		<h2>5. 사용자 의무</h2>
			<ul>
				<li> 타인의 권리를 침해하거나 불쾌감을 주는 행위를 금지합니다.</li>
				<li> 서비스 운영을 방해하는 행위는 제재 대상이 됩니다.</li>
			</ul>
		<h2> 6. 저작권 및 지적재산권</h2>
			<ul>
				<li>서비스 내 제공되는 모든 콘텐츠의 저작권은 당사 또는 해당 저작권자에게 있습니다.</li>
				<li>무단 복제, 배포, 2차적 저작물 제작은 금지됩니다.</li>
		</ul>
		<h2> 7. 책임 제한</h2>
		<ul>
			<li>당사는 서비스 이용 중 발생할 수 있는 개인 간의 분쟁이나 손해에 대해 책임지지 않습니다.</li>
			<li> 서비스 장애 시 신속한 복구를 위해 최선을 다하나, 불가피한 사유에 의한 손해에 대해서는 책임을 제한합니다.</li>
		</ul> 
		<h2> 8. 약관 변경</h2>
			<ul>
				<li>본 약관은 필요에 따라 변경될 수 있으며, 변경 시 사전 공지합니다.</li>
				<li>변경된 약관은 공지 이후 즉시 효력을 갖습니다.</li>
			</ul>
		<h2>9. 문의</h2>
		<p>
		서비스 관련 문의사항은 아래 이메일 또는 고객센터를 통해 연락해주세요.  <br>
		📧 이메일: privacy@clish.com <br> 
		📞 고객센터: 1234-5678
		</p>
	</section>
		<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include> 
	</footer>
</body>
</html>