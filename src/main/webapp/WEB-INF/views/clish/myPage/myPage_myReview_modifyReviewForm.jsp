<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html lang="ko">
 	 <head>
 	 	<meta charset="UTF-8" />
    	<link rel="icon" type="image/png" href="/favicon.png" />
    	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
    	<title>리뷰수정</title>
    	<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
    	
    	<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
    	<link rel="preconnect" href="https://fonts.googleapis.com" >
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap" rel="stylesheet">
		<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
    	<style>
			.star {
			  font-size: 30px;
			  color: #ccc; /* 비활성 별 색 */
			  cursor: pointer;
			}
			.star.active {
			  color: gold; /* 활성 별 색 */
			}
		</style>
		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    	<script src="https://cdn.portone.io/v2/browser-sdk.js" async defer></script>
    	<link href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" rel="stylesheet" type="text/css">
	</head>
	<body>
		<header>
			<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
		</header>
		
		<main id="container">
	
			<jsp:include page="/WEB-INF/views/clish/myPage/side.jsp"></jsp:include>
		
			<div id="main">
				<form action="/myPage/myReview/modifyReview" method="post" enctype="multipart/form-data">
				<input type="hidden" name="reviewIdx" value="${reviewDTO.reviewIdx }">
					<table>
						<tr>
							<th>강의 명</th>
							<td><input type="text" value="${reviewDTO.classTitle }" name="classTitle" readonly></td>
						</tr><tr>
							<th>수업 일</th>
							<fmt:parseDate var="reservationClassDate" 
									value="${reviewDTO.reservationClassDate}"
									pattern="yyyy-MM-dd'T'HH:mm"
									type="both" />
							<td><input type="text" value="<fmt:formatDate value="${reservationClassDate}" pattern="yy-MM-dd "/>" readonly></td>
						</tr><tr>
							<th>주문 번호</th>
							<td><input type="text" value="${reviewDTO.reservationIdx}"name="reservationIdx" readonly></td>
						</tr><tr>
							<th>평가 점수</th>
							<td>
			<!-- 					<input type="text" placeholder="0점 ~ 5점" name="reviewScore" > -->
									<div class="star-rating">
										<span class="star">&#9733;</span>
										<span class="star">&#9733;</span>
										<span class="star">&#9733;</span>
										<span class="star">&#9733;</span>
										<span class="star">&#9733;</span>
										<input type="hidden" id="score" name="reviewScore" value="${reviewDTO.reviewScore}" />
									</div>
							</td>
						</tr><tr>
						</tr><tr>
							<th>리뷰 제목</th>
							<td><input type="text" placeholder="제목을 작성해 주세요" name="reviewTitle" value="${reviewDTO.reviewTitle }"></td>
						</tr><tr>
							<th>리뷰 내용</th>
							<td><textarea rows="15" cols="50" placeholder="리뷰 입력" name="reviewDetail" >${reviewDTO.reviewDetail}</textarea></td> 
						</tr>
					</table>
					<label for="file">첨부파일</label>
						
					<input type="file" class="custom-file-input" name="files" multiple accept="image/*">
					
					<c:forEach var="fileDTO" items="${reviewDTO.fileList}">
						<div class="file_item">
							${fileDTO.originalFileName}
							<a href="/file/${fileDTO.fileId }?type=1">
								<img src="/resources/images/download-icon.png" class="img_btn" title="다운로드" />
							</a>
	
							<a href="javascript:deleteFile(${fileDTO.fileId})">
								<img src="/resources/images/delete-icon.png" class="img_btn" title="삭제" />
							</a>
						</div>
					</c:forEach>
					
					<input type="submit" value="리뷰등록" >
					<input type="reset" value="초기화">
					<input type="button" value="취소" onclick="history.back()">
		 		</form>
	 		</div>
	
		</main>
	 		
		<footer>
			<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
		</footer>
		<script>

			//파일삭제
			function deleteFile(fileId) {	
				if(confirm("첨부파일을 삭제하시겠습니까?")) {
					location.href = "/myPage/myReview/removeFile?fileId=" + fileId + "&reviewIdx=${reviewDTO.reviewIdx}";
				}
			}
			// 처음 강의점수 보이기
			
			//강의점수채점
			$(function(){
			    let lastScore = 0;
			    
			    let initialScore = parseInt($("#score").val()) || 0;
			    lastScore = initialScore;
			    
			    $(".star-rating .star").each(function(i){
			        if(i < initialScore){
			            $(this).addClass("active");
			        } else {
			            $(this).removeClass("active");
			        }
			    });
			    
			    $(".star-rating .star").click(function(){
				    const index = $(this).index();
				    let score = index + 1;
				    
				    console.log(lastScore);
				    if(score === 1 && lastScore === 1) {
				    	score = 0;
			    	}
				    lastScore = score;
				    $("#score").val(score);
				    $(this).parent().children(".star").each(function(i){
				      if(i < score){
				        $(this).addClass("active");
				      } else {
				        $(this).removeClass("active");
				      }
				    });
			    });
			    
			    document.querySelector('.custom-file-input').addEventListener('change', function(event) {
					const files = event.target.files;
					for (let i = 0; i < files.length; i++) {
						if (!files[i].type.startsWith('image/')) {
							alert('이미지 파일만 업로드 가능합니다.');
							event.target.value = "";  // 파일 입력값 비움
							return;
						}
					}					
		    	});
			    
			});
		</script>
	</body>
</html>