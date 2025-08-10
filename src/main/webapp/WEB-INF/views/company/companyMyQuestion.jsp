<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 나의 문의</title>
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
	  padding-right: 200px; /* ✅ 오른쪽 여백 추가! */
	  box-sizing: border-box;
	}

    /* 왼쪽 사이드바 */
	.sidebar {
	    width: 200px; /* 필요에 따라 조절 */
	    background-color: #f8f8f8;
	    padding: 20px;
	    overflow: hidden;          /* ✅ 내부 넘치는 거 잘라냄 */
    	white-space: nowrap;
	}

    .main-content {
      flex: 1;
      padding: 30px;
    }

    .main-content h1,
    .main-content h3 {
      text-align: center;
    }

    .main-content h1 {
      font-size: 24px;
      margin-bottom: 10px;
    }

    .main-content h3 {
      font-size: 18px;
      margin-top: 30px;
      margin-bottom: 10px;
    }

    .top-section {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-left: 1300px;
    }

    .btn-write {
      width: 100px;
      background-color: #ff6f0f;
      color: white;
      border: none;
      padding: 7px 16px;
      border-radius: 6px;
      font-weight: bold;
      cursor: pointer;
    }

    table {
	  width: 97%;
	}

    th, td {
      border: 1px solid #ddd;
      padding: 12px;
      text-align: center;
    }

    th {
      background-color: #f5f5f5;
    }

    .inquery-detail {
      display: none;
      background: #fff4d9;
    }

    .btn-wrap {
      display: flex;
      gap: 10px;
      margin-top: 10px;
      justify-content: center;
    }

    .btn-wrap button {
      padding: 5px 12px;
      background: #ff6f0f;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }

    .btn-wrap button:hover {
      background: #ff9c34;
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
			<h1>${sessionScope.sId}님의 문의 목록</h1>

      		<div class="top-section">
				<button class="btn-write" onclick="location.href='${pageContext.request.contextPath}/company/myPage/writeInquery'">문의 등록</button>
      		</div>
			<table>
				<thead>
					<tr>
						<th>문의 번호</th>
						<th>제목</th>
						<th>이름</th>
						<th>상태</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when test="${empty test}">
							<tr><td colspan="4">아직 등록한 문의가 없습니다.</td></tr>
            			</c:when>
            		<c:otherwise>
              			<c:forEach var="inq" items="${test}">
                			<tr class="inquery-toggle">
								<td>${inq.inquiry.inqueryIdx}</td>
								<td>${inq.inquiry.inqueryTitle}</td>
								<td>${inq.userName}</td>
								<td>
									<c:choose>
										<c:when test="${inq.inquiry.inqueryStatus == 1}">답변대기</c:when>
										<c:when test="${inq.inquiry.inqueryStatus == 2}">답변완료</c:when>
										<c:when test="${inq.inquiry.inqueryStatus == 3}">검토중</c:when>
									</c:choose>
								</td>
							</tr>
                			<tr class="inquery-detail">
                  				<td colspan="4">
									<strong>문의 내용:</strong><br>${inq.inquiry.inqueryDetail}<br><br>
									<strong>답변 내용:</strong><br>
									<c:choose>
										<c:when test="${not empty inq.inquiry.inqueryAnswer}">
											${inq.inquiry.inqueryAnswer}
										</c:when>
										<c:otherwise>
											아직 답변이 등록되지 않았습니다.
										</c:otherwise>
									</c:choose>

									<c:if test="${inq.inquiry.inqueryStatus == 1}">
										<div class="btn-wrap">
											<form action="${pageContext.request.contextPath}/company/myPage/modifyInquery" method="get">
												<input type="hidden" name="inqueryIdx" value="${inq.inquiry.inqueryIdx}">
												<button type="submit">수정</button>
											</form>
											<form action="${pageContext.request.contextPath}/company/myPage/delete" method="post">
												<input type="hidden" name="inqueryIdx" value="${inq.inquiry.inqueryIdx}">
												<button type="submit" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
											</form>
										</div>
									</c:if>
								</td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
		
		<!-- ✅ 페이징 영역 -->
		<div class="pageSection" style="display: flex; justify-content: center;">
			<c:if test="${not empty inquiryPageInfo.maxPage or inquiryPageInfo.maxPage > 0}">
				<!-- 이전 버튼 -->
				<input type="button" value="이전"
					onclick="location.href='?inquiryPageNum=${inquiryPageInfo.pageNum - 1}'"
				<c:if test="${inquiryPageInfo.pageNum == 1}">disabled</c:if>
				style="margin: 0 8px;" />
				<!-- 페이지 번호 -->
				<c:forEach var="i" begin="${inquiryPageInfo.startPage}" end="${inquiryPageInfo.endPage}">
					<c:choose>
						<c:when test="${i eq inquiryPageInfo.pageNum}">
							<strong style="margin: 0 8px;">${i}</strong> 
						</c:when>
						<c:otherwise>
							<a href="?inquiryPageNum=${i}" style="margin: 0 8px;">${i}</a>
						</c:otherwise>
					</c:choose>
				</c:forEach>
			
				<!-- 다음 버튼 -->
				<input type="button" value="다음"
					onclick="location.href='?inquiryPageNum=${inquiryPageInfo.pageNum + 1}'"
				<c:if test="${inquiryPageInfo.pageNum == inquiryPageInfo.maxPage}">disabled</c:if>
					style="margin: 0 8px;" />
			</c:if>
		</div>
		
	</div>
</div>

	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp" />
	</footer>

	<script>
	$(document).ready(function () {
		$(".inquery-toggle").click(function () {
			const detailRow = $(this).next(".inquery-detail");
			$(".inquery-detail").not(detailRow).slideUp(200);
			detailRow.slideToggle();
		});
	});
	</script>
</body>
</html>
