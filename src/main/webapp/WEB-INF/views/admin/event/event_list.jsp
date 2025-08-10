<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트</title>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
</head>
<body>
	<c:if test="${not empty msg}">
		<script>
	    	alert("${msg}");
	    </script>
	</c:if>
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"></jsp:include>	
		</div>
		<div class="main">
			<jsp:include page="/WEB-INF/views/admin/header.jsp"></jsp:include>
			<div class="main_container">
				<div class="bg-light">
					<div>
						<div class="flex">
							<h5 class="section-title">이벤트관리</h5>
							<button onclick="location.href='/admin/event/write'" class="submitBtn">등록</button>
						</div>
						<form class="filter-form">
							<select class="filter-select" name="searchType">
								<option <c:if test="${param.searchType eq '전체'}">selected</c:if> value="전체">전체</option>
								<option <c:if test="${param.searchType eq '진행중'}">selected</c:if> value="진행중">진행중</option>
								<option <c:if test="${param.searchType eq '예정'}">selected</c:if> value="예정">예정</option>
								<option <c:if test="${param.searchType eq '종료'}">selected</c:if> value="종료">종료</option>
							</select>
							<div class="search-box">
								<input type="text" class="search-input" placeholder="검색어를 입력하세요" name="searchKeyword" value="${param.searchKeyword}"/>
								<button type="submit" class="search-button">검색</button>
							</div>
						</form>
					</div>
					<div>
						<div style="height: 450px;">
							<c:choose>
								<c:when test="${empty eventList}">
									<div class="list-empty">검색된 이벤트가 없습니다.</div>
								</c:when>
								<c:otherwise>
									<table>
										<thead>
											<tr>
												<th>제목</th>
												<th>시작날짜</th>
												<th>끝나는날짜</th>
												<th>상태</th>
												<th></th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="event" items="${eventList}" varStatus="status" >
												<tr>
													<td>${event.eventTitle}</td>
													<td>${event.eventStartDate}</td>
													<td>${event.eventEndDate}</td>
													<td>
														<c:choose>
															<c:when test="${event.eventInProgress eq 1}">
																<span>진행중</span>
															</c:when>
															<c:when test="${event.eventInProgress eq 2}">
																<span>예정</span>
															</c:when>
															<c:otherwise>
																<span>종료</span>
															</c:otherwise>
														</c:choose>
													</td>
													<td class="flex">
														<button onclick="location.href='/admin/event/detail/${event.eventIdx}?pageNum=${pageNum}'">상세보기</button>
													</td>
												</tr>
											</c:forEach>									
										</tbody>
									</table>
								</c:otherwise>
							</c:choose>
						</div>
						<div style="display: flex; align-items: center; justify-content: center; margin-top: 50px;">
							<div>
								<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
									<input type="button" value="이전" onclick="location.href='/admin/event?pageNum=${pageInfo.pageNum - 1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}'" 
								<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
								<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
									<c:choose>
										<c:when test="${i eq pageInfo.pageNum}">
											<strong>${i}</strong>
										</c:when>
										<c:otherwise>
											<a href="/admin/event?pageNum=${i}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}">${i}</a>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								<input type="button" value="다음" onclick="location.href='/admin/event?pageNum=${pageInfo.pageNum + 1}&searchType=${param.searchType}&searchKeyword=${param.searchKeyword}'" 
										<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
								</c:if>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>