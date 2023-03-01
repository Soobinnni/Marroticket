<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<link rel="stylesheet" type="text/css" href="/css/playList.css">
<!-- 	<h2 class="play_status">상연 예정 목록</h2> -->
<div class="common_content_playExpectedList">
	<div class="common_content_playExpectedList_tables">
<table>
	<c:choose>
		<c:when test="${empty playExpectedList }">
			<tr>
				<td><h3>상연 예정 연극이 없습니다.</h3></td>
			</tr>
		</c:when>
		<c:otherwise>
			<tr>
				<c:forEach items="${playExpectedList}" var="list" varStatus="status">
					<td><div class="playDiv">
							<table class="playTable">
								<tr>
									<td align="center"><a
										href="/play/playDetail?pNumber=${list.pnumber }"> <img
											class="playListImg" alt="..."
											src="poster?pnumber=${list.pnumber }"></a></td>
								</tr>
							</table>
							<table class="playInfo">
								<tr class="playName">
									<td align="center">${list.pname}</td>
								</tr>

								<tr class="playTheaterName">
									<td align="center">${list.ptheaterName}</td>
								</tr>
								<tr class="playTime">
									<td align="center"><fmt:formatDate
											pattern="YYYY-MM-dd (E)" value="${list.pstartDate}" />~ <fmt:formatDate
											pattern="YYYY-MM-dd (E)" value="${list.pcloseDate }" /></td>
								</tr>
							</table>
						</div></td>
					<c:if test="${status.count%4 == 0 }">
						<tr></tr>
					</c:if>
				</c:forEach>
			</tr>
		</c:otherwise>
	</c:choose>
</table>
</div>
</div>
<script>
	$(".header_gnb_link.expected").css({
    'color': '#EB0000',
    'font-weight': 'bold'
	});
</script>
