<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 강의 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<main>
		<section style="max-width: 800px; margin: 50px auto; padding: 40px;">
			<h1>강의 수정</h1>
			<h3 style="text-align: center; margin-bottom: 30px;">[ 강의 정보 수정 ]</h3>

			<form action="${pageContext.request.contextPath}/company/myPage/modifyClass" method="post" enctype="multipart/form-data">
			<table class="table-with-side-borders" style="width: 90%;">
				<input type="hidden" name="classIdx" value="${classInfo.classIdx}" />
				<input type="hidden" name="userIdx" value="${classInfo.userIdx}">
				<tr>
					<th>강의명</th>
					<td><input type="text" name="classTitle" value="${classInfo.classTitle}"></td>
				</tr>
				<tr>
					<th>강의 소개</th>
					<td><textarea name="classIntro">${classInfo.classIntro}</textarea></td>
				</tr>
				<tr>
					<th>강의 상세 내용</th>
					<td><textarea name="classContent">${classInfo.classContent}</textarea></td>
				</tr>
				<tr>
				  <th>카테고리</th>
				  <td>
				    <!-- 대분류 -->
				    <select id="parentCategory" onchange="filterSubCategories()" style="margin-right: 10px;">
				      <c:forEach var="p" items="${parentCategories}">
				        <option value="${p.categoryIdx}"
				          <c:if test="${fn:startsWith(classInfo.categoryIdx, p.categoryIdx)}">selected</c:if>>
				          ${p.categoryName}
				        </option>
				      </c:forEach>
				    </select>
				
				    <!-- 소분류 -->
				    <select id="subCategory" name="categoryIdx">
				      <c:forEach var="s" items="${subCategories}">
				        <option value="${s.categoryIdx}" data-parent="${s.parentIdx}"
				          <c:if test="${classInfo.categoryIdx eq s.categoryIdx}">selected</c:if>>
				          ${s.categoryName}
				        </option>
				      </c:forEach>
				    </select>
				  </td>
				</tr>
		        <tr>
					<th>수강료</th>
					<td><input type="number" name="classPrice" value="${classInfo.classPrice}"></td>
				</tr>
				<tr>
					<th>정원</th>
					<td><input type="number" name="classMember" value="${classInfo.classMember}"></td>
				</tr>
				<tr>
					<th>상태</th>
					<td>
					<select name="classStatus" required>
			            <option value="1" ${classInfo.classStatus == 1 ? "selected" : ""}>임시저장</option>
			            <option value="2" ${classInfo.classStatus == 2 ? "selected" : ""}>공개</option>
			            <option value="3" ${classInfo.classStatus == 3 ? "selected" : ""}>마감</option>
		        	</select><br>
		            </td>
		        </tr>
<!-- 				<tr> -->
<!-- 					<th>강의 기간</th> -->
<!-- 					<td> -->
<%-- 						<input type="date" name="startDate" value="${classInfo.startDate}"> --%>
<%-- 						~ <input type="date" name="endDate" value="${classInfo.endDate}"> --%>
<!-- 					</td> -->
<!-- 				</tr> -->
				<!-- 날짜 설정 -->
				<tr>
					<th>강의 시작일</th>
					<td>
						<input type="date" name="startDate" id="startDateInput"
						       value="${classInfo.startDate}" 
						       min="<%= java.time.LocalDate.now().plusDays(1).toString() %>">
					</td>
				</tr>
				<tr>
					<th>강의 종료일</th>
					<td>
						<input type="date" name="endDate" id="endDateInput"
						       value="${classInfo.endDate}" 
						       min="<%= java.time.LocalDate.now().plusDays(1).toString() %>">
					</td>
				</tr>
		        <!-- 강의 구분 선택 -->
				<tr>
					<th>강의 구분</th>
					<td>
						<select name="classType" id="classType">
							<option value="0" ${classInfo.classType == 0 ? 'selected' : ''}>정기 강의</option>
            				<option value="1" ${classInfo.classType == 1 ? 'selected' : ''}>단기 강의</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>수업 요일</th>
					<td>
						<label><input type="checkbox" class="day" name="classDays" value="1">월</label>
						<label><input type="checkbox" class="day" name="classDays" value="2">화</label>
						<label><input type="checkbox" class="day" name="classDays" value="4">수</label>
						<label><input type="checkbox" class="day" name="classDays" value="8">목</label>
						<label><input type="checkbox" class="day" name="classDays" value="16">금</label>
						<label><input type="checkbox" class="day" name="classDays" value="32">토</label>
						<label><input type="checkbox" class="day" name="classDays" value="64">일</label>
