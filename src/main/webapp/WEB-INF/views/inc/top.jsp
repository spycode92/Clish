<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script type="text/javascript" src="/resources/js/home.js"></script>
<section id="top-menu">
  <a  href="/"><img id="logo" alt="logo" src="/resources/images/logo4-2.png"></a>
  <nav>
      <ul id="flex-item2" class="flex-item2">
          <li>
               <form action="/search" name="search" method="get" id="search-form">
                  <input type="search" id="search" placeholder="검색어를 입력하세요" name="searchKeyword" value="${param.searchKeyword}" required="required">
              </form>
          </li>
          <li><a id="sub-nav-toggle" href="/course/user/classList?classType=0">정기 강의</a></li>
          <li><a href="/course/user/classList?classType=1">단기 강의</a></li>
          <li><a href="/customer/announcements">고객 센터</a> </li> 
          <li><a href="/event/eventHome">이벤트</a></li>

      </ul>
       <a class="flex-item2" id="small-menu">메뉴</a>
          
	<div id="sub-nav">
        <ul>
            <li><a href="/course/user/classList?classType=0"><b>정기 강의</b></a></li>
           	<c:forEach var="Pcat" items="${parentCategories}">
           		<li><a href="/course/user/classList?classType=0&categoryIdx=${Pcat.categoryIdx}">
           		${Pcat.categoryName}</a></li>
           	</c:forEach>
        </ul>
        <ul>
            <li><a href="/course/user/classList?classType=1"><b>단기 강의</b></a></li>
			<c:forEach var="Pcat" items="${parentCategories}">
           		<li><a href="/course/user/classList?classType=1&categoryIdx=${Pcat.categoryIdx }">
           		${Pcat.categoryName }</a></li>
           	</c:forEach>
        </ul>
        <ul >
            <li><a href="/customer/announcements"><b>고객 센터</b></a></li>
            <li><a href="/customer/announcements">공지사항</a></li>
            <li><a href="/customer/FAQ"> FAQ</a></li> 
            <li><a href="/customer/inquiry">문의 게시판</a></li>

        </ul>
        <ul>
            <li><a href="/event/eventHome"><b>이벤트</b></a></li>
<!--             <li><a href="/event/earlyDiscount">얼리버드 할인</a></li> -->
<!--             <li><a href="/event/specialDiscount">특별 할인</a></li>  -->
        </ul>
      
	</div> 
	</nav>  
      <div id="header-buttons" style="position: relative;">
           <a id="noti" href="javascript:void(0)" onclick="notification()"><img alt="notification" src="${pageContext.request.contextPath}/resources/images/notification.png"></a>
           		<div id="notification-box">
           			<div id="notification-header">
	           			<h3>알림</h3>
	           			<c:choose>
	           				<c:when test="${sUT eq 1 }">
	           					<div>
		           					<a href="/myPage/notification">전체보기</a>
		           					<div onclick="readAll()">전체읽음</div>
	           					</div>
	           				</c:when>
	           				<c:otherwise>
	           					<div>
		           					<a href="/company/myPage/notification">전체보기</a>
		           					<div onclick="readAll()">전체읽음</div>
	           					</div>
	           				</c:otherwise>
	           			</c:choose>
           			</div>
					<ul id="notification-list"></ul>
           		</div>
           <c:choose>
				<c:when test="${empty sessionScope.sId}">
		           <a class="button header-button" href="/user/join">회원 가입</a>
		            
				</c:when>
				<c:otherwise>
					 
					<c:if test="${sessionScope.sUT == 3}">
						 <a class="header-button button" href="/admin/main">마이페이지</a>
					</c:if>
					<c:if test="${sessionScope.sUT == 2}">
						 <a class="header-button button" href="/company/myPage">마이페이지</a>
					</c:if>
					<c:if test="${sessionScope.sUT == 1}">
		          		 <a class="button header-button" href="/clish/myPage/main">마이페이지</a>
					</c:if>
				</c:otherwise>
			</c:choose>
			 <c:choose>
				<c:when test="${empty sessionScope.sId}">
