<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<%@ page import="java.io.PrintWriter"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">
<title>그거? 내가 해줄게</title>
</head>
<body>
	<%
	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	
	UserDTO userN = new UserDAO().getUser(userID);	// 로그인이 되어 있으면 사용자 정보를 유저객체에 담음
	%>

	<%-- 네비게이션: 하나의 웹사이트의 전반적인 구성을 보여줌 --%>
	<nav class="navbar navbar-expand-sm bg-info navbar-dark">
		<a class="navbar-brand" href="main.jsp">그거? 내가 해줄게</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
			<span class="navbar-toggler-icon"></span>
		</button>

		<!-- Navbar links -->
		<div class="collapse navbar-collapse" id="collapsibleNavbar">
			<ul class="navbar-nav">
				<li class="active"><a class="nav-link" href="main.jsp">메인</a></li>
				<li class="nav-item"><a class="nav-link" href="bbs1.jsp">공동 음식 주문</a></li>
				<li class="nav-item"><a class="nav-link" href="bbs2.jsp">공동 구매 대행</a></li>
				<li class="nav-item"><a class="nav-link" href="bbs3.jsp">프린트 대행</a></li>
				<li class="nav-item"><a class="nav-link" href="bbs4.jsp">물건 운반 대행</a></li>
				<li class="nav-item dropdown"><a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown"> <%= userN.getUserID() %>의 마이페이지  </a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
						<%
						if (userID == null) {
						%>
						<a class="dropdown-item" href="userLogin.jsp">로그인</a> <a class="dropdown-item" href="userRegister.jsp">회원가입</a>
						<%
						} else {
							UserDAO user = new UserDAO();
							String rider = user.getRider(userID);
							if (rider.equals("1")) {
							%>
							<a class="dropdown-item" href="requestList.jsp">승인 요청</a>
							<a class="dropdown-item" href="requestList2.jsp">요청 대기 목록</a>
							<a class="dropdown-item" href="requestList3.jsp">진행 사항</a>
							<a class="dropdown-item" href="completeList.jsp">활동 이력</a>
							<%
							}
							%>
							<a class="dropdown-item" href="userInfo.jsp?userID=<%=userID%>">회원정보</a>
							<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
						<%
						}
						%>
					</div></li>
			</ul>
		</div>

	</nav>
	<br>
	<div class="container">
		<div class="jumbotron">
			<div class="container">
				<h1>웹 사이트 소개</h1>
				<p>캡스톤 디자인 '그거? 내가 해줄게 - 음식 배달 공동 주문 및 심부름 서비스'</p>
				<p>
					<a class="btn btn-primary btn-pull" href="#" role="button"> 자세히 알아보기 </a>
				</p>
			</div>
		</div>
	</div>
	<div class="container">
		<div id="myCarousel" class="carousel slide" data-ride="carousel">
			<ul class="carousel-indicators">
				<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
				<li data-target="#myCarousel" data-slide-to="1"></li>
				<li data-target="#myCarousel" data-slide-to="2"></li>
			</ul>
			<div class="carousel-inner">
				<div class="carousel-item active">
					<img src="images/1.jpg">
				</div>
				<div class="carousel-item">
					<img src="images/2.jpg">
				</div>
				<div class="carousel-item">
					<img src="images/3.jpg">
				</div>
			</div>
			<a class="carousel-control-prev" href="#myCarousel" data-slide="prev"> <span class="carousel-control-prev-icon"></span>
			</a> <a class="carousel-control-next" href="#myCarousel" data-slide="next"> <span class="carousel-control-next-icon"></span>
			</a>
		</div>
	</div>
	<footer class="bg-info mt-4 p-5 text-center" style="color: #FFFFFF;"> 2023 캡스톤디자인 민상욱, 이동민 </footer>
	<script src="js/jquery.min.js"></script>
	<script src="js/popper.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
</body>
</html>