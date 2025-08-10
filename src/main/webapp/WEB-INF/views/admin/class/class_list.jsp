<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 강의목록</title>
<link
	href="${pageContext.request.contextPath}/resources/css/admin/admin.css"
	rel="stylesheet" type="text/css">
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<style type="text/css">
.pending-class {
	-ms-overflow-style: none;
 	height: 300px;
 	margin-bottom: 10px;
 	overflow-y: auto;
}

.pending-class::-webkit-scrollbar{
  	display:none;
}

.pending-class table {
  	border-collapse: collapse;
}

.pending-class table thead th {
  	position: sticky;
  	top: 0;
  	z-index: 1;
  	border-bottom: 2px solid #ccc;
}
</style>
</head>
<body>
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"></jsp:include>
		</div>
		<div class="main">
			<jsp:include page="/WEB-INF/views/admin/header.jsp"></jsp:include>
			<div class="main_container">
				<div class="bg-light">
					<div>
						<h5 class="section-title">강의 목록</h5>
					</div>
					<div>
						<h3 class="sub-title">등록 대기</h3>
					</div>
					<c:choose>
						<c:when test="${empty pendingClassList}">
							<div class="list-empty">등록 요청된 강의가 없습니다.</div>
						</c:when>
						<c:otherwise>
							<div class="pending-class">
								<table id="table">
									<thead>
										<tr class="test">
											<th>제목</th>
											<th>대분류</th>
											<th>소분류</th>
											<th>신청일</th>
											<th></th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="classItem" items="${pendingClassList}">
												<tr
													onclick="location.href='/admin/class/${classItem.class_idx}'">
													<td>${classItem.class_title}</td>
													<td>${classItem.parent_category_name}</td>
													<td>${classItem.child_category_name}</td>
													<fmt:parseDate value="${classItem.created_at}" pattern="yyyy-MM-dd" var="createdDate"/>
													<td><fmt:formatDate value="${createdDate}" pattern="yyyy-MM-dd"/></td>
													<td><button>상세보기</button></td>
												</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</c:otherwise>
					</c:choose>

					<form class="filter-form">
						<select class="filter-select" name="filter">
							<option value="all">전체</option>
							<option value="latest">최신등록순</option>
						</select>
						<div class="search-box">
							<input type="text" class="search-input" name="searchKeyword" placeholder="검색할 강의 제목을 입력해주세요." value="${param.searchKeyword}"/>
							<button class="search-button">검색</button>
						</div>
					</form>
					<div style="height: 550px;">
						<div>
							<h3 class="sub-title">등록 완료</h3>
						</div>
						<c:choose>
							<c:when test="${empty classList}">
								<div class="list-empty">등록된 강의가 없습니다.</div>
							</c:when>
							<c:otherwise>
								<table class="table">
									<thead>
										<tr>
											<th>제목</th>
											<th>대분류</th>
											<th>소분류</th>
											<th>상태</th>
											<th colspan="2"></th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="classItem" items="${classList}">
											<tr onclick="location.href='/admin/class/${classItem.class_idx}'">
												<td>${classItem.class_title}</td>
												<td>${classItem.parent_category_name}</td>
												<td>${classItem.child_category_name}</td>
												<td><c:choose>
														<c:when test="${classItem.class_status == 2}">오픈</c:when>
														<c:otherwise>마감</c:otherwise>
													</c:choose></td>
												<td><button>수정</button></td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</c:otherwise>
						</c:choose>
					</div>
					<div style="display: flex; align-items: center; justify-content: center; margin-top: 30px;">
						<div>
							<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
								<input type="button" value="이전" 
									onclick="location.href='/admin/classList?pageNum=${pageInfo.pageNum - 1}&filter=${param.filter}&searchKeyword=${param.searchKeyword}'" 
									<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
								
								<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
									<c:choose>
										<c:when test="${i eq pageInfo.pageNum}">
											<strong>${i}</strong>
										</c:when>
										<c:otherwise>
											<a href="/admin/classList?pageNum=${i}&filter=${param.filter}&searchKeyword=${param.searchKeyword}">${i}</a>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								
								<input type="button" value="다음" 
									onclick="location.href='/admin/classList?pageNum=${pageInfo.pageNum + 1}&filter=${param.filter}&searchKeyword=${param.searchKeyword}'" 
								<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
							</c:if>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>