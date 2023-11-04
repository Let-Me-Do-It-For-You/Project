<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<%@ page import="bbs.BbsDAO1"%>
<%@ page import="bbs.BbsDTO1"%>
<%@ page import="likey.LikeyDAO1"%>
<%@ page import="likey.LikeyDTO1"%>
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
			<select name="hjsy" class="form-control mx-1 mt-2">
				<option value="전체">전체</option>
				<option value="[해주세요]" <%if (hjsy.equals("[해주세요]"))
	out.println("selected");%>>[해주세요]</option>
				<option value="[해드립니다]" <%if (hjsy.equals("[해드립니다]"))
	out.println("selected");%>>[해드립니다]</option>
			</select> <select name="searchType" class="form-control mx-1 mt-2">
				<option value="최신순">최신순</option>
				<%--
				<option value="추천순" <%if (searchType.equals("추천순"))
	out.println("selected");%>>추천순</option>
	--%>
				<option value="금액순" <%if (searchType.equals("금액순"))
	out.println("selected");%>>금액순</option>
			</select> <input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요.">
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal">등록하기</a>
		</form>

		<%
		ArrayList<BbsDTO1> bbsList = new ArrayList<BbsDTO1>();
		bbsList = new BbsDAO1().getList(hjsy, searchType, search, pageNumber);
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
						<%=bbs.getHjsy()%>
						<span style="color: red;"> <%
 if (bbs.getLikeClose() == true)
 	out.print("동참 마감");
 %>
						</span> <span style="color: blue;"> <%
 if (bbs.getLikeClose() == false)
 	out.print("동참 진행중");
 %>
						</span> <br> 수령위치:&nbsp;<small><%=bbs.getPlace()%></small>&nbsp; 수령시간:&nbsp;<small><%=bbs.getSelectTime()%></small>&nbsp;
						<%
						if (bbs.getLikeCount() != 0) {
						%>
						금액:&nbsp;<span style="color: orange;"><%=bbs.getMoney() / bbs.getLikeCount()%>원</span>
						<%
						} else {
						%>
						금액:&nbsp;<span style="color: orange;"><%=bbs.getMoney()%>원</span>
						<%
						}
						%>
						/&nbsp;<span style="color: gray;"><small><%=bbs.getMoney()%>원</small></span>
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
						<span style="color: green;">(동참: <%=bbs.getLikeCount()%>)
						</span>

						<%
						if (bbs.getRiderProgress() == 0) {
						%><span style="color: purple;"> [라이더: <%=bbs.getRider()%> (라이더 모집중)]
						</span>
						<%
						} else if (bbs.getRiderProgress() == 1) {
						%><span style="color: purple;"> [라이더: <%=bbs.getRider()%> (승인 대기중)]
						</span>
						<%
						} else if (bbs.getRiderProgress() == 2) {
						%><span style="color: purple;"> [라이더: <%=bbs.getRider()%> (승인 완료)]
						</span>
						<%
						} else if (bbs.getRiderProgress() == 3) {
						%><span style="color: purple;"> [라이더: <%=bbs.getRider()%> (음식 픽업)]
						</span>
						<%
						} else if (bbs.getRiderProgress() == 4) {
						%><span style="color: purple;"> [라이더: <%=bbs.getRider()%> (배달 진행중)]
						</span>
						<%
						} else if (bbs.getRiderProgress() == 5) {
						%><span style="color: purple;"> [라이더: <%=bbs.getRider()%> (배달 완료)]
						</span>
						<%
						}
						%>

					</div>
					<div class="col-3 text-right">

						<%
						if (userID != null && userID.equals(bbs.getUserID())) {
						%>
						<a span style="color: red;" onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction1.jsp?bbsID=<%=bbs.getBbsID()%>">삭제</a>
						<%
						} else {
						%>
						<%
						if (!bbs.getLikeClose()) {
						%>
						<a class="btn btn-primary mx-1 mt-2" onclick="return confirm('동참하시겠습니까?'" href="./likeAction1.jsp?bbsID=<%=bbs.getBbsID()%>">동참</a>
						<%
						}
						}
						%>

					</div>
				</div>
			</div>
		</div>
		<%
		}
		%>
	</div>

	<ul class="pagination justify-content-center mt-3">
		<li class="page-item">
			<%
			if (pageNumber <= 0) {
			%> <a class="page-link disabled">이전</a> <%
 } else {
 %> <a class="page-link" href="bbs1.jsp?hjsy=<%=URLEncoder.encode(hjsy, "UTF-8")%>&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>&search=<%=URLEncoder.encode(search, "UTF-8")%>&pageNumber=<%=pageNumber - 1%>">이전</a> <%
 }
 %>
		</li>


		<li class="page-item">
			<%
			if (bbsList.size() < 6) {
			%> <a class="page-link disabled">다음</a> <%
 } else {
 %> <a class="page-link" href="bbs1.jsp?hjsy=<%=URLEncoder.encode(hjsy, "UTF-8")%>&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>&search=<%=URLEncoder.encode(search, "UTF-8")%>&pageNumber=<%=pageNumber + 1%>">다음</a> <%
 }
 %>
		</li>

	</ul>

	<%--
	<div class="modal fade" id="joinModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">동참자 목록</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body" id="passBbsID">
					<%
					String bbsID = request.getParameter("bbsID");
					if (bbsID == null) {
						// bbsID가 URL 매개변수로 전달되지 않았을 경우의 처리
						// 또는 다른 방법으로 bbsID를 설정해야 할 경우의 처리
					} else {
						// bbsID를 속성으로 설정
						request.setAttribute("bbsID", bbsID);
					}
					ArrayList<LikeyDTO1> joinList = new ArrayList<LikeyDTO1>();
					joinList = new LikeyDAO1().getList();
					if (joinList != null) {
						for (int i = 0; i < joinList.size(); i++) {
							if (i == 5) {
						break;
							}
							LikeyDTO1 join = joinList.get(i);
					%>
					<div class="form-row">
						<div class="form-group col-sm-6">
							<a><%=join.getUserID()%></a>
						</div>
					</div>
					<%
					}
					}
					%>
				</div>
			</div>
		</div>
	</div>
