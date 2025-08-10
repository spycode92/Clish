<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FAQ등록</title>
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
							<h5 class="section-title">FAQ 작성</h5>
						</div>
					</div>
					<div>
						<form action="/admin/faq/writeFaq" method="post">
							<table>
								<colgroup>
									<col width="20%">
									<col width="80%">
								</colgroup>
								<tbody>
									<tr>
										<th>제목</th>
										<td><input type="text" name="supportTitle" id="supportTitle" /></td>
									</tr>
									<tr>
										<th>카테고리</th>
										<td>
											<select name="supportCategory" id="supportCategory">
												<option value="강의수강" >강의수강</option>
												<option value="계정관리" >계정관리</option>
												<option value="결제환불" >결제환불</option>
											</select>
										</td>
									</tr>
									<tr>
										<th>내용</th>
										<td><textarea rows="10" cols="10" name="supportDetail" id="supportDetail"></textarea></td>
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
		</div>
	</div>
</body>
</html>