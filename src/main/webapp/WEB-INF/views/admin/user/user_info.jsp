<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원상세정보</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap"
	rel="stylesheet">
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
						<h3>회원 상세 정보</h3>
					</div>
					<form action="/admin/user/${user.userIdx}/withdraw" method="POST">
						<table border="1" style="width: 100%; text-align: left; margin: 0;">
							<tr>
								<th><label for="userName">회원이름</label></th>
								<td><input type="text" value="${user.userName}" readonly></td>
							</tr>

							<tr>
								<th><label for="userRepName">닉네임</label></th>
								<td><input type="text" value="${user.userRepName}" readonly></td>
							</tr>

							<tr>
								<th><label for="userBirth">생년월일</label></th>
								<td><input type="date" value="${user.userBirth}" readonly></td>
							</tr>
							<tr>
								<th><label for="userGender">성별</label></th>
								<td><select disabled>
										<option value="M"
											<c:if test="${user.userGender eq 'M' }">selected</c:if>>남자</option>
										<option value="F"
											<c:if test="${user.userGender eq 'F' }">selected</c:if>>여자</option>
								</select></td>
							</tr>
							<tr>
								<th><label for="userId">아이디</label></th>
								<td><input type="text" value="${user.userId}" readonly></td>
							</tr>
							<tr>
								<th><label for="userPhoneNumber">휴대폰번호</label></th>
								<td><input type="text" value="${phone}" readonly></td>

							</tr>
							<tr>
								<th><label for="userPhoneNumberSub">비상연락망</label></th>
								<td><input type="text" value="${phoneSub}" readonly></td>
							</tr>
							<tr>
								<th><label for="userEmail">이메일</label></th>
								<td><input type="text" value="${user.userEmail}" readonly></td>
							</tr>

							<tr>
								<th>주소</th>
								<td>
									<input type="text" value="${user.userPostcode}" readonly style="width: 150px;"> 
									<input type="button" value="주소검색" disabled><br>
									<input type="text" value="${user.userAddress1}" readonly style="width: 70%;"><br>
									<input type="text" value="${user.userAddress2}" readonly style="width: 70%;">
								</td>
							</tr>
						</table>
						<div class="button-wrapper">
							<button type="button" onclick="location.href='/admin/user'">닫기</button>
							<button type="submit" onclick="return confirm('정말로 탈퇴 처리하시겠습니까?');">탈퇴</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>