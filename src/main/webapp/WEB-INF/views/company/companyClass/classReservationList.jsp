<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- ✅ 모달에 AJAX로 로딩되는 부분이므로 HTML 구조 제거함 --%>
<%-- ✅ 전체 레이아웃 없이 테이블만 출력되도록 수정함 --%>

<table border="1" cellpadding="8" style="width:100%; border-collapse: collapse; margin-left: 0px;">
	<thead>
		<tr>
			<th>이름</th>
			<th>전화번호</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="r" items="${reservationList}">
			<tr>
				<td>${r.name}</td>
				<td>${r.phone}</td>
			</tr>
		</c:forEach>
		
		<%-- 예약자가 없을 때 메시지 출력 --%>
		<c:if test="${empty reservationList}">
			<tr>
				<td colspan="2" style="text-align:center;">예약자가 없습니다.</td>
			</tr>
		</c:if>
	</tbody>
</table>