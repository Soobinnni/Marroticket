<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:set var="next" value="${pagination.endPage +1}" />
<c:set var="pre" value="${pagination.startPage - 1}" />

<!-- css -->
<link rel="stylesheet" type="text/css" href="/css/noticelist.css">
<!-- CSS only -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65"
	crossorigin="anonymous">


<h2>

	<spring:message code="tfaq.header.list" />
</h2>
<sec:authorize access="hasRole('ROLE_ADMIN')">
	<a href="tfaqRegister"><spring:message code="action.new" /></a>
</sec:authorize>
<table>
	<tr>
		<th align="center" width="80"><spring:message code="tfaq.no" /></th>
		<th align="center" width="320"><spring:message code="tfaq.title" /></th>
		<th align="center" width="180"><spring:message
				code="tfaq.regdate" /></th>
	</tr>

	<c:choose>
		<c:when test="${empty tfaqList }">
			<tr>
				<td colspan="4"><spring:message code="common.listEmpty" /></td>
			</tr>
		</c:when>
		<c:otherwise>
			<c:forEach items="${tfaqList }" var="tfaqVO">
				<tr>
					<td align="center">${tfaqVO.tfaqNo}</td>
					<!-- 게시글 상세보기할 때 페이징 요청 정보를 매개변수로 전달한다. -->
					<sec:authorize
						access="hasRole('ROLE_TMEMBER') or hasRole('ROLE_GUEST')">
						<td align="left"><a
							href="/tfaq/tfaqRead${pagination.makeQuery(pagination.pageRequest.page)}&tfaqNo=
${tfaqVO.tfaqNo}">${tfaqVO.title}</a></td>
					</sec:authorize>
					<sec:authorize access="hasRole('ROLE_ADMIN')">
						<td align="left"><a
							href="/tfaq/tfaqRead${pagination.makeQuery(pagination.pageRequest.page)}&accept=admin&tfaqNo=
${tfaqVO.tfaqNo}">${tfaqVO.title}</a></td>
					</sec:authorize>
					<td align="center"><fmt:formatDate pattern="yyyy-MM-dd HH:mm"
							value="${tfaqVO.regDate}" /></td>
				</tr>
			</c:forEach>
		</c:otherwise>
	</c:choose>
</table>

<!-- 페이징 네비게이션 -->
<div>
	<c:if test="${pagination.prev}">
		<sec:authorize
			access="hasRole('ROLE_TMEMBER') or hasRole('ROLE_GUEST')">
			<a href="/tfaq/tfaqList${pagination.makeQuery(pre)}">&laquo;</a>
		</sec:authorize>
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<a href="/tfaq/tfaqList${pagination.makeQuery(pre)}&accept=admin">&laquo;</a>
		</sec:authorize>
	</c:if>

	<c:forEach begin="${pagination.startPage }"
		end="${pagination.endPage }" var="idx">
		<sec:authorize
			access="hasRole('ROLE_TMEMBER') or hasRole('ROLE_GUEST')">
			<a href="/tfaq/tfaqList${pagination.makeQuery(idx)}">${idx}</a>
		</sec:authorize>
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<a href="/tfaq/tfaqList${pagination.makeQuery(idx)}&accept=admin">${idx}</a>
		</sec:authorize>
	</c:forEach>

	<c:if test="${pagination.next && pagination.endPage > 0}">
		<sec:authorize
			access="hasRole('ROLE_TMEMBER') or hasRole('ROLE_GUEST')">
			<a href="/tfaq/tfaqList${pagination.makeQuery(next)}">&raquo;</a>
		</sec:authorize>
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<a href="/tfaq/tfaqList${pagination.makeQuery(next)}&accept=admin">&raquo;</a>
		</sec:authorize>
	</c:if>
</div>

<script>
	var result = "${msg}";
	if (result === "SUCCESS") {
		alert("<spring:message code='common.processSuccess' />");
	}
	$(".header_gnb_link.board_manage").css({
		'color' : '#EB0000',
		'font-weight' : 'bold'
	});
</script>
