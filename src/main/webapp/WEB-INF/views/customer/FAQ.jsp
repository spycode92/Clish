<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - FAQ</title>
<link rel="preconnect" href="https://fonts.googleapis.com" >
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home/main.css" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/course/sidebar.css">
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<style type="text/css">
.faq-list {
  list-style: none;
  margin: 0;
  padding: 0;
  border: 1px solid #ddd;
  border-radius: 8px;
  overflow: hidden;
  background-color: #fff;
  font-family: 'Open Sans', sans-serif;
}
.faq-item {
  border-bottom: 1px solid #eee;
}

.faq-title {
  padding: 15px 20px;
  font-size: 1rem;
  cursor: pointer;
  position: relative;
  background-color: #fff;
  transition: background-color 0.3s;
}

.faq-title:hover {
  background-color: #f9f9f9;
}

.faq-title::after {
  position: absolute;
  right: 20px;
  font-size: 0.8rem;
  transition: transform 0.3s;
}

.faq-title.active::after {
  transform: rotate(180deg);
}

.faq-detail {
  padding: 15px 20px;
  font-size: 0.9rem;
  line-height: 1.4;
  display: none;  /* 기본 숨김 */
  background-color: #fafafa;
  border-top: 1px solid #eee;
}
</style>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	</header>
	<nav>
		<jsp:include page="/WEB-INF/views/customer/sidebar.jsp" />
	</nav>
	<div style="display: flex;">
		<div ></div>
		<div style="width: calc(100vw - 440px); height: 500px; margin-left: 220px">
			<h3 style="font-size: 1.8rem; text-align: left; margin-top: 30px; margin-bottom: 30px;">FAQ</h3>
			<div style="display: flex; justify-content: flex-start; margin-bottom: 20px; gap: 30px;">
				<button  data-category="강의수강" style="width: 90px; height: 40px; font-size: 0.9rem;">강의수강</button>
				<button data-category="계정관리" style="width: 90px; height: 40px; font-size: 0.9rem;">계정관리</button>
				<button data-category="결제환불" style="width: 90px; height: 40px; font-size: 0.9rem;">결제환불</button>
			</div>
			<section>
				<ul class="faq-list" data-category="강의수강">
					<c:forEach var="faq" items="${faqList}">
						<c:if test="${faq.supportCategory eq '강의수강' }">
							<li class="faq-item">
								<div class="faq-title">${faq.supportTitle}</div>
								<div class="faq-detail" style="display: none;">${faq.supportDetail}</div>
							</li>
						</c:if>
					</c:forEach>
				</ul>
				<ul class="faq-list"  data-category="계정관리" style="display:none;">
					<c:forEach var="faq" items="${faqList}">
						<c:if test="${faq.supportCategory eq '계정관리' }">
							<li class="faq-item">
								<div class="faq-title"> Q ${faq.supportTitle}</div>
								<div class="faq-detail" style="display: none;">${faq.supportDetail}</div>
							</li>
						</c:if>
					</c:forEach>
				</ul>
				<ul class="faq-list" data-category="결제환불" style="display:none;">
					<c:forEach var="faq" items="${faqList}">
						<c:if test="${faq.supportCategory eq '결제환불' }">
							<li class="faq-item">
								<div class="faq-title">${faq.supportTitle}</div>
								<div class="faq-detail" style="display: none;">${faq.supportDetail}</div>
							</li>
						</c:if>
					</c:forEach>
				</ul>
			</section>
		</div>
	</div>
	<script type="text/javascript">
		document.addEventListener("DOMContentLoaded", () => {
			const categoryButtons = document.querySelectorAll("button[data-category]");
			const faqLists = document.querySelectorAll(".faq-list");
			
			// 카테고리 버튼 클릭
			categoryButtons.forEach((btn) => {
				btn.addEventListener("click", () => {
					const category = btn.dataset.category;
					
					faqLists.forEach((list) => {
						list.style.display = (list.dataset.category === category) ? "block" : "none";
						
					});
				});
			});
			
			// faq 제목 클릭 시 상세 내용 토글
			document.querySelectorAll(".faq-title").forEach((title) => {
				title.addEventListener("click", () => {
					const detail = title.nextElementSibling;
					const isOpen = detail.style.display === "block";
					
					detail.style.display = isOpen ? "none" : "block";
				});
			});
		});
	</script>
</body>
</html>	