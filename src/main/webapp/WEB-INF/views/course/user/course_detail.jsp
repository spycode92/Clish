<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CLISH - ${classInfo.classTitle}</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home/top.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/sidebar.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/course_list.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/course_detail.css">
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<script>
	// 카테고리 셀렉트 박스가 바뀌었을 때 함수 실행
	function filterByCategory() {
		const selected = document.getElementById('categorySelect').value;
		location.href = '/course/user/classList?classType=${param.classType}&categoryIdx=' + selected;
	}
</script>
<style type="text/css">
	.star {
		font-size: 30px;
		color: #ccc; /* 비활성 별 색 */
	}
	
	.star.active {
		color: gold; /* 활성 별 색 */
	}

	.img-thumb {
	  width: 100px;      /* 썸네일 너비 */
	  height: auto;      /* 원본 비율 유지 */
	  cursor: pointer;   /* 마우스 올리면 손모양 */
	  border: 1px solid #ddd;
	  margin: 5px;
	}
</style>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"/>
	</header>
	
	<jsp:include page="/WEB-INF/views/course/sidebar.jsp" />
	
	<div class="main">
        
		<section class="class-details">
			<%-- 강의에 대한 간단한 설명 --%>
			<div class="class-container">
				<%-- 강의 썸네일 --%>
				<div class="cls-pic">
					<c:forEach var="file" items="${classInfo.fileList}">
						<img src="/file/${file.fileId }?type=0" alt="${file.originalFileName }"  id="preview" class="figure-img img-fluid rounded" style="height: 280px;"/>
					</c:forEach>
				</div>
				<%-- 제목 및 인트로, 카테고리 표시 --%>
				<div class="cls-info-card">
					<h2 class="class-title">${classInfo.classTitle}</h2>
					<p class="class-description">${classInfo.classIntro}</p>
					<div class="class-tags">
						<c:forEach var="child" items="${childCategories}">
							<c:if test="${child.categoryIdx eq classInfo.categoryIdx}">
								<span class="tag">#${child.categoryName}</span>
							</c:if>
						</c:forEach>
					</div>
				</div>
			</div>
			
		    <div style="text-align: center; padding-top: 30px; display: flex;">
		    	<%-- 강의 목록은 항상 표시 --%>
		        <button class="orange-button" onclick="location.href='/course/user/classList?classType=${param.classType}'">
		        강의 목록</button>
		        <%-- 신청가능한 강의이고 일반 유저일 경우 예약정보 입력 버튼, 강의 문의 활성화 --%>
		        <c:if test="${userInfo.userType eq 1 and classInfo.classStatus eq 2}">
		          <div class="status-box" style="padding-left: 10px;">
					<button onclick="showAlert()">강의 문의</button>
		            <button class="orange-button" onclick="location.href='/course/user/classReservation?classIdx=${classInfo.classIdx}&classType=${param.classType}&categoryIdx=${param.categoryIdx}'">
		            예약정보 입력</button>
		          </div>
		        </c:if>
		        <%-- 정보 수정버튼은 기업 유저일 경우만 표시 --%>
		        <c:if test="${userInfo.userType eq 2 and userInfo.userStatus eq 1}">
		          <div class="status-box" style="padding-left: 10px;">
					<button onclick="location.href='/company/myPage/modifyClass?classIdx=${classItem.classIdx}'">정보 수정</button>
				  </div>
				</c:if>
				<c:if test="${userInfo.userIdx eq null}">
				  <div class="status-box" style="padding-left: 10px;">
				    <button onclick="location.href='/user/login?prevURL=<%=request.getAttribute("javax.servlet.forward.request_uri") %>&params=${pageContext.request.queryString}'">예약</button>
				  </div>
				</c:if>
		    </div>
					
		</section>
		
		<%-- 상세 정보를 보기 위한 태그 버튼 --%>
		<ul class="tabnav" style="text-align: center; display: flex;">
			<li><a href="#classDetail">클래스 소개</a></li>
			<li><a href="#curriCulum">커리큘럼</a></li>
			<li><a href="#refund">환불규정</a></li>
			<li><a href="#reView">수강평(${pageInfo.listCount != null ? pageInfo.listCount : 0})</a></li>
		</ul> 
		
		<div class="section-container">
		    <h1>클래스 상세 페이지</h1>
		    <h3 style="text-align: center; margin-bottom: 30px;">[ 클래스 상세 정보 ]</h3>
			<%-- classIdx를 hidden 속성으로 전달 --%>
		    <input type="hidden" id="classIdx" name="classIdx" value="${classInfo.classIdx}"><br>
			<section id="classDetail">
		    	<b>강사명</b> : ${userInfo.userName} <br>
				<b>강의 컨텐츠</b> : ${classInfo.classContent} <br>
				<b>운영 기간</b> : ${classInfo.startDate} ~ ${classInfo.endDate} <br>
				<b>신청 마감일</b> : ${applyEndDate} <br>
				<b>수강료</b> : <fmt:formatNumber value="${classInfo.classPrice}" type="number" maxFractionDigits="0"/>원<br>
				<b>수업 요일</b> : ${classInfo.dayString}<br>
			</section>
		    
			<section id="curriCulum" >
				<h3 style="margin-bottom: 20px;">📚 커리큘럼 소개</h3>
				<div id="curriculumContainer">
					<c:forEach var="curri" items="${curriculumList}">
						<div class="curriculum-box" style="display: flex; align-items: center; justify-content: space-between;">
							<div style="display: flex; gap: 30px;">
								<span>${curri.curriculumTitle}</span>
								<span>${curri.curriculumRuntime}</span>
							</div>
						</div>
					</c:forEach>
				</div>
			</section>
			
			<section id="refund">
				<h1>환불 규정</h1>
					<br>
					<b>정기강의 일때</b><br> 
					10일 이상 100%<br>
					5일 이상 10일 미만 70%<br>
					3일 이상 5일 미만 50%<br>
					1일 이상 3일 미만 30%<br>
					1일 미만 관리자에게 문의<br>
					<br>
					<b>단기강의 일때</b><br>
					5일 이상 100%<br>
					3일 이상 5일 미만 70%<br>
					1일 이상 3일 미만 50%<br>
					1일 미만 관리자에게 문의<br>
					<br>
			</section>
			
			<section id="reView">
				<h1>수강후기</h1>
				<c:forEach var="review" items="${reviewList}" varStatus="status">
					<table style="margin: 0;">
					<tr>
						<th>작성자</th>
						<td>${review.userName}(${review.userId})</td>
						<th>평점</th>
						<td>
							<div class="star-rating" data-index="${status.index}">
								<span class="star">&#9733;</span>
								<span class="star">&#9733;</span>
								<span class="star">&#9733;</span>
								<span class="star">&#9733;</span>
								<span class="star">&#9733;</span>
								<input type="hidden" id="score_${status.index}" name="reviewScore" value="${review.reviewScore}" />
							</div>
						</td>
					</tr>
					<tr class="review-detail">
						<th>제목</th>
						<td colspan="3">${review.reviewTitle}</td>								
					</tr>
					<tr class="review-detail">
						<th>내용</th>
						<td colspan="3" width="30">${review.reviewDetail}</td>
					</tr>
					<tr class="review-detail">
						<th>첨부사진</th>
						<td colspan="3" width="30">
							<c:forEach var="file" items="${review.fileList}">
								<img class="img-thumb"
									src="${pageContext.request.contextPath}/resources/upload/${file.subDir}/${file.realFileName}" alt="${file.originalFileName}" />					
							</c:forEach>
						</td>
					</tr>
					</table>
				</c:forEach>
				<%-- 리뷰 리스트 페이징 --%>
				<section id="classReviewPageList">
					<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
						<input type="button" value="이전" 
							onclick="location.href='/course/user/classDetail?classIdx=${param.classIdx}&classType=${param.classType}&categoryIdx=${param.categoryIdx}&reviewPageNum=${pageInfo.pageNum - 1}#reView'" 
							<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
						
						<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
							<c:choose>
								<c:when test="${i eq pageInfo.pageNum}">
									<strong>${i}</strong>
								</c:when>
								<c:otherwise>
									<a href="/course/user/classDetail?classIdx=${param.classIdx}&classType=${param.classType}&categoryIdx=${param.categoryIdx}&reviewPageNum=${i}#reView">${i}</a>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						
						<input type="button" value="다음" 
							onclick="location.href='/course/user/classDetail?classIdx=${param.classIdx}&classType=${param.classType}&categoryIdx=${param.categoryIdx}&reviewPageNum=${pageInfo.pageNum + 1}#reView'" 
							<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
					</c:if>
				</section>
				
			</section>
		
		
		</div>
	</div>
	<%-- 클래스 등록 이미지 보여주기 --%>
	<div id="imgModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100vw; height:100vh; background:rgba(0,0,0,0.7); text-align:center;">
  		<img id="modalImg" src="" alt="원본" style="max-width:90vw; max-height:90vh; margin-top:5vh; border:3px solid #fff;" />
	</div>
	
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		function showAlert() {
	      alert("서비스 준비중입니다.");
	    }
		
		$(function(){
			//평점보여주기
			$(".star-rating").each(function() {
				var $container = $(this);
				var index = $container.data("index");
				var score = parseInt($("#score_" + index).val(), 10);
				
				$container.children(".star").each(function(i){
			      if(i < score){
			        $(this).addClass("active");
			      } else {
			        $(this).removeClass("active");
			      }
			    });
			})
			//이미지 크기
			$(function(){
			  // 썸네일 클릭 시 원본 큰 이미지 보여줌
				$(document).on("click", ".img-thumb", function(e) {
				    var src = $(this).attr("src");
				    $("#modalImg").attr("src", src);
				    $("#imgModal").fadeIn(200);
				});
			  
				// 모달 바깥 클릭 or 이미지 클릭 시 닫기
				$("#imgModal").on("click", function(){
				    $(this).fadeOut(200);
				    $("#modalImg").attr("src", "");
				});
			});
		});
	</script>
</body>
</html>