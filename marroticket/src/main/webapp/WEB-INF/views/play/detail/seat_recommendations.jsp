<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap"
	rel="stylesheet">
<div class="seat_recommendations">
	<div class="content_seat_recommendations">
		<div class="header_seat_recommendations">마로티켓 좌석추천</div>
		<div id="chat">
			<div class="marro_bot">
				<img src="/images/챗봇.png">
				<p>
					안녕하세요!<br>마로티켓 좌석추천 서비스입니다.<br>좌석을 추천받기 위해선 관람일을 먼저
					입력해야합니다.
				</p>
			</div>
			<!-- 문의하시는 서비스를 선택해주세요! -->
			<div class="marro_bot_select_month"></div>
		</div>
		<div class="clear"></div>
		<!-- -->
		<form>
			<label for="user-input">고객 :</label> <input type="text"
				id="user-input"
				value="예약 좌석중에 A열 마감, B열 마감, C열 3개 잔여, D열 13개 잔여가 남아 있는 상황 입니다. 남은 열의 좌석중에서 자리를 추천해주세요.">
			<button type="submit">질문하기</button>
		</form>

	</div>
</div>
<script>
	$(document)
			.ready(
					function() {
						//시작일
						var pstartDate = new Date($('#pstartDate').text()
								.substring(0, 4), '0'+($('#pstartDate').text()
								.substring(6, 7)-1),  $('#pstartDate').text()
								.substring(8, 10)); 
								//종료일
						var pcloseDate = new Date($('#pcloseDate').text()
								.substring(0, 4), '0'+($('#pcloseDate').text()
								.substring(6, 7)-1),  $('#pcloseDate').text()
								.substring(8, 10)); 
								console.log(pcloseDate);
								
						//페이지가 준비되면, 월을 선택하도록 선택지를 준다.
						//'조건 1 : 상연일이 미래'
						//'조건 2 : 상연시작일이 과거 혹은 현재'
						$("form")
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
										});

						function getChatGPTResponse(userInput) {
							var openai_api_key = "";
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
					});
</script>