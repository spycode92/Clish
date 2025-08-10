<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 문의</title>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<link
	href="${pageContext.request.contextPath}/resources/css/admin/modal.css"
	rel="stylesheet" type="text/css">
<style type="text/css">
.status-pending {
    background-color: #f8d7da; 
    color: #721c24;           
    padding: 4px 8px;
    border-radius: 4px;
    font-weight: bold;
    font-size: 0.9rem;
}

.status-complete {
    background-color: #d4edda; 
    color: #155724;
    padding: 4px 8px;
    border-radius: 4px;
    font-weight: bold;
    font-size: 0.9rem;
}

.status-hold {
    background-color: #fff3cd; 
    color: #856404;
    padding: 4px 8px;
    border-radius: 4px;
    font-weight: bold;
    font-size: 0.9rem;
}
</style>
</head>
<body>
	<c:if test="${not empty msg}">
		<script>
	    	alert("${msg}");
	    </script>
	</c:if>
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"></jsp:include>	
		</div>
		<div class="modal" id="inquiry-modal">
			<div class="modal_body">
				<h3>문의 상세 정보</h3>
				<form id="modal-form" action="/admin/inquiry/write" method="post" >
					<input type="hidden" name="inqueryIdx" id="inquiry-idx"/>
					<input type="hidden" name="userIdx" id="user-idx"/>
					<table>
						<colgroup>
							<col width="30%">
							<col width="70%">
						</colgroup>
						<tbody>
							<tr>
								<th>작성자</th>
								<td><span id="inquiry-user"></span></td>
							</tr>
							<tr>
								<th>작성일</th>
								<td><span id="inquiry-date"></span></td>
							</tr>
							<tr>
								<th>문의유형</th>
								<td><span id="inquiry-type"></span></td>
							</tr>
							<tr>
								<th>문의내용</th>
								<td><div id="inquiry-detail"></div></td>
							</tr>
							<tr style="border-bottom: 2px solid #d8d3d3">
								<th>첨부파일</th>
								<td> <div class="file-container"></div></td>
							</tr>
							<tr>
								<th>답변</th>
								<td><textarea rows="10" cols="10" id="inquiry-answer" name="inqueryAnswer"></textarea></td>
							</tr>
						</tbody>
					</table>
					<div class="button-wrapper">
						<button type="submit" id="btn"></button>
						<button type="button" onclick="location.href='/admin/inquiry?pageNum=${pageInfo.pageNum}'">취소</button>
					</div>
				</form>
			</div>
		</div>
		<div class="main">
			<jsp:include page="/WEB-INF/views/admin/header.jsp"></jsp:include>
			<div class="main_container">
				<div class="bg-light">
					<div>
						<div class="flex">
							<h5 class="section-title">문의관리</h5>
						</div>
					</div>
					<div>
						<div style="height: 450px;">
							<table>
								<colgroup>
									<col width="10%">
									<col width="35%">
									<col width="20%">
									<col width="20%">
									<col width="15%">
								</colgroup>
								<thead>
									<tr>
										<th>문의유형</th>
										<th>제목</th>
										<th>작성자</th>
										<th>등록일</th>
										<th>답변여부</th>
										<th></th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="inquiry" items="${inquiryList}" varStatus="status" >
										<tr onclick="onModal('${inquiry.inquiry.inqueryIdx}')">
											<td>1:1문의</td>
											<td>${inquiry.inquiry.inqueryTitle}</td>
											<td>${inquiry.userName}</td>
											<td><fmt:formatDate value="${inquiry.inquiry.inqueryDatetime}" pattern="yyyy-MM-dd" /></td>
											<td>											
												<c:choose>
													<c:when test="${inquiry.inquiry.inqueryStatus eq 1}"><span class="status-pending">미답변</span></c:when>
													<c:when test="${inquiry.inquiry.inqueryStatus eq 2}"><span class="status-complete">답변완료</span></c:when>
													<c:otherwise><span class="status-hold">보류</span></c:otherwise>
												</c:choose>
											</td>
										</tr>
									</c:forEach>									
								</tbody>
							</table>
						</div>
					</div>
					<div style="display: flex; align-items: center; justify-content: center; margin-top: 30px;">
						<div>
							<c:if test="${not empty pageInfo.maxPage or pageInfo.maxPage > 0}">
								<input type="button" value="이전" 
									onclick="location.href='/admin/inquiry?pageNum=${pageInfo.pageNum - 1}'" 
									<c:if test="${pageInfo.pageNum eq 1}">disabled</c:if>>
								
								<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
									<c:choose>
										<c:when test="${i eq pageInfo.pageNum}">
											<strong>${i}</strong>
										</c:when>
										<c:otherwise>
											<a href="/admin/inquiry?pageNum=${i}">${i}</a>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								
								<input type="button" value="다음" 
									onclick="location.href='/admin/inquiry?pageNum=${pageInfo.pageNum + 1}'" 
								<c:if test="${pageInfo.pageNum eq pageInfo.maxPage}">disabled</c:if>>
							</c:if>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		function onModal(inqueryIdx) {
			const modal = document.querySelector('#inquiry-modal');
		  	modal.style.display = "block";

			fetch("/admin/inquiry/detail/" + inqueryIdx)
		      .then(res => res.json())
		      .then(data => {
		       	 document.querySelector("#inquiry-idx").value = data.inquiry.inqueryIdx;
		       	 document.querySelector("#user-idx").value = data.inquiry.userIdx;
		       	 document.querySelector("#inquiry-user").innerText = data.userName;
		       	 document.querySelector("#inquiry-date").innerText = formattedDate(data.inquiry.inqueryDatetime);
		       	 document.querySelector("#inquiry-type").innerText = data.inqueryType === 1 && "1:1문의";
		         document.querySelector("#inquiry-detail").innerText = data.inquiry.inqueryDetail;
		         document.querySelector("#inquiry-answer").value = data.inquiry.inqueryAnswer || "";
		         document.querySelector("#btn").textContent = data.inquiry.inqueryAnswer ? "수정" : "등록";
		         
		         // 파일 리스트 렌더링
		         fileList(data.inquiry.fileList)
		    })
		      .catch(err => console.error("문의 상세 조회 실패", err));
		}
		
		function fileList(fileList) {
			const fileContainer = document.querySelector("#inquiry-modal .file-container");
			fileContainer.innerHTML = "";
			
			if (fileList && fileList.length > 0) {
				fileList.forEach((file) => {
					const div = document.createElement("div");
					div.innerHTML =
					    file.originalFileName +
					    '<a href="/file/' + file.fileId + '?type=1">' +
					    '    <img src="/resources/images/download-icon.png" class="img_btn" title="다운로드" />' +
					    '</a>';
		            fileContainer.appendChild(div);
		        });
		    } else {
		        fileContainer.innerHTML = "<span>첨부된 파일이 없습니다.</span>";
		    }
		}

		function formattedDate(timestamp) {
			const date = new Date(timestamp);
			const fmt = date.toLocaleString("ko-KR", {
				year: "numeric",
				month: "2-digit",
				day: "2-digit",
				hour: "2-digit",
			});
			
			return fmt;
		}
	</script>
</body>
</html>