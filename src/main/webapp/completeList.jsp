<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page import="user.UserDTO"%>
<%@ page import="bbs.BbsDAO1"%>
<%@ page import="bbs.BbsDTO1"%>
<%@ page import="likey.LikeyDAO1"%>
<%@ page import="likey.LikeyDTO1"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<!doctype html>
<html>
<head>
<title>활동 이력</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">
<style type="text/css">
a, a:hover {
	color: #000000;
	text-decoration: none;
}
</style>
</head>
<body>
	<%
	request.setCharacterEncoding("UTF-8");
	String hjsy = "전체";
	String searchType = "최신순";
	String search = "";
	int pageNumber = 0;

	if (request.getParameter("hjsy") != null) {
		hjsy = request.getParameter("hjsy");
	}
	if (request.getParameter("searchType") != null) {
		searchType = request.getParameter("searchType");
	}
	if (request.getParameter("search") != null) {
		search = request.getParameter("search");
	}
	if (request.getParameter("pageNumber") != null) {
		try {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		} catch (Exception e) {
			System.out.println("검색 페이지 번호 오류");
		}
	}

	String userID = null;
	if (session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp'");
		script.println("</script>");
		script.close();
	}
	
	UserDTO userN = new UserDAO().getUser(userID);	// 로그인이 되어 있으면 사용자 정보를 유저객체에 담음
	%>
	<nav class="navbar navbar-expand-sm bg-info navbar-dark">
		<a class="navbar-brand" href="main.jsp">그거? 내가 해줄게</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
			<span class="navbar-toggler-icon"></span>
		</button>

		<!-- Navbar links -->
		<div class="collapse navbar-collapse" id="collapsibleNavbar">
			<ul class="navbar-nav">
				<li class="nav-item"><a class="nav-link" href="main.jsp">메인</a></li>
				<li class="nav-item"><a class="nav-link" href="bbs1.jsp">공동 음식 주문</a></li>
				<li class="nav-item"><a class="nav-link" href="bbs2.jsp">공동 구매 대행</a></li>
				<li class="nav-item"><a class="nav-link" href="bbs3.jsp">프린트 대행</a></li>
				<li class="nav-item"><a class="nav-link" href="bbs4.jsp">물건 운반 대행</a></li>
				<li class="active dropdown"><a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">  <%= userN.getUserID() %>의 마이페이지  </a>
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
		<h4>활동 이력</h4>
		<%
		BbsDAO1 bbsDAO = new BbsDAO1();
		ArrayList<BbsDTO1> bbsList = bbsDAO.getCompleteList(userID, hjsy, searchType, search, pageNumber);
		if (bbsList != null)
			for (int i = 0; i < bbsList.size(); i++) {
				if (i == 5)
			break;
				BbsDTO1 bbs = bbsList.get(i);
		%>

		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left">
						수령위치:&nbsp;<small><%=bbs.getPlace()%></small>&nbsp; 수령시간:&nbsp;<small><%=bbs.getSelectTime()%></small>&nbsp; 금액:&nbsp;<span style="color: red;"><%=bbs.getMoney()%>원</span>
					</div>

					<div class="col-4 text-right">
						작성자: <span style="color: green;"><%=bbs.getUserID()%></span>&nbsp; 작성시간: <span style="color: blue;"><%=bbs.getBbsDate()%></span>
					</div>

				</div>
			</div>

			<div class="card-body">
				<h5 class="card-title">
					<a href="view1.jsp?bbsID=<%=bbsList.get(i).getBbsID()%>"><%=bbs.getBbsTitle()%></a>
				</h5>
				<p class="card-text"><%=bbs.getBbsContent()%></p>
				<div class="row">
					<div class="col-9 text-left">
						<span style="color: green;" data-toggle="modal" href="#joinModal" onclick="passBbsID('<%=bbs.getBbsID()%>')">(동참: <%=bbs.getLikeCount()%>)</span>
								
					</div>
					
				</div>
			</div>
			<%
			}
			%>
		</div>
	</div>

	<ul class="pagination justify-content-center mt-3">
		<li class="page-item">
			<%
			if (pageNumber <= 0) {
			%> <a class="page-link disabled">이전</a>
			<%
			} else {
			%> <a class="page-link" href="completeList.jsp?hjsy=<%=URLEncoder.encode(hjsy, "UTF-8")%>&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>&search=<%=URLEncoder.encode(search, "UTF-8")%>&pageNumber=<%=pageNumber - 1%>">이전</a>
			<%
			}
			%>
		</li>


		<li class="page-item">
			<%
			if (bbsList.size() < 6) {
			%> <a class="page-link disabled">다음</a>
			<%
			} else {
			%> <a class="page-link" href="completeList.jsp?hjsy=<%=URLEncoder.encode(hjsy, "UTF-8")%>&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>&search=<%=URLEncoder.encode(search, "UTF-8")%>&pageNumber=<%=pageNumber + 1%>">다음</a>
			<%
			}
			%>
		</li>

	</ul>

	<footer class="bg-info mt-4 p-5 text-center" style="color: #FFFFFF;"> 2023년 캡스톤디자인 민상욱, 이동민 </footer>
	<script src="js/jquery.min.js"></script>
	<script src="js/popper.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script>
		function passBbsID(bbsID) {
			document.getElementById("approveForm" + bbsID).submit();
		}
	</script>
</body>
</html>