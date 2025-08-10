<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트상세정보</title>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<style type="text/css">
.event-detail-container {
	display: flex;
	flex-direction: column;
	margin-left: 30px;
	align-items: center;
}

.event-info {
	width: 500px;
	text-align: left;
}

.event-thumbnail, .event-content {
	display: flex;
	display: flex;
	flex-direction: column;
}

</style>
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
						<div class="flex">
							<h5 class="section-title">이벤트 상세 정보</h5>
						</div>
					</div>
					<div class="event-detail-container">
						<table>
							<colgroup>
								<col width="20%">
								<col width="80%">
							</colgroup>
							<tr>
								<th>제목 :</th>
								<td>${eventDTO.eventTitle}</td>
							</tr>
							<tr>
								<th>날짜 :</th>
								<td>${eventDTO.eventStartDate} ~ ${eventDTO.eventEndDate}</td>
							</tr>
							<tr>
								<th>상태 :</th>
								<td>
									<c:choose>
							    		<c:when test="${eventDTO.eventInProgress eq 0}">
							    			<span>종료</span>
							    		</c:when>
							    		<c:when test="${eventDTO.eventInProgress eq 1}">
							    			<span>진행중</span>
							    		</c:when>
							    		<c:otherwise>
									    	<span>예정</span>
							    		</c:otherwise>
							    	</c:choose>
								</td>
							</tr>
							<tr>
								<th>썸네일</th>
								<td><img src="/file/${thumbnailFile.fileId}?type=2"  alt="이벤트 썸네일" width="500px;"/></td>
							</tr>
							<tr>
								<th>이벤트 본문</th>
								<td><img src="/file/${contentFile.fileId}?type=0"  alt="이벤트 내용 이미지" width="500px;"/></td>
							</tr>
						</table>
					</div>
					<div class="button-wrapper">
						<button onclick="location.href='/admin/event/modify/${eventDTO.eventIdx}'">수정</button>
						<button onclick="deleteEvent('${eventDTO.eventIdx}')">삭제</button>
						<button onclick="location.href='/admin/event/?pageNum=${param.pageNum}'">목록</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		function deleteEvent(idx) {
			if (confirm("삭제하시겠습니까?")) {
				location.href="/admin/event/delete/" + idx;
			}
		}
	</script>
</body>
</html>