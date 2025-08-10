<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${classInfo.classTitle}</title>
<link
	href="/resources/css/admin/modal.css"
	rel="stylesheet" type="text/css">
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<style>
</style>
<body>
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"></jsp:include>
		</div>
		<div class="modal">
			<div class="modal_body">
				<h3>강의 반려</h3>
				<form action="/admin/class/${classInfo.classIdx}/reject"
					method="post">
					<div>
						<label>강의명</label> <input type="text"
							value="${classInfo.classTitle}" readonly />
					</div>
					<div>
						<label>반려사유</label>
						<textarea rows="10" cols="20" name="content" required></textarea>
					</div>
					<div class="button-wrapper">
						<button type="button" onclick="closeModal()">닫기</button>
						<button type="submit">반려하기</button>
					</div>
				</form>
			</div>
		</div>
		<div class="main">
			<jsp:include page="/WEB-INF/views/admin/header.jsp"></jsp:include>
			<div class="main_container">
				<div class="bg-light">
					<div>
						<h3 class="section-title">강의 상세 정보</h3>
					</div>
					<form id="classForm" style="border: none; padding: 50px;" enctype="multipart/form-data">
						<input type="hidden" name="userIdx" id="userIdx" value="${classInfo.userIdx}" />
						<div>
							<div style="display: flex; flex: 1 1 auto;  align-items: center; justify-content: space-between; margin-left: 30px; margin-right: 30px;">
								<div style="display: flex; flex-direction: column; width: 600px;">
									<div>
										<label>강의명</label> 
										<input type="text" value="${classInfo.classTitle}" name="classTitle" id="classTitle" required/>
									</div>
									<div>
										<span>강의 소개</span>
										<textarea name="classIntro" id="classIntro" required>${classInfo.classIntro}</textarea>
									</div>
									<div>
										<span>강의 상세 내용</span>
										<textarea rows="9" cols="10" name="classContent" id="classContent" required>${classInfo.classContent}</textarea>
									</div>
								</div>
								<div style="width: 350px; height: 350px; display: flex; flex-direction: column; align-items: center; gap: 30px;">
									<c:forEach var="fileDTO" items="${classInfo.fileList}">
										<img src="/file/${fileDTO.fileId}?type=0" alt="${fileDTO.originalFileName }" width="300px" height="300px"/>
										<div>
											${fileDTO.originalFileName}
											<a href="javascript:deleteFile(${fileDTO.fileId})">
												<img src="/resources/images/delete-icon.png" class="img_btn" title="삭제" />
											</a>
										</div>
									</c:forEach>
									<c:if test="${empty classInfo.fileList}">
										<input type="file"  name="files"  accept="image/png, image/jpeg" multiple required>
									</c:if>
								</div>
							</div>
						</div>
						<div style="display: flex; align-items: center; justify-content: flex-start; gap: 30px; margin-left: 30px; ">
							<div style="width: 300px;">
								<label for="startDate">시작날짜</label> 
								<input type="date" value="${classInfo.startDate}" name="startDate" id="startDate" required/>
								<input type="hidden" id="originalStartDate" value="${classInfo.startDate}" />
							</div>
							<div style="width: 300px;">
								<label for="endDate">종료날짜</label> 
								<input type="date" value="${classInfo.endDate}" name="endDate" id="endDate" required/>
							</div>
							<c:if test="${classInfo.classStatus != 1}">
								<div style="width: 300px;">
									<label for="classStatus">공개상태</label> 
									<select name="classStatus" id="classStatus" required>
										<option value="2"
											<c:if test="${classInfo.classStatus == 2}">selected</c:if>>오픈</option>
										<option value="3"
											<c:if test="${classInfo.classStatus == 3}">selected</c:if>>마감</option>
									</select>
								</div>
							</c:if>
						</div>
						<div style="display: flex; align-items: center; justify-content: flex-start; gap: 30px; margin-left: 30px; ">
							<div style="width: 300px;">
								<label for="classType">강의 타입</label>
								<select id="classType" required>
									<option <c:if test="${classInfo.classType eq 0 }">selected</c:if> value="0">장기</option>
									<option <c:if test="${classInfo.classType eq 1 }">selected</c:if> value="1">단기</option>
								</select>
							</div>
							<div style="width: 300px;">
								<label>정원</label> 
								<input type="number" value="${classInfo.classMember}" name="classMember" id="classMember" required/>
							</div>
							<div style="width: 300px;">
								<label>가격</label>
								<fmt:formatNumber value="${classInfo.classPrice}" type="number" maxFractionDigits="0" var="formattedPrice" />
								<input type="number" value="${classInfo.classPrice.intValue()}" name="classPrice" id="classPrice" required/>
							</div>
						</div>
						<div style="display: flex; flex-direction: column;  margin-left: 30px; margin-bottom: 10px;">
							<label >수업요일</label> 
							<div>
								<input type="checkbox" class="day-checkbox" value="1"
									<c:if test="${fn:contains(classInfo.classDayNames, '월')}">checked</c:if> />월
								<input type="checkbox" class="day-checkbox" value="2"
									<c:if test="${fn:contains(classInfo.classDayNames, '화')}">checked</c:if> />화
								<input type="checkbox" class="day-checkbox" value="4"
									<c:if test="${fn:contains(classInfo.classDayNames, '수')}">checked</c:if> />수
								<input type="checkbox" class="day-checkbox" value="8"
									<c:if test="${fn:contains(classInfo.classDayNames, '목')}">checked</c:if> />목
								<input type="checkbox" class="day-checkbox" value="16"
									<c:if test="${fn:contains(classInfo.classDayNames, '금')}">checked</c:if> />금
								<input type="checkbox" class="day-checkbox" value="32"
									<c:if test="${fn:contains(classInfo.classDayNames, '토')}">checked</c:if> />토
								<input type="checkbox" class="day-checkbox" value="64"
									<c:if test="${fn:contains(classInfo.classDayNames, '일')}">checked</c:if> />일
								<input type="hidden" name="classDays" id="classDays" />
							</div>
						</div>
						<div style="margin-left: 30px; margin-right: 30px; width: 950px">
							<label for="location">수업장소</label> 
							<input type="text" value="${classInfo.location}" name="location" id="location" required/>
						</div>
						<div style="margin-left: 30px;">
							<span>카테고리</span>
							<div style="display: flex; align-items: center; gap: 30px;">
								<div style="width: 300px;">
									<div>대분류</div>
									<select required>
										<c:forEach var="category" items="${parentCategories}">
											<option value="${category.categoryIdx}"
												<c:if test="${selectedParentCategory != null && category.categoryIdx == selectedParentCategory.categoryIdx}">selected</c:if>>
												${category.categoryName}</option>
										</c:forEach>
									</select>
								</div>
								<div style="width: 300px;">
									<div>소분류</div>
									<select name="categoryIdx" required>
										<c:forEach var="category" items="${childCategories}">
											<option value="${category.categoryIdx}"
												<c:if test="${selectedChildCategory != null && category.categoryIdx == selectedChildCategory.categoryIdx}">selected</c:if>>
												${category.categoryName}</option>
										</c:forEach>
									</select>
								</div>
							</div>
						</div>
						<div style="margin-left: 30px; margin-right: 30px;">
							<div style="display: flex; align-items: center; justify-content: space-between;">
								<h3>📚 커리큘럼 소개</h3>
								<button type="button" onclick="addCurriculum()">커리큘럼 추가</button>
							</div>
							<div id="curriculumContainer">
								<c:forEach var="curri" items="${curriculumList}">
									<div class="curriculum-box" style="display: flex; align-items: center; justify-content: space-between;">
										<div style="display: flex; gap: 30px;">
											<input type="hidden" name="curriculumIdx" value="${curri.curriculumIdx}"/>
											<input type="text" name="curriculumTitle" value="${curri.curriculumTitle}" style="width: 600px">
											<input type="text" name="curriculumRuntime" value="${curri.curriculumRuntime}" style="width: 200px">
										</div>
										<button type="button" onclick="removeCurriculum(this)">삭제</button>
									</div>
								</c:forEach>
							</div>
							<div id="curriculumTemplate" style="display: none;">
								<div class="curriculum-box" style="display: flex; align-items: center; justify-content: space-between;">
									<div style="display: flex; gap: 30px;">
										<input type="hidden" name="curriculumIdx" value="${curri.curriculumIdx}"/>
										<input type="text" name="curriculumTitle" value="${curri.curriculumTitle}" placeholder="커리큘럼 제목" style="width: 600px">
										<input type="text" name="curriculumRuntime" value="${curri.curriculumRuntime}" placeholder="강의 시간"  style="width: 200px">
									</div>
									<button type="button" onclick="removeCurriculum(this)">삭제</button>
								</div>
							</div>
						</div>
						<div class="button-wrapper">
							<button type="button" onclick="back()">닫기</button>
							<c:choose>
								<c:when test="${classInfo.classStatus == 1}">
									<button type="submit" name="action" value="approval"
										formaction="/admin/class/${classInfo.classIdx}/approve"
										formmethod="post">승인</button>
									<button type="button" onclick="onModal()">반려</button>
								</c:when>
								<c:otherwise>
									<button type="submit" name="action" value="update"
										formaction="/admin/class/${classInfo.classIdx}/update"
										formmethod="post"
										>수정</button>
								</c:otherwise>
							</c:choose>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		function onModal() {
			const modal = document.querySelector('.modal');
			modal.classList.add("on");
		}
		
		function closeModal() {
			const modal = document.querySelector('.modal');
			modal.classList.remove("on");
		}
		
		function calculateClassDays() {
			let total = 0;
			document.querySelectorAll(".day-checkbox:checked").forEach(cb => {
				total += parseInt(cb.value);
			});
			document.getElementById('classDays').value = total;
		}
		
		document.getElementById("classForm").addEventListener("submit", function (e) {
			calculateClassDays();
		});
		
		function addCurriculum() {
			const container = document.getElementById("curriculumContainer");
			const template = document.getElementById("curriculumTemplate").innerHTML;
			container.insertAdjacentHTML("beforeend", template);
		}
	
		function removeCurriculum(button) {
			const box = button.parentElement;
			box.remove();
		}
		
		function deleteFile(fileId) {

			if(confirm("첨부파일을 삭제하시겠습니까?")) {
				location.href = "/admin/class/fileDelete?fileId=" + fileId + "&classIdx=${classInfo.classIdx}";
			}
		}
		
		function back(pageNum) {
			console.log(pageNum);
			location.href="/admin/classList";
		}
		
		document.getElementById("classForm").addEventListener("submit", (e) => {
			// 날짜 비교 검사
			const startInput = document.getElementById("startDate");
			const endInput = document.getElementById("endDate");
			
			const startDate = new Date(startInput.value);
			const endDate = new Date(endInput.value);
			const originalStartDate = new Date(document.getElementById("originalStartDate").value);
			const today = new Date();
			
			if (endDate.getTime() < startDate.getTime()) {
				alert("종료일이 시작일보다 빠를 수 없습니다.");
				e.preventDefault();
				return;
			}
			
			// 시작 날짜 값을 변경했는지 확인
			const isStartDateModified = originalStartDate.toISOString().slice(0, 10) !== startInput.value;
			
			if (isStartDateModified && startDate < today) {
				alert("시작 날짜는 오늘과 같거나 이후여야 합니다.");
				startInput.focus();
				e.preventDefault();
				return;
			}
			
			// 정원 검사
			const memberInput = document.getElementById("classMember");
			const memberValue = parseInt(memberInput.value);
			
			if (isNaN(memberValue) || memberValue < 1) {
				alert("최소 인원은 1명 이상입니다.");
				memberInput.focus();
				e.preventDefault();
				return;
			}
			
			// 금액 검사
			const priceInput = document.getElementById("classPrice");
			const priceValue = parseInt(priceInput.value);
			
			if (isNaN(priceValue) || priceValue < 10000) {
				alert("최소 금액은 10,000원 입니다.");
				priceInput.focus();
				e.preventDefault();
				return;
				}
			
			// 수업 요일 검사
			const checkboxes = document.querySelectorAll(".day-checkbox");
		    const isChecked = Array.from(checkboxes).some(cb => cb.checked);
			
			if (!isChecked) {
				alert("수업 요일을 최소 1개 이상 선택해주세요.");
				e.preventDefault();
				return;
			}
			
			// 커리큘럼 검사
			const container = document.getElementById("curriculumContainer");
			
			if (container.children.length === 0) {
				alert("커리큘럼은 최소 1개 이상 필요합니다.");
				e.preventDefault();
				return;
			}
		});
		
		$("input[name='files']").change(function(){
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