--%>

	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">공동 음식 주문 글작성</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="bbsRegisterAction1.jsp" method="post">
						<div class="form-row">
							<div class="form-group col-sm-6">
								<label>해주세요/해드립니다</label> <select name="hjsy" class="form-control">
									<option selected>[해주세요]</option>
									<option>[해드립니다]</option>
								</select>
							</div>
							<div class="form-group col-sm-6">
								<label>금액(원)</label> <input type="text" name="money" class="form-control" maxlength="50" placeholder="1000">
							</div>
							<div class="form-group col-sm-6">
								<label>수령장소</label> <input type="text" name="place" class="form-control" maxlength="50" placeholder="아리관">
							</div>
							<div class="form-group col-sm-6">
								<label>수령시간</label> <input type="time" name="selectTime" class="form-control">
							</div>
						</div>
						<div class="form-group">
							<label>제목</label> <input type="text" name="bbsTitle" class="form-control" maxlength="50">
						</div>
						<div class="form-group">
							<label>내용</label>
							<textarea name="bbsContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
						</div>
						<div class="form-group">
							<label for="restaurant_name">픽업매장(선택사항)</label> <span style="margin-right: 4px;"></span>
							<button type="button" class="btn btn-info btn-sm" onClick="goPopup2();">검색</button>
							<input type="text" name="restaurant_name" id="restaurant_name" class="form-control" placeholder="매장 이름"> <input type="text" name="restaurant_address" id="restaurant_address" class="form-control" placeholder="매장 주소" required readonly>
						</div>
						<div class="form-group">
							<label>라이더 지정(선택사항)</label> <input type="text" name="rider" id="selectrider" class="form-control" required readonly>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="button" class="btn btn-success" onClick="goPopup();">라이더 선택</button>
							<button type="submit" class="btn btn-primary">등록하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
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
			var pop = window.open("kakaoMap.jsp", "pop",
					"width=1000,height=800, scrollbars=yes, resizable=yes");
		}
	</script>
</body>
</html>