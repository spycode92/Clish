<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 나의리뷰</title>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<link rel="preconnect" href="https://fonts.googleapis.com" >
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
<style type="text/css">
	#container {
		text-align: center;
	}
	
	.leftAlign{
		text-align: left;
	}

	.reviewbar-container {
		display: flex;
		justify-content: flex-start;
		gap: 8px; /* 버튼 사이 간격 */
	}
	
	.reviewbar {
		background: #f6f7fb;        /* 밝은 배경 */
		border: none;               /* 테두리 없음 */
		border-radius: 10px;        /* 둥근 모서리 */
		padding: 12px 26px;         /* 넉넉한 여백 */
		font-size: 16px;
		font-weight: 600;
		margin-right: 8px;          /* 버튼 사이 간격 */
		color: #222;                /* 글씨 색 */
		box-shadow: 0 1px 3px rgba(0,0,0,.04);
		cursor: pointer;
		transition: background 0.2s, color 0.2s;
	}
	
	.reviewbar:hover, .reviewbar:focus {
		background: #2478ff;        /* 마우스 올렸을 때 파란색 */
		color: #fff;                /* 글씨 흰색 */
	}
	
	.star {
		font-size: 30px;
		color: #ccc; /* 비활성 별 색 */
	}
	
	.star.active {
		color: gold; /* 활성 별 색 */
	}
	
	.review-detail {
		display: none;
	}
	
	table tr.review-summary {
		display: table-row;
	}
	
	.review-summary th,
	.review-summary td,
	.review-summary label{
		cursor: pointer;
	}
	
	input[type="checkbox"]:checked + table .review-detail {
		display: table-row;
	}
	
	.img-thumb {
	  width: 100px;      /* 썸네일 너비 */
	  height: auto;      /* 원본 비율 유지 */
	  cursor: pointer;   /* 마우스 올리면 손모양 */
	  border: 1px solid #ddd;
	  margin: 5px;
	}
	
	.pageSection {
		text-align: center;
		border: none;
	}

</style>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	
	<main id="container">
	
	<jsp:include page="/WEB-INF/views/clish/myPage/side.jsp"></jsp:include>
	<div id="main">
		<div class="reviewbar-container">
		<input type="button" class="reviewbar" value="작성 가능 수강후기"
		onclick="location.href='/myPage/myReview?reviewCom=0'">
		<input type="button" class="reviewbar" value="작성 한 수강후기"
		onclick="location.href='/myPage/myReview?reviewCom=1'">
		</div>
		<div>
			<c:choose>
				<c:when test="${reviewCom eq 0 }" >
					<c:forEach items="${reviewInfo}" var="review" >
						<table style="width: 50em;">
							<tr>
								<th>수강 강의</th>
								<th>수강일</th>
								<th rowspan="2">
									<input type="button" value="강의 상세 페이지" 
									onclick="location.href='/course/user/classDetail?classIdx=${review.class_idx}&classType=${review.class_type }&categoryIdx=${review.category_idx }'">
									
									<br><br>
									<!-- classIdx=CLC20250712154900&classType=0&categoryIdx=CT_it_backend -->
									<input type="button" value="수강후기쓰러가기"
									onclick="location.href='/myPage/myReview/writeReviewForm?reservationIdx=${review.reservation_idx}'">
								</th>
							</tr>
							<tr>
								<td>${review.class_title }</td>
								<td>
									<fmt:parseDate var="reviewCreatedAt" 
										value="${review.reservation_class_date }"
										pattern="yyyy-MM-dd'T'HH:mm"
										type="both" />
									<fmt:formatDate value="${reviewCreatedAt}" pattern="yy-MM-dd HH:mm"/>
								</td>
							</tr>
						</table>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<c:forEach items="${reviewInfo}" var="review" varStatus="status">
							
						<form action="/myPage/myReview/modifyReviewForm" method="get">
						<input type="hidden" value="${review.reviewIdx }" name="reviewIdx">
						<input type="checkbox" id="rev_${status.index }" hidden>
							<table  style="width: 50em;" data-index="${status.index }" data-reviewidx="${review.reviewIdx }">
								<tr class="review-summary">
									<th colspan="2"><label for="rev_${status.index}">수강 강의</label></th>
									
									<th><label for="rev_${status.index}">수강일</label></th>
									<th><label for="rev_${status.index}">리뷰작성일</label></th>
								</tr>
								<tr class="review-summary">
									<td colspan="2"><label for="rev_${status.index}">${review.classTitle }</label></td>
									<fmt:parseDate var="reservationClassDate" 
									value="${review.reservationClassDate }"
									pattern="yyyy-MM-dd'T'HH:mm"
									type="both" />
									<td><fmt:formatDate value="${reservationClassDate}" pattern="yy-MM-dd HH:mm"/></td>
