<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!-- css -->
<link rel="stylesheet" type="text/css" href="/css/list.css">

<!-- set -->
<c:set var="next" value="${pagination.endPage +1}" />
<c:set var="pre" value="${pagination.startPage - 1}" />

<!-- html -->
<div class="common_ufaqList">
	<div class="common_ufaqList_list">
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<div class="write_btn">
				<button type="button">
					<a href="ufaqRegister"><spring:message code="action.new" /></a>
				</button>
			</div>
		</sec:authorize>

		<h3 style="line-height: 5px; letter-spacing: -1px; margin-top: 10px"
			align="left">자주 묻는 질문</h3>
		<hr style="margin-top: 15px; margin-bottom: 15px">
		<table>
			<colgroup>
				<col style="width: 30px;">
				<col style="width: 100px">
				<col style="width: 80px">
			</colgroup>
			<tr>
				<th scope="col" style="height: 23px; padding: 5px;"><spring:message
						code="ufaq.no" /></th>
				<th scope="col"><spring:message code="ufaq.title" /></th>
				<th scope="col"><spring:message code="ufaq.regdate" /></th>
			</tr>


			<c:choose>
				<c:when test="${empty ufaqList }">
					<tr>
						<td colspan="4"><spring:message code="common.listEmpty" /></td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach items="${ufaqList }" var="ufaqVO">
						<tr>
							<td style="height: 23px; padding: 7px 5px;">${ufaqVO.ufaqNo}</td>
							<sec:authorize access="isAnonymous() or hasRole('ROLE_UMEMBER')">
								<td><a
									href="/ufaq/ufaqRead${pagination.makeQuery(pagination.pageRequest.page)}&ufaqNo=
	${ufaqVO.ufaqNo}">${ufaqVO.title}</a></td>
							</sec:authorize>
							<sec:authorize access="hasRole('ROLE_ADMIN')">
								<td><a
									href="/ufaq/ufaqRead${pagination.makeQuery(pagination.pageRequest.page)}&accept=admin&ufaqNo=
	${ufaqVO.ufaqNo}">${ufaqVO.title}</a></td>
							</sec:authorize>
							<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm"
									value="${ufaqVO.regDate}" /></td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</table>
		<hr style="margin-top: 15px; margin-bottom: 15px">
	</div>
	<!-- 페이징 네비게이션 -->
	<div class="pagination">
		<div class="pagination-container">
			<div class="pagination-hover-overlay"></div>
			<c:choose>
				<c:when test="${pagination.prev}">
					<sec:authorize access="isAnonymous() or hasRole('ROLE_UMEMBER')">
						<a href="/ufaq/ufaqList${pagination.makeQuery(pre)}"
							class="pagination-prev">
					</sec:authorize>
					<sec:authorize access="hasRole('ROLE_ADMIN')">
						<a href="/ufaq/ufaqList${pagination.makeQuery(pre)}&accept=admin"
							class="pagination-prev">
					</sec:authorize>
					<span style="font-weight: bold"
						class="icon-pagination icon-pagination-prev"> < </span>
					</a>
				</c:when>
				<c:otherwise>
					<span style="color: gray"
						class="icon-pagination icon-pagination-prev">< </span>
				</c:otherwise>
			</c:choose>

			<c:forEach begin="${pagination.startPage }"
				end="${pagination.endPage }" var="idx">
				<sec:authorize access="isAnonymous() or hasRole('ROLE_UMEMBER')">
					<a href="/ufaq/ufaqList${pagination.makeQuery(idx)}"
						class="pagination-page-number">${idx}</a>
				</sec:authorize>
				<sec:authorize access="hasRole('ROLE_ADMIN')">
					<a href="/ufaq/ufaqList${pagination.makeQuery(idx)}&accept=admin"
						class="pagination-page-number">${idx}</a>
				</sec:authorize>
			</c:forEach>

			<c:choose>
				<c:when test="${pagination.next && pagination.endPage > 0}">
					<sec:authorize access="isAnonymous() or hasRole('ROLE_UMEMBER')">
						<a href="/ufaq/ufaqList${pagination.makeQuery(next)}"
							class="pagination-next">
					</sec:authorize>
					<sec:authorize access="hasRole('ROLE_ADMIN')">
						<a href="/ufaq/ufaqList${pagination.makeQuery(next)}&accept=admin"
							class="pagination-next">
					</sec:authorize>
					<span style="font-weight: bold"
						class="icon-pagination icon-pagination-next"> > </span>
					</a>
				</c:when>
				<c:otherwise>
					<span style="color: gray"
						class="icon-pagination icon-pagination-prev"> > </span>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</div>

<script>
	$(".header_gnb_link.service").css({
		'color' : '#EB0000',
		'font-weight' : 'bold'
	});
	$(".header_gnb_link.board_manage").css({
		'color' : '#EB0000',
		'font-weight' : 'bold'
	});
	var result = "${msg}";
	if (result === "SUCCESS") {
		alert("<spring:message code='common.processSuccess' />");
	}
</script>
<style>
.write_btn button {
	border-radius: 20px;
	border: 1px solid rgba(0, 0, 0, 0.02);
	width: 67px;
	padding: 2px;
}

.write_btn button a {
	color: black;
}
</style>