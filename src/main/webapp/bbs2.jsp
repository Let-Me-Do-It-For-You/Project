<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page import="bbs.BbsDAO2"%>
<%@ page import="bbs.BbsDTO2"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<!doctype html>
<html>
<head>
<title>공동 구매 대행</title>
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
				<li class="active"><a class="nav-link" href="bbs2.jsp">공동 구매 대행</a></li>
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
						%>
						<a class="dropdown-item" href="userLogout.jsp">로그아웃</a>
						<%
						}
						%>
					</div></li>
			</ul>
		</div>

	</nav>
	<div class="container">
		<form method="get" action="bbs2.jsp" class="form-inline mt-3">
			<select name="hjsy" class="form-control mx-1 mt-2">
				<option value="전체">전체</option>
				<option value="[해주세요]" <%if (hjsy.equals("[해주세요]"))
	out.println("selected");%>>[해주세요]</option>
				<option value="[해드립니다]" <%if (hjsy.equals("[해드립니다]"))
	out.println("selected");%>>[해드립니다]</option>
			</select> <select name="searchType" class="form-control mx-1 mt-2">
				<option value="최신순">최신순</option>
				<option value="추천순" <%if (searchType.equals("추천순"))
	out.println("selected");%>>추천순</option>
				<option value="금액순" <%if (searchType.equals("금액순"))
	out.println("selected");%>>금액순</option>
			</select> <input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요.">
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#registerModal">등록하기</a>
		</form>

		<%
		ArrayList<BbsDTO2> bbsList = new ArrayList<BbsDTO2>();
		bbsList = new BbsDAO2().getList(hjsy, searchType, search, pageNumber);
		if (bbsList != null)
			for (int i = 0; i < bbsList.size(); i++) {
				if (i == 5)
			break;
				BbsDTO2 bbs = bbsList.get(i);
		%>

		<div class="card bg-light mt-3">
			<div class="card-header bg-light">
				<div class="row">
					<div class="col-8 text-left">
						<%=bbs.getHjsy()%>&nbsp; 수령위치:&nbsp;<small><%=bbs.getPlace()%></small>&nbsp; 수령시간:&nbsp;<small><%=bbs.getSelectTime()%></small>&nbsp; 금액:&nbsp;<span style="color: red;"><%=bbs.getMoney()%>원</span>
					</div>

					<div class="col-4 text-right">
						작성자: <span style="color: blue;"><%=bbs.getUserID()%></span>&nbsp; 작성시간: <span style="color: blue;"><%=bbs.getBbsDate()%></span>
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
						<span style="color: green;">(추천: <%=bbs.getLikeCount()%>)
						</span>
					</div>
					<div class="col-3 text-right">
						<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction2.jsp?bbsID=<%=bbs.getBbsID()%>">추천</a> <a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction2.jsp?bbsID=<%=bbs.getBbsID()%>">삭제</a>
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
 %> <a class="page-link" href="bbs2.jsp?hjsy=<%=URLEncoder.encode(hjsy, "UTF-8")%>&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>&search=<%=URLEncoder.encode(search, "UTF-8")%>&pageNumber=<%=pageNumber - 1%>">이전</a> <%
 }
 %>
		</li>


		<li class="page-item">
			<%
			if (bbsList.size() < 6) {
			%> <a class="page-link disabled">다음</a> <%
 } else {
 %> <a class="page-link" href="bbs2.jsp?hjsy=<%=URLEncoder.encode(hjsy, "UTF-8")%>&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>&search=<%=URLEncoder.encode(search, "UTF-8")%>&pageNumber=<%=pageNumber + 1%>">다음</a> <%
 }
 %>
		</li>

	</ul>


	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">공동 구매 대행 글작성</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="bbsRegisterAction2.jsp" method="post">
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
								<label>수령시간</label> <select name="selectTime" class="form-control">
									<option value="직접선택">직접선택</option>

									<option value="========오후========">========오후========</option>
									<option value="01:00(AM) ~ 01:30(AM)">01:00(PM) ~ 01:30(PM)</option>
									<option value="01:30(AM) ~ 02:00(AM)">01:30(PM) ~ 02:00(PM)</option>
									<option value="02:00(AM) ~ 02:30(AM)">02:00(PM) ~ 02:30(PM)</option>
									<option value="02:30(AM) ~ 03:00(AM)">02:30(PM) ~ 03:00(PM)</option>
									<option value="03:00(AM) ~ 03:30(AM)">03:00(PM) ~ 03:30(PM)</option>
									<option value="03:30(AM) ~ 04:00(AM)">03:30(PM) ~ 04:00(PM)</option>
									<option value="04:00(AM) ~ 04:30(AM)">04:00(PM) ~ 04:30(PM)</option>
									<option value="04:30(AM) ~ 05:00(AM)">04:00(PM) ~ 04:30(PM)</option>
									<option value="05:00(AM) ~ 05:30(AM)">05:00(PM) ~ 05:30(PM)</option>
									<option value="05:30(AM) ~ 06:00(AM)">05:30(PM) ~ 06:00(PM)</option>
									<option value="06:00(AM) ~ 06:30(AM)">06:00(PM) ~ 06:30(PM)</option>
									<option value="06:30(AM) ~ 07:00(AM)">06:30(PM) ~ 07:00(PM)</option>
									<option value="07:00(AM) ~ 07:30(AM)">07:00(PM) ~ 07:30(PM)</option>
									<option value="07:30(AM) ~ 08:00(AM)">07:30(PM) ~ 08:00(PM)</option>
									<option value="08:00(AM) ~ 08:30(AM)">08:00(PM) ~ 08:30(PM)</option>
									<option value="08:30(AM) ~ 09:00(AM)">08:30(PM) ~ 09:00(PM)</option>
									<option value="09:00(AM) ~ 09:30(AM)">09:00(PM) ~ 09:30(PM)</option>
									<option value="09:30(AM) ~ 10:00(AM)">09:30(PM) ~ 10:00(PM)</option>
									<option value="10:00(AM) ~ 10:30(AM)">10:00(PM) ~ 10:30(PM)</option>
									<option value="10:30(AM) ~ 11:00(AM)">10:30(PM) ~ 11:00(PM)</option>
									<option value="11:00(AM) ~ 11:30(AM)">11:00(PM) ~ 11:30(PM)</option>
									<option value="11:30(AM) ~ 12:00(PM)">11:30(PM) ~ 12:00(PM)</option>
									<option value="12:00(PM) ~ 12:30(PM)">12:00(PM) ~ 12:30(PM)</option>
									<option value="12:30(PM) ~ 01:00(PM)">12:30(PM) ~ 01:00(AM)</option>

									<option value="========오전========">========오전========</option>
									<option value="01:00(PM) ~ 01:30(PM)">01:00(PM) ~ 01:30(PM)</option>
									<option value="01:30(PM) ~ 02:00(PM)">01:30(PM) ~ 02:00(PM)</option>
									<option value="02:00(PM) ~ 02:30(PM)">02:00(PM) ~ 02:30(PM)</option>
									<option value="02:30(PM) ~ 03:00(PM)">02:30(PM) ~ 03:00(PM)</option>
									<option value="03:00(PM) ~ 03:30(PM)">03:00(PM) ~ 03:30(PM)</option>
									<option value="03:30(PM) ~ 04:00(PM)">03:30(PM) ~ 04:00(PM)</option>
									<option value="04:00(PM) ~ 04:30(PM)">04:00(PM) ~ 04:30(PM)</option>
									<option value="04:30(PM) ~ 05:00(PM)">04:00(PM) ~ 04:30(PM)</option>
									<option value="05:00(PM) ~ 05:30(PM)">05:00(PM) ~ 05:30(PM)</option>
									<option value="05:30(PM) ~ 06:00(PM)">05:30(PM) ~ 06:00(PM)</option>
									<option value="06:00(PM) ~ 06:30(PM)">06:00(PM) ~ 06:30(PM)</option>
									<option value="06:30(PM) ~ 07:00(PM)">06:30(PM) ~ 07:00(PM)</option>
									<option value="07:00(PM) ~ 07:30(PM)">07:00(PM) ~ 07:30(PM)</option>
									<option value="07:30(PM) ~ 08:00(PM)">07:30(PM) ~ 08:00(PM)</option>
									<option value="08:00(PM) ~ 08:30(PM)">08:00(PM) ~ 08:30(PM)</option>
									<option value="08:30(PM) ~ 09:00(PM)">08:30(PM) ~ 09:00(PM)</option>
									<option value="09:00(PM) ~ 09:30(PM)">09:00(PM) ~ 09:30(PM)</option>
									<option value="09:30(PM) ~ 10:00(PM)">09:30(PM) ~ 10:00(PM)</option>
									<option value="10:00(PM) ~ 10:30(PM)">10:00(PM) ~ 10:30(PM)</option>
									<option value="10:30(PM) ~ 11:00(PM)">10:30(PM) ~ 11:00(PM)</option>
									<option value="11:00(PM) ~ 11:30(PM)">11:00(PM) ~ 11:30(PM)</option>
									<option value="11:30(PM) ~ 12:00(PM)">11:30(PM) ~ 12:00(PM)</option>
									<option value="12:00(AM) ~ 12:30(AM)">12:00(PM) ~ 12:30(PM)</option>
									<option value="12:30(AM) ~ 01:00(AM)">12:30(PM) ~ 01:00(AM)</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label>제목</label> <input type="text" name="bbsTitle" class="form-control" maxlength="50">
						</div>
						<div class="form-group">
							<label>내용</label>
							<textarea name="bbsContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
						</div>

						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">등록하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<footer class="bg-info mt-4 p-5 text-center" style="color: #FFFFFF;"> 2023-1학기 캡스톤디자인 민상욱, 이동민 </footer>
	<script src="js/jquery.min.js"></script>
	<script src="js/popper.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
</body>
</html>