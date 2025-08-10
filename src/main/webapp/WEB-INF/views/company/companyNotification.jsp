<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 나의 알림</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<style>
	#footer-area {
      margin-top: 0 !important;
    }

  .container {
    display: flex;
    min-height: 80vh;
  }

  .sidebar {
    width: 200px;
    background-color: #f8f8f8;
    padding: 20px;
    overflow: hidden;
    white-space: nowrap;
  }

  .main-content {
    flex: 1;
    padding: 30px 60px 30px 30px;
    max-width: 1200px;
    margin-left: auto;
    margin-right: auto;
  }

  h1.page-title {
    margin-bottom: 20px;
    text-align: center;
  }

  /* ✅ 버튼 감싸는 div: 오른쪽 정렬 */
  .btn-right-wrap {
    width: 100%;
    display: flex;
    justify-content: flex-end;
    margin-bottom: 30px;
  }

  .btn-notice-readAll {
     background-color: #FF7601;
     color: #fff;
     border-radius: 10px;
     width: 80px;
     height: 30px;
     border: none;
     display: block;
  }

  .btn-notice-readAll:hover {
    background-color: #FF8C00;
    transform: translateY(-2px);
    transition: background-color 0.3s ease, transform 0.3s ease;
  }
  
  table {
    width: 100%;
    border-collapse: collapse;
    text-align: center;
  }

  th, td {
    border: 1px solid #ddd;
    padding: 10px;
  }

  th {
    background-color: #f5f5f5;
  }

  .circle {
    display: inline-block;
    width: 8px;
    height: 8px;
    border-radius: 50%;
    margin-right: 6px;
  }

  .unread {
    background-color: red;
  }

  .read {
    background-color: gray;
  }

  .pageSection {
    margin-top: 20px;
    text-align: center;
  }
</style>
</head>
<body>
	<header>
	    <jsp:include page="/WEB-INF/views/inc/top.jsp" />
	</header>

	<div class="container">
    <div class="sidebar">
      <jsp:include page="/WEB-INF/views/company/comSidebar.jsp" />
    </div>

    <div class="main-content">
      <h1 class="page-title">${sessionScope.sId}의 알림 목록</h1>

       <!-- ✅ 모두읽음 버튼 영역 -->
      <div class="btn-right-wrap">
        <button type="button" id="btn-notice-readAll" class="btn-notice-readAll">모두읽음</button>
      </div>
	  
	  <!-- ✅ 알림 테이블 -->
      <table>
        <thead>
          <tr>
            <th>알림 내용</th>
            <th>알림 시간</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="notification" items="${notificationList}">
            <tr class="notiTr" style="cursor:pointer;">
              <td>
                <input type="hidden" class="notiIdx" value="${notification.noticeIdx}">
  				<input type="hidden" name="notiUrl" value="${notification.userNoticeLink}">
                <span class="circle ${notification.userNoticeReadStatus == 2 ? 'unread' : 'read'}"></span>
                ${notification.userNoticeMessage}
              </td>
              <td>${notification.userNoticeCreatedAt}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>

	  <!-- ✅ 페이지네이션 영역 -->
      <div class="pageSection">
        <c:if test="${not empty notificationPageInfo.maxPage or notificationPageInfo.maxPage > 0}">
          <input type="button" value="이전"
            onclick="location.href='/company/myPage/notification?notificationPageNum=${notificationPageInfo.pageNum - 1}'"
            <c:if test="${notificationPageInfo.pageNum eq 1}">disabled</c:if>
          />

          <c:forEach var="i" begin="${notificationPageInfo.startPage}" end="${notificationPageInfo.endPage}">
            <c:choose>
              <c:when test="${i eq notificationPageInfo.pageNum}">
                <strong>${i}</strong>
              </c:when>
              <c:otherwise>
                <a href="/company/myPage/notification?notificationPageNum=${i}">${i}</a>
              </c:otherwise>
            </c:choose>
          </c:forEach>

          <input type="button" value="다음"
            onclick="location.href='/company/myPage/notification?notificationPageNum=${notificationPageInfo.pageNum + 1}'"
            <c:if test="${notificationPageInfo.pageNum eq notificationPageInfo.maxPage}">disabled</c:if>
          />
        </c:if>
      </div>
    </div>
  </div>
	
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp" />
	</footer>
	
	<script>
    // 개별 알림 클릭 시
    $(document).ready(function () {
      $('.notiTr').on('click', function () {
        const idx = $(this).find('.notiIdx').val();
        const link = $(this).find('input[name="notiUrl"]').val();

        $(this).find('.circle').removeClass('unread').addClass('read');

        fetch("/company/myPage/notification/" + idx + "/read", {
          method: "POST"
        });

        if (link && link !== "/company/myPage/notification") {
          window.location.href = link;
        }
      });
    });

    // 모두 읽음 처리
    $('.btn-notice-readAll').on('click', function () {
      $.ajax({
        url: '/company/myPage/notification/all-read',
        method: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        success: function (response) {
          alert(response.result);
          location.reload();
        },
        error: function () {
          alert('서버 오류 발생');
        }
      });
    });
  </script>
</body>
</html>