<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="content_seat_recommendations">
	<div id="chat">
		<div class="marro_bot">
			<img src="/images/챗봇.png">
			<p>
				<strong>안녕하세요!<br>
						마로티켓 좌석추천 서비스 <br><span style='color:#EB0000'>마로봇</span>입니다.<br><br>
						마로봇은 <i>예매 좌석을 추천</i>할 수도, <i>예매하고자하는 좌석의 예매 여부를 확인</i>할 수도 있습니다.<br><br>
						이용하고자하는 서비스를 선택해주세요.
				</strong>
			</p>
			<div style="margin-top: 20px;">
				<span><button type='button' class="recommendSeatsNum" value='recommend'
					style='cursor: pointer; display: inline-block; font-size:18px; border-radius: 5px; background-color: #d9d9d9; min-width: 30px; height: 35px; color: black; padding: 0 8px;'
					align="center"><strong>좌석 추천</strong></button></span> <span><button type='button' class="checkSeatsNum" value='check'
					style='cursor: pointer; display: inline-block; font-size:18px; border-radius: 5px; background-color: #d9d9d9; min-width: 30px; height: 35px; color: black; padding: 0 8px;'
					align="center"><strong>좌석 예매 정보 확인</strong></button></span>
			</div>
		</div>
		<div class="clear"></div>
		<!-- 문의하시는 서비스를 선택해주세요! -->
		<div class="marro_bot_service_start"></div>
	</div>
