<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<style type="text/css">
.jumbotron {
	background-position: center;
	background-size: 80em;
}

.btn btn-default {
	
}
</style>
<script type="text/javascript">
	$(".header_gnb_link.home").css({
		'color' : '#EB0000',
		'font-weight' : 'bold'
	});
</script>


<!-- CSS only -->

<div class="admin_home_content">
	<div class="page-header">
		<div class="jumbotron">
			<h1>마로티켓 관리자 페이지</h1>


			<p>마로티켓 관리자 페이지 입니다</p>
		</div>
	</div>

	<div class="row">
		<div class="col-xs-6 col-lg-4">
			<h2>공지사항</h2>
			<p>공지사항 게시판</p>
			<p>
				<a class="btn btn-default" href="/notice/noticeList?accept=admin"
					role="button"> 바로가기 &raquo;</a>
			</p>
		</div>
		<div class="col-xs-6 col-lg-4">

			<h2>사용자 FAQ</h2>
			<p>사용자 FAQ 게시판</p>
			<p>
				<a class="btn btn-default" href="/ufaq/ufaqList?accept=admin"
					role="button"> 바로가기 &raquo;</a>
			</p>
		</div>
		<div class="col-xs-6 col-lg-4">

			<div>
				<h2>극단 FAQ</h2>
				<p>극단 FAQ 게시판</p>
				<p>
					<a class="btn btn-default" href="/tfaq/tfaqList?accept=admin"
						role="button"> 바로가기 &raquo;</a>
				</p>
			</div>
		</div>
		<div class="col-xs-6 col-lg-4">

			<div>
				<h2>마로봇 관리</h2>
				<p>마로봇 통계</p>
				<p>
					<a class="btn btn-default" href="/chat/readStatistics"
						role="button"> 바로가기 &raquo;</a>
				</p>
			</div>
		</div>
	</div>
</div>
<style>
	.page-header {
		padding : 60px;
	}
	.admin_home_content {
		width : 550px;
		margin : 0 auto;
	}
	.col-xs-6 {
		display : inline-block;
		float : left;
		margin-right : 70px;
	}
</style>