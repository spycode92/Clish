<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 강의 목록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/the_best_styles.css">
<link href="${pageContext.request.contextPath}/resources/css/home/top.css" rel="stylesheet" >
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
    <style>
    	#footer-area {
	      margin-top: 0 !important;
	    }
    	
    	/* 왼쪽 사이드바 */
		.sidebar {
		    width: 200px; /* 필요에 따라 조절 */
		    background-color: #f8f8f8;
		    padding: 20px;
		    overflow: hidden;          /* ✅ 내부 넘치는 거 잘라냄 */
	    	white-space: nowrap;
		}
    	
        .classManage-container {
		    display: flex;
		    width: 100%;
		    min-height: 100vh;
		    padding-right: 200px; /* ✅ 오른쪽도 사이드바만큼 여백 주기 */
		    box-sizing: border-box;
		}

        .content-area {
            flex: 1;
            padding: 30px;
            margin-right: 50px
        }

        .class-header {
            margin-bottom: 10px;
        }

        .button-right {
            width: 100%;
            display: flex;
            justify-content: flex-end;
            margin-bottom: 30px;
        }

        .orange-button {
            background-color: #FF7601;
            color: #fff;
            border-radius: 10px;
            width: 80px;
            height: 30px;
            border: none;
            display: block;
            margin-left: 40px;
        }

        .orange-button:hover {
            background-color: #FF8C00;
            transform: translateY(-2px);
            transition: background-color 0.3s ease, transform 0.3s ease;
        }
        
        .registButton {
            background-color: #FF7601;
            color: #fff;
            border-radius: 10px;
            width: 80px;
            height: 30px;
            border: none;
            display: block;
        }

        .registButton:hover {
            background-color: #FF8C00;
            transform: translateY(-2px);
            transition: background-color 0.3s ease, transform 0.3s ease;
        }
		
        .class-filter-box {
            border: 1px solid black;
            padding: 10px;
            margin-bottom: 20px;
        }

        .class-table {
            width: 100%;
            border-collapse: collapse;
            margin-left: 0px; /* ✅ 살짝 왼쪽으로 이동 */
        }

        .class-table th, .class-table td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: center;
        }

        .class-table tr:hover {
            background-color: #f5f5f5;
            cursor: pointer;
        }
        
	   /* 예약자 버튼 (흰 배경 + 주황 테두리 + 주황 텍스트) */
		.reserved-btn {
		    background-color: white;
		    border: 1px solid #FF7601;
		    color: #FF7601;
		    padding: 5px 12px;             /* 살짝 더 넉넉하게 */
		    border-radius: 10px;
		    font-weight: bold;
		    font-size: 13px;               /* 글자가 너무 크지 않게 */
		    min-width: 110px;               /* 버튼 너비 고정 - 이게 핵심! */
		    text-align: center;
		    white-space: nowrap;          /* 줄바꿈 방지 */
		    box-sizing: border-box;
		    cursor: pointer;
		    margin-left: 60px;
		}
		.reserved-btn:hover {
			background-color: #fff3e0;
		}
		
		#reservationModal {
		    display: none;
		    position: fixed;
		    top: 50%;
		    left: 50%;
		    transform: translate(-50%, -50%);
		    background: #fff;
		    padding: 20px;
		    border: 1px solid #ccc;
		    z-index: 999;
		    max-height: 80vh;         /* 브라우저 화면 80%까지만 높이 허용 */
		    overflow-y: auto;         /* 내부 스크롤 허용 */
		    box-sizing: border-box;
		}
    </style>
