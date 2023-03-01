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

<!-- CSS only -->
<!-- <link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65"
	crossorigin="anonymous">
 -->
<!-- JavaScript Bundle with Popper -->
<!-- <script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
	crossorigin="anonymous"></script> -->

<!-- <
<style>
div.table {
	background-color: blue;
}

div.newbtn {
	background-color: red;
}

div.pag {
	background-color: green;
}
</style> -->

<!-- css -->
<link rel="stylesheet" type="text/css" href="/css/noticelist.css">
<!-- CSS only -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65"
	crossorigin="anonymous">
<div>
	<h2></h2>
</div>
<h2>
	<spring:message code="notice.header.list" />
</h2>
<sec:authorize access="hasRole('ROLE_ADMIN')">
	<a href="noticeRegister"><spring:message code="action.new" /></a>
</sec:authorize>
<table class="table table-hover">
	<tr>
		<th class="th1" id="noticelist" align="center" width="80" scope="cols"><spring:message
				code="notice.no" /></th>

		<th class="th2" align="center" width="320" scope="cols"><spring:message
				code="notice.title" /></th>

		<th class="th3" align="center" width="180" scope="cols"><spring:message
				code="notice.regdate" /></th>
	</tr>

	<tbody>
		<c:choose>
			<c:when test="${empty noticeList}">
				<tr>
					<td colspan="3"><spring:message code="common.listEmpty" /></td>
				</tr>
			</c:when>

			<c:otherwise>
				<c:forEach items="${noticeList}" var="noticeVO">


					<tr>
						<td align="center" scope="row">${noticeVO.noticeNo}</td>

						<!-- 게시글 상세보기할 때 페이징 요청 정보를 매개변수로 전달한다. -->
						<sec:authorize
							access="hasRole('ROLE_TMEMBER') or hasRole('ROLE_GUEST')">
							<td align="center" scope="row"><a
								href="/notice/noticeRead${pagination.makeQuery(pagination.pageRequest.page)}&noticeNo=
${noticeVO.noticeNo}">${noticeVO.title}</a></td>
						</sec:authorize>
						<sec:authorize access="hasRole('ROLE_ADMIN')">
							<td align="center" scope="row"><a
								href="/notice/noticeRead${pagination.makeQuery(pagination.pageRequest.page)}&accept=admin&noticeNo=
${noticeVO.noticeNo}">${noticeVO.title}</a></td>
						</sec:authorize>
						<td align="center" scope="row"><fmt:formatDate
								pattern="yyyy-MM-dd HH:mm" value="${noticeVO.regDate}" /></td>
					</tr>


				</c:forEach>
			</c:otherwise>
		</c:choose>
	</tbody>
</table>
</div>

<!-- 페이징 네비게이션 -->

<div class="pag" align="center">
	<c:if test="${pagination.prev}">
		<sec:authorize
			access="hasRole('ROLE_TMEMBER') or hasRole('ROLE_GUEST')">
			<a href="/notice/noticeList${pagination.makeQuery(pre)}">&laquo;</a>
		</sec:authorize>
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<a href="/notice/noticeList${pagination.makeQuery(pre)}&accept=admin">&laquo;</a>
		</sec:authorize>
	</c:if>

	<c:forEach begin="${pagination.startPage }"
		end="${pagination.endPage }" var="idx">
		<sec:authorize
			access="hasRole('ROLE_TMEMBER') or hasRole('ROLE_GUEST')">
		<a href="/notice/noticeList${pagination.makeQuery(idx)}">${idx}</a>
		</sec:authorize>
		<sec:authorize
			access="hasRole('ROLE_ADMIN')">
		<a href="/notice/noticeList${pagination.makeQuery(idx)}&accept=admin">${idx}</a>
		</sec:authorize>
	</c:forEach>

	<c:if test="${pagination.next && pagination.endPage > 0}">
		<sec:authorize
			access="hasRole('ROLE_TMEMBER') or hasRole('ROLE_GUEST')">
		<a href="/notice/noticeList${pagination.makeQuery(next)}">&raquo;</a>
		</sec:authorize>
		<sec:authorize
			access="hasRole('ROLE_ADMIN')">
		<a href="/notice/noticeList${pagination.makeQuery(next)}&accept=admin">&raquo;</a>
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