<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의상세</title>
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
	<c:if test="${not empty msg}">
		<script>
	    	alert("${msg}");
	    </script>
	</c:if>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include> 
	</header>
	<div style="display: flex; flex-direction: column;">
		<div style="width: calc(100vw - 440px); margin-left: 220px">
			<h3 style="font-size: 1.8rem; text-align: left; margin-top: 30px; margin-bottom: 50px;">1:1문의내역</h3>
			<div style="height: 400px;" >
				<table style="width: 100%; margin: 0; height: 100%">
					<colgroup>
						<col width="20%">
						<col width="80%">
					</colgroup>
					<tbody>
						<tr>
							<th>작성자</th>
							<td><span id="inquiry-user">${inquiry.userName}</span></td>
						</tr>
						<tr>
							<th>작성일</th>
							<td>
								<span>
									<fmt:formatDate value="${inquiry.inquiry.inqueryDatetime}" pattern="yyyy-MM-dd" />
									<c:if test="${not empty inquiry.inquiry.inqueryModifyDatetime}">
										(수정됨: <fmt:formatDate value="${inquiry.inquiry.inqueryModifyDatetime}" pattern="yyyy-MM-dd" />)
									</c:if>
								</span>
							</td>
						</tr>
						<tr>
							<th>문의유형</th>
							<td>
								<c:if test="${inquiry.inqueryType eq 1}">
									<span id="inquiry-type">1:1문의</span>
								</c:if>
							</td>
						</tr>
						<tr style="height: 200px;">
							<th>문의내용</th>
							<td valign="top"><div id="inquiry-detail">${inquiry.inquiry.inqueryDetail}</div></td>
						</tr>
						<tr style="border-bottom: 2px solid #d8d3d3">
							<th>첨부파일</th>
							<td>
								<div>
									<div style="display: flex;">
										<div>
											<div>
												<c:forEach var="fileDTO" items="${inquiry.inquiry.fileList}">
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
							</td>
						</tr>
						<c:if test="${not empty inquiry.inquiry.inqueryAnswer}">
							<tr style="height: 200px;">
								<th style="background-color: #f2f1f1">답변내용</th>
								<td valign="top">${inquiry.inquiry.inqueryAnswer}</td>
							</tr>
						</c:if>
					</tbody>
				</table>
				<div class="button-wrapper">
					<c:if test="${dbUser.userIdx eq inquiry.inquiry.userIdx}">
						<button style="background-color: #f65a6e" onclick="deleteInquiry('${inquiry.inquiry.inqueryIdx}')">삭제</button>
						<button onclick="location.href='/customer/inquiry/modify/${inquiry.inquiry.inqueryIdx}'">수정</button>
					</c:if>
					<button type="button" onclick="location.href='/customer/inquiry?pageNum=${param.pageNum}'">목록</button>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	function deleteInquiry(idx) {
		if (confirm("삭제하시겠습니까?")) {
			location.href="/customer/inquiry/delete/" + idx;
		}
	}
</script>
</html>	