<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 홈</title>
<link rel="preconnect" href="https://fonts.googleapis.com" >
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home/main.css" >
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/home.js"></script>
<link rel='icon' href='${pageContext.request.contextPath}/resources/images/logo4-2.png' type='image/x-icon'/>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	</header>
<!-- 	<h1>Main.jsp</h1> -->
	
		<div id="event" onclick="location.href='/event/event_detail/EVT20250804112506'"></div>
	<div class="h2-flexbox">
		<h2>추천 정기 강의</h2>
		<div id="class-filter-wrapper">
			<div class="class-filter">
				<button onclick="location.href='/course/user/classList?classType=0'">정기 강의</button>
			</div>
		</div>
	</div>
<!-- 		carousel from: https://codepen.io/CalculateQuick/pen/qEEZRmN -->
	<div class="carousel">
	<div class="carousel-track">
		<c:forEach var="i" begin="0" end="${listSize2 -1}">
			<article class="deconstructed-card" onclick="location.href='/course/user/classDetail?classIdx=${classList2.get(i).classIdx}&classType=${classList2.get(i).classType}&categoryIdx=${classList2.get(i).categoryIdx}'">
	
					<div class="content-fragment fragment-heading">
						<h3 class="content-text">${classList2.get(i).classTitle}</h3>
					</div>
					<div class="small-thumbnail">  
					<c:choose>
					    <c:when test="${empty fileDTO2.get(i).fileId}">
					        <img src="${pageContext.request.contextPath}/resources/images/example_thumbnail.jpg" alt="${classList2.get(i).classTitle}" >
					    </c:when>
					    <c:otherwise>
					        <img src="/file/${fileDTO2.get(i).fileId}?type=0" alt="${classList2.get(i).classTitle}" >
					    </c:otherwise>
					</c:choose>
						
 				    </div> 
					<div class="content-fragment fragment-meta">
						<div class="meta-line"></div>
						<span class="meta-text">	
						<script type="text/javascript"> 
							(function () {
								let courseCategory = "${classList2.get(i).categoryIdx}";
								let modifiedCategory = courseCategory.substring(3).replace(/_/g, " ");
								document.write(modifiedCategory);
							})();
						</script>
						</span>
					</div>
					<div class="content-fragment fragment-meta">
<!-- 						<div class="meta-line"></div> -->
						<p class="">강의 기간 : ${classList2.get(i).classLength} 일</p> 
					</div>

					<div class="content-fragment fragment-body">
						<p class="description-text">${classList2.get(i).classIntro}</p>
					</div>
					<div class="content-fragment fragment-body">
						<p class=" orange-tag">
						<script type="text/javascript">
						(function () {
							let location = "${classList2.get(i).location}"
							let shortenedLocation = location.slice(0, 2);
		 					document.write(shortenedLocation);
						})();
						</script></p>
					</div>
					<div class="content-fragment fragment-meta">
<!-- 						<div class="meta-line"></div> -->
						<span class="meta-text">
							
						<script type="text/javascript">
							(function () {
			 					let coursePrice = "${classList2.get(i).classPrice}";
			 					let stopIndex = coursePrice.indexOf(".");
			 					let modifiedPrice = coursePrice.substring(0, stopIndex);
			 					let modifiedPriceComma = Number(modifiedPrice).toLocaleString('ko-KR');
			 					document.write(modifiedPriceComma);
			 					})(); 
						</script> 원
						</span>
					</div>				
				</article>
		</c:forEach>
			</div>
			
		
		
	
		<div class="carousel-controls">
			<button class="carousel-button prev">
				<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
					<polyline points="15 18 9 12 15 6"></polyline>
				</svg>
			</button>
			<button class="carousel-button next">
				<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
					<polyline points="9 18 15 12 9 6"></polyline>
				</svg>
			</button>
		</div>
	
		<div class="dots-container"></div>
	</div>
	<div class="h2-flexbox">
		<h2>추천 단기 강의</h2>
		<div id="class-filter-wrapper">
			<div class="class-filter">
				<button onclick="location.href='/course/user/classList?classType=1'">단기 강의</button>			
			</div>
		</div>
	</div>
