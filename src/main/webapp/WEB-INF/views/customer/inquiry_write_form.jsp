<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의작성</title>
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
	<div style="display: flex;">
		<div ></div>
		<div style="width: calc(100vw - 440px); margin-left: 220px">
			<h3 style="font-size: 1.8rem; text-align: left; margin-top: 30px;">1:1문의쓰기</h3>
			<div>
				<form action="/customer/inquiry/write" method="post" enctype="multipart/form-data" style="border: none; padding: 0; margin-top: 30px;">
					<table style="width: 100%; margin: 0">
						<colgroup>
							<col width="20%">
							<col width="80%">
						</colgroup>
							<tbody>
								<tr>
									<th>제목</th>
									<td><input type="text" name="inqueryTitle"/></td>
								</tr>
								<tr>
									<th>내용</th>
									<td><textarea rows="10" cols="10" name="inqueryDetail"></textarea></td>
								</tr>
								<tr>
									<th>파일첨부</th>
									<td>
										<input type="file" name="files" multiple>
									</td>
								</tr>
							</tbody>
						</table>
					<div class="button-wrapper">
						<button type="submit" >등록</button>
						<button type="button" onclick="history.back()">취소</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>	