$(document)
	.ready(
		function() {
			// ajax 통신을 위한 csrf 설정
			var token = $("meta[name='_csrf']").attr("content");
			var header = $("meta[name='_csrf_header']").attr("content");
			$(document).ajaxSend(function(e, xhr, options) {
				xhr.setRequestHeader(header, token);
			});

			function prevMonth(date) {
				var target = new Date(date);
				target.setDate(1);
				target.setMonth(target.getMonth() - 1);

				return getYmd(target);
			}

			function nextMonth(date) {
				var target = new Date(date);
				target.setDate(1);
				target.setMonth(target.getMonth() + 1);

				return getYmd(target);
			}

			function getYmd(target) {
				// IE에서 날짜 문자열에 0이 없으면 인식 못함
				var month = ('0' + (target.getMonth() + 1))
					.slice(-2);
				return [target.getFullYear(), month, '01']
					.join('-');
			}

			function fullDays(date) { //date == 현재 달력의 연월일
				//현재 그려진 달력에 필요한 구성(일, 요일, 당일(getTime비교))
				var target = new Date(date);
				var year = target.getFullYear();
				var month = target.getMonth();

				var firstWeekDay = new Date(year, month, 1)
					.getDay(); //현재 달력의 1일의 요일
				var thisDays = new Date(year, month + 1, 0)
					.getDate(); //현재 달력의 마지막 일의 요일

				// 7*4, 7*5, 7*6 cell 범위
				var cell = [28, 35, 42].filter(function(n) {
					return n >= (firstWeekDay + thisDays);
				}).shift(); //배열 중 해당 인덱스 값만 남음

				// 셀 초기화
				var days = []
				for (var i = 0; i < cell; i++) {
					days[i] = {
						date: '',
						dayNum: '',
						today: false
					};
				}

				// 현재 날짜 vs 달력 날짜 비교
				var now = new Date();
				var today = new Date(now.getFullYear(), now
					.getMonth(), now.getDate());
				var inDate;

				//셀 초기화(달력에 맞게)
				for (var index = firstWeekDay, i = 1; i <= thisDays; index++, i++) {
					inDate = new Date(year, month, i);
					days[index] = {
						date: i,
						dayNum: inDate.getDay(),
						today: (inDate.getTime() === today
							.getTime())
					};
				}
				return days;
			}

			function drawMonth(date) {
				// 달력 연/월 그리기 
				$('#calendar_title').text(
					date.substring(0, 7).replace('-', '.'));

				var dateInfoList = dateInfo();
				var calendarJson = dateInfoList[0];
				var pstartDateJson = dateInfoList[1];
				var pcloseDateJson = dateInfoList[2];

				// 버튼 활성화/비활성화 조건
				var getBtnPast = getBtnActiveInfo(calendarJson, pstartDateJson, pcloseDateJson);

				if (getBtnPast == undefined) {

				} else if (getBtnPast == 'past') {
					document
						.getElementById('calendar_nav_btn_prev').disabled = true; //버튼 비활성화
					document
						.getElementById('calendar_nav_btn_next').disabled = true; //버튼 비활성화

					$("#content_ticketingInfo_tickecting").hide();
					$('#content_close_ticketingInfo')
						.append(
							'<input type="button" class="reservation_button" value="종료된 공연" style="background-color:gray;cursor: default; margin-left:70%">');
					return;
				}

				//data 저장
				$('#calendar_nav_btn_prev').data('ym',
					prevMonth(date));
				$('#calendar_nav_btn_next').data('ym',
					nextMonth(date));


				//버튼을 넘길 때마다 새롭게 그리기 위해 비움.
				$('.calandar_content').empty();

				var div = '<div class="__REST__ __TODAY__"><a __HREF__>__DATE__</a></div>';
				var href = '/reserve/schedule?date='
					+ date.substring(0, 8);
				var hasEvent;
				var divClass;
				var week = null;
				var days = fullDays(date); //초기화가 완료된 셀들
				var inDate; //index일의 date객체 생성
				var today = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate());

				for (var i = 0, length = days.length; i < length; i += 7) {
					// 전체 셀을 주단위로 잘라서 사용
					week = days.slice(i, i + 7);

					var $div = $('<div class="calandar_week"></div>');
					week
						.forEach(function(obj, index) {
							//obj는 week, index는 0~6까지
							//달력에 그릴 날
							inDate = new Date(calendarJson["date"]
								.getFullYear(), (calendarJson["date"].getMonth())
								, obj['date']);

							hasEvent = ((pstartDateJson["date"]
								.getTime()) <= inDate
									.getTime())
								&& ((pcloseDateJson["date"]
									.getTime()) >= inDate
										.getTime())
								&& (today < inDate);

							divClass = (index === 0) ? 'sun'
								: 'calandar_day';
							divClass = (index === 6) ? 'sat'
								: divClass;

							$div
								.append(div
									.replace(
										'__REST__',
										divClass)
									.replace(
										'__TODAY__',
										(obj['today']) ? 'today" id="itIstoday'
											: '')
									.replace(
										'__HREF__',
										(hasEvent) ? 'class="event" tabindex="1" href="'
											+ href
											+ ('0' + obj['date'])
												.slice(-2)
											+ '"'
											: '')
									.replace(
										'__DATE__',
										obj['date']));
						});
					$('.calandar_content').append($div);

				}
			}
			function dateInfo() {//새롭게 그려진 달력 / 공연 시작 / 공연 종료의 연 월 일 요일 가져오기
				var calendarTitle = $('#calendar_title').text();
				var calendarDate = new Date(calendarTitle
					.substring(0, 4), calendarTitle.substring(
						5, 7) - 1, '01');
				var calendarDateFull = calendarDate.getFullYear()
					+ '-'
					+ (('0' + (calendarDate.getMonth() + 1)
					).slice(-2)) + '-' + '01';
				var calendarJson = {
					"date": calendarDate,
					"yyyy-mm-dd": calendarDateFull,
					"yyyy.mm": calendarTitle,
					"mm": ('0' + (calendarDate.getMonth() + 1)).slice(-2),
					"dd": calendarDate.getDate(),
					"day": calendarDate.getDay()
				};
				var pstartDateFull = $('#pstartDate').text()
					.substring(0, 10); //YYYY-MM-dd
				var pstartDate = new Date(pstartDateFull
					.substring(0, 4), pstartDateFull.substring(
						5, 7) - 1, pstartDateFull.slice(-2));
				var pstartDateCalendar = $('#pstartDate').text().substring(
					0, 7).replace('-', '.'); //YYYY.MM
				var pstartDateMonth = pstartDateCalendar.slice(-2);

				var pstartDateJson = {
					"date": pstartDate,
					"yyyy-mm-dd": pstartDateFull,
					"yyyy.mm": pstartDateCalendar,
					"mm": pstartDateMonth,
					"dd": pstartDate.getDate(),
					"day": pstartDate.getDay()
				};

				var pcloseDateFull = $('#pcloseDate').text()
					.substring(0, 10);
				var pcloseDate = new Date(pcloseDateFull
					.substring(0, 4), pcloseDateFull.substring(
						5, 7) - 1, pcloseDateFull.slice(-2))
				var pcloseDateCalendar = $('#pcloseDate').text().substring(
					0, 7).replace('-', '.');
				var pcloseDateMonth = pcloseDateCalendar.slice(-2);

				var pcloseDateJson = {
					"date": pcloseDate,
					"yyyy-mm-dd": pcloseDateFull,
					"yyyy.mm": pcloseDateCalendar,
					"mm": pcloseDateMonth,
					"dd": pcloseDate.getDate(),
					"day": pcloseDate.getDay()
				};

				var dateInfoList = [calendarJson, pstartDateJson, pcloseDateJson];

				return dateInfoList;
			}

			function getBtnActiveInfo(calendarJson, pstartDateJson, pcloseDateJson) {

				//현재 연-월 / 월
				var realy = (new Date()).toISOString().substring(0,
					7).replace('-', '.');
				var realyMonth = realy.slice(-2);

				if (realy < pstartDateJson["yyyy.mm"]) {//현재 시점보다 상연시작일이 미래
					//'조건 1 : 상연일이 미래'
					if (realyMonth >= calendarJson["mm"]) { //현시점보다 그려진 달력의 월이 과거일 때
						// '조건 1-2 : 현시점보다 그려진 달력의 월이 과거거나 같을 때');
						document
							.getElementById('calendar_nav_btn_prev').disabled = true; //버튼 비활성화
						return;
					} else if (pcloseDateJson["mm"] <= calendarJson["mm"]) { //그려진 달력의 월이 상연종료일보다 크지 않도록 버튼 비활성화
						//'조건 1-3 : 그려진 달력의 월이 상연종료일보다 미래일 때');
						document
							.getElementById('calendar_nav_btn_next').disabled = true; //버튼 비활성화
						return;
					}
				} else { //상연시작일이 과거 혹은 현재
					//"조건 2 : 상연일이 현시점이거나, 현시점보다 과거일 때");
					if (pcloseDateJson["yyyy.mm"] < realy) {
						return 'past';
					}

					//현재 공연 중일 떄
					if (pstartDateJson["mm"] >= calendarJson["mm"]) { //현시점보다 그려진 달력의 월이 과거일 때
						// '조건 1-2 : 현시점보다 그려진 달력의 월이 과거거나 같을 때');
						document
							.getElementById('calendar_nav_btn_prev').disabled = true; //버튼 비활성화
						return;
					} else if (pcloseDateJson["mm"] <= calendarJson["mm"]) { //그려진 달력의 월이 상연종료일보다 크지 않도록 버튼 비활성화
						// '조건 1-3 : 그려진 달력의 월이 상연종료일보다 미래일 때');
						document
							.getElementById('calendar_nav_btn_next').disabled = true; //버튼 비활성화
						return;
					}
					return;
				}
			}

			$(function() {
				var date = (new Date()).toISOString().substring(0,
					10);
				drawMonth(date);

				$('.month-move')
					.on(
						'click',
						function(e) {
							e.preventDefault();
							//버튼을 다시 활성화
							document
								.getElementById('calendar_nav_btn_prev').disabled = false;
							document
								.getElementById('calendar_nav_btn_next').disabled = false;
							drawMonth($(this).data('ym'));
						});
			});
			$(document).on("click", ".event", function() {
				botServiceStart();
				$(".seat_recommendations").hide();
				$('.event').css({
					'background-color': 'white',
					'color': 'black'
				});
				$('.sat a.event').css({
					'background-color': 'white',
					'color': 'blue'
				});
				$('.sun a.event').css({
					'background-color': 'white',
					'color': '#EB0000'
				});
				$(this).css({
					'background-color': 'black',
					'color': 'lightgray',
					'border-radius': '50px',
					'font-weight': 'bold',
					'padding': '0',
					'margin': '0',
					'width': '34px',
					'height': '34px',
					'line-height': '32px',
					'box-sizing': 'border-box',
					'display': 'inline-block',
					'text-align': 'center',
					'padding': '0',
					'white-space': 'nowrap',
					'letter-spacing': '-0.03em'
				});
			});
			$(document).on("click", "#play_time_btn_first", function() {
				$(".seat_recommendations").hide();
				$('#turnInfoHidden').empty();
				botServiceStart();
				$("#turnInfoHidden").append("<input type='hidden' name='turnInfo' value=1 />");
				$('#play_time_btn_first').css({
					'border': '1px black solid'
				});
				$('#play_time_btn_second').css({
					'border': '#ecedf2 solid 1px',
					'margin-top': '10px'
				});
				$('.play_seat_remain').html($('input[name=firstTimeSeatInfo]').val());
				$('.seat_recommendations_btn').html('<img src="/images/챗봇셀렉.png" width="20px" style="margin-top:6px;"><span style="cursor:pointer;color:#EB0000;font-weight:bold;font-size:15px;">마로봇 이용하기 ▼</span>');
			});
			$(document).on("click", "#play_time_btn_second", function() {
				$('#turnInfoHidden').empty();
				botServiceStart();
				$(".seat_recommendations").hide();
				$("#turnInfoHidden").append("<input type='hidden' name='turnInfo' value=2 />");
				$('#play_time_btn_second').css({
					'border': '1px black solid',
					'margin-top': '10px'
				});
				$('#play_time_btn_first').css({
					'border': '#ecedf2 solid 1px'
				});
				$('.play_seat_remain').html($('input[name=secondTimeSeatInfo]').val());
				$('.seat_recommendations_btn').html('<img src="/images/챗봇셀렉.png" width="20px" style="margin-top:6px;"><span class="" style="cursor:pointer;color:#EB0000;font-weight:bold;font-size:15px;">마로봇 이용하기 ▼</span>');
			});


			$(document).on("click", "a.event", function(e) { //a태그를 이용해서 공연 정보 가져오기
				e.preventDefault();

				var href = $(this).attr('href').replace(/-/g, ''); //href = "/reserve/schedule?date=yyyymmdd"


				$('#reserveDateInfoHidden').empty();
				botServiceStart();
				$("#reserveDateInfoHidden").append('<input type="hidden" name="reserveDateInfo" value="' + href.slice(-8) + '">');

				var pnumberVal = $('input[name=pnumber]').val(); //공연번호
				var pnameVal = $('input[name=pname]').val(); //공연명
				var ptheaterNameVal = $('input[name=ptheaterName]').val(); //극장명
				var ptheaterAddressVal = $('input[name=ptheaterAddress]').val(); //극장주소
				var pticketPriceVal = $('input[name=pticketPrice]').val(); //티켓가격(낱개)
				var pseatNumberVal = $('input[name=pseatNumber]').val(); //좌석개수
				var pfirstStartTimeVal = $('input[name=pfirstStartTime]').val(); //1회차
				var psecondStartTimeVal = $('input[name=psecondStartTime]').val();//2회차

				var playInfoJSON = {
					"pnumber": pnumberVal,
					"pname": pnameVal,
					"ptheaterName": ptheaterNameVal,
					"ptheaterAddress": ptheaterAddressVal,
					"pticketPrice": pticketPriceVal,
					"pseatNumber": pseatNumberVal,
					"pfirstStartTime": pfirstStartTimeVal,
					"psecondStartTime": psecondStartTimeVal
				}
				var playInfoJSONStr = JSON.stringify(playInfoJSON);


				$.ajax({
					type: "post",
					url: href,
					data: playInfoJSONStr,
					contentType: "application/json; charset=utf-8",
					success: function(result) {
						console.log("1회차 잔여좌석 : " + result["first"]);
						//기존 회차별 좌석 정보 엘리먼트 지움
						$('.play_time_list').empty();
						$('#hiddenSeatInfoFirst').empty();
						$('#hiddenSeatInfoSecond').empty();

						//1회차 좌석 정보(회차선택)
						var firstTurnInfoElement
							= '<li class="play_time_item" role="none"><button type="button" id="play_time_btn_first" class="play_time_btn" role="option"aria-selected="true" style="border : black solid 1px; color:white;"><span class="play_time">1회차 ' + $('input[name=pfirstStartTime]').val() + '</span></button></li>';
						var firstTurnInfoHidden = '<input type="hidden" name="firstTimeSeatInfo" value="' + result["first"] + '"/>';
						$(".play_time_list").append(firstTurnInfoElement);
						$("#hiddenSeatInfoFirst").append(firstTurnInfoHidden);
						$("#turnInfoHidden").append("<input type='hidden' name='turnInfo' value=1 />");

						//1회차 좌석 정보(예매가능좌석수)
						$(".play_time").html("1회차 " + $('input[name=pfirstStartTime]').val());
						$('.play_seat_remain').html(result["first"]);
						$('.seat_recommendations_btn').html('<img src="/images/챗봇셀렉.png" width="20px" style="margin-top:6px;"><span style="cursor:pointer;color:#EB0000;font-weight:bold;font-size:15px;">마로봇 이용하기 ▼</span>');
				
						switch (result["second"]) {
							case 100:
								console.log("2회차 공연이 없음");
								$("#hiddenSeatInfoSecond").append(null);
								break;
							default:
								console.log("2회차 잔여좌석 : " + result["second"]);

								var secondTurnInfoElement
									= '<li class="play_time_item" role="none"><button type="button" id="play_time_btn_second" class="play_time_btn" role="option"aria-selected="true" style="margin-top:10px; border : #ecedf2 solid 1px"><span class="play_time">2회차 ' + $('input[name=psecondStartTime]').val() + '</span></button></li>';
								var secondTurnInfoHidden = '<input type="hidden" name="secondTimeSeatInfo" value="' + result["second"] + '"/>';

								$(".play_time_list").append(secondTurnInfoElement);
								$("#hiddenSeatInfoSecond").append(secondTurnInfoHidden);
								break;
						}
					}
				});
			});

			//예매하기
			$(".reservation_button").click(function() {
				if ($('input[name=firstTimeSeatInfo]').val() == undefined) {
					alert('회차를 선택해주세요!');
					return;
				}
				$.ajax({
					type: "POST",
					url: "/auth/loginCheck",
					success: function(data) {
						if (data == 'loginStatusNull') {
							if (confirm("로그인이 필요합니다")) {
								window.location.href = "/auth/memberlogin?return_to=" + encodeURIComponent(window.location.href);
							}
						} else {
							$("#reserveCautionModal").show();
						}
					}
				});
			});

			$(".close").click(function() {
				$("#reserveCautionModal").hide();
				//임시 start
				var url = "/reserve/book?pdate=" + $('input[name=reserveDateInfo]').val() + "&pturn=" + $('input[name=turnInfo]').val();
				$("#reserveInfoForm").attr("action", url);
				$("#reserveInfoForm").attr("method", "POST"); //임시 end
				$("#reserveInfoForm").submit();
			});
			
			function botServiceStart(){
				$('.marro_bot_service_start').empty();
				$(".recommendSeatsNum").attr("disabled", false);
				$(".checkSeatsNum").attr("disabled", false);
				$("#check_seatNum").attr("disabled", false);
			}	
		});