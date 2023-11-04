<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page import="user.UserDTO"%>
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
		// script.println("alert('유효하지 않은 글입니다.')");
		script.println("location.href = 'bbs1.jsp'"); // bbs1.jsp로 페이지 이동
		script.println("</script>");
	}
	BbsDTO1 bbs = new BbsDAO1().getBbs(bbsID);
	UserDTO userN = new UserDAO().getUser(userID); // 로그인이 되어 있으면 사용자 정보를 유저객체에 담음
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
				<li class="nav-item dropdown"><a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown"> <%=userN.getUserID()%>의 마이페이지
				</a>
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
						<a class="dropdown-item" href="requestList.jsp">승인 요청</a> <a class="dropdown-item" href="requestList2.jsp">요청 대기 목록</a> <a class="dropdown-item" href="requestList3.jsp">진행 사항</a> <a class="dropdown-item" href="completeList.jsp">활동 이력</a>
						<%
						}
						%>
						<a class="dropdown-item" href="userInfo.jsp?userID=<%=userID%>">회원정보</a> <a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
						<%
						}
						%>
					</div></li>
			</ul>
		</div>

	</nav>
	<div class="container">
		<form method="get" action="bbs1.jsp" class="form-inline mt-3">
			<a href="bbs1.jsp" class="btn btn-info mr-1">글 목록</a>
		<%
		if (userID != null && userID.equals(bbs.getUserID())) {
		%>
		<a href="update1.jsp?bbsID=<%=bbsID%>" class="btn btn-info mr-1">수정</a>
		<a href="deleteAction1.jsp?bbsID=<%=bbsID%>" class="btn btn-info mr-1">삭제</a>
		<%
        if (!bbs.getLikeClose()) {
        %>
        <a href="./likeCloseAction1.jsp?bbsID=<%=bbs.getBbsID()%>" class="btn btn-danger mr-1">동참 마감</a>
        <%
        }
		}
		%>
		
		</form>

		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left">
						<%=bbs.getHjsy()%>
						<span style="color: red;"> <%if (bbs.getLikeClose() == true) out.print("동참 마감");%> </span>
						<span style="color: blue;"> <%if (bbs.getLikeClose() == false) out.print("동참 진행중");%> </span>
						<span style="color: purple;">
						<% if (bbs.getRiderProgress() == 2) { %>
						/ 음식 주문 중
						<% } else if (bbs.getRiderProgress() == 3) { %>
						/ 음식 픽업 중
						<% } else if (bbs.getRiderProgress() == 4) { %>
						/ 배달 중
						<% } else if (bbs.getRiderProgress() == 5) { %>
						/ 배달 완료
						<% } %> </span>
						<%
						if (bbs.getRiderProgress() == 0) {
						%><span style="color: purple;"> [라이더: <%=bbs.getRider()%> (라이더 모집중)]
						</span>
						<%
						} else if (bbs.getRiderProgress() == 1) {
						%><span style="color: purple;"> [라이더: <%=bbs.getRider()%> (요청 대기중)]
						</span>
						<%
						} else {
						%><span style="color: purple;"> [라이더: <%=bbs.getRider()%>]
						</span>
						<%
						}
						%>
						
						<br> 수령위치:&nbsp;<small><%=bbs.getPlace()%></small>&nbsp; 수령시간:&nbsp;<small><%=bbs.getSelectTime()%></small>&nbsp; 금액:&nbsp;<span style="color: orange;"><%=bbs.getMoney() / bbs.getLikeCount()%>원</span> /&nbsp;<span style="color: gray;"><small><%=bbs.getMoney()%>원</small></span>
					</div>

					<div class="col-4 text-right">
						작성자: <span style="color: green;"><%=bbs.getUserID()%></span>&nbsp; 작성시간: <span style="color: blue;"><%=bbs.getBbsDate()%></span>
					</div>
					<div class="col-8 text-left">
						매장위치 : <%String restaurantName = bbs.getRestaurantName(); if (restaurantName != null) {%>
						<a style="color: green; cursor: pointer;" onClick="goPopup2()"><%= restaurantName %></a><%} else {%>지정하지 않음<%}%>
					</div>

				</div>
			</div>
			<div class="card-body">
				<h5 class="card-title">
					<%=bbs.getBbsTitle()%>
				</h5>
				<p class="card-text"><%=bbs.getBbsContent()%></p>
				<div class="row">
					<div class="col-9 text-left">
						<span style="color: green;"><a data-toggle="modal" href="#likeModal">(동참자 명단: <%=bbs.getLikeCount()%>)</a></span>

						<div class="modal fade" id="likeModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<h5 class="modal-title" id="modal">동참자 명단</h5>
									<%
									String bbsUserID = bbs.getUserID();
									UserDTO userN2 = new UserDAO().getUser(bbsUserID);
									if (bbs.getLikeClose() == true) {
									%> <h5 class="modal-title" id="modal">&nbsp;[<%=bbs.getUserID()%>님의 계좌 : <%=userN2.getAccountNumber()%>]</h5>
									<%
									}
									%>
									<button type="button" class="close" data-dismiss="modal" aria-label="Close">
										<span aria-hidden="true">&times;</span>
									</button>
								</div>
								<div class="modal-body">
									<div class="form-row">
										<div class="form-group col-sm-6">
											<%
											LikeyDAO1 likeDAO = new LikeyDAO1();
											ArrayList<LikeyDTO1> joinlist = likeDAO.getLikey(bbsID);
											for (int j = 0; j < joinlist.size(); j++) {
											%>
											<%=joinlist.get(j).getUserID()%>
											<%
											}
											%>
											<%--<%=likey.getUserID() %>		 --%>

										</div>
									</div>
								</div>
							</div>
						</div>
					</div>

					</div>
					<div class="col-3 text-right">
						<%
						if (userID != null && userID.equals(bbs.getUserID())) {
						%>

						<%
						} else {

						if (bbs.getLikeClose() == false) {
						%>
						<a onclick="return confirm('동참하시겠습니까?')" href="./likeAction1.jsp?bbsID=<%=bbs.getBbsID()%>">동참</a>
						<a onclick="return confirm('동참을 취소하시겠습니까?')" href="./unlikeAction1.jsp?bbsID=<%=bbs.getBbsID()%>">동참취소</a>
						<%
						}
						%>
						<%
						}
						%>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="container">
		<form method="post" action="commentAction1.jsp?bbsID=<%=bbsID%>&action=write">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<%-- 홀,짝 행 구분 --%>
				<thead>
					<tr>
						<th colspan="3" style="background-color: #eeeeeee; text-align: center;">댓글</th>
					</tr>
				</thead>
				<tbody>

					<%
					CommentDAO1 commentDAO = new CommentDAO1();
					int commentID = 0;
					boolean commentPrivate = false;
					ArrayList<CommentDTO1> list = commentDAO.getList(bbsID, pageNumber, commentID, commentPrivate);
					for (int i = list.size() - 1; i >= 0; i--) {
					%>
					<tr>

						<%
						if (list.get(i).getCommentPrivate() == true) {
							if (!userID.equals(bbs.getUserID()) && !userID.equals(list.get(i).getUserID())) {
						%>
						<td style="text-align: left;">비공개 댓글입니다.</td>
						<td style="text-align: right;"></td>
						<%
						} else {
						%>
						<td style="text-align: left;">[비공개] <%=list.get(i).getCommentContent()%></td>
						<td style="text-align: right;"><%=list.get(i).getUserID()%> <%
 						}
						 if (userID.equals(list.get(i).getUserID())) {
						 %> <a onclick="return confirm('삭제하시겠습니까?')" href="commentAction1.jsp?bbsID=<%=bbsID%>&commentID=<%=list.get(i).getCommentID()%>&action=delete" class="btn">삭제</a> <%
 						}
 						} else {
 						%>
						<td style="text-align: left;"><%=list.get(i).getCommentContent()%></td>
						<td style="text-align: right;"><%=list.get(i).getUserID()%> <%
 						if (userID.equals(list.get(i).getUserID())) {
						 %> <a onclick="return confirm('삭제하시겠습니까?')" href="commentAction1.jsp?bbsID=<%=bbsID%>&commentID=<%=list.get(i).getCommentID()%>&action=delete" class="btn">삭제</a> <%
						 }
						 }
 						}
 						%> <%--<a href="commentUpdate1.jsp?bbsID=<%=bbsID%>" class="btn">수정</a> --%></td>
					</tr>



				</tbody>
				    					<td>
        					<textarea class="form-control" placeholder="댓글을 입력하세요." name="commentContent" maxlength="2048"></textarea>
    					</td>
			</table>

			<td class="checkbox-cell"><input type="checkbox" id="checkbox1" name="commentPrivate" value="true"> <label for="checkbox1" class="checkbox-label">비공개</label></td> <input type="submit" class="btn" value="댓글입력">
		</form>
	</div>

	<footer class="bg-info mt-4 p-5 text-center" style="color: #FFFFFF;"> 2023 캡스톤디자인 민상욱, 이동민 </footer>
	<script src="js/jquery.min.js"></script>
	<script src="js/popper.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script type="text/javascript">
		function goPopup() {
			var pop = window.open("riderList.jsp", "pop",
					"width=500,height=800, scrollbars=yes, resizable=yes");
		}
		
		function goPopup2() {
		    var restaurantAddress = "<%=bbs.getRestaurantAddress()%>";
		    var restaurantName = "<%=bbs.getRestaurantName()%>";
			var url = "kakaoMap2.jsp?restaurantAddress=" + restaurantAddress
					+ "&restaurantName=" + restaurantName;
			var pop = window.open(url, "pop",
					"width=500,height=400,scrollbars=yes,resizable=yes");
		}
	</script>
</body>
</html>