</head>
<body>

    <!-- 공통 헤더 -->
    <header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>

    <!-- 페이지 전체 컨테이너 -->
    <div class="classManage-container">
        <!-- 왼쪽 사이드바 -->
        <div class="sidebar">
            <jsp:include page="/WEB-INF/views/company/comSidebar.jsp" />
        </div>

        <!-- 본문 내용 -->
        <div class="content-area">
            <div class="class-header">
                <h1>강의 목록</h1>
            </div>

            <!-- 강의 개설 버튼 -->
            <div class="button-right">
                <button class="registButton"
                        onclick="location.href='${pageContext.request.contextPath}/company/myPage/registerClass'">
                    강의 개설
                </button>
            </div>

            <!-- 필터 & 검색창 -->
            <div class="class-filter-box">
                <h5>강의 조회</h5>
                
                <!-- 단기 & 정기강의 구분 -->
				<div style="margin-bottom: 10px;">
				    <a href="${pageContext.request.contextPath}/company/myPage/classManage?type=short"
				       style="<c:if test='${param.type == "short"}'>font-weight: bold; color: red;</c:if>">
				        단기 강의
				    </a> |
				    
				    <a href="${pageContext.request.contextPath}/company/myPage/classManage?type=regular"
				       style="<c:if test='${param.type == "regular"}'>font-weight: bold; color: red;</c:if>">
				        정기 강의
				    </a> |
				    
				    <a href="${pageContext.request.contextPath}/company/myPage/classManage"
				       style="<c:if test='${empty param.type}'>font-weight: bold; color: red;</c:if>">
				        전체 보기
				    </a>
				</div>
            </div>

            <!-- 강의 목록 테이블 -->
            <div>
                <table class="class-table">
                    <thead>
                        <tr>
                            <th>예약자 확인</th>
                            <th>제목</th>
                            <th>대분류</th>
                            <th>소분류</th>
                            <th>상태</th>
                            <th>승인 여부</th>
                            <th>수정</th>
                            <th>삭제</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="hasRegisteredClass" value="false" />
                        <c:forEach var="classItem" items="${classList}">
                                <c:set var="hasRegisteredClass" value="true" />
                                <tr onclick="location.href='${pageContext.request.contextPath}/company/myPage/classDetail?classIdx=${classItem.class_idx}'">
									<!-- 버튼: 예약자 수 / 총 정원 -->
									<td>
										<button type="button" class="reserved-btn"
										        onclick="openReservationModal('${classItem.class_idx}')">
										  예약자 ${classItem.reservedCount}/${classItem.class_member}
										</button>
									</td>
                                    <td>${classItem.class_title}</td>
                                    <td>${classItem.parent_category_name}</td>
                                    <td>${classItem.child_category_name}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${classItem.class_status == 2}">오픈</c:when>
                                            <c:otherwise>마감</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <!-- =================================== 지피티 =================================== -->
                                    <td>
										<c:choose>
											<c:when test="${classItem.class_status == 1}">
												<span style="color: gray;">승인대기</span>
											</c:when>
											<c:when test="${classItem.class_status == 2}">
												<span style="color: green;">승인</span>
											</c:when>
											<c:when test="${classItem.class_status == 3}">
												<span style="color: red;">반려</span>
											</c:when>
										</c:choose>
									</td>
                                    <!-- =================================== 지피티 =================================== -->
                                    <td>
								        <!-- 버튼 클릭 시, 수정 페이지로 이동 -->
								        <button class="orange-button"
								            onclick="event.stopPropagation(); location.href='${pageContext.request.contextPath}/company/myPage/modifyClass?classIdx=${classItem.class_idx}'">
								            수정
								        </button>
								    </td>
								    <!-- 삭제 버튼 -->
                                    <td>
									    <button class="orange-button"
									        onclick="event.stopPropagation(); deleteClass('${classItem.class_idx}')">
									        삭제
									    </button>
									</td>
                                </tr>
                        </c:forEach>
                        <c:if test="${not hasRegisteredClass}">
                            <tr><td colspan="5">등록된 강의가 없습니다.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
	
	<!-- 예약자 모달창 -->
	<div id="reservationModal">
		<h3>예약자 목록</h3>
		<div id="reservationContent">로딩 중...</div>
		<button onclick="closeReservationModal()">닫기</button>
	</div>
	
    <!-- 공통 푸터 -->
    <footer>
        <jsp:include page="/WEB-INF/views/inc/bottom.jsp" />
    </footer>
    
	<script>
	// 강의 삭제 함수 (강의 idx를 파라미터로 받아서 삭제 요청)
	function deleteClass(classIdx) {
	  if(confirm("정말 삭제하시겠습니까?")) {
	    location.href = '${pageContext.request.contextPath}/company/myPage/deleteClass?classIdx=' + classIdx;
	  }
	}
	  
	// 예약자 모달 열기 함수 (AJAX)
	function openReservationModal(classIdx) {
	  event.stopPropagation(); // tr 클릭 막기
	  document.getElementById('reservationModal').style.display = 'block';
	  document.getElementById('reservationContent').innerHTML = '로딩 중...';
	
	  fetch('${pageContext.request.contextPath}/company/myPage/classReservationList', {
	    method: 'POST',
	    headers: {
	      'Content-Type': 'application/x-www-form-urlencoded' // 폼 전송 형태로 설정
	    },
	    body: 'classIdx=' + encodeURIComponent(classIdx) // 데이터는 body에 담아야 함
	  })
	  .then(response => response.text())
	  .then(html => {
	    document.getElementById('reservationContent').innerHTML = html;
	  })
	  .catch(error => {
	    document.getElementById('reservationContent').innerHTML = '오류 발생';
	    console.error(error);
	  });
	}
	
	// 예약자 모달 닫기 함수
	function closeReservationModal() {
	  document.getElementById('reservationModal').style.display = 'none';
	}
	</script>
</body>
</html>