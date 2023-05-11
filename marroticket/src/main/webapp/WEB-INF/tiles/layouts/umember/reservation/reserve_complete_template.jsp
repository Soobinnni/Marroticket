<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<!DOCTYPE html>
<html>
<head>
<!-- ajax 통신을 위한 meta tag -->
<meta name="_csrf" content="${_csrf.token}">
<meta name="_csrf_header" content="${_csrf.headerName}">
<meta charset="UTF-8">
<title><tiles:getAsString name="title" /></title>
<!-- jQuery -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<!-- css -->
<link rel="stylesheet" type="text/css" href="/css/reserve.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&family=IBM+Plex+Sans+KR:wght@300&family=Nanum+Gothic&family=Nanum+Myeongjo:wght@700&display=swap" rel="stylesheet">

</head>
<body>
	<div id="wrap_reserve">
		<div id="header"></div>
		<div class="reserve_title">
			<tiles:insertAttribute name="logo" ignore="true" />
		</div>
		<!-- 예매진행탭 -->
		<tiles:insertAttribute name="step" ignore="true" />
		<div id="container" class="ng-isolate-scope">
			<div class="reserve_content">
				<div class="reserve_left ng-isolate-scope">
					<tiles:insertAttribute name="content" ignore="true" />
				</div>
			</div>
		</div>
		<div class="reserve_ban"></div>
	</div>
</body>
</html>