<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트등록</title>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
							<h5 class="section-title">이벤트 등록</h5>
						</div>
					</div>
					<div>
						<form action="/admin/event/write" method="post" enctype="multipart/form-data" id="eventForm">
							<table>
								<colgroup>
									<col width="20%">
									<col width="80%">
								</colgroup>
								<tbody>
									<tr>
										<th>제목<span style="vertical-align: middle; margin-left: 5px; color: red;">*</span></th>
										<td><input type="text" name="eventTitle" id="eventTitle" required/></td>
									</tr>
									<tr>
										<th>썸네일<span style="vertical-align: middle; margin-left: 5px; color: red;">*</span></th>
										<td>
											<input type="file" name="thumbnailFile" accept="image/png, image/jpeg" required />
											<input type="hidden" name="fileTypes" value="thumbnail" />
										</td>
									</tr>
									<tr>
										<th>이벤트페이지<span style="vertical-align: middle; margin-left: 5px; color: red;">*</span></th>
										<td>
											<input type="file" name="contentFile" accept="image/png, image/jpeg" required/>
											<input type="hidden" name="fileTypes" value="content" />
										</td>
									</tr>
									<tr>
										<th>내용</th>
										<td><textarea rows="5" cols="5" name="eventDescription" id="eventDescription"></textarea></td>
									</tr>
									<tr>
										<th>적용기간<span style="vertical-align: middle; margin-left: 5px; color: red;">*</span></th>
										<td>
											<div style="display: flex; align-items: center; justify-content: space-between;">
												<div style="width: 400px;">
													<label for="startDate">시작날짜</label>
													<input type="date" id="startDate" name="eventStartDate" required/>
												</div>
												<div style="width: 400px;">
													<label for="endDate">종료날짜</label>
													<input type="date" id="endDate" name="eventEndDate" required/>
												</div>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
							<div class="button-wrapper">
								<button type="submit" >등록</button>
								<button type="button" onclick="history.back()">취소</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		document.getElementById("eventForm").addEventListener("submit", (e) => {
			// 날짜 비교 검사
			const startInput = document.getElementById("startDate");
			const endInput = document.getElementById("endDate");
			const errorSpan = document.getElementById("startDateError");
			
			const startDate = new Date(startInput.value);
			const endDate = new Date(endInput.value);
			const today = new Date();
			
			if (startDate < today) {
				alert("시작 날짜는 오늘과 같거나 이전일 수 없습니다.");
				e.preventDefault();
			    return;
			}
			
			if (endDate.getTime() < startDate.getTime()) {
				alert("종료일이 시작일보다 이전일 수 없습니다.");
				e.preventDefault();
				return;
			}
			
		});
		
		$("input[name='thumbnailFile']").change(function(){
			  let fileVal = $(this).val();
			  let valTypeArr = fileVal.split(".")
			  let fileType = valTypeArr.pop().toLowerCase()
			  let fileTypeArr = ['jpg','jpeg','gif','png','ai','psd','svg',''];


			  if($.inArray(fileType,fileTypeArr)==-1){
			    alert("이미지 파일만 등록가능합니다.")
			    $(this).val("")
			  }else{
			    $("#logo").val(fileVal)
			 }
		});
		
		$("input[name='contentFile']").change(function(){
			  let fileVal = $(this).val();
			  let valTypeArr = fileVal.split(".")
			  let fileType = valTypeArr.pop().toLowerCase()
			  let fileTypeArr = ['jpg','jpeg','gif','png','ai','psd','svg',''];


			  if($.inArray(fileType,fileTypeArr)==-1){
			    alert("이미지 파일만 등록가능합니다.")
			    $(this).val("")
			  }else{
			    $("#logo").val(fileVal)
			  }
			});
	
	</script>
</body>
</html>