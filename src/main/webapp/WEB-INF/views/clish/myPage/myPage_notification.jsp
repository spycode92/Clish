<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Clish - 나의알림</title>
	<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
	<style type="text/css">
		.notiTr {
			cursor: pointer;
		}
		.pageSection {
			text-align: center;
			border: none;
		}
		.notiHeader {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin: 0px 0px 0px 30px;
			width: 95%;
		/* 필요하면 width:100% 지정도 가능 */
		}
		#allRead {
			padding: 6px 14px;
			border-radius: 5px;
			background: #ff9696cf;
			color: #252323;
			border: none;
			cursor: pointer;
			font-weight: bold;
			font-size: 15px;
			box-shadow: 0 2px 8px rgba(0,0,0,0.06);
			transition: background 0.2s;
		}
		#allRead:hover {
			background: #1d4fbb;
		}
		
		#notificationTable {
			width: 1200px;          /* 테이블 전체 너비 */
			table-layout: fixed;    /* 고정 너비 레이아웃 */
		}

		#notificationTable {
			width: 1200px;
			table-layout: fixed;
		}

		#notificationTable th:first-child,
		#notificationTable td:first-child {
			width: 1000px;
			white-space: normal;           /* 줄바꿈 허용 */
			word-break: break-word;        /* 긴 단어 줄바꿈 */
			overflow-wrap: break-word;     /* 추가 줄바꿈 허용 */
			/* 아래 속성으로 내용이 셀 영역 넘는 걸 방지 */
			overflow: hidden;
		}

		#notificationTable th:last-child,
		#notificationTable td:last-child {
			width: 200px;
			white-space: nowrap;
			text-align: center;
		}

		/* 내부 .noti-message span 같은 요소가 너무 넓게 나오지 않도록 제한 */
		#notificationTable .noti-message {
			max-width: 100%;       /* 부모 셀 너비 최대 100%로 제한 */
			word-break: break-word;
			white-space: normal;
			overflow-wrap: break-word;
		}
	</style>
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<link rel="preconnect" href="https://fonts.googleapis.com" >
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	
	<main id="container">
	
	<jsp:include page="/WEB-INF/views/clish/myPage/side.jsp"></jsp:include>
	
	<div id="main" >
		<div>
			<div class="notiHeader">
				<h3>알림 전체</h3>
				<input type="button" value="모두읽음" id="allRead">
			</div>
			<table border="1" id="notificationTable">
				<thead style="background-color: #f5f5f5;">
	   			<tr>
	      			<th>알림 내용</th>
				    <th width="200px;">알림 시간</th>
			    </tr>
			    </thead>
			  	<tbody>
				  	<c:forEach var="notification" items="${notificationList}">
					    <tr class="notiTr">
					    	<td>
					    		<c:choose>
					    			<c:when test="${notification.userNoticeReadStatus eq 2 }">
					    				<!-- 0일때 안읽음 -->
					    				<span class="noti-message">${notification.userNoticeMessage}</span><span class="circle unread"></span>
					    			</c:when>
					    			<c:otherwise>
					    				<!--  1일때 읽음 표시 -->
					    				<span class="noti-message">${notification.userNoticeMessage}</span><span class="circle read"></span>
					    			</c:otherwise>
					    		</c:choose>
					    		<input type="hidden" class="notiIdx" value="${notification.noticeIdx }">
<%-- 				    			<div class="notiContent">${notification.userNoticeMessage}</div> --%>
					    		<input type="hidden" name="notiUrl" value="${notification.userNoticeLink }">
					    		
					    	</td>
					      	<td>
					      		<fmt:formatDate value="${notification.userNoticeCreatedAt }" pattern="yy-MM-dd HH:mm:ss" />
					      	</td>
					    </tr>			
				  	</c:forEach>
			  	</tbody>
		  	</table>
			<section id="notificationList" class="pageSection" >
				<c:if test="${not empty notificationPageInfo.maxPage or notificationPageInfo.maxPage > 0}">
					<input type="button" value="이전" 
						onclick="location.href='/myPage/notification?notificationPageNum=${notificationPageInfo.pageNum - 1 }'" 
						<c:if test="${notificationPageInfo.pageNum eq 1}">disabled</c:if>
					>
					
					<c:forEach var="i" begin="${notificationPageInfo.startPage}" end="${notificationPageInfo.endPage}">
						<c:choose>
							<c:when test="${i eq notificationPageInfo.pageNum}">
								<strong>${i}</strong>
							</c:when>
							<c:otherwise>
								<a href="/myPage/notification?notificationPageNum=${i}">${i}</a>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					
					<input type="button" value="다음" 
						onclick="location.href='/myPage/notification?notificationPageNum=${notificationPageInfo.pageNum + 1}'" 
						<c:if test="${notificationPageInfo.pageNum eq notificationPageInfo.maxPage}">disabled</c:if>
					>
				</c:if>
			</section>
		</div>
		
	
	</div>
	
	</main>
	
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
	<script type="text/javascript">
		$(document).ready(function() {
			
			$('.notiTr').on('click', function(e) {
				var $this = $(this);
			    $this.find('span.circle.unread').removeClass('unread').addClass('read');
			   
				var idx = $(this).find('.notiIdx').val();  // 🔴
			    markAsRead(idx)
			    //읽음 처리 함수 호출, 성공시 읽음상태표시 변경
			    
				//a 태그의 href 속성을 읽어와서 페이지 이동
				console.log($this);
				var link = $(this).find('input[name="notiUrl"]').val();
				if(link !== "/myPage/notification"){ // 링크가 존재할때
					window.location.href = link;        
				}
	
			    //input(hidden)에서 idx 값 읽어오기
			});
			
	
			 // 알림 읽음 처리함수
			function markAsRead(noticeIdx) {
				return fetch("/user/notification/" + noticeIdx + "/read", {
    				method : "POST"
    			});
   			}
		});
		// 모두 읽음 처리
		$('#allRead').on('click', function() {
		    $.ajax({
		        url: '/user/notification/all-read', 
		        method: 'PATCH',
		        contentType: 'application/json',
		        dataType: 'json',
		        success: function(response) {
					alert(response.result);
					window.location.reload();
		        },
		        error: function(xhr, status, error) {
		            console.error('서버 통신 오류:', error);
		            alert('서버와 통신 중 오류가 발생했습니다.');
		        }
		    });
		});
	</script>
</body>
</html>