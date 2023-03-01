<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- css -->
<link rel="stylesheet" type="text/css" href="/css/noticeread.css">

<h2>
	<spring:message code="notice.header.read" />
</h2>

<form:form modelAttribute="noticeVO">
	<form:hidden path="noticeNo" />
	<table>
		<tr>
			<td><spring:message code="notice.title" /></td>
			<td><form:input path="title" readonly="true" /></td>
			<td><font color="red"><form:errors path="title" /></font></td>
		</tr>

		<tr>
			<td><spring:message code="notice.content" /></td>
			<td><form:textarea path="content" readonly="true" /></td>
			<td><font color="red"><form:errors path="content" /></font></td>
		</tr>
	</table>
</form:form>

<div>
	<sec:authorize access="hasRole('ROLE_ADMIN')">
		<button type="submit" id="btnEdit">
			<spring:message code="action.edit" />
		</button>

		<button type="submit" id="btnRemove">
			<spring:message code="action.remove" />
		</button>

	</sec:authorize>
	<sec:authorize
		access="hasRole('ROLE_TMEMBER') or hasRole('ROLE_GUEST')">
		<button type="submit" id="btnList" class="list_btn">
	</sec:authorize>
	<sec:authorize access="hasRole('ROLE_ADMIN')">
		<button type="submit" id="btnListAdmin" class="list_btn">
	</sec:authorize>
	<spring:message code="action.list" />
	</button>

</div>

<script>
	$(document).ready(function() {

		var formObj = $("#noticeVO");

		console.log(formObj);

		// 현재 페이지 번호와 페이징 크기
		var pageObj = $("#page");
		var sizePerPageObj = $("#sizePerPage");
		var pageVal = pageObj.val();
		var sizePerPageVal = sizePerPageObj.val();

		$("#btnEdit").on("click", function() {
			var noticeNo = $("#noticeNo");
			var noticeNoVal = noticeNo.val();

			self.location = "noticeModify?noticeNo=" + noticeNoVal;
		});

		$("#btnRemove").on("click", function() {
			formObj.attr("action", "remove");
			formObj.submit();
		});
		$("#btnList").on("click", function() {
			self.location = "/notice/noticeList";
		});
		$("#btnListAdmin").on("click", function() {
			self.location = "/notice/noticeList?accept=admin";
		});
	});
	$(".header_gnb_link.board_manage").css({
		'color' : '#EB0000',
		'font-weight' : 'bold'
	});
</script>