<!-- 		carousel from: https://codepen.io/CalculateQuick/pen/qEEZRmN -->
	<div class="carousel">
	<div class="carousel-track">
		<c:forEach var="i" begin="0" end="${listSize -1}">
			<article class="deconstructed-card" onclick="location.href='/course/user/classDetail?classIdx=${classList.get(i).classIdx}&classType=${classList.get(i).classType}&categoryIdx=${classList.get(i).categoryIdx}'">
	
					<div class="content-fragment fragment-heading">
						<h3 class="content-text">${classList.get(i).classTitle}</h3>
					</div>
					<div class="small-thumbnail">  
					<c:choose>
					    <c:when test="${empty fileDTO.get(i).fileId}">
					        <img src="${pageContext.request.contextPath}/resources/images/example_thumbnail.jpg" alt="${classList.get(i).classTitle}" >
					    </c:when>
					    <c:otherwise>
					        <img src="/file/${fileDTO.get(i).fileId}?type=0" alt="${classList.get(i).classTitle}" >
					    </c:otherwise>
					</c:choose>
						
 				    </div> 
					<div class="content-fragment fragment-meta">
						<div class="meta-line"></div>
						<span class="meta-text">	
						<script type="text/javascript"> 
							(function () {
								let courseCategory = "${classList.get(i).categoryIdx}";
								let modifiedCategory = courseCategory.substring(3).replace(/_/g, " ");
								document.write(modifiedCategory);
							})();
						</script>
						</span>
					</div>
					<div class="content-fragment fragment-meta">
<!-- 						<div class="meta-line"></div> -->
						<p class="">강의 기간 : ${classList.get(i).classLength} 일</p> 
					</div>

					<div class="content-fragment fragment-body">
						<p class="description-text">${classList.get(i).classIntro}</p>
					</div>
					<div class="content-fragment fragment-body">
						<p class=" orange-tag">
						<script type="text/javascript">
							(function () {
								let location = "${classList.get(i).location}"
								let shortenedLocation = location.slice(0, 2);
			 					document.write(shortenedLocation);
							})();
						</script></p>
					</div>
					<div class="content-fragment fragment-meta">
<!-- 						<div class="meta-line"></div> -->
						<span class="meta-text">	
						<script type="text/javascript">
							(function () {
			 					let coursePrice = "${classList.get(i).classPrice}";
			 					let stopIndex = coursePrice.indexOf(".");
			 					let modifiedPrice = coursePrice.substring(0, stopIndex);
			 					let modifiedPriceComma = Number(modifiedPrice).toLocaleString('ko-KR');
			 					document.write(modifiedPriceComma);
			 					})(); 
						</script> 원
						</span>
					</div>
					
				</article>
		</c:forEach>
			</div>
			
		
		
	
		<div class="carousel-controls">
			<button class="carousel-button prev">
				<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
					<polyline points="15 18 9 12 15 6"></polyline>
				</svg>
			</button>
			<button class="carousel-button next">
				<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
					<polyline points="9 18 15 12 9 6"></polyline>
				</svg>
			</button>
		</div>
	
		<div class="dots-container"></div>
	</div>
	
	<h2>신규 정기 강의</h2>
<!-- 		carousel from: https://codepen.io/CalculateQuick/pen/qEEZRmN -->
	<div class="carousel">
	<div class="carousel-track">
		<c:forEach var="i" begin="0" end="${listSize3 -1}">
			<article class="deconstructed-card" onclick="location.href='/course/user/classDetail?classIdx=${classListLongLatest.get(i).classIdx}&classType=${classListLongLatest.get(i).classType}&categoryIdx=${classListLongLatest.get(i).categoryIdx}'">
	
					<div class="content-fragment fragment-heading">
						<h3 class="content-text">${classListLongLatest.get(i).classTitle}</h3>
					</div>
					<div class="small-thumbnail">  
					<c:choose>
					    <c:when test="${empty fileDTO3.get(i).fileId}">
					        <img src="${pageContext.request.contextPath}/resources/images/example_thumbnail.jpg" alt="${classListLongLatest.get(i).classTitle}" >
					    </c:when>
					    <c:otherwise>
					        <img src="/file/${fileDTO3.get(i).fileId}?type=0" alt="${classListLongLatest.get(i).classTitle}" >
					    </c:otherwise>
					</c:choose>
						
 				    </div> 
					<div class="content-fragment fragment-meta">
						<div class="meta-line"></div>
						<span class="meta-text">	
						<script type="text/javascript"> 
							(function () {
								let courseCategory = "${classListLongLatest.get(i).categoryIdx}";
								let modifiedCategory = courseCategory.substring(3).replace(/_/g, " ");
								document.write(modifiedCategory);
							})();
						</script>
						</span>
					</div>
					<div class="content-fragment fragment-meta">
<!-- 						<div class="meta-line"></div> -->
						<p class="">강의 기간 : ${classListLongLatest.get(i).classLength} 일</p> 
					</div>

					<div class="content-fragment fragment-body">
						<p class="description-text">${classListLongLatest.get(i).classIntro}</p>
					</div>
					<div class="content-fragment fragment-body">
						<p class=" orange-tag">
							<script type="text/javascript">
								(function () {
									let location = "${classListLongLatest.get(i).location}"
									let shortenedLocation = location.slice(0, 2);
				 					document.write(shortenedLocation);
								})();
							</script>
						</p>
					</div>
					<div class="content-fragment fragment-meta">
