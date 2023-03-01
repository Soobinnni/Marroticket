<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<section class="play_place">
	<div class="play_place_header">
		<h2 class="play_place_h2" style="font-size: 2em; margin-top: 60px">공연장
			정보</h2>
	</div>
	<hr>
	<br>
	<div class="play_place_text"
		style="font-size: 20px; letter-spacing: -0.03em; line-height: 40px;">
		<span class="theater_name">장소 : ${ play.ptheaterName }</span><br>
		<span class="theater_address">주소 : ${ play.ptheaterAddress }</span>
		<!-- 대표번호-->
	</div>
	<div id="map" style="width: 100%; height: 500px; margin-top: 3%;"></div> 
</section>
<script>
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 

	mapOption = {
		center : new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
		level : 3
	// 지도의 확대 레벨
	};

	// 지도 생성
	var map = new kakao.maps.Map(mapContainer, mapOption);
	// 주소-좌표 변환 객체 생성
	var geocoder = new kakao.maps.services.Geocoder();
	//극장 주소
	var theaterAddress = "${ play.ptheaterAddress }";
	//극장명
	var theaterName = "${ play.ptheaterName }";

	function relayout() {
		// 지도를 표시하는 div 크기를 변경한 이후 지도가 정상적으로 표출되지 않을 수도 있음
		// 크기를 변경한 이후에는 반드시  map.relayout 함수를 호출해야 한다.
		// window의 resize 이벤트에 의한 크기변경은 map.relayout 함수가 자동으로 호출된다.
		map.relayout();
		setTimeout(reRelayout, 0.1);
	}
	function reRelayout() {
		map.relayout();
		geocoder
				.addressSearch(
						theaterAddress,
						function(result, status) {

							// 정상적으로 검색이 완료됐으면 
							if (status === kakao.maps.services.Status.OK) {

								var coords = new kakao.maps.LatLng(result[0].y,
										result[0].x);

								// 결과값으로 받은 위치를 마커로 표시
								var marker = new kakao.maps.Marker({
									map : map,
									position : coords
								});

								// 인포윈도우로 장소에 대한 설명을 표시
								var infowindow = new kakao.maps.InfoWindow(
										{
											content : '<div style="width:150px;text-align:center;padding:6px 0;">'
													+ theaterName + '</div>'
										});
								infowindow.open(map, marker);

								// 지도의 중심을 결과값으로 받은 위치로 이동.
								map.setCenter(coords);

							}
						});

	}
</script>