</div>
<script>
$(document)
.ready(
	function() {
		// ajax 통신을 위한 csrf 설정
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr(
			"content");
		$(document).ajaxSend(function(e, xhr, options) {
			xhr.setRequestHeader(header, token);
		});

		//숨기기
		$(".seat_recommendations").hide();
		//나타내기
		$(document).on("click", ".seat_recommendations_btn span",
				function(e) {
					e.preventDefault();
					$(".recommendSeatsNum").attr("disabled", false);
					$(".checkSeatsNum").attr("disabled", false);
					$("#check_seatNum").attr("disabled", false);
					$(".seat_recommendations").show();
					$(".recommendSeatsNum").animate({ opacity: 0 }, 400, function() {
						$(this).animate({ opacity: 1 }, 900);
					});
					$(".checkSeatsNum").animate({ opacity: 0 }, 400, function() {
						$(this).animate({ opacity: 1 }, 900);
					});

					$('.play_reserve_seat').css({
						'padding': '15px 0 10px 20px'
					});
				});

		//마로봇 응답
		var marrobot_response_tag = '<div class="marro_bot" style="margin-top:30px;margin-bottom:10px;"><img src="/images/챗봇.png"><p><strong></strong></p><div class="clear"></div>';

		//사용자 응답
		var check_user_input_tag = "<div class='user-input'><p></p><button type='button' id='check_seatNum'><img src='/images/send.png'></button></div><div class='clear'></div>"; //예매확인

		//종료 응답
		var marrobot_ending_tag = "<div><img src='/images/마로티켓 로고 2.png' style='display:block; margin:0 auto; padding-top:30px; width:120px;'><img src='/images/refresh.png' style='display:block; margin:0 auto; padding-top:10px; width:35px; cursor:pointer' class='marrobot_ending_tag'></div>";

		
		//좌석 추천 기능
		$(document).on("click", ".recommendSeatsNum", function(e) {
			e.preventDefault();
			chatTypeCount($(this).val());
			$(".recommendSeatsNum").attr("disabled", true);
			$(".checkSeatsNum").attr("disabled", true);
			//ajax
			readSeatInfoAjax().then(function(response) {
				//ajax통신에 성공했을 때
				var reservedSeatNumList = response;
				//예매 추천 좌석 리스트 응답받기
				readAvailableSeatInfoAjax(reservedSeatNumList).then(function(result) {
					var availableSeatNumList = result; //예매가능좌석리스트
					var colNum = 9; //
					//GPT
					var chatGPTRequest = "모든 좌석은 알파벳 순의 열을, 오름차순의 행을 가지고 있습니다. 좌석은 좌석번호의 알파벳이 작을수록 무대와 가깝고 좌석번호의 숫자가 " + colNum + "의 평균과 가까울수록 중앙에 위치합니다. 현재 예매할 수 있는 좌석의 리스트는 " + availableSeatNumList + " 입니다.";
					chatGPTRequest += "대답은 리스트 좌석번호 가운데 '중앙에 가까운 좌석번호로 ___를 추천하고, 무대와 가장 가까운 좌석은 _열의 ___들을 추천합니다!'라고 사용자에게 추천합니다.(알파벳은 소문자로 표현합니다)";
					console.log(chatGPTRequest);
					getChatGPTResponse(chatGPTRequest);
				});
			});
		});

		//좌석 확인 기능
		$(document).on("click", ".checkSeatsNum", function(e) {
			e.preventDefault();
			chatTypeCount($(this).val());
			$(".recommendSeatsNum").attr("disabled", true);
			$(".checkSeatsNum").attr("disabled", true);
			$(this).disabled = false;
			$(".marro_bot_service_start").append(marrobot_response_tag);
			var seatNumbers = generateSeatNumbers($('input[name=pseatNumber]').val());
			var seatSelectBox = createSeatSelectBox(seatNumbers);

			$(".marro_bot:last p strong").append("확인하는 좌석을 선택해주세요.");

			$(".marro_bot_service_start").append(check_user_input_tag);
			$(".user-input:last p").append(seatSelectBox);

		});

		$(document).on("click", "#check_seatNum", function(e) {
			e.preventDefault();
			$("#check_seatNum").attr("disabled", true);
			//ajax
			readSeatInfoAjax().then(function(response) {
				//ajax통신에 성공했을 때
				var selectSeatNum = $(".select_seat_num").val(); //선택좌석
				var reservedSeatNumList = response; //예매좌석
				var found = false;

				//좌석 일치 확인
				$.each(reservedSeatNumList, function(index, item) {
					if (item === selectSeatNum) { // 예매 불가
						found = true;
						//예매 불가능 알림 & 자리 추천 - 예매 가능 좌석 리스트 응답받기
						readAvailableSeatInfoAjax(reservedSeatNumList).then(function(result) {
							var availableSeatNumList = result; //예매가능좌석리스트

							var chatGPTRequest = "'" + reservedSeatNumList + "'좌석은 마감 상황입니다. ";
							chatGPTRequest += "'" + availableSeatNumList + "'남은 좌석중에서 좌석1개를 추천하며 뒤의 조건을 따릅니다. ";
							chatGPTRequest += "첫째 "+selectSeatNum+"과 알파벳이 같은 좌석 또는 둘째 남은 좌석에서 같은 알파벳이 존재하지 않으면 "+selectSeatNum+"과 알파벳의 순서가 가장 가까운 좌석";

							console.log(chatGPTRequest);
							//GPT
							$(".marro_bot_service_start").append(marrobot_response_tag);
							$(".marro_bot:last p strong").append("이미 예매된 좌석입니다.<br><br>대신, 마로봇이 예매되지 않은 가까운 좌석을 추천해드릴게요!<br><br>");
							getChatGPTResponse(chatGPTRequest);
						});

						return false;
					}
				});
				if (!found) { // 예매 가능
					$(".marro_bot_service_start").append(marrobot_response_tag);
					$(".marro_bot:last p strong").append("예매가 가능한 좌석입니다!");
					//봇 응답 종료
					$(".marro_bot_service_start").append(marrobot_ending_tag);
				}
			});
		});
		//refresh를 눌렀을 때
		$(document).on("click", ".marrobot_ending_tag", function(e) {
			e.preventDefault();
			$(".recommendSeatsNum").attr("disabled", false);
			$(".checkSeatsNum").attr("disabled", false);
			$("#check_seatNum").attr("disabled", false);
			$('.marro_bot_service_start').empty();
			$(".recommendSeatsNum").animate({ opacity: 0 }, 400, function() {
				$(this).animate({ opacity: 1 }, 900);
			});
			$(".checkSeatsNum").animate({ opacity: 0 }, 400, function() {
				$(this).animate({ opacity: 1 }, 900);
			});
		});
		
		//chat button click count update
		function chatTypeCount(type){				
			//ajax
			$.ajax({
				url: "/chat/saveType",
				type: "POST",
				contentType: "application/json",
				data: JSON.stringify({
					"type": type
				}),
				success: function(result) {
					console.log(result); 
				}
			});
		}

		function generateSeatNumbers(numSeats) {
			var alphabet = "abcdefghijklmnopqrstuvwxyz";
			let seatNumbers = [];

			for (let i = 0; i < numSeats; i++) {
				var letter = alphabet[Math.floor(i / 9)];
				var number = i % 9 + 1;
				var seatNumber = letter + number;
				seatNumbers.push(seatNumber);
			}

			return seatNumbers;
		}
		function createSeatSelectBox(seatNumbers) {
			var selectBox = $("<select class='select_seat_num'>");
			var seatOptions = {};

			// 좌석번호를 알파벳과 숫자로 분리하고, 중복된 알파벳을 제거.
			seatNumbers.forEach((seatNumber) => {
				var letter = seatNumber[0];
				var number = seatNumber.slice(1);

				if (!seatOptions[letter]) {
					seatOptions[letter] = [];
				}

				seatOptions[letter].push(number);
			});

			// 알파벳별로 option그룹을 생성
			for (var letter in seatOptions) {
				var optionGroup = $("<optgroup>");
				optionGroup.attr("label", letter.toUpperCase());

				seatOptions[letter].forEach((number) => {
					var option = $("<option>");
					option.attr("value", letter + number);
					option.text(letter + number);
					optionGroup.append(option);
				});

				selectBox.append(optionGroup);
			}

			return selectBox;
		}
		//좌석정보 ajax 통신
		function readSeatInfoAjax() {
			//통신에 필요한 변수
			var pdateVal = $('input[name=reserveDateInfo]').val();
			var pnumberVal = $('input[name=pnumber]').val();
			var pturnVal = $('input[name=turnInfo]').val();
			var pinfoJSON = {
				"pdate": pdateVal,
				"pnumber": pnumberVal,
				"pturn": pturnVal
			}
			return new Promise(function(resolve) { // Promise 객체 생성
				//ajax
				$.ajax({
					type: "post",
					url: "/reserve/readSeatInfo",
					data: JSON.stringify(pinfoJSON),
					contentType: "application/json; charset=utf-8",
					success: function(response) {
						resolve(response); // 비동기 처리 결과 값을 반환
					}
				});
			});
		}
		//예매가능좌석 ajax 통신
		function readAvailableSeatInfoAjax(reservedSeatNumList) {
			return new Promise(function(resolve) { // Promise 객체 생성
				console.log(reservedSeatNumList);
				//ajax
				$.ajax({
					url: "/reserve/recommendSeat",
					type: "POST",
					contentType: "application/json",
					data: JSON.stringify({
						"reservedSeatNumList": reservedSeatNumList,
						"pseatNumber": $('input[name=pseatNumber]').val()
					}),
					success: function(result) {
						resolve(result); // 비동기 처리 결과 값을 반환
					}
				});
			});
		}


		//GPT 통신
		function getChatGPTResponse(userInput) {
			var settings = {
				"async": true,
				"crossDomain": true,
				"url": "https://api.openai.com/v1/completions",
				"method": "POST",
				"headers": {
					"Content-Type": "application/json",
					"Authorization": "Bearer "
						+ openai_api_key
				},
				"data": JSON.stringify({
					"model": "text-davinci-003",
					"prompt": userInput,
					"temperature": 0.4,
					"max_tokens": 2048,
					"top_p": 1,
					"frequency_penalty": 0,
					"presence_penalty": 0,
					"stop": ["#", ";"],
				})
			};

			$
				.ajax(settings)
				.done(
					function(response) {
						var chatGPTResponse = response.choices[0].text;
						$(".marro_bot_service_start").append(marrobot_response_tag);
						$(".marro_bot:last p strong").append(chatGPTResponse);
						//봇 응답 종료
						$(".marro_bot_service_start").append(marrobot_ending_tag);
					}).fail(
						function(jqXHR, textStatus,
							errorThrown) {
							console.log(textStatus + ": "
								+ errorThrown);
						});
		}

	});
</script>