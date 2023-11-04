<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO"%>
<%@ page import="user.UserDTO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.net.URLEncoder"%>
<!doctype html>
<html>
<head>
<title>라이더 목록</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">
</head>
<body>
	<%
	request.setCharacterEncoding("UTF-8");

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
		<a class="navbar-brand" style="color: white;">라이더 목록</a>

	</nav>

	<div class="container">
		<%
		ArrayList<UserDTO> riderList = new ArrayList<UserDTO>();
		riderList = new UserDAO().getList();
		if (riderList != null)
			for (int i = 0; i < riderList.size(); i++) {
				if (i == 5)
			break;
				UserDTO user = riderList.get(i);
				
				if (!userID.equals(user.getUserID())) {
					%>
					        <div class="card w-25 bg-light mt-3">
					            <div class="card-header bg-light">
					                <div class="row">
					                    <div class="col-8 text-left">
					                        <a id="riderlist" onclick="confirmAndSelectRider('<%=user.getUserID()%>')" href="#"><%=user.getUserID()%></a>
					                    </div>
					                </div>
					            </div>
					        </div>
					<%
					        }
					    }
					%>
	</div>

	<footer class="bg-info mt-4 p-5 text-center" style="color: #FFFFFF;"> 2023 캡스톤디자인 민상욱, 이동민 </footer>
	<script src="js/jquery.min.js"></script>
	<script src="js/popper.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script type="text/javascript">
	  function confirmAndSelectRider(userID) {
		    if (confirm("선택한 라이더에게 요청을 보내겠습니까?")) {
		      opener.document.getElementById("selectrider").value = userID;
		      window.close();
		    }
		  }
	</script>
</body>
</html>