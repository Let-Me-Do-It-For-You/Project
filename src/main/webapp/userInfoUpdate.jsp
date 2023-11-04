<%@page import="user.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<!doctype html>
<html>
<head>
<title>회원정보수정</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">
</head>
<body>


	<%
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
				<li class="active dropdown"><a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown"> 회원 관리 </a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
						<%
						if (userID == null) {
						%>
						<a class="dropdown-item" href="userLogin.jsp">로그인</a> <a class="dropdown-item" href="userRegister.jsp">회원가입</a>
						<%
						} else {
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

	<div class="container mt-3" style="max-width: 560px;">
		<form method="post" action="userInfoUpdateAction.jsp?userID=<%=userID%>">
			
			<h5><%=userN.getUserID()%>님의 회원정보 수정</h5>
			
			<%-- <input type="hidden" name="userID" value=<%=user.getUserID()%>> --%>
			
			<div class="form-group">
				<label>아이디</label> <input type="text" name="userID" class="form-control" autocomplete="off" value="<%=userN.getUserID() %>" disabled>
			</div>

			<div class="form-group">
				<label>비밀번호</label> <input type="text" name="userPassword" class="form-control" autocomplete="off" value="<%=userN.getUserPassword() %>">
			</div>

			<div class="form-group">
				<label>이름</label> <input type="text" name="userName" class="form-control" autocomplete="off" value="<%=userN.getUserName() %>">
			</div>

			<div class="form-group" style="text-align: center;">
				<div class="btn-group" data-toggle="buttons">
					<label class="btn btn-primary active"> <input type="radio" name="userGender" autocomplete="off" value="남성" <%if(userN.getUserGender().equals("남성")) out.print("checked"); %>>남성
					</label> <%-- <%if(user.getUserGender().equals("남성")) out.print("checked"); %> --%>				
					
					<label class="btn btn-primary"> <input type="radio" name="userGender" autocomplete="off" value="여성" <%if(userN.getUserGender().equals("여성")) out.print("checked"); %> >여성
					</label>
				</div>
			</div>

			<div class="form-group">
				<label>이메일</label> <input type="email" name="userEmail" class="form-control" autocomplete="off" value="<%=userN.getUserEmail() %>" >
			</div>
			
			<div class="form-group">
				<label>계좌번호</label> <input type="text" name="accountNumber" class="form-control" autocomplete="off" placeholder="ex) 국민은행 123456789 (-없이)" value="<%=userN.getAccountNumber() %>" >
			</div>			

			<div class="form-group">
				<label>주소</label> <input type="text" name="userAddress" id="address" class="form-control" autocomplete="off" value="<%=userN.getUserAddress() %>" >
			</div>

			<div class="form-group" style="text-align: right;">
				<button type="button" class="btn btn-info" onClick="goPopup();">주소검색</button>
			</div>			
			
			<div class="form-group" style="text-align: center;">
				<div class="btn-group" data-toggle="buttons">
					<label class="btn btn-primary active"> <input type="radio" name="userRider" autocomplete="off" value="False" <%if(userN.getUserRider() == false) out.print("checked"); %>>일반 사용자
					</label> <%--<%if(user.getUserRider().equals("False")) out.print("checked"); %> --%>
					<label class="btn btn-primary"> <input type="radio" name="userRider" autocomplete="off" value="True" <%if(userN.getUserRider() == true) out.print("checked"); %>>라이더
					</label>
				</div>
			</div>

			<button type="submit" class="btn btn-info">수정완료</button>
			&nbsp;
			<a href="userInfo.jsp" class="btn btn-info">돌아가기</a>
		</form>
	</div>	

	<footer class="bg-info mt-4 p-5 text-center" style="color: #FFFFFF;"> 2023-1학기 캡스톤디자인 민상욱, 이동민 </footer>
	<script src="js/jquery.min.js"></script>
	<script src="js/popper.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script type="text/javascript">
		// opener관련 오류가 발생하는 경우 아래 주석을 해지하고, 사용자의 도메인정보를 입력합니다. ("팝업API 호출 소스"도 동일하게 적용시켜야 합니다.)
		//document.domain = "abc.go.kr";

		function goPopup() {
			// 주소검색을 수행할 팝업 페이지를 호출합니다.
			// 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(https://business.juso.go.kr/addrlink/addrLinkUrl.do)를 호출하게 됩니다.
			var pop = window.open("jusoPopup.jsp", "pop",
					"width=570,height=420, scrollbars=yes, resizable=yes");

			// 모바일 웹인 경우, 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(https://business.juso.go.kr/addrlink/addrMobileLinkUrl.do)를 호출하게 됩니다.
			//var pop = window.open("/popup/jusoPopup.jsp","pop","scrollbars=yes, resizable=yes"); 
		}

		function jusoCallBack(roadFullAddr) {
			// 팝업페이지에서 주소입력한 정보를 받아서, 현 페이지에 정보를 등록합니다.
			var addressEl = document.querySelector("#address");
			addressEl.value = roadFullAddr;
			//document.form.roadFullAddr.value = roadFullAddr;	// 옛날 방법
		}
	</script>

</body>
</html>