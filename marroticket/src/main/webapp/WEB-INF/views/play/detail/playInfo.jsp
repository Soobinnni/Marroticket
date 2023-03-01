<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!-- div / id ="content_playInfo" -->

<!-- 연극 공연명 -->
<h1 style="font-size : 2em">
	${ play.pname }
</h1>
<hr>

<!--  연극 공연 정보 -->
<table class="playInfo_table">
	<!-- 장소, 관람시간, 기간, 관람등급  -->
	<tr>
		<td width="30%" height= 45 class="first_column">장소</td>
		<td width="70%" height= 45>${play.ptheaterName }</td>
	</tr>
	<tr>
		<td class="first_column" height= 45>관람시간</td>
		<td height= 50>${ play.prunningTime }분</td>
	</tr>
	<tr>
		<td class="first_column" height= 45>기간</td>
		<td height= 50><span id="pstartDate"><fmt:formatDate pattern="YYYY-MM-dd (E)" value="${ play.pstartDate}" /></span> ~ <span id="pcloseDate"><fmt:formatDate
                              pattern="YYYY-MM-dd (E)" value="${ play.pcloseDate}" /></span></td>
	</tr>
	<tr>
		<td class="first_column" height= 45>장르</td>
		<td height= 50>${ play.pgenre}</td>
	</tr>
	<tr>
		<td class="first_column" height= 45>관람등급</td>
		<td height= 50>${ play.pratings}</td>
	</tr>
</table>
<hr style="border: 0; bord-style: solid; background-color: rgba(222, 222, 222, 1); height: 1px;">
<table class="playInfo_table">	
	<!-- 가격 -->
	<tr>
		<td width="30%" class="first_column" height= 45>가격</td>
		<td width="70%" height= 45>전석 ${ play.pticketPrice}원</td>
	</tr>
</table>
<!-- 상연이 끝난 공연일 경우 -->
<div id="content_close_ticketingInfo"></div>