<!-- 						<div class="meta-line"></div> -->
						<span class="meta-text">	
						<script type="text/javascript">
							(function () {
			 					let coursePrice = "${classListLongLatest.get(i).classPrice}";
			 					let stopIndex = coursePrice.indexOf(".");
			 					let modifiedPrice = coursePrice.substring(0, stopIndex);
			 					let modifiedPriceComma = Number(modifiedPrice).toLocaleString('ko-KR');
			 					document.write(modifiedPriceComma);
			 					})(); 
						</script> 원
						</span>
					</div>
					
				</article>
		</c:forEach>
			</div>
			
		
		
	
		<div class="carousel-controls">
			<button class="carousel-button prev">
				<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
					<polyline points="15 18 9 12 15 6"></polyline>
				</svg>
			</button>
			<button class="carousel-button next">
				<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
					<polyline points="9 18 15 12 9 6"></polyline>
				</svg>
			</button>
		</div>
	
		<div class="dots-container"></div>
	</div>
	
	<h2>신규 단기 강의</h2>
<!-- 		carousel from: https://codepen.io/CalculateQuick/pen/qEEZRmN -->
	<div class="carousel">
	<div class="carousel-track">
		<c:forEach var="i" begin="0" end="${listSize4 -1}">
			<article class="deconstructed-card" onclick="location.href='/course/user/classDetail?classIdx=${classListShortLatest.get(i).classIdx}&classType=${classListShortLatest.get(i).classType}&categoryIdx=${classListShortLatest.get(i).categoryIdx}'">
	
					<div class="content-fragment fragment-heading">
						<h3 class="content-text">${classListShortLatest.get(i).classTitle}</h3>
					</div>
					<div class="small-thumbnail">  
					<c:choose>
					    <c:when test="${empty fileDTO4.get(i).fileId}">
					        <img src="${pageContext.request.contextPath}/resources/images/example_thumbnail.jpg" alt="${classListShortLatest.get(i).classTitle}" >
					    </c:when>
					    <c:otherwise>
					        <img src="/file/${fileDTO4.get(i).fileId}?type=0" alt="${classListShortLatest.get(i).classTitle}" >
					    </c:otherwise>
					</c:choose>
						
 				    </div> 
					<div class="content-fragment fragment-meta">
						<div class="meta-line"></div>
						<span class="meta-text">	
						<script type="text/javascript"> 
							(function () {
								let courseCategory = "${classListShortLatest.get(i).categoryIdx}";
								let modifiedCategory = courseCategory.substring(3).replace(/_/g, " ");
								document.write(modifiedCategory);
							})();
						</script>
						</span>
					</div>
					<div class="content-fragment fragment-meta">
<!-- 						<div class="meta-line"></div> -->
						<p class="">강의 기간 : ${classListShortLatest.get(i).classLength} 일</p> 
					</div>

					<div class="content-fragment fragment-body">
						<p class="description-text">${classListShortLatest.get(i).classIntro}</p>
					</div>
					<div class="content-fragment fragment-body">
						<p class=" orange-tag">
							<script type="text/javascript">
								(function () {
									let location = "${classListShortLatest.get(i).location}"
									let shortenedLocation = location.slice(0, 2);
				 					document.write(shortenedLocation);
								})();
							</script>
						</p>
					</div>
					<div class="content-fragment fragment-meta">
<!-- 						<div class="meta-line"></div> -->
						<span class="meta-text">	
						<script type="text/javascript">
							(function () {
			 					let coursePrice = "${classListShortLatest.get(i).classPrice}";
			 					let stopIndex = coursePrice.indexOf(".");
			 					let modifiedPrice = coursePrice.substring(0, stopIndex);
			 					let modifiedPriceComma = Number(modifiedPrice).toLocaleString('ko-KR');
			 					document.write(modifiedPriceComma);
			 					})(); 
						</script> 원
						</span>
					</div>
					
				</article>
		</c:forEach>
			</div>
			
		
		
	
		<div class="carousel-controls">
			<button class="carousel-button prev">
				<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
					<polyline points="15 18 9 12 15 6"></polyline>
				</svg>
			</button>
			<button class="carousel-button next">
				<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
					<polyline points="9 18 15 12 9 6"></polyline>
				</svg>
			</button>
		</div>
	
		<div class="dots-container"></div>
	</div>
	
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include> 
	</footer>

	



</body>
</html>