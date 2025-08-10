<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 1:1문의</title>
<link rel="preconnect" href="https://fonts.googleapis.com" >
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home/main.css" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/sidebar.css">
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<style type="text/css">
.status-pending {
    background-color: #f8d7da; 
    color: #721c24;           
    padding: 4px 8px;
    border-radius: 4px;
    font-weight: bold;
    font-size: 0.9rem;
}

.status-complete {
    background-color: #d4edda; 
    color: #155724;
    padding: 4px 8px;
    border-radius: 4px;
    font-weight: bold;
    font-size: 0.9rem;
}

.status-hold {
    background-color: #fff3cd; 
    color: #856404;
    padding: 4px 8px;
    border-radius: 4px;
    font-weight: bold;
    font-size: 0.9rem;
}
.button {
	margin: 0 15px;
}
</style>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	</header>
	<nav>
		<jsp:include page="/WEB-INF/views/customer/sidebar.jsp" />
	</nav>
	<div style="display: flex;">
		<div ></div>
		<div style="width: calc(100vw - 440px); height: 500px; margin-left: 220px">
			<h3 style="font-size: 1.8rem; text-align: left; margin-top: 30px; margin-bottom: 30px;">1:1문의</h3>
			<div>
				<div style="display: flex; justify-content: flex-end; margin-bottom: 30px;">
					<c:if test="${sUT ne 3}">
						<button onclick="location.href='/customer/inquiry/write'" style="width: 100px; height: 30px; font-size: 0.85rem;">문의남기기</button>
					</c:if>
				</div>
				<div style="height: 250px;">
					<table style="width: 100%; margin: 0">
						<colgroup>
							<col width="50%">
							<col width="15%">
							<col width="20%">
							<col width="15%">
						</colgroup>
						<thead>
							<tr>
								<th>제목</th>
								<th>작성자</th>
								<th>날짜</th>
								<th>상태</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="inquiry" items="${inquiryList}" varStatus="status" >
								<tr>
									<td onclick="location.href='/customer/inquiry/detail/${inquiry.inquiry.inqueryIdx}?pageNum=${pageInfo.pageNum}'">${inquiry.inquiry.inqueryTitle}</td>
									<td style="text-align: center;">${inquiry.userName}</td>
									<td style="text-align: center;"><fmt:formatDate value="${inquiry.inquiry.inqueryDatetime}" pattern="yyyy-MM-dd" /></td>
									<td style="text-align: center;">											
										<c:choose>
											<c:when test="${inquiry.inquiry.inqueryStatus eq 1}"><span class="status-pending">미답변</span></c:when>
											<c:when test="${inquiry.inquiry.inqueryStatus eq 2}"><span class="status-complete">답변완료</span></c:when>
											<c:otherwise><span class="status-hold">보류</span></c:otherwise>
										</c:choose>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div style="display: flex; align-items: center; justify-content: center; margin-top: 30px; ">
					<div style="display: flex; ">
						<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
							<input class="button" type="button" value="이전" 
								onclick="location.href='/customer/inquiry?pageNum=${pageInfo.pageNum - 1}'" 
								<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
							
							<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
								<c:choose>
									<c:when test="${i eq pageInfo.pageNum}">
										<strong>${i} &nbsp;</strong>
									</c:when>
									<c:otherwise>
										<a href="/customer/inquiry?pageNum=${i}">${i} &nbsp;</a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							
							<input class="button" type="button" value="다음" 
								onclick="location.href='/customer/inquiry?pageNum=${pageInfo.pageNum + 1}'" 
							<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
						</c:if>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>	