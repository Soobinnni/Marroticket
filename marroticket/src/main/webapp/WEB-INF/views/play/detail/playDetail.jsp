<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script>
	$(function($) {
		$(".tab-content").eq(0).show(0);
		$(".tab-ul li").click(function() {
			var idx = $(this).index();
			$(".tab-content").hide();
			$(".tab-content").eq(idx).show();
			$(".tab-ul li").removeClass("active");
			$(this).addClass("active");
		});

	});
</script>
<ul class="tab-ul">
	<li class="active">상세정보</li>
	<li onclick="relayout()">장소정보</li>
	<li>예매/취소안내</li>
</ul>
<div class="tab-content">
	<section class="common_section section_product_content">
		<div class="product_detail_tabcontent">
			<section class="section_product_tabcont section_product_detail">
				<h3 class="product_content_subtit" style="margin-bottom:30px; margin-top : 30px">공연 시간 정보</h3>
				<div class="product_editor" style="border : 0.1px solid #242428; padding : 5px 30px; width : 300px;margin-bottom:80px">
					<p><b><span id="pstartDate"><fmt:formatDate pattern="YYYY-MM-dd (E)" value="${ play.pstartDate}" /></span> ~ <span id="pcloseDate"><fmt:formatDate
                              pattern="YYYY-MM-dd (E)" value="${ play.pcloseDate}" /></span></b></p>
					1회차 ${play.pfirstStartTime } / 2회차 ${play.psecondStartTime }
					<div>&nbsp;</div>
				</div>
				<h3 class="product_content_subtit">공지사항</h3>
				<div class="product_banner">
					<img class="product_banner_img" alt="" src="/images/notice_play_detail.png" />
				</div>
				<p>&nbsp;</p>
				<div class="product_editor"></div>
				<h3>작품상세정보</h3>
				<div class="product_templete">
					${play.pplot }
					<img alt="" src="">
					<img alt="" src="">
					<br style="clear:both">
					<br style="clear:both">
					<br style="clear:both">
					<br style="clear:both">
					<br style="clear:both">
				</div>
				<h3>캐스팅정보</h3>
				<div class="product_templete">
					${play.pcasting }
				</div>
				<h3 class="product_content_subtit" style="margin-top:100px;">상품관련정보</h3>
				<div class="product_info_table">
					<table>
						<caption>
							<span>상품관련정보</span>
						</caption>
						<colgroup>
							<col style="width : 168px;">
							<col style="width : 392px;">
							<col style="width : 168px;">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">주최/기획</th>
								<td colspan="3">${play.pagency }</td>
							</tr>
							<tr>
								<th scope="row">공연시간</th>
								<td>${play.prunningTime}분</td>
								<th scope="row">관람등급</th>
								<td>${play.pratings}</td>
							</tr>
							<tr>
								<th scope="row">공연장소</th>
								<td>${play.ptheaterAddress}</td>
								<th scope="row">예매수수료</th>
								<td>500원</td>
							</tr>
							<tr>
								<th scope="row">유효기간/이용조건	</th>
								<td colspan="3"><span id="pstartDate"><fmt:formatDate pattern="YYYY-MM-dd (E)" value="${ play.pstartDate}" /></span> ~ <span id="pcloseDate"><fmt:formatDate
                              pattern="YYYY-MM-dd (E)" value="${ play.pcloseDate}" /></span> 예매한 공연 날짜, 회차에 한해 이용 가능</td>
							</tr>
							<tr>
								<th scope="row">예매취소조건</th>
								<td colspan="3">
									<span class="text_gray">
										<span style="color: rgb(118, 118, 118);">
                                      	   예매/취소 안내에서 상세히 보실 수 있습니다.
										</span>
									</span>
								</td>
							</tr>
							<tr>
								<th scope="row">취소환불방법</th>
								<td colspan="3">
									<span style="color: rgb(118, 118, 118);">
										'마이페이지 > 예매/취소내역'에서 취소마감시간 이내에 취소할 수 있습니다.
                                    </span>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</section>
		</div>
	</section>
</div>
<div class="tab-content"><%@include file="placeInfo.jsp"%></div>
<div class="tab-content"><%@include
		file="cancelReservationInfo.jsp"%></div>