<%-- 									<td><label for="rev_${status.index}">${review.reservationClassDate }</label></td> --%>
									<fmt:parseDate var="reviewCreatedAt" 
									value="${review.reviewCreatedAt }"
									pattern="yyyy-MM-dd'T'HH:mm"
									type="both" />
									<td><fmt:formatDate value="${reviewCreatedAt}" pattern="yy-MM-dd HH:mm"/></td>
<%-- 									<td><label for="rev_${status.index}">${review.reviewCreatedAt }</label></td> --%>
								</tr>
								<tr class="review-detail">
									<th>작성자</th>
									<td>${review.userName }(${review.userId })</td>
									<th>평점</th>
									<td>
										<div class="star-rating" data-index="${status.index }">
											<span class="star">&#9733;</span>
											<span class="star">&#9733;</span>
											<span class="star">&#9733;</span>
											<span class="star">&#9733;</span>
											<span class="star">&#9733;</span>
											<input type="hidden" id="score_${status.index }" name="reviewScore" value="${review.reviewScore }" />
										</div>
									</td>
								</tr>
								<tr class="review-detail">
									<th>제목</th>
									<td colspan="3" class="leftAlign">${review.reviewTitle }</td>								
								</tr>
								<tr class="review-detail">
									<th>내용</th>
									<td colspan="3" width="30" class="leftAlign">${review.reviewDetail }</td>
								</tr>
								<tr class="review-detail">
									<th>첨부사진</th>
									<td colspan="3" width="30" class="leftAlign">
										<c:forEach var="file" items="${review.fileList }">
											<img class="img-thumb" 
												src="/file/${file.fileId }?type=0" alt="${file.originalFileName }" />					
										</c:forEach>
									</td>
								</tr>
								<tr class="review-detail">
									<th colspan="4">
										<input type="submit" value="수정">
										<input type="button" id="btn_del_${status.index }" class="btnDelete" value="삭제" >
									</th>
								</tr>
							</table>
						</form>						
					</c:forEach>
				</c:otherwise>
			</c:choose>

			<section id="reviewPageList" class="pageSection">
				<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
					<input type="button" value="이전" 
						onclick="location.href='/myPage/myReview?reviewCom=${reviewCom }&reviewPageNum=${pageInfo.pageNum - 1 }'" 
						<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>
					>
					
					<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
						<c:choose>
							<c:when test="${i eq pageInfo.pageNum}">
								<strong>${i}</strong>
							</c:when>
							<c:otherwise>
								<a href="/myPage/myReview?reviewCom=${reviewCom }&reviewPageNum=${i}">${i}</a>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					
					<input type="button" value="다음" 
						onclick="location.href='/myPage/myReview?reviewCom=${reviewCom }&reviewPageNum=${pageInfo.pageNum + 1}'" 
						<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>
					>
				</c:if>
			</section>
		</div>
	</div>
	</main>
	<div id="imgModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100vw; height:100vh; background:rgba(0,0,0,0.7); text-align:center;">
  		<img id="modalImg" src="" alt="원본" style="max-width:90vw; max-height:90vh; margin-top:5vh; border:3px solid #fff;" />
	</div>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		$(function(){
			//평점함수
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
			
			//토글함수
			$("table").on("click", "tr.review-summary", function(e) {
				if ($(e.target).is("label") || $(e.target).closest("label").length > 0) {
					return; // 기본 체크박스 토글 동작만 하도록 여기서 함수를 종료
				}

				var $table = $(this).closest("table");
				var index = $table.data("index");
				  
				if (index !== undefined) {
				    var $checkbox = $("#rev_" + index);

				    if ($checkbox.length) {
				      	// 체크박스 현재 상태 토글
				    	var currentChecked = $checkbox.prop("checked");
				    	$checkbox.prop("checked", !currentChecked);
					}
				}
			});
			
			//삭제버튼
			$(".btnDelete").click(function() {
				var $table = $(this).closest("table");
				var reviewIdx = $table.data("reviewidx");
				
				console.log("리뷰아이디엑스 : " + reviewIdx);
				
				if(confirm("정말 삭제하시겠습니까 ?")){
					$.ajax({
						url: "/myPage/myReview/deleteReview",
						type: 'POST',
						data: {	reviewIdx: reviewIdx},
						dataType: "json",
						success: function(response){
							alert(response.msg);
							window.location.reload();
						},
						error: function(xhr, status, error) {
					    	alert("삭제 중 오류가 발생했습니다: " + error);
					    }
					});
				}
			});
			
			

		});
	</script>
</body>
</html>

