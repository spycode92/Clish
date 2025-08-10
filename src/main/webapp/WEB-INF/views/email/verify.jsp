<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% 
    String msg = (String) request.getAttribute("authResult");
    String verifiedEmail = (String) request.getAttribute("verifiedEmail"); // 인증된 이메일 전달받기
%>
<!DOCTYPE html>
<html>
<head>
    <title>이메일 인증</title>
</head>
<body>
    <div style="text-align: center; margin-top: 100px;">
        <h2>
            <%= msg != null ? msg : "인증에 실패했거나, 링크가 만료되었습니다." %>
        </h2>
        <script>
            setTimeout(() => window.close(), 1500);
        </script>
    </div>
</body>	
</html>
