<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 기업회원목록</title>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
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
						<div>
							<h5 class="section-title">기업 회원 목록</h5>
						</div>
						<form class="filter-form">
							<select class="filter-select" name="filter">
								<option value="all" <c:if test="${param.filter eq 'all' }">selected</c:if>>전체</option>
								<option value="latest" <c:if test="${param.filter eq 'latest' }">selected</c:if>>최근가입순</option>
								<option value="oldest" <c:if test="${param.filter eq 'oldest' }">selected</c:if>>오래된가입순</option>
								<option value="waiting" <c:if test="${param.filter eq 'waiting' }">selected</c:if>>승인대기</option>
								<option value="approved" <c:if test="${param.filter eq 'approved' }">selected</c:if>>승인완료</option>
							</select> 
							<div class="search-box">
								<input type="text" class="search-input" name="searchKeyword" placeholder="검색할 이름을 입력해주세요." value="${param.searchKeyword}"/>
								<button class="search-button">검색</button>
							</div>
						</form>
					</div>
					<div style="height: 500px;">
						<c:choose>
							<c:when test="${empty companys}">
								<div class="list-empty">검색된 기업이 없습니다.</div>
							</c:when>
							<c:otherwise>
								<table class="table">
									<thead>
										<tr>
											<th>회원번호</th>
											<th>회원아이디</th>
											<th>이름</th>
											<th>연락처</th>
											<th>가입일</th>
											<th>상태</th>
											<th></th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="company" items="${companys}">
											<tr>
												<td>${fn:substringAfter(company.userIdx, 'comp')}</td>
												<td>${company.userId}</td>
												<td>${company.userName}</td>
												<td>${company.userPhoneNumber}</td>
												<td>${company.userRegDate}</td>
												<td>
													<c:choose>
														<c:when test="${company.userStatus == 1}">
												            승인
												        </c:when>
														<c:otherwise>
												            대기
												        </c:otherwise>
													</c:choose>
												</td>
												<td>
													<button onclick="location.href='/admin/company/${company.userIdx}?pageNum=${pageInfo.pageNum}'" >
														상세보기
													</button>
												</td>
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
									onclick="location.href='/admin/company?pageNum=${pageInfo.pageNum - 1}&filter=${param.filter}&searchKeyword=${param.searchKeyword}'" 
									<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
								
								<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
									<c:choose>
										<c:when test="${i eq pageInfo.pageNum}">
											<strong>${i}</strong>
										</c:when>
										<c:otherwise>
											<a href="/admin/company?pageNum=${i}&filter=${param.filter}&searchKeyword=${param.searchKeyword}">${i}</a>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								
								<input type="button" value="다음" 
									onclick="location.href='/admin/company?pageNum=${pageInfo.pageNum + 1}&filter=${param.filter}&searchKeyword=${param.searchKeyword}'" 
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