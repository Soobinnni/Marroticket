<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<h2>지난 상연 목록</h2>
<table border="1">
	<c:choose>
		<c:when test="${empty playPassList }">
			<tr>
				<td><h3>지난 상연 연극이 없습니다.</h3></td>
				<td><h3>상연기간이 지난 연극이 없습니다.</h3></td>
			</tr>
		</c:when>
		<c:otherwise>
			<c:forEach items="${list}" var="playPassList">
				<tr>
					<td width="160">${playPassList.pPoster }<br>${playPassList.pName }<br>${playPassList.pTheaterName }<br>${playPassList.pStartDate }~${playPassList.pCloseDate }</td>
				</tr>
			</c:forEach>
			<tr>
				<c:forEach items="${playPassList}" var="CurrentList"
					varStatus="status">
					<td><table>
							<tr>
								<td align="center"><a
									href="/play/playDetail?pNumber=${CurrentList.PNumber }">${CurrentList.PPoster }</a></td>
							</tr>
							<tr>
								<td align="center">${CurrentList.PName}</td>
							</tr>
							<tr>
								<td align="center">${CurrentList.PTheaterName}</td>
							</tr>
							<tr>
								<td align="center"><fmt:formatDate pattern="YYYY-MM-dd (E)"
										value="${CurrentList.PStartDate}" />~<br> <fmt:formatDate
										pattern="YYYY-MM-dd (E)" value="${CurrentList.PCloseDate }" /></td>
							</tr>
						</table></td>
					<c:if test="${status.count%4 == 0 }">
						<tr></tr>
					</c:if>
				</c:forEach>
			</tr>
		</c:otherwise>
	</c:choose>
</table>