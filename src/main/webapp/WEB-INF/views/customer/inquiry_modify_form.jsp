<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의수정</title>
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
			<h3 style="font-size: 1.8rem; text-align: left; margin-top: 30px; margin-bottom: 50px;">1:1문의수정</h3>
			<form action="/customer/inquiry/modify/${inquiry.inquiry.inqueryIdx}" method="post" enctype="multipart/form-data" style="height: 400px; border: none; padding: 0" >
				<input type="hidden" name="inqueryIdx" value="${inquiry.inquiry.inqueryIdx}"/>
				<table style="width: 100%; margin: 0; height: 100%">
					<colgroup>
						<col width="20%">
						<col width="80%">
					</colgroup>
					<tbody>
						<tr>
							<th>제목</th>
							<td>
								<input type="text" name="inqueryTitle" value="${inquiry.inquiry.inqueryTitle}"/>
							</td>
						</tr>
						<tr style="height: 200px;">
							<th>문의내용</th>
							<td valign="top">
								<textarea rows="15" cols="40" name="inqueryDetail">${inquiry.inquiry.inqueryDetail}</textarea>
							</td>
						</tr>
						<tr style="border-bottom: 2px solid #d8d3d3">
							<th>첨부파일</th>
							<td>
								<c:choose>
									<c:when test="${empty inquiry.inquiry.fileList }">
										<input type="file" class="custom-file-input" name="files" multiple>
									</c:when>
									<c:otherwise>
										<c:forEach var="fileDTO" items="${inquiry.inquiry.fileList}">
											<div>
												${fileDTO.originalFileName}
												<a href="/file/${fileDTO.fileId }?type=1">
													<img src="/resources/images/download-icon.png" class="img_btn" title="다운로드" />
												</a>
						
												<a href="javascript:deleteFile(${fileDTO.fileId})">
													<img src="/resources/images/delete-icon.png" class="img_btn" title="삭제" />
												</a>
											</div>
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="button-wrapper">
					<button type="submit">수정</button>
					<button type="button" onclick="location.href='/customer/inquiry/detail/${inquiry.inquiry.inqueryIdx}?pageNum=${param.pageNum}'">취소</button>
				</div>
			</form>
		</div>
	</div>
	<script type="text/javascript">
		function deleteFile(fileId) {
	
			if(confirm("첨부파일을 삭제하시겠습니까?")) {
				location.href = "/customer/inquiry/fileDelete?fileId=" + fileId + "&inqueryIdx=${inquiry.inquiry.inqueryIdx}";
			}
		}
	</script>
</body>
</html>	