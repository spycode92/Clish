<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항상세정보</title>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
</head>
<body>
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"></jsp:include>	
		</div>
		<div class="main">
			<jsp:include page="/WEB-INF/views/admin/header.jsp"></jsp:include>
			<div class="main_container">
				<div class="bg-light">
					<div>
						<div>
							<h5 class="section-title">공지사항 상세 정보</h5>
						</div>
					</div>
					<div>
						<form action="/admin/notice/modify" method="post" enctype="multipart/form-data">
							<input type="hidden" name="supportIdx"  id="supportIdx" value="${support.supportIdx}"/>
							<input type="hidden" name="supportCategory"  id="supportCategory" value="${support.supportCategory}"/>
							<table>
								<colgroup>
									<col width="20%">
									<col width="80%">
								</colgroup>
								<tbody>
									<tr>
										<th>작성자</th>
										<td><input type="text" value="운영자" disabled/></td>
									</tr>
									<tr>
										<th>제목</th>
										<td><input type="text" name="supportTitle" id="supportTitle" value="${support.supportTitle}"/></td>
									</tr>
									<tr>
										<th>내용</th>
										<td><textarea rows="10" cols="10" name="supportDetail" id="supportDetail">${support.supportDetail}</textarea></td>
									</tr>
									<tr>
										<th>파일첨부</th>
										<td>
											<c:choose>
												<c:when test="${empty support.fileList}">
													<input type="file" class="custom-file-input" name="files" multiple>
												</c:when>
												<c:otherwise>
													<c:forEach var="fileDTO" items="${support.fileList}">
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
								<button type="submit" >수정</button>
								<button type="button" onclick="location.href='/admin/notice?pageNum=${param.pageNum}'">취소</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		function deleteFile(fileId) {
	
			if(confirm("첨부파일을 삭제하시겠습니까?")) {
				location.href = "/admin/notice/fileDelete?fileId=" + fileId + "&supportIdx=${support.supportIdx}";
			}
		}
	</script>
</body>
</html>