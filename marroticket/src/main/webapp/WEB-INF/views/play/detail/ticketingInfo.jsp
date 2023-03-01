<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- ticketingInfo -->
<!-- content_ticketingInfo -->
<div class="content_ticketingInfo">
	<!-- 날짜선택 -->
	<div class="play_reserve_date">
		<!-- 소제목 -->
		<h3 class="play_reserve_heading">
			<span class="play_reserve_step">STEP1</span> <span
				class="play_reserve_title">날짜 선택</span>
		</h3>
		<!-- 달력(내용) -->
		<div class="datepicker">
			<div class="datepicker_triangle"></div>
			<div class="datepicker_month-container">
				<div id="datepicker_header">
					<div id="calendar_header">
						<div id="calendar_nav">
							<button type="button" class="month-move"
								id="calendar_nav_btn_prev" data-ym="2022-04-01"><</button>
							<strong id="calendar_title">2023.01</strong>
							<button type="button" class="month-move"
								id="calendar_nav_btn_next" data-ym="2022-06-01">></button>
						</div>
						<div class="day_names">
							<div class="day_name">일</div>
							<div class="day_name">월</div>
							<div class="day_name">화</div>
							<div class="day_name">수</div>
							<div class="day_name">목</div>
							<div class="day_name">금</div>
							<div class="day_name">토</div>
						</div>
					</div>
					<div class="calandar_content">
						<div class="calandar_week">
							<!-- 							<div class="sun">1</div>
							<div class="calandar_day">2</div>
							<div class="calandar_day">3</div>
							<div class="calandar_day">4</div>
							<div class="calandar_day">5</div>
							<div class="calandar_day">6</div>
							<div class="sat">7</div> -->
						</div>
						<!-- 행 반복 -->
						<div class="calandar_week">
							<!-- 							<div class="sun">29</div>
							<div class="calandar_day">30</div>
							<div class="calandar_day"></div>
							<div class="calandar_day"></div>
							<div class="calandar_day"></div>
							<div class="calandar_day"></div>
							<div class="sat"></div> -->
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 회차선택 -->
	<div class="play_reserve_time">
		<!-- 소제목 -->
		<h3 class="play_reserve_heading">
			<span class="play_reserve_step">STEP2</span> <span
				class="play_reserve_title">회차 선택</span>
		</h3>
		<!-- 회차선택(내용) -->
		<ul class="play_time_list" role="listbox">
<!-- 			<li class="play_time_item" role="none">
				<button type="button" class="play_time_btn" role="option"
					aria-selected="true">
					<span class="play_time">00시 00분</span>
				</button>
			</li> -->
		</ul>
	</div>
	<!-- 좌석 여부 -->
	<div class="play_reserve_seat">
		<!-- 소제목 -->
		<h3 class="play_reserve_heading">
			<span class="play_reserve_title" style="font-size:16px">예매가능좌석</span>
		</h3>
		<!-- 예매가능좌석(내용) -->
		<ul class="play_seat_list">
			<li class="play_seat_item"><span class="play_seat_title">잔여</span>
				<span class="play_seat_remain"></span></li>
		</ul>
	</div>
</div>
<div align="right">
	<input type="button" class="reservation_button" value="예매하기">
</div>
<div class="closeDate_content"></div>

<form id="reserveInfoForm">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<!-- 연극 hidden -->
	<input type="hidden" name="pnumber" value="${play.pnumber}"/>
	<input type="hidden" name="pname" value="${play.pname}"/>
	<input type="hidden" name="ptheaterName" value="${play.ptheaterName}"/>
	<input type="hidden" name="ptheaterAddress" value="${play.ptheaterAddress}"/>
	<input type="hidden" name="pticketPrice" value="${play.pticketPrice}"/>
	<input type="hidden" name="pseatNumber" value="${play.pseatNumber}"/>
	<input type="hidden" name="pfirstStartTime" value="${play.pfirstStartTime}"/>
	<input type="hidden" name="psecondStartTime" value="${play.psecondStartTime}"/>
	<!-- 예매잔여좌석 -->
	<div id="hiddenSeatInfoFirst">
		
	</div>
	<div id="hiddenSeatInfoSecond">
		
	</div>
	<!-- 예매 날짜 -->
	<div id="reserveDateInfoHidden">
		
	</div>
	<div id="turnInfoHidden">
	
	</div>
</form>
<%@include file="resereCautionModal.jsp"%>