<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의수정</title>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" >
<link href="${pageContext.request.contextPath}/resources/css/myPage.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<style type="text/css">

	.btn-group {
	    display: flex;
	    justify-content: center; /* 버튼 그룹 전체를 가운데 정렬 */
	    gap: 10px;               /* 버튼 사이 간격 */
	    margin-top: 15px;
	}
	
	.btn-group button {
	    padding: 10px 20px;
	    border: none;
	    border-radius: 5px;
	    cursor: pointer;
	    flex: 1; /* 버튼을 균등하게 나눔 (또는 원하면 auto) */
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
	
		<h1>문의수정</h1>
		<form action="/myPage/myQuestion/inquery/modify" method="post" enctype="multipart/form-data">
			<fieldset>
				<input type="hidden" name="inqueryIdx" value="${inqueryDTO.inqueryIdx }">
				<table >
					<tr>
						<th>이름</th>
						<td>${user.userName }</td>
						<th>문의시각</th>
						<td><fmt:formatDate value="${inqueryDTO.inqueryDatetime}" pattern="yy-MM-dd HH:mm:ss"/></td>
					</tr>
					<c:if test="${!empty inqueryDTO.classTitle }">
						<tr>
							<th style="white-space:nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 100px;">강의명</th>
							<td colspan="3">
								${inqueryDTO.classTitle }
								<input type="hidden" value="${inqueryDTO.classTitle }" readonly>
							</td>
						</tr>
					</c:if>
		        	<tr>
		        		<th>제목</th>
		        		<td colspan="3"> <input type="text" name="inqueryTitle" value="${inqueryDTO.inqueryTitle }"></td>
		        	</tr>
		        	<tr>
						<th colspan="4">문의내용</th>
					</tr>
		        	<tr>
		        	<td colspan="4"><textarea rows="20" cols="50" name="inqueryDetail">${inqueryDTO.inqueryDetail }</textarea></td>
				</table>
				<label for="file">첨부파일</label>
			
				<input type="file" class="custom-file-input" name="files" multiple>

				<c:forEach var="fileDTO" items="${inqueryDTO.fileList}">
					<div class="file_item">
						${fileDTO.originalFileName}
						<a href="/file/${fileDTO.fileId }?type=1" >
							<img src="/resources/images/download-icon.png" class="img_btn" title="다운로드" />
						</a>

						<a href="javascript:deleteFile(${fileDTO.fileId})">
							<img src="/resources/images/delete-icon.png" class="img_btn" title="삭제" />
						</a>
					</div>
				</c:forEach>
			</fieldset>
			<div class="btn-group">
				<button type="submit">수정완료</button>
				<button type="reset" >초기화</button>
				<button type="button" onclick="history.back()">취소</button>
			</div>

		</form>
		
	
	</div>
	
	</main>
		<script type="text/javascript">
		function deleteFile(fileId) {

			if(confirm("첨부파일을 삭제하시겠습니까?")) {
				location.href = "/myPage/myQuestion/fileDelete?fileId=" + fileId + "&inqueryIdx=${inqueryDTO.inqueryIdx}";
			}
		}
	</script>

</body>
</html>