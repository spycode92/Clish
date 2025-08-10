<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트수정</title>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
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
						<div>
							<h5 class="section-title">이벤트 수정</h5>
						</div>
					</div>
					<div>
						<form action="/admin/event/modify" method="post" enctype="multipart/form-data" id="modifyForm">
							<input type="hidden" name="eventIdx" value="${eventDTO.eventIdx }"/>
							<table>
								<colgroup>
									<col width="20%">
									<col width="80%">
								</colgroup>
								<tbody>
									<tr>
										<th>제목<span style="vertical-align: middle; margin-left: 5px; color: red;">*</span></th>
										<td><input type="text" name="eventTitle" id="eventTitle" value="${eventDTO.eventTitle}" required/></td>
									</tr>
									<tr>
										<th>이벤트 상태<span style="vertical-align: middle; margin-left: 5px; color: red;">*</span></th>
										<td>
											<label for="event-progress-ended">
												<input type="radio" id="event-progress-active" name="eventInProgress" value="0" class="eventInProgress"
													<c:if test="${eventDTO.eventInProgress eq 0}">checked</c:if>/>
												종료
											</label>
											<label for="event-progress-active">
												<input type="radio" id="event-progress-active" name="eventInProgress" value="1" class="eventInProgress"
													<c:if test="${eventDTO.eventInProgress eq 1}">checked</c:if>/>
												진행중											
											</label>
											<label for="event-progress-upcoming">
												<input type="radio" id="event-progress-upcoming"" name="eventInProgress" value="2" class="eventInProgress"
													<c:if test="${eventDTO.eventInProgress eq 2}">checked</c:if>/>
												예정
											</label>
										</td>
									</tr>
									<tr>
										<th>썸네일<span style="vertical-align: middle; margin-left: 5px; color: red;">*</span></th>
										<td>
											<c:choose>
												<c:when test="${not empty thumbnailFile}">
													${thumbnailFile.originalFileName}
													<a href="javascript:deleteFile(${thumbnailFile.fileId}, 'thumbnail')">
														<img src="/resources/images/delete-icon.png" class="img_btn" title="삭제" />
													</a>
												</c:when>
												<c:otherwise>
													<input type="file" name="thumbnailFile" required />
													<input type="hidden" name="fileTypes" value="thumbnail" />
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<th>이벤트페이지<span style="vertical-align: middle; margin-left: 5px; color: red;">*</span></th>
										<td>
											<c:choose>
												<c:when test="${not empty contentFile}">
													${contentFile.originalFileName}
													<a href="javascript:deleteFile(${contentFile.fileId}, 'content')">
														<img src="/resources/images/delete-icon.png" class="img_btn" title="삭제" />
													</a>
												</c:when>
												<c:otherwise>
													<input type="file" name="contentFile" required />
													<input type="hidden" name="fileTypes" value="content" />
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<th>내용</th>
										<td><textarea rows="5" cols="5" name="eventDescription" id="eventDescription">${eventDTO.eventDescription}</textarea></td>
									</tr>
									<tr>
										<th>적용기간<span style="vertical-align: middle; margin-left: 5px; color: red;">*</span></th>
										<td>
											<div style="display: flex; align-items: center; justify-content: space-between;">
												<div style="width: 400px;">
													<label for="startDate">시작날짜</label>
													<input type="date" id="startDate" name="eventStartDate" value="${eventDTO.eventStartDate}"/>
												</div>
												<div style="width: 400px;">
													<label for="endDate">종료날짜</label>
													<input type="date" id="endDate" name="eventEndDate" value="${eventDTO.eventEndDate}" required/>
												</div>
											</div>
											<span id="startDateError" style="color: red; display: none;"></span>
										</td>
									</tr>
								</tbody>
							</table>
							<div class="button-wrapper">
								<button type="submit" >등록</button>
								<button type="button" onclick="location.href='/admin/event/detail/${eventDTO.eventIdx}'">취소</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		function deleteFile(fileId, type) {
			if(confirm("첨부파일을 삭제하시겠습니까?")) {
				location.href = "/admin/event/fileDelete?fileId=" + fileId + "&type=" + type + "&idx=${eventDTO.eventIdx}";
			}
		}
		
		// 수정 폼 제출
		document.getElementById("modifyForm").addEventListener("submit", (e) => {
			// 날짜 비교 검사
			const startInput = document.getElementById("startDate");
			const endInput = document.getElementById("endDate");
			const errorSpan = document.getElementById("startDateError");
			 const radioButtons = document.querySelectorAll(".eventInProgress");
			
			const startDate = new Date(startInput.value);
			const endDate = new Date(endInput.value);
			const today = new Date();
			
			// 라디오 버튼 유효성 검사
			const selectedRadio  = [...radioButtons].find(radio => radio.checked);
			const selectedValue = selectedRadio ? selectedRadio.value : null;
			
			const isValidStatus = validateEventStatusChange(selectedValue, startDate, endDate, today, endInput, startInput);
			
			if (!isValidStatus) {
				e.preventDefault();
				return;
			};
			
			if (endDate.getTime() < startDate.getTime()) {
				alert("종료일이 시작일보다 이전일 수 없습니다.");
				e.preventDefault();
				return;
			}
		});
		
		function validateEventStatusChange(selectedValue, startDate, endDate, today, endInput, startInput) {
			// 예정
			if (selectedValue === "2") {
				if (startDate <= today) {
					alert("시작 날짜가 오늘보다 뒤인 경우에만 '예정' 상태로 설정할 수 있습니다.");
				    return false;
				}
			}
			
			// 진행중
			if (selectedValue === "1") {
				if (endDate < today) {
					alert("종료 날짜가 오늘보다 이전입니다. 종료 날짜를 수정해주세요.");
					endInput.focus();
				    return false;
				}
				
				if (startDate > today) {
					alert("시작 날짜는 오늘 날짜와 같거나 이전이어야 합니다.");
					startInput.focus();
				    return false;
				}
			}
			
			return true;
		}
		
	</script>
</body>
</html>