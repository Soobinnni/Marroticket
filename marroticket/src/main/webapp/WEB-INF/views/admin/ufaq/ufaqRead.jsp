<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!-- css -->
<link rel="stylesheet" type="text/css" href="/css/list.css">

<div class="common_ufaqRead">
	<h2>
		<%-- <spring:message code="ufaq.header.read" /> --%>
	</h2>
	<form:form modelAttribute="ufaqVO">
		<form:hidden path="ufaqNo" />
		<table>
			<tr>
				<%-- <td><spring:message code="ufaq.title" /></td> --%>
				<td><strong><form:input path="title" readonly="true"
							style="padding-left:30px;font-size : 40px;width:500px;border:0px solid white;" /></strong></td>
				<td><font color="red"><form:errors path="title" /></font></td>
			</tr>
		</table>
		<hr style="margin-bottom: 20px;">
		<table>
			<tr>
				<%-- <td><spring:message code="ufaq.content" /></td> --%>
				<td><form:textarea path="content" readonly="true"
						style="font-size : 18px;width:800px;min-height:300px;border:2px solid rgba(0, 0, 0, 0.2);border-radius:10px;padding:50px 150px 50px 50px" /></td>
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
		<sec:authorize access="isAnonymous() or hasRole('ROLE_UMEMBER')">
			<button type="submit" id="btnList" class="list_btn">
		</sec:authorize>
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<button type="submit" id="btnListAdmin" class="list_btn">
		</sec:authorize>
		<spring:message code="action.list" />
		</button>
	</div>
</div>
<script>
	$(document).ready(function() {
		var formObj = $("#ufaqVO");

		console.log(formObj);

		// 현재 페이지 번호와 페이징 크기
		var pageObj = $("#page");
		var sizePerPageObj = $("#sizePerPage");
		var pageVal = pageObj.val();
		var sizePerPageVal = sizePerPageObj.val();

		$("#btnEdit").on("click", function() {
			var ufaqNo = $("#ufaqNo");
			var ufaqNoVal = ufaqNo.val();

			self.location = "ufaqModify?ufaqNo=" + ufaqNoVal;
		});

		$("#btnRemove").on("click", function() {
			formObj.attr("action", "remove");
			formObj.submit();
		});
		$("#btnList").on("click", function() {
			self.location = "/ufaq/ufaqList";
		});
		$("#btnListAdmin").on("click", function() {
			self.location = "/ufaq/ufaqList?accept=admin";
		});
	});
	$(".header_gnb_link.board_manage").css({
		'color' : '#EB0000',
		'font-weight' : 'bold'
	});
	$(".header_gnb_link.service").css({
		'color' : '#EB0000',
		'font-weight' : 'bold'
	});
</script>
<style>
.list_btn {
	display: inline-block;
	border-radius: 20px;
	border: 1px solid rgba(0, 0, 0, 0.02);
	width: 67px;
	padding: 2px;
	float: right;
	margin-top: 10px;
	margin-bottom: 50px;
	cursor: pointer;
}

.list_btn a {
	color: black;
}
</style>