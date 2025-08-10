<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="sidebar" id="sidebar">
	<ul class="category-list">
		<c:choose>
			<c:when test="${param.classType eq 0}">
				<c:set var="classType" value="정기 강의" />
			</c:when>
			<c:otherwise>
				<c:set var="classType" value="단기 강의" />
			</c:otherwise>
		</c:choose>
		<li class="sidebar-title">
			<span class="sidebar-toggle" onclick="toggleSidebar()">≡</span>
			<a href="/course/user/classList?classType=${param.classType}">
				<strong>${classType}</strong>
			</a>
		</li>
		<c:forEach var="Pcat" items="${parentCategories}">
			<li class="parent-category">
				<span onclick="toggleSubmenu(this)">
					${Pcat.categoryName} ▼
				</span>
				<ul class="child-category">
					<c:forEach var="Ccat" items="${childCategories}">
						<c:if test="${Ccat.parentIdx eq Pcat.categoryIdx}">
							<li>
								<a href="/course/user/classList?classType=${param.classType}&categoryIdx=${Ccat.categoryIdx}">
									${Ccat.categoryName}
								</a>
							</li>
						</c:if>
					</c:forEach>
				</ul>
			</li>
		</c:forEach>
	</ul>
</div>
<script>
	function toggleSubmenu(element) {
		const li = element.closest('.parent-category');
		li.classList.toggle('open');
	}
	function toggleSidebar() {
		const sidebar = document.getElementById('sidebar');
		sidebar.classList.toggle('closed');
		const openToggle = document.getElementById('sidebar-open-toggle');
		if (sidebar.classList.contains('closed')) {
			if (openToggle) openToggle.style.display = "flex";
		} else {
			if (openToggle) openToggle.style.display = "none";
		}
	}
</script>
<!-- sidebar 닫혔을 때만 표시되는 고정 버튼 -->
<span id="sidebar-open-toggle" onclick="toggleSidebar()">≡</span>
