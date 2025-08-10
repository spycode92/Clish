<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 강의 개설</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<style>
	.big-button {
		width: 130px !important;
	}
</style>
</head>
<body>

	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>

	<section style="max-width: 700px; margin: 50px auto; padding: 30px;">
	    <h2 style="text-align: center; margin-bottom: 20px;">강의 개설</h2>
	
		<form action="${pageContext.request.contextPath}/company/myPage/registerClass" method="post" enctype="multipart/form-data">
	        
	        <label><b>강의명</b></label>
	        <input type="text" name="classTitle" required>
	
			<label><b>강의 소개</b></label>
			<textarea name="classIntro" rows="3" required></textarea>
			
			<label><b>강의 상세 내용</b></label>
			<textarea name="classContent" rows="5" required></textarea>
			
	        <label><b>카테고리</b></label>
			<div style="display: flex; gap: 10px; margin-bottom: 15px;">
			  <!-- 대분류 -->
			  <select id="parentCategory" onchange="filterSubCategories()" style="flex:1;">
			    <option value="" disabled selected>대분류</option>
			    <c:forEach var="p" items="${parentCategories}">
			      <option value="${p.categoryIdx}">${p.categoryName}</option>
			    </c:forEach>
			  </select>
			
			  <!-- 소분류 -->
			  <select id="subCategory" name="categoryIdx" required style="flex:1;">
			    <option value="" disabled selected>소분류</option>
			    <c:forEach var="s" items="${subCategories}">
			      <option value="${s.categoryIdx}" data-parent="${s.parentIdx}">
			        ${s.categoryName}
			      </option>
			    </c:forEach>
			  </select>
			</div>
	
			
	        <label><b>수강료</b></label>
	        <input type="number" name="classPrice" value="0" required>
	
	        <label><b>정원</b></label>
	        <input type="number" name="classMember" required>
	
<!-- 	        <label><b>강의 시작일</b></label> -->
<!-- 	        <input type="date" name="startDate" required> -->
	
