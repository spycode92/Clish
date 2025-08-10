<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${announcement.supportTitle}</title>
<link rel="preconnect" href="https://fonts.googleapis.com" >
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home/main.css" >
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<style type="text/css">
.button-wrapper {
	margin-top: 20px;
  	display: flex;
  	justify-content: center;
  	align-items: center;
  	gap: 30px;
}

.button-wrapper button {
	width: 100px;
	height: 40px;
	padding: 8px 16px;
  	font-size: 1rem;
 	border: none;
 	border-radius: 4px;
  	cursor: pointer;
}

</style>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	</header>
	<div style="display: flex; flex-direction: column;">
		<div ></div>
		<div style="width: calc(100vw - 440px); margin-left: 220px">
			<h3 style="font-size: 1.8rem; text-align: left; margin-top: 30px;">공지사항</h3>
			<div style="margin-top: 30px; padding: 1.4rem; border-bottom: 1px solid #ddd; font-size: 0.875rem; font-weight: 500; background-color: #fff1e5">
				<h3 style="font-size: 1.4rem; margin-bottom: 0.6rem">${announcement.supportTitle}</h3>
				작성자 : <span style="margin-right: 2rem">관리자</span> 작성일자 : <span style="margin-right: 2rem">${announcement.supportCreatedAt}</span>
			</div>
			<div style="padding: 2rem; min-height: 450px; border-bottom: 1px solid #ddd;">
				${announcement.supportDetail}
			</div>
			<div style="padding: 1.2rem 20px; border-bottom: 1px solid #ddd; ">
				<div style="display: flex;">
					<div>
						<div>
							<c:forEach var="fileDTO" items="${announcement.fileList}">
								<div>
									${fileDTO.originalFileName}
									<a href="/file/${fileDTO.fileId }?type=1">
										<img src="/resources/images/download-icon.png" class="img_btn" title="다운로드" />
									</a>
								</div>
							</c:forEach>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="button-wrapper">
			<c:if test="${sUT == 3}">
				<button style="background-color: #f65a6e" onclick="deleteAnnouncement('${announcement.supportIdx}')">삭제</button>
				<button onclick="location.href='/customer/announcement/modify/${announcement.supportIdx}'">수정</button>
			</c:if>
			<button onclick="location.href='/customer/announcements?pageNum=${param.pageNum}'">목록</button>
		</div>
	</div>
</body>
<script type="text/javascript">
	function deleteAnnouncement(idx) {
		if (confirm("삭제하시겠습니까?")) {
			location.href="/customer/announcement/delete/" + idx;
		}
	}
</script>
</html>	