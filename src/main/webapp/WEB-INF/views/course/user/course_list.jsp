<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>
<c:if test="${param.classType eq 0}">CLISH - 정기 강의</c:if>
<c:if test="${param.classType eq 1}">CLISH - 단기 강의</c:if>
</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home/top.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/sidebar.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/course_list.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp" />
	</header>
	
	<jsp:include page="/WEB-INF/views/course/sidebar.jsp" />
		
		<div class="main">
			<div class="main-content">
				<div class="box">
					
					<div class="filter-search-row">
						<div class="search-container">
							<%-- 카테고리별 검색 셀렉트박스 --%>
							<%-- 검색 기능을 위한 폼 생성 --%>
							<form action="/course/user/classList" method="get">
								<%-- 파라미터에 검색어(searchKeyword) 있을 경우 해당 내용 표시 --%>
								<input type="hidden" name="classType" value="${param.classType}">
								<input type="text" name="searchClassKeyword" value="${param.searchClassKeyword}" placeholder="제목을 입력하세요."/>
								<input type="submit" value="검색" />
							</form>
						</div>
						
						<div class="class-filter-wrapper">
							<div class="class-filter">
								<button id="class-filter-button">필터</button>	
							</div>	
							
							<div id="class-main-filter" style="display: none; width: auto; position: absolute;; right: 50px; z-index: 100; margin-top: 50px;">
								<form action="/course/user/classList" method="get" style="border-radius: 30px;">
									<input type="hidden" name="classType" value="${param.classType}">
									
									<select name="searchType">
										<option value="">유형 선택</option>
										<option <c:if test="${param.filterType eq '최신'}">selected</c:if> value="최신">최신</option>
										<option <c:if test="${param.filterType eq '인기'}">selected</c:if> value="인기">인기</option>
										<option <c:if test="${param.filterType eq '평점'}">selected</c:if> value="평점">평점</option>
										<option <c:if test="${param.filterType eq '높은가격'}">selected</c:if> value="높은가격">높은가격</option>
										<option <c:if test="${param.filterType eq '낮은가격'}">selected</c:if> value="낮은가격">낮은가격</option>
									</select>
									
									<%-- 추후 개발 예정 --%>
									<select name="region">
										<option value="">지역 선택</option>
										<option <c:if test="${param.region eq '서울'}">selected</c:if> value="서울">서울</option>
										<option <c:if test="${param.region eq '인천'}">selected</c:if> value="인천">인천</option>
										<option <c:if test="${param.region eq '대전'}">selected</c:if> value="대전">대전</option>
										<option <c:if test="${param.region eq '대구'}">selected</c:if> value="대전">대구</option>
										<option <c:if test="${param.region eq '울산'}">selected</c:if> value="울산">울산</option>
										<option <c:if test="${param.region eq '부산'}">selected</c:if> value="울산">부산</option>
										<option <c:if test="${param.region eq '광주'}">selected</c:if> value="광주">광주</option>
										<option <c:if test="${param.region eq '세종'}">selected</c:if> value="새종">세종</option>
									</select>
									
									<select id="categorySelect" name="categoryIdx">
										<option value="">카테고리 선택</option>
										<c:forEach var="parentCat" items="${parentCategories}">
											<option value="${parentCat.categoryIdx}">
												${fn:substringAfter(parentCat.categoryIdx, 'CT_')}
											</option>
										</c:forEach>
									</select>
									
									<%-- 추후 개발 예정 --%>
									<div>
										<label for="price" style="font-size: 12px">상한 금액: 0원</label>
									  <input type="range" id="price" name="price" min="0" max="5000000" step="50000" style="width: 300px;"/>
									  <label for="price" style="font-size: 12px">5,000,000원</label><br>
									  <div style="text-align: center;"><p>금액: <output id="value"></output>원</p></div>
									</div>
						
									<input type="submit" value="정렬"  />
								</form>
							</div>
							
							<%-- 기업 유저의 경우 강의 개설 버튼 표시 --%>
							<c:if test="${userInfo.userType eq 2}">
								<div class="class-open">
					                <button class="orange-button"
					                        onclick="location.href='${pageContext.request.contextPath}/company/myPage/registerClass'">
					                    강의 개설
					                </button>
								</div>
			                </c:if>
						</div>
					</div>
				</div>
				
				
				<%-- 강의 목록 리스트 --%>
				<table class="table">
				
					<thead>
						<tr>
							<th colspan="7">강좌 목록</th>
						</tr>
						<tr>
							<th>썸네일</th>
							<th>제목</th>
							<th>일자</th>
							<th>장소</th>
							<th>수강료</th>
							<th colspan="2">진행상태</th>
						</tr>
					</thead>
					
					<tbody>
						<c:set var="hasRegisteredClass" value="false" /> <%-- 강의 목록 확인용 변수(boolean) --%> 
						<%-- 강의 목록이 있을 경우 --%>
						<c:forEach var="classItem" items="${classList}">
							<c:if test="${classItem.classStatus != 1}">
								<c:set var="hasRegisteredClass" value="true" />
								<tr>
									<td onclick="location.href='/course/user/classDetail?classIdx=${classItem.classIdx}&classType=${classItem.classType}&categoryIdx=${classItem.categoryIdx}'">
										<img src="/resources/images/logo4-2.png" alt="썸네일" style="width: 100px; height: auto; cursor: pointer;">
									</td>
									<td onclick="location.href='/course/user/classDetail?classIdx=${classItem.classIdx}&classType=${classItem.classType}&categoryIdx=${classItem.categoryIdx}'" style="cursor: pointer;">
										${classItem.classTitle}
									</td>
									<c:if test="${classItem.classType eq 1}">
										<td>${classItem.startDate}</td>
									</c:if>
									<c:if test="${classItem.classType eq 0}">
										<td>${classItem.startDate} ~ ${classItem.endDate}</td>
									</c:if>
									<td>${classItem.location}</td>
									<td><fmt:formatNumber value="${classItem.classPrice}" type="number" maxFractionDigits="0"/>원</td>
									<td class="status-cell">
										<c:choose>
											<c:when test="${userInfo.userIdx eq null}">
											  <div class="status-box">
												<span>오픈</span>
											    <button onclick="location.href='/user/login?prevURL=<%=request.getAttribute("javax.servlet.forward.request_uri") %>&params=${pageContext.request.queryString}'">예약</button>
											  </div>
											</c:when>
											<%-- 신청가능한 강의이면서 일반 유저일 경우 예약 버튼 활성화 --%>
											<c:when test="${classItem.classStatus == 2 and userInfo.userType eq 1}">
											  <div class="status-box">
											    <span>오픈</span>
											    <button onclick="location.href='/course/user/classReservation?&classType=${classItem.classType}&classIdx=${classItem.classIdx}'">예약</button>
											  </div>
											</c:when>
											<%-- 관리자일 경우 관리자 아이디라는 것을 표시 --%>
											<c:when test="${userInfo.userType eq 3}">
												관리자
											</c:when>
											<%-- 신청이 마감된 강의는 예약 버튼 비활성화 및 마감 표시 --%>
											<c:otherwise>
												<div class="status-box">
													마감 <button disabled>예약</button>
												</div>
											</c:otherwise>
										</c:choose>
									</td>
									<%-- 기업 유저의 경우 수정버튼 표시 --%>
									<c:if test="${userInfo.userType eq 2 and userInfo.userStatus eq 1}">
										<c:if test="${classItem.userIdx eq userInfo.userIdx}">
											<td>
												<button onclick="location.href='/company/myPage/modifyClass?classIdx=${classItem.classIdx}'">수정</button>
											</td>
										</c:if>
									</c:if>
								</tr>
							</c:if>
						</c:forEach>
						<%-- 강의 목록이 없을 경우 --%>
						<c:if test="${not hasRegisteredClass}">
							<tr>
								<td colspan="7">등록된 강의가 없습니다.</td>
							</tr>
						</c:if>
					</tbody>
				</table>
				
				<%-- 페이지 리스트 --%>
				<section id="pageList">
					<c:if test="${not empty pageInfoDTO.maxPage or pageInfoDTO.maxPage > 0}">
						<input type="button" value="이전" 
							onclick="location.href='/course/user/classList?pageNum=${pageInfoDTO.pageNum - 1}&classType=${param.classType}&searchClassKeyword=${param.searchClassKeyword}&categoryIdx=${param.categoryIdx}&filterType=${param.filterType}&region=${param.region}&price=${param.price}'" 
							<c:if test="${pageInfoDTO.pageNum eq 1}">disabled</c:if>
						>
						
						<c:forEach var="i" begin="${pageInfoDTO.startPage}" end="${pageInfoDTO.endPage}">
							<c:choose>
								<c:when test="${i eq pageInfoDTO.pageNum}">
									<strong>${i}</strong>
								</c:when>
								<c:otherwise>
									<a href="/course/user/classList?pageNum=${i}&classType=${param.classType}&searchClassKeyword=${param.searchClassKeyword}&categoryIdx=${param.categoryIdx}&filterType=${param.filterType}&region=${param.region}&price=${param.price}">${i}</a>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						
						<input type="button" value="다음" 
							onclick="location.href='/course/user/classList?pageNum=${pageInfoDTO.pageNum + 1}&classType=${param.classType}&searchClassKeyword=${param.searchClassKeyword}&categoryIdx=${param.categoryIdx}&filterType=${param.filterType}&region=${param.region}&price=${param.price}'" 
							<c:if test="${pageInfoDTO.pageNum eq pageInfoDTO.maxPage}">disabled</c:if>
						>
					</c:if>
				</section>
			</div>
		</div>
		
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include> 
	</footer>
	
	
	<script>
		document.addEventListener("DOMContentLoaded", function () {
			const filterButton = document.getElementById("class-filter-button");
			const filterArea = document.getElementById("class-main-filter");
		
			filterButton.addEventListener("click", () => {
				if (filterArea.style.display === "block") {
					filterArea.style.display = "none";
				} else {
					filterArea.style.display = "block";
				}
			});
		});
	</script>
</body>
</html>
