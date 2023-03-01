<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<div class="header_util_inner">
	<div class="header_util_left"></div>
	<div class="header_util_right">
		<ul class="header_util_list">
			<!-- 로그인을 하지 않은 경우 -->
			<sec:authorize access="isAnonymous()">
				<li class="header_util_item"><a href="/auth/memberlogin" class="header_util_link">로그인</a></li>
				<li class="header_util_item"><a href="/umember/umembermypage" class="header_util_link">마이페이지</a></li>
				<li class="header_util_item"><a href="/umember/umemberReserveInfo" class="header_util_link">예매확인/취소</a></li>
				<li class="header_util_item"><a href="/join" class="header_util_link">회원가입</a></li>
			</sec:authorize>
			<!-- 로그인을 한(인증된 사용자인) 경우 -->
			<sec:authorize access="isAuthenticated()">
				<li class="header_util_item"><a href="#" onclick="document.getElementById('logout').submit();" class="header_util_link">로그아웃</a></li>
				<li class="header_util_item"><a href="/umember/umembermypage" class="header_util_link">마이페이지</a></li>
				<li class="header_util_item"><a href="/umember/umemberReserveInfo" class="header_util_link">예매확인/취소</a></li>
			</sec:authorize>
		</ul>
	</div>	
</div>	
<form id="logout" action="/memberlogout" method="POST">
	<input name="${_csrf.parameterName}" type="hidden" value="${_csrf.token}" />
</form>