<!-- 		            <a href="/user/login" class="header-button button">로그인</a> -->
		            <a href="/user/login?prevURL=<%=request.getAttribute("javax.servlet.forward.request_uri") %>&params=${pageContext.request.queryString}" class="header-button button">로그인</a><br>
				</c:when>
				<c:otherwise>
					<a class="header-button button" href="javascript:void(0)" onclick="logout()">로그아웃</a>
				</c:otherwise>
			</c:choose>
    	</div>
    	<script type="text/javascript">
	    	const notiButton = document.getElementById('notification-box');
	    	
    		function notification() {
    			notiButton.style.display = (notiButton.style.display === 'block') ? 'none' : 'block';
    			
    			fetch("/user/notification")
    			  .then(res => res.json())
    			  .then(data => {
    				  notificationList(data);
    			  })
    			  .catch(err => console.log("알림 조회 실패"));
    		}
    		
    		function changeNotiColor(e) {
    			e.currentTarget.style.backgroundColor = "#f0f0f0";
    		}
    		
    		function notificationList(data) {
    			const ul = document.querySelector("#notification-list");
    			ul.innerHTML = "";
    			
    			if (data.length === 0) {
    				ul.innerHTML = "<li class='no-notification'>알림이 없습니다.</li>"
    				return
    			}
    			
    			data.forEach((noti) => {
    				const li = document.createElement("li");
    				const type = getNoticeType(noti.userNoticeType);
    				const status = getReadStatus(noti.userNoticeReadStatus);
    				
    				li.dataset.noticeIdx = noti.noticeIdx;
    				li.dataset.link = noti.userNoticeLink;
    				
    				li.innerHTML = '[' + type + '] ' + '<span class="noti-message">' + noti.userNoticeMessage + '</span>' + '<span class="read-status">' + status + '</span>';
    				li.addEventListener("mouseover", changeNotiColor);
    				li.addEventListener("click", () => handleNotiClick(li))
    				ul.appendChild(li);
    			});
    		}
    		
    		function handleNotiClick(li) {
    			const noticeIdx = li.dataset.noticeIdx;
    			const link = li.dataset.link || "/";
    			
    			const readSpan = li.querySelector(".read-status");
    			if (readSpan) {
    				readSpan.innerHTML = getReadStatus(1);
    			}
    			
    			markAsRead(noticeIdx)
    				.catch(err => console.log(err))
    				.finally(() => {
    					window.location.href = link;
    				});
    		}
    		
    		function markAsRead(noticeIdx) {
    			return fetch("/user/notification/" + noticeIdx + "/read", {
    				method: "POST"
    			});
    		}
    		
    		// 알림 타입
    		function getNoticeType(type) {
    			switch (type) {
    				case 1: return "프로모션"; 
    				case 2: return "문의"; 
    				case 3: return "클래스"; 
    				case 4: return "로그인"; 
    				default: return "알림"	
    			}
    		}
    		
    		// 알림 확인
    		function getReadStatus(status) {
   				return status === 1 
	   		        ? '<span class="circle read"></span>' 
	   		        : '<span class="circle unread"></span>';
    		}
    		
    		// 전체 읽음
    		function readAll(userIdx) {
    			fetch("/user/notification/all-read", {
    				method: "PATCH",
    				header: {
    					"Content-Type": "application/json"
    				}
    			})
    			  .then((res) => res.json())
    			  .then((data) => {
    				  if (data.result === "모든 알림을 읽음 처리했습니다") {
    					  document.querySelectorAll(".read-status").forEach(span => {
    				          span.innerHTML = getReadStatus(1);
    				      }); 
    				  } else {
    					  alert("더 이상 읽을 알림이 없습니다.");
    				  }
    			  })
    			    .catch((err) => console.error("전체 읽음 오류:", err));
    		}
    	</script>
</section>
