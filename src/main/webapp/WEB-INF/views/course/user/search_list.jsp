<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강의 목록</title>
<style type="text/css">
	.pageList > nav > ul  {
		display: flex;
		flex-direction: row;
	}
	.pageList > nav > ul > li  {
	margin-right: 10px;
	}
	.pageList > nav {
	margin: 50px  auto;	
	width: 200px;
	}
	
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home/top.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/sidebar.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/course_list.css">
<link rel='icon' href='${pageContext.request.contextPath}/resources/images/logo4-2.png' type='image/x-icon'/>


</head>
<body id="search-list">
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp" />
	</header>

	<div class="main">
		<div class="main-content">
			
			<table class="table">
				<thead>
					<tr>
						<th colspan="6">강좌 검색 목록</th>
					</tr>
					<tr>
						<th>썸네일</th>
						<th>제목</th>
						<th>일자</th>
						<th>장소</th>
						<th colspan="2">진행상태</th>
					</tr>
				</thead>
				<tbody>
					<c:set var="hasRegisteredClass" value="false" />
					<c:forEach var="classItem" items="${classList}">
							<c:set var="hasRegisteredClass" value="true" />
							<tr>
								<td onclick="location.href='/course/user/classDetail?classIdx=${classItem.classIdx}&classType=${classItem.classType}&categoryIdx=${classItem.categoryIdx}'">
									<img src="/resources/images/logo4-2.png" alt="썸네일" style="width: 100px; height: auto;">
								</td>
								<td onclick="location.href='/course/user/classDetail?classIdx=${classItem.classIdx}&classType=${classItem.classType}&categoryIdx=${classItem.categoryIdx}'">
									${classItem.classTitle}
								</td>
								<td>${classItem.startDate} ~ ${classItem.endDate}</td>
								<td>${classItem.location}</td>
								<td>
									<c:choose>
										<c:when test="${classItem.classStatus == 2 and user.userType eq 1}">
											오픈 <button onclick="location.href='/course/user/courseReservation?&classType=${classItem.classType}&classIdx=${classItem.classIdx}'">예약</button>
										</c:when>
										<c:when test="${user.userType eq 3}">
											관리자
										</c:when>
										<c:otherwise>
											마감 <button disabled>예약</button>
										</c:otherwise>
									</c:choose>
								</td>
								<c:if test="${user.userType eq 2}">
									<td>
										<button onclick="location.href='/company/myPage/modifyClass?classIdx=${classItem.classIdx}'">수정</button>
									</td>
								</c:if>
							</tr>
					</c:forEach>
					<c:if test="${listCount eq 0}">
						<tr>
							<td colspan="6">검색된 강의가 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			<div class="pageList">
				<c:if test="${not empty param.searchKeyword}">
					<c:set var="searchParams" value="searchKeyword=${param.searchKeyword}" />
				</c:if>
	
				<c:if test='${not empty pageInfoDTO.maxPage or pageInfoDTO.maxPage > 0}'>
		
					<nav>
						<ul>
							<li><input class="button" type="button" value="back" onclick="location.href='/search?${searchParams}&pageNum=${pageInfoDTO.pageNum -1}'" <c:if test="${pageInfoDTO.pageNum eq 1}">disabled</c:if>></li>
							<c:forEach var="i" begin="${pageInfoDTO.startPage}" end="${pageInfoDTO.endPage}">
								<c:choose>
									<c:when test="${i eq pageInfoDTO.pageNum}">
										<li><strong>${i}</strong></li>
									</c:when>
									<c:otherwise>
										<li><a href="/search?${searchParams}&pageNum=${i}">${i}</a></li>
									</c:otherwise>
								</c:choose>
							</c:forEach>
								<li><input class="button"  type="button" value="next" onclick="location.href='/search?${searchParams}&pageNum=${pageInfoDTO.pageNum +1}'" <c:if test="${pageInfoDTO.pageNum eq pageInfoDTO.maxPage}">disabled</c:if>></li>
							
						</ul>
					</nav>
				</c:if>
			</div>
			
			
			<table class="table">
				<thead>
					<tr>
						<th colspan="6">고객 센터 검색 목록</th>
					</tr>
					<tr>
						<th>제목</th>
						<th>날짜</th>
						
					</tr>
				</thead>
				<tbody>
					
					<c:forEach var="supportItem" items="${supportList}">
							<tr>
								
								<td onclick="location.href='/customer/announcement/detail/${supportItem.supportIdx}'" style="text-align: left; width: 60%">${supportItem.supportTitle}</td>
								<td style="text-align: center;">${supportItem.supportCreatedAt}</td>
							</tr>
					</c:forEach>
					<c:if test="${listCountAnn eq 0}">
						<tr>
							<td colspan="6">검색된 고객 센터 정보가 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			<div class="pageList">
				<c:if test="${not empty param.searchKeyword}">
					<c:set var="searchParams" value="searchKeyword=${param.searchKeyword}" />
				</c:if>
	
				<c:if test='${not empty pageInfoDTO2.maxPage or pageInfoDTO2.maxPage > 0}'>
		
					<nav>
						<ul>
							<li><input class="button" type="button" value="back" onclick="location.href='/search?${searchParams}&pageNum2=${pageInfoDTO2.pageNum -1}'" <c:if test="${pageInfoDTO2.pageNum eq 1}">disabled</c:if>></li>
							<c:forEach var="i" begin="${pageInfoDTO2.startPage}" end="${pageInfoDTO2.endPage}">
								<c:choose>
									<c:when test="${i eq pageInfoDTO2.pageNum}">
										<li><strong>${i}</strong></li>
									</c:when>
									<c:otherwise>
										<li><a href="/search?${searchParams}&pageNum2=${i}">${i}</a></li>
									</c:otherwise>
								</c:choose>
							</c:forEach>
								<li><input class="button"  type="button" value="next" onclick="location.href='/search?${searchParams}&pageNum2=${pageInfoDTO2.pageNum +1}'" <c:if test="${pageInfoDTO2.pageNum eq pageInfoDTO2.maxPage}">disabled</c:if>></li>
							
						</ul>
					</nav>
				</c:if>
			</div>
		</div>
	</div>
	<jsp:include page="/WEB-INF/views/admin/bottom.jsp" />
</body>
</html>