<%-- 						<input type="hidden" name="classDays" id="classDays" value="${classInfo.classDays}" /> --%>
					</td>
				</tr>
				<tr>
					<th>장소</th>
					<td>
						<input type="text" name="classPostcode" id="classPostcode" 
						       placeholder="우편번호" style="width:150px;" readonly required
						       value="">
						<input type="button" value="주소 검색" id="btnSearchAddress"><br>
						<input type="text" name="classAddress1" id="classAddress1" 
						       placeholder="도로명 주소" style="width:70%;" readonly required
						       value="">
						<input type="text" name="classAddress2" id="classAddress2" 
						       placeholder="장소 상세 설명" style="width:70%;" required
						       value="">
						<input type="hidden" name="location" id="location" value="${classInfo.location}">
					</td>
				</tr>
				<tr>
					<th>썸네일 수정</th>
					<td>
						<c:if test="${not empty classInfo.fileList}">
						    <c:forEach var="file" items="${classInfo.fileList}">
						        <img src="${pageContext.request.contextPath}/resources/upload/${file.subDir}/${file.realFileName}" width="200" />
						        <br>
						        <span>${file.originalFileName}</span>
						    </c:forEach>
						</c:if>
						<c:if test="${empty classInfo.fileList}">
						    <span>이미지 없음</span>
						</c:if>
					
						<!-- 새로 업로드할 파일 선택 -->
						<input type="file" name="files" id="thumbnailInput" multiple accept="image/*" />
					
						<!-- 새로 선택 시 미리보기 -->
						<div id="preview-area" style="margin-top: 15px;"></div>
					</td>
				</tr>
			</table>

			<h3>📚 커리큘럼 수정</h3>
			<!-- 기존 커리큘럼을 출력하는 영역 (처음에 보여지는 것들) -->
			<div id="curriculumContainer">
				<c:forEach var="curri" items="${curriculumList}">
					<div class="curriculum-box">
						<input type="hidden" name="curriculumIdx" value="${curri.curriculumIdx}" />
						<b>제목:</b> <input type="text" name="curriculumTitle" value="${curri.curriculumTitle}">
						<b>시간:</b> <input type="text" name="curriculumRuntime" value="${curri.curriculumRuntime}">
						<!-- 삭제 버튼 추가 (기존 커리큘럼도 지울 수 있게) -->
						<button type="button" onclick="removeCurriculum(this)">삭제</button>
					</div>
				</c:forEach>
			</div>
			
			<!-- 새 커리큘럼을 추가할 때 사용할 빈 템플릿 (처음엔 숨김) -->
			<div id="curriculumTemplate" style="display: none;">
				<div class="curriculum-box">
					<input type="hidden" name="curriculumIdx" value="0" />
					<b>제목:</b> <input type="text" name="curriculumTitle" placeholder="제목 입력">
					<b>시간:</b> <input type="text" name="curriculumRuntime" placeholder="시간 입력">
					<button type="button" onclick="removeCurriculum(this)">삭제</button>
				</div>
			</div>

			<!-- 커리큘럼 추가 버튼 -->
			<div style="margin-top: 10px;">
				<button type="button" onclick="addCurriculum()">커리큘럼 추가</button>
			</div>

			<!-- 제출 버튼 -->
			<div style="display: flex; justify-content: center; margin-top: 40px;">
				<button type="submit" class="orange-button">수정 완료</button>
			</div>
			</form>
		</section>
	</main>
	<footer>
        <jsp:include page="/WEB-INF/views/inc/bottom.jsp" />
    </footer>
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<!-- 요일 처리 스크립트 -->
	<script>
	window.addEventListener("DOMContentLoaded", function () {
		// 추가된 주소 복원 코드
	    const locationValue = document.getElementById("location").value;
	    if (locationValue && locationValue.trim() !== "") {
	        const lastSpace = locationValue.lastIndexOf(" ");
	        const address1 = locationValue.substring(0, lastSpace);
	        const address2 = locationValue.substring(lastSpace + 1);
	        document.getElementById("classAddress1").value = address1;
	        document.getElementById("classAddress2").value = address2;
	        document.getElementById("classPostcode").value = "";
	    }
		
	    const value = parseInt(document.getElementById("classDays").value || "0");
	    document.querySelectorAll(".day").forEach(cb => {
	        if (value & parseInt(cb.value)) {
	            cb.checked = true;
	        }
	    });
	});	
	document.querySelector("form").addEventListener("submit", function () {
	    let total = 0;
	    document.querySelectorAll(".day:checked").forEach(cb => {
	        total += parseInt(cb.value);
	    });
	    document.getElementById("classDays").value = total;
	});

	// 커리큘럼 추가 함수
	function addCurriculum() {
		const container = document.getElementById("curriculumContainer");
		const template = document.getElementById("curriculumTemplate").innerHTML;
		container.insertAdjacentHTML("beforeend", template);
	}

	// 커리큘럼 삭제 함수
	function removeCurriculum(button) {
		const box = button.parentElement;
		box.remove();
	}
	
	// 썸네일 미리보기 기능
	document.getElementById('thumbnailInput').addEventListener('change', function(event) {
	    const previewArea = document.getElementById('preview-area');
	    previewArea.innerHTML = ""; // 기존 이미지 제거
	
	    const files = event.target.files;
	    for (let i = 0; i < files.length; i++) {
	      const file = files[i];
	
	      if (file.type.startsWith("image/")) {
	        const reader = new FileReader();
	        reader.onload = function(e) {
	          const img = document.createElement('img');
	          img.src = e.target.result;
	          img.style.width = "300px";
	          img.style.marginBottom = "10px";
	          previewArea.appendChild(img);
	        };
	        reader.readAsDataURL(file);
	      }
	    }
	  });
	
	// 주소 검색 버튼 이벤트 바인딩
	document.getElementById("btnSearchAddress").addEventListener("click", function () {
	    new daum.Postcode({
	      oncomplete: function (data) {
	        let addr = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
	        let detail = "";

	        document.getElementById("classPostcode").value = data.zonecode;
	        document.getElementById("classAddress1").value = addr;
	        document.getElementById("classAddress2").focus();

	        document.getElementById("classAddress2").addEventListener("input", function () {
	          detail = this.value;
	          document.getElementById("location").value = addr + " " + detail;
	        });

	        // 상세주소 없이도 기본 주소는 넣어줌
	        document.getElementById("location").value = addr;
	      }
	    }).open();
	  });
	</script>
	
	<!-- 날짜 제약 관련 스크립트 -->
	<script>
	window.addEventListener('DOMContentLoaded', () => {
		const startDateInput = document.querySelector('input[name="startDate"]');
		const endDateInput = document.querySelector('input[name="endDate"]');
		const classTypeSelect = document.querySelector('select[name="classType"]');

		// 시작일은 오늘+1일부터 선택 가능
		const today = new Date();
		today.setDate(today.getDate() + 1);
		const minDateStr = today.toISOString().split('T')[0];
		
		if (startDateInput) {
			startDateInput.setAttribute('min', minDateStr);
		}
		if (endDateInput) {
			endDateInput.setAttribute('min', minDateStr);
		}

		// 시작일 변경 시 종료일도 최소값 재설정
		startDateInput.addEventListener('change', () => {
			const start = startDateInput.value;
			endDateInput.setAttribute('min', start);
			
			if (classTypeSelect.value === '1') {
				endDateInput.value = start;
			}
		});

		// 강의 구분 변경 시 종료일 제어
		classTypeSelect.addEventListener('change', () => {
			const type = classTypeSelect.value;
			const start = startDateInput.value;
			
			if (type === '1') {
				endDateInput.readOnly = true;
				endDateInput.value = startDateInput.value;
			} else {
				endDateInput.readOnly = false;
			}
		});

		// 페이지 로딩 시 초기 상태 반영
		if (classTypeSelect.value === '1') {
			endDateInput.readOnly = true;
			endDateInput.value = startDateInput.value;
		}
	});
	</script>
	
</body>
</html>