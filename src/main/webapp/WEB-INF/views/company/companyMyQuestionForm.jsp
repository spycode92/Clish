<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 사이트 문의 작성</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<style>
  /* ✅ 전체 컨테이너: flex로 사이드바와 본문 배치 */
  .container {
    display: flex;
    min-height: calc(100vh - 160px); /* header + footer 높이 감안 (필요시 조정) */
  }

  /* ✅ 왼쪽 사이드바 */
  .sidebar {
    width: 200px;
    background-color: #f8f8f8;
    padding: 30px 20px;
    overflow: hidden;
    white-space: nowrap;
    box-sizing: border-box;
  }

  /* ✅ 오른쪽 본문 영역 */
  .content-area {
    flex: 1;
    display: flex;
    justify-content: center;     /* 수평 가운데 */
    align-items: flex-start;     /* 위로 정렬 */
    padding-top: 50px;           /* 위쪽 여백 */
    padding-bottom: 60px;        /* 아래쪽 여백 */
    box-sizing: border-box;
  }

  /* ✅ 폼 래퍼 */
  .form-wrapper {
    max-width: 800px;
    width: 100%;
    padding: 20px;
    margin: 0 auto;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    margin: 0px !important;
  }

  th, td {
    padding: 10px;
    vertical-align: top;
    border-bottom: 1px solid #ddd;
  }

  th {
    width: 120px;
    text-align: left;
    background-color: #f4f4f4;
  }

  textarea {
    width: 100%;
    height: 150px;
  }

  .btn-wrap {
    text-align: center;
    margin-top: 30px;
  }

  .btn-wrap button {
    padding: 10px 20px;
    margin: 0 10px;
  }
</style>
</head>
<body>
	<header>
	    <jsp:include page="/WEB-INF/views/inc/top.jsp" />
	</header>
	
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/company/comSidebar.jsp" />
		</div>
	
		<div class="content-area">
		  	<div class="form-wrapper">
			    <h2>사이트 문의 <c:out value="${empty inqueryDTO ? '등록' : '수정'}"/></h2>
			
			    <!-- ✅ form action JSTL로 분기해서 변수에 저장 -->
			    <c:choose>
					<c:when test="${empty inqueryDTO}">
						<c:set var="formAction" value="/company/myPage/writeInquery"/>
					</c:when>
				<c:otherwise>
					<c:set var="formAction" value="/company/myPage/modifyInquery"/>
				</c:otherwise>
				</c:choose>
		
			    <!-- ✅ 하나의 form 태그 -->
			    <form action="${pageContext.request.contextPath}${formAction}" method="post" enctype="multipart/form-data">
					<!-- 고정 값 -->
					<input type="hidden" name="inqueryType" value="2" />
					<input type="hidden" name="userIdx" value="${sessionScope.userIdx}" />
		
				<c:if test="${not empty inqueryDTO.inqueryIdx}">
					<input type="hidden" name="inqueryIdx" value="${inqueryDTO.inqueryIdx}" />
				</c:if>
		
				<table>
			        <tr>
						<th>제목</th>
						<td>
							<input type="text" name="inqueryTitle" value="${inqueryDTO.inqueryTitle}" required />
						</td>
			        </tr>
			        <tr>
						<th>내용</th>
						<td>
							<textarea name="inqueryDetail" required>${inqueryDTO.inqueryDetail}</textarea>
						</td>
			        </tr>
				</table>
		
				<div class="btn-wrap">
					<button type="submit"><c:out value="${empty inqueryDTO ? '등록' : '수정'}"/></button>
					<button type="button" onclick="history.back()">취소</button>
				</div>
				</form>
			</div>
		</div>
	</div>
	
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp" />
	</footer>
	
</body>
</html>
