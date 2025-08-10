<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
<link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;700&display=swap" rel="stylesheet">
<style>
body {
    background: #fff;
    font-family: 'Open Sans', sans-serif;
    color: #222;
    margin: 0;
    padding: 0;
}
.changePasswd-container {
    width: 100%;
    max-width: 340px;
    margin: 32px auto 0 auto;
    padding: 22px 24px 18px 24px;
    border-radius: 14px;
    box-shadow: 0 0 12px rgba(0,0,0,0.07);
    background: #fff;
}


.changePasswd-title {
    font-size: 20px;
    color: #FF7601;
    font-weight: 700;
    margin-bottom: 22px;
    text-align: center;
}
.changePasswd-form label {
    font-size: 15px;
    color: #222;
    font-weight: 500;
    margin-bottom: 5px;
    display: block;
}
.changePasswd-form input[type="text"], input[type="email"], input[type="password"] {
    width: 93%;
    padding: 9px 10px;
    font-size: 15px;
    border: 1px solid #d9d9d9;
    border-radius: 7px;
    margin-bottom: 14px;
}

.changePasswd-form button {
    width: 100%;
    padding: 10px 0;
    background: #FF7601;
    color: #fff;
    border: none;
    border-radius: 7px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    margin-bottom: 6px;
    transition: background 0.18s;
}

#pw-change-form button {
    width: 100%;
    padding: 10px 0;
    background: #FF7601;
    color: #fff;
    border: none;
    border-radius: 7px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    margin-bottom: 6px;
    transition: background 0.18s;
}

.changePasswd-form button:hover {
    background: #00809D;
}

#pw-change-form button:hover {
    background: #00809D;
}
#changePasswd-result {
    margin: 24px 0 0 0;
    text-align: center;
    font-size: 16px;
    color: #00809D;
    font-weight: 600;
    min-height: 36px;
}
#changePasswd-confirm-btn {
    width: 80px;
    padding: 8px 0;
    background: #00809D;
    color: #fff;
    border: none;
    border-radius: 7px;
    font-size: 15px;
    font-weight: 500;
    margin-top: 18px;
    cursor: pointer;
    display: none;   
}

.pw-check-result {
    display: block;
    margin-top: -10px;   
    margin-bottom: 8px;   
    font-size: 14px;
    color: #888;
    min-height: 18px;  
}

.pw-check-result2 {
    display: block;
    margin-top: -10px;
    margin-bottom: 8px;
    font-size: 14px;
    min-height: 18px;
    color: #888;
}

</style>
</head>
<body>
<div class="changePasswd-container">
    <div class="changePasswd-title">비밀번호 찾기</div>
    <form class="changePasswd-form" onsubmit="return false;">
    	<label for="userId">아이디 입력</label>
    	<input type="text" id="userId" required placeholder="가입한 아이디 입력">
        <label for="userEmail">가입 시 입력한 이메일</label>
        <input type="email" id="userEmail" required placeholder="가입한 이메일 입력">
        <button type="button" id="emailVerifyBtn">이메일 발송</button>
	    <button type="button" id="checkEmailVerifiedBtn" style="display:none;">이메일 인증 확인</button>
	    <span id="email-auth-result"></span>
    </form>
    
    <div id="changePasswd-result" style="display:none;"></div>
    <button id="changePasswd-confirm-btn" type="button" style="display:none;">확인</button>
    
    <div id="pw-change-form" style="display:none;">
   		<label>새 비밀번호</label>
	    <input type="password" class="password1" placeholder="새 비밀번호 입력">
	    <span class="pw-check-result"></span>
	    
	    <label>비밀번호 확인</label>
	    <input type="password" class="password2" placeholder="비밀번호 확인">
	    <span class="pw-check-result2"></span>
	    
	    <button type="button" class="pw-change-btn">비밀번호 변경</button>
	    <span class="pw-change-result"></span>
	</div>
</div>


<script type="module">
import { initEmailAuth } from '/resources/js/email/email_auth.js';
import { initPasswordChangeModule } from '/resources/js/common/resetPasswd.js';

initEmailAuth("userEmail", "emailVerifyBtn", "email-auth-result", {purpose: "changePasswd"});

// 인증 성공시 실행
window.onEmailAuthSuccess = function() {
	document.getElementById('userId').readOnly = true;
    document.getElementById('pw-change-form').style.display = 'block';
    
	// 폼이 보여졌을 때 모듈 초기화 (폼 셀렉터, 유저정보 전달)
    initPasswordChangeModule({
        formSelector: "#pw-change-form",
        userId: document.getElementById('userId').value,
        userEmail: document.getElementById('userEmail').value
    });
};
</script>

</body>
</html>



