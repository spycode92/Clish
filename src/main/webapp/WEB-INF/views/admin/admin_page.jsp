<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Clish - 대시보드</title>
<link href="${pageContext.request.contextPath}/resources/css/the_best_styles.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/admin/admin.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/admin/dashboard.css" rel="stylesheet" type="text/css">
<link rel='icon' href='/resources/images/logo4-2.png' type='image/x-icon'/>
<script src="https://kit.fontawesome.com/a96e186b03.js" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.5.0/Chart.min.js"></script>
</head>
<body>
	<div class="container">
		<div class="sidebar">
			<jsp:include page="/WEB-INF/views/admin/sidebar.jsp"></jsp:include>	
		</div>
		<div class="main">
			<jsp:include page="/WEB-INF/views/admin/header.jsp"></jsp:include>
			<div class="main_container">
				<div>
					<div class="dashboard-container bg-light">
						<div class="dashboard-summary">
							<div class="summary-card" onclick="location.href='/admin/user'">
								<div class="summary-icon">
									<i class="fa-solid fa-users"></i>
								</div>
								<div class="summary-text">
									<div class="summary-label">총 회원수</div>
									<div class="summary-value">${summary.userCount}명</div>
								</div>
							</div>
						</div>
						<div class="dashboard-summary" onclick="location.href='/admin/company'">
							<div class="summary-card">
								<div class="summary-icon">
									<i class="fa-solid fa-building"></i>
								</div>
								<div class="summary-text">
									<div class="summary-label">총 기업수</div>
									<div class="summary-value">${summary.companyCount}개</div>
								</div>
							</div>
						</div>
						<div class="dashboard-summary" onclick="location.href='/admin/company'">
							<div class="summary-card">
								<div class="summary-icon">
									<i class="fa-solid fa-address-card"></i>
								</div>
								<div class="summary-text">
									<div class="summary-label">가입 승인 대기</div>
									<div class="summary-value">${summary.pendingCompanyCount}개</div>
								</div>
							</div>
						</div>
						<div class="dashboard-summary" onclick="location.href='/admin/classList'">
							<div class="summary-card">
								<div class="summary-icon">
									<i class="fa-solid fa-landmark"></i>
								</div>
								<div class="summary-text">
									<div class="summary-label">강의 승인 대기</div>
									<div class="summary-value">${summary.pendingClassCount}개</div>
								</div>
							</div>
						</div>
						<div class="dashboard-summary" onclick="location.href='/admin/inquiry'">
							<div class="summary-card">
								<div class="summary-icon">
									<i class="fa-solid fa-bell"></i>
								</div>
								<div class="summary-text">
									<div class="summary-label">미답변 문의</div>
									<div class="summary-value">${summary.unAnsweredInquiryCount}개</div>
								</div>
							</div>
						</div>
					</div>
					<div class="bg-light mini-chart">
						<canvas id="dailyChart" width="500" height="300"></canvas>
						<canvas id="categoryChart" width="500" height="300"></canvas>
					</div>	
					<div class="bg-light chart">
						<canvas id="monthlyChart" width="1000" height="400"></canvas>
					</div>	
				
				</div>
			</div>
		</div>
	</div>
<script type="text/javascript">
function loadDailyRevenueChart() {
	  fetch("/admin/revenue/daily")
	    .then(res => res.json())
	    .then(data => {
	      // 5일 간격으로 날짜 보여주기
	      const today = new Date();
	      const day = today.getDay();
	      const monday = new Date(today);
	      monday.setDate(today.getDate() - ((day + 6) % 7));
	      
	      const labels = [];
	      const dataMap = {};

	      for (let i = 0; i < 5; i++) {
	          const d = new Date(monday);
	          d.setDate(monday.getDate() + i);
	          const label = d.toISOString().split('T')[0];
	          labels.push(label);
	      }

	      data.forEach(item => {
	        dataMap[item.date] = item.total;
	      });

	      const values = labels.map(label => dataMap[label] || 0);

	      new Chart(document.getElementById("dailyChart").getContext("2d"), {
	        type: 'bar',
	        data: {
	          labels: labels.map(d => d.slice(5)),
	          datasets: [{
	            label: "일별 매출",
	            data: values,
	            backgroundColor: 'rgba(255, 118, 1, 0.7)'
	          }]
	        },
	        options: {
	          responsive: false,
	          scales: {
	        	  yAxes: [{
	        	      ticks: {
	        	        beginAtZero: true,
	        	        min: 0,
	        	        max: 100000,   
	        	        stepSize: 10000
	        	      }
	        	    }]
	            }
	          }
	      });
	    });
	}
	
	const labels = Array.from({ length: 12 }, (_, i) => {
	  const month = i + 1;
	  return month + "월";
	});
	

	function loadMonthlyRevenueChart() {
	  fetch("/admin/revenue/monthly")
	    .then(res => res.json())
	    .then(data => {
	      const revenueMap = new Map();
	      const currentYear = new Date().getFullYear();
	      
	      data.forEach(item => {
	    	const [yearStr, monthStr] = (item.date || "").split('-');
	    	const year = parseInt(yearStr);
	    	const month = parseInt(monthStr);
	    	
	        if (!isNaN(year) && year === currentYear && !isNaN(month)) {
	            revenueMap.set(month + "월", item.total);
	          }
	        });

	      const values = labels.map(label => revenueMap.get(label) || 0);

	      const ctx = document.getElementById("monthlyChart").getContext("2d");
	      new Chart(ctx, {
	        type: "bar",
	        data: {
	          labels: labels,
	          datasets: [{
	            label: currentYear + " 매출",
	            data: values,
	            backgroundColor: "rgba(255, 118, 1, 0.7)",
	            borderRadius: 6
	          }]
	        },
	        options: {
	          responsive: false,
	          scales: {
	            y: {
	              beginAtZero: true,
	              title: { display: true, text: "매출 (원)" }
	            },
	            x: {
	              title: { display: true, text: "월" }
	            }
	          }
	        }
	      });
	    });
	}
	
	function loadCategoryRevenueChart() {
		fetch("/admin/revenue/category")
		  .then(res => res.json())
		  .then(data => {
			  const labels = data.map(item => item.categoryName);
			  const values = data.map(item => item.total);
			  
			  const ctx = document.getElementById("categoryChart").getContext("2d");
			  
			  new Chart(ctx, {
			        type: "bar",
			        data: {
			          labels: labels,
			          datasets: [{
			            label: "월별 카테고리 매출",
			            backgroundColor: "rgba(255, 118, 1, 0.7)",
			            data: values,
			            borderRadius: 6
			          }]
			        },
			        options: {
			          responsive: false,
			          scales: {
			            y: {
			              beginAtZero: true,
			              title: { display: true, text: "매출 (원)" }
			            },
			            x: {
			              title: { display: true, text: "카테고리" }
			            }
			          }
			        }
			      });
			    })
			    .catch(err => {
			      console.error("카테고리별 매출 로딩 실패:", err);
			    });
			}
	
	document.addEventListener("DOMContentLoaded", () => {
		  loadDailyRevenueChart();
		  loadMonthlyRevenueChart();
		  loadCategoryRevenueChart();
		});
</script>
</body>
</html>