<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Clish개인정보정책</title>
   	<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
    
    <style>
        /* 모달 기본 스타일 */
        .modal {
            position: fixed;
            z-index: 1000;
            left: 0; top: 0;
            width: 100%; height: 100%;
            overflow: auto;
            background: rgba(0,0,0,0.4);
        }
        .modal-content {
            background: #fff;
            margin: 10% auto;
            padding: 30px 20px;
            border: 1px solid #888;
            max-width: 480px;
            min-width: 320px;
        }

    </style>
</head>
<body>
    <div id="privacyText" class="modal">
        <div class="modal-content">
            <h3>[필수] 개인정보 수집 및 이용 동의</h3>
            <p>
                본 사이트는 서비스 제공을 위해 아래와 같이 개인정보를 수집·이용합니다.<br><br>
                - 수집항목: 이름, 이메일, 연락처(휴대전화), 결제 정보 등<br>
                - 이용목적: 회원가입 및 관리, 서비스 제공, 결제 및 환불 처리, 문의사항 응대 등<br>
                - 보유기간: 회원 탈퇴 시 또는 관련 법령에 따라 보관 기간 종료 시까지<br><br>
                ※ 개인정보 제공에 동의하지 않으실 권리가 있으나, 동의를 거부하실 경우 서비스 이용 및 결제 등이 제한될 수 있습니다.
            </p>
        </div>
    </div>

</body>
</html>