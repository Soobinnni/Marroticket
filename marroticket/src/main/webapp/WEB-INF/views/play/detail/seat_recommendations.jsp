<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap"
	rel="stylesheet">
<div class="content_seat_recommendations">
	<div id="chat">
		<div class="marro_bot">
			<img src="/images/챗봇.png">
			<p>
				<strong>안녕하세요!<br>
						마로티켓 좌석추천 서비스 마로봇입니다.<br><br>
						마로봇은 예매 좌석을 추천할 수도, 예매하고자하는 좌석의 예매 여부를 확인할 수도 있습니다.<br><br>
						이용하고자하는 서비스를 선택해주세요.
				</strong>
			</p>
			<div style="margin-top: 20px;">
				<span class="recommendSeatsNum"
					style='cursor: pointer; display: inline-block; border-radius: 5px; background-color: #EB0000; min-width: 30px; height: 25px; color: white; padding: 4px 8px 0;'
					align="center"><strong>좌석 추천</strong></span> <span class="checkSeatsNum"
					style='cursor: pointer; display: inline-block; border-radius: 5px; background-color: #d9d9d9; min-width: 30px; height: 25px; color: black; padding: 4px 8px 0;'
					align="center"><strong>좌석 예매 정보 확인</strong></span>
			</div>
		</div>
		<div class="clear"></div>
		<!-- 문의하시는 서비스를 선택해주세요! -->
		<div class="marro_bot_service_start">
			<!-- 			<div class="user-input">
				<p>내용</p>
			</div> -->
			<!-- 
		<form>
			<label for="user-input">고객 :</label> <input type="text"
				id="user-input"
				value="예약 좌석중에 A열 마감, B열 마감, C열 3개 잔여, D열 13개 잔여가 남아 있는 상황 입니다. 남은 열의 좌석중에서 자리를 추천해주세요.">
			<button type="submit">질문하기</button>
		</form>-->
		</div>
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
						
						//마로봇 응답
						var marrobot_response_tag = '<div class="marro_bot" style="margin-top:30px;margin-bottom:10px;"><img src="/images/챗봇.png"><p><strong></strong></p><div class="clear"></div>';

						//사용자 응답
						var user_input_tag = "<div class='user-input'><p></p><img src='/images/send.png'></div><div class='clear'></div>";

						//종료 응답
						var marrobot_ending_tag="<div><img src='/images/마로티켓 로고 2.png' style='display:block; margin:0 auto; padding-top:30px; width:120px;'><img src='/images/refresh.png' style='display:block; margin:0 auto; padding-top:10px; width:35px; cursor:pointer' class='marrobot_ending_tag'></div>";

