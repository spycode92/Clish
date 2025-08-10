<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 카테고리편집</title>
<link
	href="${pageContext.request.contextPath}/resources/css/admin/modal.css"
	rel="stylesheet" type="text/css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<style type="text/css">
.child-category {
	-ms-overflow-style: none;
 	height: 500px;
 	margin-bottom: 10px;
 	overflow-y: auto;
}

.child-category::-webkit-scrollbar{
  	display:none;
}

#childTable {
  width: 95%;
  border-collapse: collapse;
}

#childTable thead th {
  position: sticky;
  top: 0;
  z-index: 1;
  border-bottom: 2px solid #ccc;
}
</style>
</head>
<body>
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"></jsp:include>
		</div>
		<div class="modal" id="add_category">
			<div class="modal_body">
				<h3>카테고리 등록</h3>
				<form action="/admin/category/add" method="post">
					<div>
						<label>카테고리 이름</label> <input type="text" name="categoryName" required/>
					</div>
					<div>
						<span>대분류</span> 
						<select name="parentIdx" required>
							<option value="no_parent">없음</option>
							<c:forEach var="category" items="${parentCategories}">
								<option
									value="${category.categoryIdx}">${fn:substringAfter(category.categoryIdx, 'CT_')}</option>
							</c:forEach>
						</select> <span>1차 카테고리는 없음 선택</span>
					</div>
					<div>
						<label>카테고리 순서</label> 
						<input type="number" name="sortOrder" required/>
					</div>
					<div class="button-wrapper">
						<button type="button" onclick="closeAddModal()">닫기</button>
						<button type="submit">등록하기</button>
					</div>
				</form>
			</div>
		</div>
		<div class="main">
			<jsp:include page="/WEB-INF/views/admin/header.jsp"></jsp:include>
			<div class="main_container">
				<div class="bg-light">
					<div>
						<h5 class="section-title">카테고리 편집</h5>
					</div>
					<div>
						<div>
							<div class="category-header">
								<h3 class="sub-title">대분류</h3>
								<button type="button" onclick="onAddModal()">등록</button>
							</div>
						</div>
						<table id="parentTable">
							<thead>
								<tr>
									<th>대분류</th>
									<th>카테고리 이름</th>
									<th>카테고리 순서</th>
									<th colspan="2"></th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="category" items="${parentCategories}">
									<tr>
										<td>${fn:substringAfter(category.categoryIdx, 'CT_')}</td>
										<td>${category.categoryName}</td>
										<td>${category.sortOrder}</td>
										<td class="category-controls">
											<button type="button"
												onclick="onModifyModal('${category.categoryIdx}')">수정</button>
											<button type="button"
												onclick="deleteCategory('${category.categoryIdx}', ${category.depth})">삭제</button>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<div class="child-category">
						<div>
							<div>
								<h3 class="sub-title">소분류</h3>
							</div>
						</div>
						<div class="table-wrapper">
							<table id="childTable">
								<thead>
									<tr>
										<th>대분류</th>
										<th>소분류</th>
										<th>카테고리 이름</th>
										<th>카테고리 순서</th>
										<th colspan="2"></th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="category" items="${childCategories}">
										<tr>
											<td>${fn:substringAfter(category.parentIdx, 'CT_')}</td>
											<td>${category.categoryName}</td>
											<td>${category.categoryName}</td>
											<td>${category.sortOrder}</td>
											<td class="category-controls">
												<button type="button"
													onclick="onModifyModal('${category.categoryIdx}')">수정</button>
												<button type="button"
													onclick="deleteCategory('${category.categoryIdx}', ${category.depth})">삭제</button>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="modal" id="modify_category">
					<div class="modal_body">
						<h3>카테고리 수정</h3>
						<form action="/admin/category/update" method="post" id="updateForm">
							<input type="hidden" name="categoryIdx" />
							<div>
								<label>카테고리 이름</label> <input type="text" name="categoryName" required/>
							</div>
							<div>
								<span>대분류</span> 
								<select name="parentIdx" required>
									<option value="no_parent">없음</option>
									<c:forEach var="p" items="${parentCategories}">
										<option value="${fn:substringAfter(p.categoryIdx, 'CT_')}"
											<c:if test="${fn:substringAfter(p.categoryIdx, 'CT_')}">selected</c:if>>
											${fn:substringAfter(p.categoryIdx, 'CT_')}</option>
									</c:forEach>
								</select> 
								<span>1차 카테고리는 없음 선택</span>
							</div>
							<div>
								<label>카테고리 순서</label> <input type="number" name="sortOrder" required/>
							</div>
							<div class="button-wrapper">
								<button type="button" onclick="closeModifyModal()">닫기</button>
								<button type="submit">저장</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
	$(function() {
	    // 카테고리 추가 모달 열기
	    window.onAddModal = function() {
	        $('#add_category').show();
	    };

	    // 카테고리 추가 모달 닫기
	    window.closeAddModal = function() {
	        $('#add_category').hide();
	    };

	    // 카테고리 수정 모달 열기
	    window.onModifyModal = function(categoryIdx) {
	        $.ajax({
	            url: "/admin/category/modify",
	            type: "GET",
	            data: { cId: categoryIdx },
	            dataType: "json",
	            success: function(data) {
	                $('#modify_category input[name="categoryName"]').val(data.categoryName);
	                $('#modify_category select[name="parentIdx"]').val(data.parentIdx === null ? 'no_parent' : data.parentIdx.replace('CT_', ''));
	                $('#modify_category input[name="sortOrder"]').val(data.sortOrder);
	                $('#modify_category input[name="categoryIdx"]').val(data.categoryIdx);
	                $('#modify_category').show();
	            },
	            error: function() {
	                alert("카테고리 정보를 불러오는 데 실패했습니다.");
	            }
	        });
	    };

	    // 카테고리 수정 모달 닫기
	    window.closeModifyModal = function() {
	        $('#modify_category').hide();
	    };

	    // 카테고리 삭제
	    window.deleteCategory = function(categoryIdx, depth) {
	        if (confirm("해당 카테고리를 삭제하시겠습니까?")) {
	            location.href = "/admin/category/delete?cId=" + categoryIdx + "&depth=" + depth;
	        }
	    };
	});

	// 카테고리 등록
	$(function() {
	    $("form[action='/admin/category/add']").on("submit", function(e) {
	        e.preventDefault(); // 기본 제출 막기

	        const categoryName = $("input[name='categoryName']").val().trim();
	        const sortOrder = $("input[name='sortOrder']").val().trim();
	        const parentIdx = $("select[name='parentIdx']").val();
	        
	        // 특수문자 제한
	        const RegExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi;
	        if (RegExp.test(categoryName)) {
	        	alert("특수문자 입력은 불가능합니다.");
	        	return;
	        }

	        if (!categoryName || !sortOrder) {
	            alert("카테고리 이름과 순서를 입력해주세요.");
	            return;
	        }

	        $.ajax({
	            url: "/admin/category/checkDuplicate",
	            type: "GET",
	            data: {
	                categoryName: categoryName,
	                sortOrder: sortOrder,
	                parentIdx: parentIdx === "no_parent" ? '' : parentIdx
	            },
	            success: function(result) {
	                if (result.nameDuplicate) {
	                    alert("이미 존재하는 카테고리 이름입니다.");
	                } else if (result.orderDuplicate) {
	                    alert("이미 사용 중인 정렬 순서입니다.");
	                } else {
	                    $("form[action='/admin/category/add']")[0].submit();
	                }
	            },
	            error: function() {
	                alert("중복 확인 중 오류가 발생했습니다.");
	            }
	        });
	    });
	});

	// 카테고리 수정
	$(function () {
	  $("#updateForm").on("submit", function (e) {
	    e.preventDefault();
		const form = $(this);
		
	    const categoryIdx = form.find("input[name='categoryIdx']").val();
	    const categoryName = form.find("input[name='categoryName']").val().trim();
	    const sortOrder = form.find("input[name='sortOrder']").val().trim();
	    const parentIdx = form.find("select[name='parentIdx']").val();
	    
        // 특수문자 제한
        const RegExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi;
        if (RegExp.test(categoryName)) {
        	alert("특수문자 입력은 불가능합니다.");
        	return;
        }

	    if (!categoryName || !sortOrder) {
	      alert("카테고리 이름과 순서를 입력해주세요.");
	      return;
	    }

	    $.ajax({
	      url: "/admin/category/checkDuplicate",
	      type: "GET",
	      data: {
	        categoryName: categoryName,
	        sortOrder: sortOrder,
	        parentIdx: parentIdx === "no_parent" ? '' : "CT_" + parentIdx,
	        currentIdx: categoryIdx
	      },
	      success: function (result) {
	        if (result.nameDuplicate) {
	          alert("이미 존재하는 카테고리 이름입니다.");
	        } else if (result.orderDuplicate) {
	          alert("이미 사용 중인 정렬 순서입니다.");
	        } else {
	           form[0].submit(); // 원래 폼 제출
	        }
	      },
	      error: function () {
	        alert("중복 확인 중 오류가 발생했습니다.");
	      }
	    });
	  });
	});
	
	</script>
</body>
</html>