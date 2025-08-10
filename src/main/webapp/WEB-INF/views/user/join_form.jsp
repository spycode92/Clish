<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>회원가입</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/join_form.css">
	<link rel="preconnect" href="https://fonts.googleapis.com" >
	<link rel="preconnect" href="https://fonts.gstatic.com" >
	<link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Nanum+Myeongjo&family=Open+Sans:ital,wght@0,300..800;1,300..800&family=Orelega+One&display=swap" rel="stylesheet">
</head>
<body>
	<div class="join-wrapper">
		<div class="logo-area">
	     	<a href="${pageContext.request.contextPath}/">
				<img src="${pageContext.request.contextPath}/resources/images/logo_mini.png" alt="Clish" style="cursor:pointer;">
			</a>
	    </div>
		<h2>회원가입</h2>
		<form name="joinForm" action="${pageContext.request.contextPath}/user/register" method="post" enctype="multipart/form-data">
			<table border="1" style="width: 100%; text-align: left;">
				<!-- 기업인증영역 -->
				<c:if test="${sessionScope.userType == 2}">
					<tr>
						<th>사업자등록번호</th>
						<td>
							<input type="text" id="bizRegNo" name="bizRegNo" required>
						</td>
					</tr>
					<tr>
						<th>사업자등록증 업로드</th>
						<td>
							<input type="file" id="bizFile" name="bizFile" accept=".jpg,.jpeg,.png,.pdf" required>
							<span id="biz-file-result" style="margin-left: 10px; color: green;"></span>
						</td>
					</tr>
				</c:if>
		
				<!-- 공통 입력 영역 -->
				<tr>
					<th>이메일</th>
					<td>
						<div class="email-auth-wrap">
							<input type="email" id="userEmail" name="userEmail" />
							<button type="button" id="emailVerifyBtn">[이메일 인증]</button>
							<button type="button" id="checkEmailVerifiedBtn" style="display: none;">[인증 완료 확인]</button>
						</div>
						<span id="email-auth-result" style="color: red; margin-left: 10px;">이메일 인증 필요</span>
					</td>
				</tr>
			</table>
				
			<div class="required_auth">
				<table border="1" style="width: 100%; text-align: left;">
					<tr>
						<th><label for="userName"><c:if test="${sessionScope.userType == 1}">회원이름</c:if><c:if test="${sessionScope.userType == 2}">회사명</c:if></label></th>
						<td><input type="text" name="userName" id="userName" required></td>
					</tr>
			
					<tr>
					    <th>
					        <label for="userRepName">
					            <c:if test="${sessionScope.userType == 1}">닉네임</c:if>
					            <c:if test="${sessionScope.userType == 2}">대표관리자명</c:if>
					        </label>
					    </th>
					    <td>
					        <input type="text" name="userRepName" id="userRepName">
					        <span id="nicknameCheckResult"></span>
					    </td>
					</tr>
					
					<tr>
						<th><label for="userBirth"><c:if test="${sessionScope.userType == 1}">생년월일</c:if><c:if test="${sessionScope.userType == 2}">설립일</c:if></label></th>
						<td>
							<input type="date" name="userBirth" id="userBirth" max="9999-12-31" required>
							<span id="birthCheckResult"></span>
						</td>
					</tr>
			
					<c:if test="${sessionScope.userType == 1}">
						<tr>
							<th><label for="userGender">성별</label></th>
							<td>
								<select name="userGender" id="userGender" required>
									<option value="">선택</option>
									<option value="M">남자</option>
									<option value="F">여자</option>
								</select>
							</td>
						</tr>
					</c:if>
			
					<tr>
						<th><label for="userId">아이디</label></th>
						<td>
					        <input type="text" name="userId" id="userId">
					        <span id="idCheckResult"></span>
					    </td>
					</tr>
			
					<tr>
					    <th><label for="userPassword">비밀번호</label></th>
					    <td>
					    	<input type="password" name="userPassword" id="userPassword" required>
					   		<div id="checkPasswdResult" style="margin-top: 5px;"></div>
					    </td>
					</tr>
		
					<tr>
					    <th><label for="userPasswordConfirm">비밀번호 확인</label></th>
					    <td>
					        <input type="password" id="userPasswordConfirm" name="userPasswordConfirm" required>
					        <span id="pw-match-msg" style="margin-left: 10px;"></span>
					        <div id="checkPasswd2Result" style="margin-top: 5px;"></div>
					    </td>
					</tr>
					
					<tr>
						<th><label for="userPhoneNumber"><c:if test="${sessionScope.userType == 1}">휴대폰번호</c:if>
														<c:if test="${sessionScope.userType == 2}">대표관리자번호</c:if></label></th>
						<td>
							<div class="phone-input-group">
								<input type="text" id="userPhoneNumber1" maxlength="3" required> -
								<input type="text" id="userPhoneNumber2" maxlength="4" required> -
								<input type="text" id="userPhoneNumber3" maxlength="4" required>
								<input type="hidden" name="userPhoneNumber" id="userPhoneNumber" required>
							</div>
							<span id="phoneCheckResult"></span>
						</td>
					</tr>
			
					<tr>
						<th><label for="userPhoneNumberSub"><c:if test="${sessionScope.userType == 1}">비상연락망</c:if>
															<c:if test="${sessionScope.userType == 2}">기업전화번호</c:if></label></th>
						<td>
							<div class="SubPhone-input-group">
								<input type="text" id="userPhoneNumberSub1" maxlength="3" required> -
								<input type="text" id="userPhoneNumberSub2" maxlength="4" required> -
								<input type="text" id="userPhoneNumberSub3" maxlength="4" required>
								<input type="hidden" name="userPhoneNumberSub" id="userPhoneNumberSub" required>
							</div>
							<span id="SubPhoneCheckResult"></span>
						</td>
					</tr>
			
					<tr>
						<th>주소</th>
						<td>
							<input type="text" name="userPostcode" id="userPostcode" placeholder="우편번호" required readonly style="width: 150px;">
							<input type="button" value="주소검색" id="btnSearchAddress"><br>
							<input type="text" name="userAddress1" id="userAddress1" placeholder="기본주소" required readonly style="width: 70%;"><br>
							<input type="text" name="userAddress2" id="userAddress2" placeholder="상세주소" required style="width: 70%;">
						</td>
					</tr>
				</table>
			</div>
			
			<input type="hidden" name="userType" value="${sessionScope.userType}"/>
			
			<div style="margin-top:20px; margin-bottom:10px;">
				<input type="checkbox" id="agreeTerms">
				<label for="agreeTerms" style="cursor:pointer;">(임시) 약관에 동의합니다</label>
			</div>
			
			<p><button type="submit" id="submitBtn">회원가입</button></p>
		</form>
	</div>
</body>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="module"> 
	import { initEmailAuth } from '/resources/js/email/email_auth.js';
	import { initJoinForm } from '/resources/js/user/join_form.js';

	window.addEventListener("DOMContentLoaded", () => {
		initJoinForm();
		initEmailAuth("userEmail", "emailVerifyBtn", "email-auth-result", {purpose: "join"});
		// userEmail : 이메일 입력창 id
		// emailVerifyBtn : 버튼 id
		// email-auth-result : 이메일 인증 표시창 id
		// purpose : 용도 구분, 위에 3개만 입력해도 작동함
	});
</script>
</html>
