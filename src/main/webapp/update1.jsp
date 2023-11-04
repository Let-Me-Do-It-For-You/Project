<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page import="bbs.BbsDAO1"%>
<%@ page import="bbs.BbsDTO1"%>
<%@ page import="likey.LikeyDAO1"%>
<%@ page import="likey.LikeyDTO1"%>
<%@ page import="comment.CommentDAO1"%>
<%@ page import="comment.CommentDTO1"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<!doctype html>
<html>
<head>
<title>공동 음식 주문</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">

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

	int bbsID = 0;
	if (request.getParameter("bbsID") != null) {
		bbsID = Integer.parseInt(request.getParameter("bbsID"));
	}
	
	if (bbsID == 0) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		//script.println("alert('유효하지 않은 글입니다.')");
		script.println("location.href = 'bbs1.jsp'"); // bbs1.jsp로 페이지 이동
		script.println("</script>");
	}
	
	BbsDTO1 bbs = new BbsDAO1().getBbs(bbsID);
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
				<li class="active"><a class="nav-link" href="bbs1.jsp">공동 음식 주문</a></li>
				<li class="nav-item"><a class="nav-link" href="bbs2.jsp">공동 구매 대행</a></li>
				<li class="nav-item"><a class="nav-link" href="bbs3.jsp">프린트 대행</a></li>
				<li class="nav-item"><a class="nav-link" href="bbs4.jsp">물건 운반 대행</a></li>
				<li class="nav-item dropdown"><a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown"> 회원 관리 </a>
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
							<%
							}
							%>
							<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
						<%
						}
						%>
					</div></li>
			</ul>
		</div>

	</nav>
	<br>
	<%-- 
	<a href="bbs1.jsp" class="btn btn-info">글목록</a>
	--%>
	

	
<form method="post" action="bbsUpdateAction1.jsp?bbsID=<%= bbsID %>">
	<div class="card bg-light mt-3">
		<div class="card-header bg-light">
			<div class="row">
				<div class="col-8 text-left">
							<div class="form-group col-sm-6">
							작성자: <span style="color: green;"><%=bbs.getUserID()%></span>&nbsp; 작성시간: <span style="color: blue;"><%=bbs.getBbsDate()%></span>
							</div>					
				</div>

			</div>
		</div>
		<div class="card-body">
								<label>*해주세요/해드립니다</label> <select name="hjsy" class="form-control">
									<option selected>[해주세요]</option>
									<option>[해드립니다]</option>
								</select>
								<br>
								<label>*수령위치</label> <input type="text" name="place" class="form-control" placeholder="아리관" maxlength="10" autocomplete="off" value="<%= bbs.getPlace() %>">
								<br>
								<label>*수령시간</label> <input type="time" name="selectTime" class="form-control">
								<br>
								<label>*원금액(원)</label> <input type="text" name="money" class="form-control" maxlength="50" placeholder="1000" autocomplete="off" value="<%= bbs.getMoney() %>">
								<br>
								<label>*제목</label> <input type="text" name="bbsTitle" class="form-control" maxlength="50" autocomplete="off" value="<%= bbs.getBbsTitle() %>">
								<br>
								<label>*내용</label> <textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"><%= bbs.getBbsContent() %></textarea>
		</div>
	</div>
	
	<%
		if(userID != null && userID.equals(bbs.getUserID())) {
	%>
			&nbsp;
			 <%-- <a href="update1.jsp?bbsID=<%= bbsID %>" class="btn btn-info" type="submit" >수정완료</a> --%>
			 <input type="submit" class="btn btn-info" value="수정완료"></a>
			 <a href="bbs1.jsp" class="btn btn-info">취소</a>
	<%
		}
	%>	
</form>
	<footer class="bg-info mt-4 p-5 text-center" style="color: #FFFFFF;"> 2023-1학기 캡스톤디자인 민상욱, 이동민 </footer>
	<script src="js/jquery.min.js"></script>
	<script src="js/popper.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script type="text/javascript">
		function goPopup() {
			var pop = window.open("riderList.jsp", "pop",
					"width=500,height=800, scrollbars=yes, resizable=yes");
		}
	</script>
</body>
</html>