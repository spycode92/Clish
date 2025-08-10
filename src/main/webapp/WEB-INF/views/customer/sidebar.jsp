<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="sidebar" id="sidebar">
	<ul class="category-list ">

		<li class="sidebar-title">
			<span class="sidebar-toggle" onclick="toggleSidebar()">≡</span>
			
				<strong>고객 센터</strong>
			
		</li>

			<li><a href="/customer/announcements">공지사항</a></li>
			<li><a href="/customer/FAQ">FAQ</a></li>
			<li><a href="/customer/inquiry">문의 게시판</a></li>

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
