<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="${pageContext.request.contextPath}/resources/css/myPage.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style type="text/css">
	.slide_btn.active {
		background-color: #FF8C00; /* 선택된 버튼 색상 */
		color: white;
	}
</style>

<div id="side" >
		<div class="title-fixed" id="userProfileHeader">
			<h1 ><a href="/myPage/main">${sessionScope.sId}'s page</a></h1>
		</div>
	<input type="button" value="정보변경" class="slide_btn" onclick="location.href='/myPage/change_user_info'"><br>
<!-- 	<input type="button" value="즐겨찾기" class="slide_btn" onclick="location.href='/myPage/favoriteClass'"><br> -->
	<input type="button" value="예약/결제" class="slide_btn" onclick="location.href='/myPage/payment_info'"><br>
	<input type="button" value="나의문의" class="slide_btn" onclick="location.href='/myPage/myQuestion'"><br>
	<input type="button" value="나의리뷰" class="slide_btn" onclick="location.href='/myPage/myReview'"><br>
	<input type="button" value="나의알림" class="slide_btn" onclick="location.href='/myPage/notification'"><br>
	<input type="button" value="회원탈퇴" class="slide_btn" onclick="location.href='/myPage/withdraw'"><br>
</div>


<script type="text/javascript">
	document.addEventListener("DOMContentLoaded", function() {
		fetch("/myPage/profileImg")
		.then(res => res.json())
		.then(data => {
			const header = document.getElementById('userProfileHeader');
			const link = document.createElement('a');
			link.href = '/myPage/main';
			const img = document.createElement('img');
			img.src = data.src;
	        img.alt = '프로필 이미지';
	        img.style.width = '100px';
	        img.style.height = '80px';
	        img.style.borderRadius = '50%';
	        img.style.marginRight = '10px';
	        img.style.verticalAlign = 'middle';
	        
	        link.appendChild(img);
	        
	        header.appendChild(link);
			
		}).catch(err => console.log("프로필이미지를 불러올 수 없습니다."));
		
		const buttons = document.querySelectorAll('.slide_btn');
		
		// 현재 페이지 URL 경로나 파라미터로 현재 위치 판단
		const currentPath = window.location.pathname;
		buttons.forEach(button => {
			const url = new URL(button.getAttribute('onclick').match(/'(.*?)'/)[1], window.location.origin);
			
			if (currentPath.includes(url.pathname)) {
			    button.classList.add('active');
		    }
			
			button.addEventListener('click', function() {
				// 모든 버튼에서 active 클래스 제거
				buttons.forEach(btn => btn.classList.remove('active'));
				// 클릭된 버튼에만 active 클래스 추가
				this.classList.add('active');
			});
		});
		
	});
</script>
