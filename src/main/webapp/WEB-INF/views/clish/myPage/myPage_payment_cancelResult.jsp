<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>결제취소 영수증</title>
    <link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
    <script src="https://cdn.portone.io/v2/browser-sdk.js" async defer></script>
    <style>
        body {
            background: #f7f7f7;
            font-family: 'Pretendard', 'Malgun Gothic', sans-serif;
            margin: 0;
            padding: 0;
        }
        .receipt-container {
            background: #e1d8d8;
            margin: 40px auto;
            padding: 32px 36px 40px 36px;
            border-radius: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.13);
            width: 410px;
            max-width: 95vw;
        }
        .receipt-header {
            text-align: center;
            margin-bottom: 26px;
        }
        .receipt-header img {
            height: 48px;
            margin-bottom: 14px;
        }
        .receipt-title {
            font-size: 1.5em;
            font-weight: 700;
            margin-bottom: 6px;
        }
        .receipt-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0 auto 14px auto;
        }
        .receipt-table th, .receipt-table td {
            padding: 10px 9px;
            font-size: 1em;
        }
        .receipt-table th {
            background: #fafbfc;
            text-align: left;
            color: #555;
            font-weight: 600;
            width: 44%;
            border-bottom: 1.5px solid #eee;
        }
        .receipt-table td {
            background: #fff;
            color: #181818;
            border-bottom: 1px solid #f0f0f0;
            word-break: break-all;
        }
        .receipt-table tr:last-child td, 
        .receipt-table tr:last-child th {
            border-bottom: none;
        }
        .receipt-links a {
            display: inline-block;
            margin-right: 12px;
            color: #1369d8;
            text-decoration: underline;
            font-size: 0.98em;
        }
        .receipt-footer {
            margin-top: 18px;
            text-align: center;
        }
        input[type="button"] {
            padding: 8px 35px;
            border: none;
            background: #1369d8;
            color: white;
            font-size: 1em;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.15s;
        }
        input[type="button"]:hover {
            background: #084f98;
        }
    </style>
</head>
<body>
<div class="receipt-container">
    <div class="receipt-header">
        <img src="/resources/images/logo4-2.png" alt="로고"/>
        <div class="receipt-title">결제취소 정보</div>
        <div style="font-size:0.9em; color:#9a9a9a;">${cancelTime}</div>
    </div>
    <table class="receipt-table">
        <tr>
            <th>메시지</th>
            <td>${message}</td>
        </tr>
        <tr>
            <th>결제취소 번호</th>
            <td>${paymentCancel.impUid}</td>
        </tr>
        <tr>
            <th>결제 금액</th>
            <td><fmt:formatNumber value="${paymentCancel.amount}" type="number" maxFractionDigits="0" /> 원</td>
        </tr>
        <tr>
            <th>결제취소 금액</th>
            <td><fmt:formatNumber value="${paymentCancel.cancelAmount}" type="number" maxFractionDigits="0" /> 원</td>
        </tr>
        <tr>
            <th>결제취소 상태</th>
            <td>
            	<c:if test="${paymentCancel.status  eq 'cancelled'}">취소완료 </c:if>	
            </td>
        </tr>
        <tr>
            <th>결제취소 사유</th>
            <td>${paymentCancel.cancelReason}</td>
        </tr>
        <tr>
            <th>회원</th>
            <td>${paymentCancel.userName}</td>
        </tr>
        <tr>
            <th>결제 방법</th>
            <td>${paymentCancel.payMethod}</td>
        </tr>
        <tr>
            <th>영수증 링크</th>
            <td class="receipt-links">
                <a href="${paymentCancel.receiptUrl}" target="_blank">🧾 결제 영수증</a>
                <a href="${paymentCancel.cancelReceiptUrl}" target="_blank">🧾 결제취소 영수증</a>
            </td>
        </tr>
    </table>
    <div class="receipt-footer">
        <input type="button" value="확인" onclick="window.close()">
    </div>
</div>
</body>
</html>