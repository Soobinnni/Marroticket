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
				<strong>안녕하세요!<br>마로티켓 좌석추천 서비스입니다.<br>서비스를
					선택해주세요!
				</strong>
			</p>
			<div style="margin-top: 20px;">
				<span class="remainSeatsNum"
					style='cursor: pointer; display: inline-block; border-radius: 5px; background-color: red; min-width: 30px; height: 25px; color: white; padding: 4px 8px 0;'
					align="center"><strong>잔여 좌석번호 정보 확인</strong></span> <span
					style='cursor: pointer; display: inline-block; border-radius: 5px; background-color: #d9d9d9; min-width: 30px; height: 25px; color: black; padding: 4px 8px 0;'
					align="center"><strong>좌석 추천</strong></span>
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

						//사용자 응답
						var user_input_tag = "<div class='user-input'></div><div class='clear'></div>";

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
												$("#chat")
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
									$('.play_reserve_seat').css({
										'padding':'15px 0 10px 20px'
									});
								});
						
						$(document).on("click", ".remainSeatsNum", function(e) {
								e.preventDefault();
								var pdateVal = $('input[name=reserveDateInfo]').val();
								var pnumberVal = $('input[name=pnumber]').val();
								var pturnVal = $('input[name=turnInfo]').val();
								var pseatNumberVal = $('input[name=pseatNumber]').val();
								
								var pinfoJSON = {
										"pdate" : pdateVal,
										"pnumber" : pnumberVal,
										"pturn" : pturnVal,
										"pseatNumber" : pseatNumberVal
										}
								//ajax
								$.ajax({
									type: "post",
									url: "/reserve/recommendSeat",
									data: JSON.stringify(pinfoJSON),
									contentType: "application/json; charset=utf-8",
									success: function(result) {
										console.log(result);
									}
								});
						});
					});
</script>