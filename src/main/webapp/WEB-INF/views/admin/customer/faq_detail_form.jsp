<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FAQ상세정보</title>
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
							<h5 class="section-title">FAQ 상세 정보</h5>
						</div>
					</div>
					<div>
						<form action="/admin/faq/modify" method="post">
							<input type="hidden" name="supportIdx"  id="supportIdx" value="${support.supportIdx}"/>
							<table>
								<colgroup>
									<col width="20%">
									<col width="80%">
								</colgroup>
								<tbody>
									<tr>
										<th>제목</th>
										<td><input type="text" name="supportTitle" id="supportTitle" value="${support.supportTitle}"/></td>
									</tr>
									<tr>
										<th>카테고리</th>
										<td>
											<select name="supportCategory" id="supportCategory">
												<option value="강의수강" <c:if test="${support.supportCategory eq '강의수강'}">selected</c:if>>강의수강</option>
												<option value="계정관리" <c:if test="${support.supportCategory eq '계정관리'}">selected</c:if>>계정관리</option>
												<option value="결제환불" <c:if test="${support.supportCategory eq '결제환불'}">selected</c:if>>결제환불</option>
											</select>
										</td>
									</tr>
									<tr>
										<th>내용</th>
										<td><textarea rows="10" cols="10" name="supportDetail" id="supportDetail">${support.supportDetail}</textarea></td>
									</tr>
								</tbody>
							</table>
							<div class="button-wrapper">
								<button type="submit" >수정하기</button>
								<button type="button" onclick="location.href='/admin/faq'">취소</button>
							</div>
						</form>
					</div>
				
				</div>
			</div>
		</div>
	</div>
</body>
</html>