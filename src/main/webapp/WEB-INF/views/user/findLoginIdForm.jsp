<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
<link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;700&display=swap" rel="stylesheet">
<style>
body {
    background: #fff;
    font-family: 'Open Sans', sans-serif;
    color: #222;
    margin: 0;
    padding: 0;
}
.findid-container {
    width: 100%;
    max-width: 340px;
    margin: 32px auto 0 auto;
    padding: 22px 24px 18px 24px;
    border-radius: 14px;
    box-shadow: 0 0 12px rgba(0,0,0,0.07);
    background: #fff;
}
.findid-title {
    font-size: 20px;
    color: #FF7601;
    font-weight: 700;
    margin-bottom: 22px;
    text-align: center;
}
.findid-form label {
    font-size: 15px;
    color: #222;
    font-weight: 500;
    margin-bottom: 5px;
    display: block;
}
.findid-form input[type="email"] {
    width: 93%;
    padding: 9px 10px;
    font-size: 15px;
    border: 1px solid #d9d9d9;
    border-radius: 7px;
    margin-bottom: 14px;
}
.findid-form button {
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
.findid-form button:hover {
    background: #00809D;
}
#findid-result {
    margin: 24px 0 0 0;
    text-align: center;
    font-size: 16px;
    color: #00809D;
    font-weight: 600;
    min-height: 36px;
}
#findid-confirm-btn {
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
</style>
</head>
<body>
<div class="findid-container">
    <div class="findid-title">아이디 찾기</div>
    <form class="findid-form" onsubmit="return false;">
        <label for="userEmail">가입 시 입력한 이메일</label>
        <input type="email" id="userEmail" required placeholder="가입한 이메일 입력">
        <button type="button" id="emailVerifyBtn">이메일 발송</button>
	    <button type="button" id="checkEmailVerifiedBtn" style="display:none;">이메일 인증 확인</button>
	    <span id="email-auth-result"></span>
    </form>
    <div id="findid-result" style="display:none;"></div>
    <button id="findid-confirm-btn" type="button" style="display:none;">확인</button>
</div>

<script type="module">
	import { initEmailAuth } from '/resources/js/email/email_auth.js';
    initEmailAuth("userEmail", "emailVerifyBtn", "email-auth-result", {purpose: "findLoginId"});
</script>

<script>
    function onFindIdSuccess(foundId) {
        document.getElementById('findid-result').style.display = 'block';
        document.getElementById('findid-result').innerText = "당신의 아이디는 '" + foundId + "' 입니다.";
        document.getElementById('findid-confirm-btn').style.display = 'inline-block';
        
        // 확인버튼 클릭시 부모창에 입력
        document.getElementById('findid-confirm-btn').onclick = function() {
            if(window.opener) {
                var userIdInput = window.opener.document.querySelector('input[name="userId"]');
                if(userIdInput) userIdInput.value = foundId;
                var rememberCheckbox = window.opener.document.querySelector('input[name="rememberId"]');
                if(rememberCheckbox) rememberCheckbox.checked = true;
                window.opener.document.cookie = "rememberId=" + encodeURIComponent(foundId) + ";path=/;max-age=2592000"; // 30일
            }
            window.close();
        };
    }
</script>
</body>
</html>
