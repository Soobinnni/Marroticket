<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- 부트스트랩 CDN 링크 -->
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
	integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
	crossorigin="anonymous">
<!-- chart.js CDN 링크 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<div class="content"
	style='min-height: 500px; padding-top: 100px; width: 1080px; margin: 0 auto'>
	<div class="container" style='width: 60%'>
	<h2>마로봇 관리</h2>
	<p>마로봇 통계</p>
		<!-- 원형 그래프를 그리기 위한 div 태그 -->
		<div class="row">
			<div class="col-sm-6">
				<canvas id="chatType"></canvas>
			</div>
			<div class="col-sm-6">
				<canvas id="memberType"></canvas>
			</div>
		</div>

		<!-- 변수 설정 -->
		<c:set var='total' value='${chat["TOTALCOUNT"]}' />
		<c:set var='nonmember' value='${chat["NONMEMBERCOUNT"]}' />
		<c:set var='member' value='${total-nonmember}' />
		<c:set var='recommend' value='${chat["RECOMMENDCOUNT"]}' />
		<c:set var='check' value='${chat["CHECKCOUNT"]}' />

		<!-- 데이터를 배열에 저장 -->
		<c:set var="chatData" value="${recommend},${check}" />
		<c:set var="memberData" value="${member},${nonmember}" />

		<!-- chart.js 스크립트 -->
		<script>
				const chatData = [${chatData}];
				const memberData = [${memberData}];
				const chatcolors = [
					'rgb(255, 99, 132)', 
					'rgb(54, 162, 235)'
				];
				const membercolors = [
					'rgb(255, 255, 51)', 
					'rgb(0, 255, 0)'
				];
	
				// chatType
				const ctx1 = document.getElementById('chatType').getContext('2d');
				const myChart1 = new Chart(ctx1, {
					type: 'doughnut',
					data: {
						labels: ['자리추천', '좌석 예매 여부 확인'],
						datasets: [{
							data: chatData,
							backgroundColor: chatcolors
						}]
					},
					options: {
						responsive: true,
						plugins: {
							legend: {
								position: 'bottom'
							},
							title: {
								display: true,
								text: '챗봇 이용 유형'
							}
						}
					}
				});
	
				// memberType
				const ctx2 = document.getElementById('memberType').getContext('2d');
				const myChart2 = new Chart(ctx2, {
					type: 'doughnut',
					data: {
						labels: ['회원', '비회원'],
						datasets: [{
							data: memberData,
							backgroundColor: membercolors
						}]
					},
		        options: {
		            responsive: true,
		            plugins: {
		                legend: {
		                    position: 'bottom'
		                },
		                title: {
		                    display: true,
		                    text: '회원 유형'
		                }
		            }
		        }
		    });
		</script>
	</div>
</div>
