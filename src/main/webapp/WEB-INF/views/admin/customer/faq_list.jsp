<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - FAQ</title>
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
							<h5 class="section-title">FAQ</h5>
							<button onclick="location.href='/admin/faq/writeFaq'" class="submitBtn">등록</button>
						</div>
						<form class="filter-form">
							<select class="filter-select" name="searchType">
								<option <c:if test="${param.searchType eq '전체'}">selected</c:if> value="전체">전체</option>
								<option <c:if test="${param.searchType eq '강의수강'}">selected</c:if> value="강의수강">강의수강</option>
								<option <c:if test="${param.searchType eq '계정관리'}">selected</c:if> value="계정관리">계정관리</option>
								<option <c:if test="${param.searchType eq '결제환불'}">selected</c:if> value="결제환불">결제환불</option>
							</select>
							<div class="search-box">
								<input type="text" class="search-input" placeholder="내용을 검색해주세요." name="searchKeyword" value="${param.searchKeyword}"/>
								<button class="search-button">검색</button>
							</div>
						</form>
					</div>
					<div>
						<div>
							<c:choose>
								<c:when test="${empty faqList}">
									<div class="list-empty">검색 결과가 없습니다.</div>
								</c:when>
								<c:otherwise>
									<table>
										<thead>
											<tr>
												<th>게시판번호</th>
												<th>제목</th>
												<th>작성일자</th>
												<th>게시판유형</th>
												<th></th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="faq" items="${faqList}" varStatus="status" >
												<tr>
													<td>${status.index + 1}</td>
													<td>${faq.supportTitle}</td>
													<td>${faq.supportCreatedAt}</td>
													<td>${faq.supportCategory}</td>
													<td class="flex">
														<button onclick="location.href='/admin/faq/detail/${faq.supportIdx}'">상세보기</button>
														<button onclick="deleteFaq('${faq.supportIdx}')">삭제</button>
													</td>
												</tr>
											</c:forEach>									
										</tbody>
									</table>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	function deleteFaq(idx) {
		if (confirm("삭제하시겠습니까?")) {
			location.href="/admin/faq/delete/" + idx;
		}
	}
</script>
</html>