<!-- 	        <label><b>강의 종료일</b></label> -->
<!-- 	        <input type="date" name="endDate" required> -->

			<!-- 강의 시작일 -->
			<label><b>강의 시작일</b></label>
			<input type="date" name="startDate" id="startDateInput"
			       required min="<%= java.time.LocalDate.now().plusDays(1).toString() %>">
			
			<!-- 강의 종료일 -->
			<label><b>강의 종료일</b></label>
			<input type="date" name="endDate" id="endDateInput"
			       required min="<%= java.time.LocalDate.now().plusDays(1).toString() %>">
	
	        <label><b>강의 구분</b></label>
			<select name="classType" required>
			  <option value="0">정기 강의</option>
			  <option value="1">단기 강의</option>
			</select>
	        
	        <label><b>수업요일</b></label>
	        <div style="display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 15px;">
	            <label><input type="checkbox" name="classDayNames" value="1">월</label>
	            <label><input type="checkbox" name="classDayNames" value="2">화</label>
	            <label><input type="checkbox" name="classDayNames" value="4">수</label>
	            <label><input type="checkbox" name="classDayNames" value="8">목</label>
	            <label><input type="checkbox" name="classDayNames" value="16">금</label>
	            <label><input type="checkbox" name="classDayNames" value="32">토</label>
	            <label><input type="checkbox" name="classDayNames" value="64">일</label>
	        </div>
	
	        <label><b>장소</b></label><br>
			<input type="text" name="classPostcode" id="classPostcode" 
			       placeholder="우편번호" style="width:150px;" readonly required>
			<input type="button" value="주소 검색" id="btnSearchAddress"><br>
			<input type="text" name="classAddress1" id="classAddress1" 
			       placeholder="도로명 주소" style="width:70%;" readonly required><br>
			<input type="text" name="classAddress2" id="classAddress2" 
			       placeholder="장소 상세 설명" style="width:70%;" required>
			<input type="hidden" name="location" id="location"><br>
			
			<label><b>썸네일 업로드</b></label>
			<input type="file" name="files" id="thumbnailInput" multiple accept="image/*" required="required">
			
			<!-- ✅ 썸네일 미리보기 영역 -->
			<div id="preview-area" style="margin-top: 15px;"></div>
			
			<!-- 커리큘럼 등록 폼 (여러개 입력 가능) -->
			<h3>커리큘럼</h3>
			<div id="curri-area">
			  <div class="curri-item">
			    제목: <input type="text" name="curriculumTitle" placeholder="1강. 커리큘럼 제목 입력"><br>
			    시간: <input type="text" name="curriculumRuntime" placeholder="예: 1시간20분"><br>
			  </div>
			</div>
			<button type="button" onclick="addCurriculum()" style="width: 100px;">커리큘럼 추가</button><br><br>
	        
	        <div style="text-align: center; margin-top: 30px;">
	            <input type="submit" value="강의 개설 신청" class="orange-button big-button">
	        </div>
	        
	    </form>
	    
	    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
		<script>
		document.addEventListener("DOMContentLoaded", function () {
		    let curriculumCount = 1;
		
		    // ✅ 커리큘럼 추가
		    function addCurriculum() {
		        const div = document.createElement('div');
		        div.classList.add("curri-item");
		        div.innerHTML = `
		            제목: <input type="text" name="curriculumTitle" placeholder="${curriculumCount}강. 커리큘럼 제목 입력"><br>
		            시간: <input type="text" name="curriculumRuntime" placeholder="예: 1시간20분"><br><br>
		        `;
		        document.getElementById("curri-area").appendChild(div);
		        curriculumCount++;
		    }
		
		    // 전역에서도 쓸 수 있게 window에 등록
		    window.addCurriculum = addCurriculum;
		
		    // ✅ 썸네일 미리보기 기능
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
		
		    // ✅ 주소 검색 버튼 이벤트 바인딩
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
		
		                document.getElementById("location").value = addr;
		            }
		        }).open();
		    });
		
		});
		</script>
		<!-- 날짜 제약 관련 스크립트 -->
		<script>
		window.addEventListener('DOMContentLoaded', () => {
			  const startDateInput = document.querySelector('input[name="startDate"]');
			  const endDateInput = document.querySelector('input[name="endDate"]');
			  const classTypeSelect = document.querySelector('select[name="classType"]');

			  const today = new Date();
			  today.setDate(today.getDate() + 1);
			  const minDateStr = today.toISOString().split('T')[0];

			  startDateInput.setAttribute('min', minDateStr);
			  endDateInput.setAttribute('min', minDateStr);

			  // 시작일 바뀌면 종료일도 자동 설정
			  startDateInput.addEventListener('change', () => {
			    const start = startDateInput.value;
			    endDateInput.setAttribute('min', start);
			    if (classTypeSelect.value === '1') {
			      endDateInput.value = start;
			    }
			  });

			  // 강의 구분 변경 시 종료일 처리
			  classTypeSelect.addEventListener('change', () => {
			    const type = classTypeSelect.value;
			    const start = startDateInput.value;
			    if (type === '1') {
			      endDateInput.readOnly = false;
			      endDateInput.value = start;
			      endDateInput.readOnly = true;
			    } else {
			      endDateInput.readOnly = false;
			    }
			  });

			  // 최초 로드시 단기강의면 종료일 셋팅
			  if (classTypeSelect.value === '1') {
			    endDateInput.readOnly = false; // 일단 열고
			    endDateInput.value = startDateInput.value; // 값 셋팅하고
			    endDateInput.readOnly = true; // 다시 잠그기
			  }

			  // 폼 제출 직전에도 종료일 강제 맞춤
			  const form = document.querySelector('form');
			  form.addEventListener('submit', () => {
			    if (classTypeSelect.value === '1') {
			      endDateInput.readOnly = false;
			      endDateInput.value = startDateInput.value;
			      endDateInput.readOnly = true;
			    }
			  });
			});
		</script>
	</section>
	
	<footer>
        <jsp:include page="/WEB-INF/views/inc/bottom.jsp" />
    </footer>
</body>
</html>