/* 						$("form")
								.submit(
										function(event) {
											event.preventDefault();
											var userInput = $("#user-input")
													.val();
											$("#user-input").val("");
											$("#chat")
													.append(
															"<div class='q_seat_recommendations' style='display:inline-block;float:right;'><p>고객: "
																	+ userInput
																	+ "</p></div>");
											getChatGPTResponse(userInput);
										}); */

						function getChatGPTResponse(userInput) {
							var openai_api_key = "sk-";
							var settings = {
								"async" : true,
								"crossDomain" : true,
								"url" : "https://api.openai.com/v1/completions",
								"method" : "POST",
								"headers" : {
									"Content-Type" : "application/json",
									"Authorization" : "Bearer "
											+ openai_api_key
								},
								"data" : JSON.stringify({
									"model" : "text-davinci-003",
									"prompt" : userInput,
									"temperature" : 0.5,
									"max_tokens" : 2048,
									"top_p" : 1,
									"frequency_penalty" : 0,
									"presence_penalty" : 0,
									"stop" : [ "#", ";" ],
								})
							};

							$
									.ajax(settings)
									.done(
											function(response) {
												var chatGPTResponse = response.choices[0].text;
												$(".marro_bot_service_start")
														.append(
																"<div id='chat'><div class='marro_bot'><img src='/images/챗봇.png'><p>"
																		+ chatGPTResponse
																		+ "</p></div></div>");
											}).fail(
											function(jqXHR, textStatus,
													errorThrown) {
												console.log(textStatus + ": "
														+ errorThrown);
											});
						}

						//클릭 이벤트
						$(document).on("click", ".seat_recommendations_btn span",
								function(e) {
								e.preventDefault();
								$(".seat_recommendations").show();
								 $(".recommendSeatsNum").animate({ opacity: 0 }, 400, function() {
									    $(this).animate({ opacity: 1 }, 900);
									  });
								 $(".checkSeatsNum").animate({ opacity: 0 }, 400, function() {
									    $(this).animate({ opacity: 1 }, 900);
									  });
								
								$('.play_reserve_seat').css( {
									'padding':'15px 0 10px 20px'
								});
								});
						
						//좌석 추천 기능
						$(document).on("click", ".recommendSeatsNum", function(e) {
								e.preventDefault();
								//ajax
								readSeatInfoAjax().then(function(response) {
									//ajax통신에 성공했을 때
									  var myData = response;
									  console.log(myData);
									});
						});
						
						//좌석 확인 기능
						$(document).on("click", ".checkSeatsNum", function(e) {
							e.preventDefault();
							$(this).disabled = false;
							$(".marro_bot_service_start").append(marrobot_response_tag);
							const seatNumbers = generateSeatNumbers($('input[name=pseatNumber]').val());
							const seatSelectBox = createSeatSelectBox(seatNumbers);

							$(".marro_bot:last p strong").append("확인하는 좌석을 선택해주세요.");
							
							$(".marro_bot_service_start").append(user_input_tag);
							$(".user-input:last p").append(seatSelectBox);

						});
						
						$(document).on("click", ".user-input img", function(e) {
							e.preventDefault();
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
								  //예매 불가능 알림 & 자리 추천
									$(".marro_bot_service_start").append(marrobot_response_tag);
									$(".marro_bot:last p strong").append("이미 예매된 좌석입니다.<br>대신, 마로봇이 새로운 좌석을 추천해드릴게요!");
								    return false;
								  }
								});
								if (!found) { // 예매 가능
									$(".marro_bot_service_start").append(marrobot_response_tag);
									$(".marro_bot:last p strong").append("예매가 가능한 좌석입니다!");
									$(".marro_bot_service_start").append(marrobot_ending_tag);
								}
								
							});
						});
						//refresh를 눌렀을 때
						$(document).on("click", ".marrobot_ending_tag", function(e) {
							e.preventDefault();
							$('.marro_bot_service_start').empty();
							 $(".recommendSeatsNum").animate({ opacity: 0 }, 400, function() {
								    $(this).animate({ opacity: 1 }, 900);
								  });
							 $(".checkSeatsNum").animate({ opacity: 0 }, 400, function() {
								    $(this).animate({ opacity: 1 }, 900);
								  });
						});
						
						
						//함수
						function generateSeatNumbers(numSeats) {
							  const alphabet = "abcdefghijklmnopqrstuvwxyz";
							  let seatNumbers = [];

							  for (let i = 0; i < numSeats; i++) {
							    const letter = alphabet[Math.floor(i / 9)];
							    const number = i % 9 + 1;
							    const seatNumber = letter + number;
							    seatNumbers.push(seatNumber);
							  }

							  return seatNumbers;
							}
						function createSeatSelectBox(seatNumbers) {
							  const selectBox = $("<select class='select_seat_num'>");
							  const seatOptions = {};

							  // 좌석번호를 알파벳과 숫자로 분리하고, 중복된 알파벳을 제거.
							  seatNumbers.forEach((seatNumber) => {
							    const letter = seatNumber[0];
							    const number = seatNumber.slice(1);

							    if (!seatOptions[letter]) {
							      seatOptions[letter] = [];
							    }

							    seatOptions[letter].push(number);
							  });

							  // 알파벳별로 option그룹을 생성
							  for (const letter in seatOptions) {
							    const optionGroup = $("<optgroup>");
							    optionGroup.attr("label", letter.toUpperCase());

							    seatOptions[letter].forEach((number) => {
							      const option = $("<option>");
							      option.attr("value", letter + number);
							      option.text(letter + number);
							      optionGroup.append(option);
							    });

							    selectBox.append(optionGroup);
							  }

							  return selectBox;
							}
						//좌석정보 ajax 통신
						function readSeatInfoAjax(callback) {
						    //통신에 필요한 변수
						    var pdateVal = $('input[name=reserveDateInfo]').val();
						    var pnumberVal = $('input[name=pnumber]').val();
						    var pturnVal = $('input[name=turnInfo]').val();
						    var pinfoJSON = {
						        "pdate" : pdateVal,
						        "pnumber" : pnumberVal,
						        "pturn" : pturnVal
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
						    }); // 닫는 괄호 추가
						}
					});
</script>