<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원상세정보</title>
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
						<h3>기업 상세 정보</h3>
					</div>
					<form>
						<table border="1" style="width: 100%; text-align: left; margin: 0;">
							<tr>
								<th><label for="userName">회원이름</label></th>
								<td><input type="text" value="${company.userName}" readonly></td>
							</tr>
							<tr>
								<th><label for="userRepName">닉네임</label></th>
								<td><input type="text" value="${company.userRepName}" readonly></td>
							</tr>
							<tr>
								<th><label for="userBirth">기업설립일</label></th>
								<td><input type="date" value="${company.userBirth}" readonly></td>
							</tr>
							<tr>
								<th>사업자등록번호</th>
								<td>
									<input type="text"  value="${comDto.bizRegNo}">
								</td>
							</tr>
							<tr>
								<th>사업자등록증</th>
								<td>
									<div style="display: flex;">
										<div>
											${comDto.bizFileName}
											<a href="/file/${comDto.bizFilePath}?type=1">
												<input type="button" class="btn-download" value="다운로드"/>
											</a>
										</div>
									</div>
								</td>
							</tr>
							<tr>
								<th><label for="userGender">성별</label></th>
								<td><select disabled>
										<option value="N"
											<c:if test="${company.userGender eq 'M' }">selected</c:if>>선택없음</option>
										<option value="M"
											<c:if test="${company.userGender eq 'M' }">selected</c:if>>남자</option>
										<option value="F"
											<c:if test="${company.userGender eq 'F' }">selected</c:if>>여자</option>
								</select></td>
							</tr>
							<tr>
								<th><label for="userId">아이디</label></th>
								<td><input type="text" value="${company.userId}" readonly></td>
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
								<td><input type="text" value="${company.userEmail}" readonly></td>
							</tr>

							<tr>
								<th>주소</th>
								<td>
									<input type="text" value="${company.userPostcode}" readonly style="width: 150px;"> 
									<input type="button" value="주소검색" disabled><br>
									<input type="text" value="${company.userAddress1}" readonly style="width: 70%;"><br>
									<input type="text" value="${company.userAddress2}" readonly style="width: 70%;">
								</td>
							</tr>
						</table>
						<div class="button-wrapper">
							<button type="button" onclick="location.href='/admin/company?pageNum=${param.pageNum}'">닫기</button>
							<c:choose>
								<c:when test="${company.userStatus != 1}">
									<button type="submit" name="action" value="approval" 
											formaction="/admin/company/${company.userIdx}/approve" formmethod="post">승인</button>
								</c:when>
								<c:otherwise>
									<button type="submit" name="action" value="withdraw" 
											formaction="/admin/company/${company.userIdx}/withdraw" formmethod="post"
											onclick="return confirm('정말로 탈퇴 처리하시겠습니까?');"
											>탈퇴</button>
								</c:otherwise>
							</c:choose>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>