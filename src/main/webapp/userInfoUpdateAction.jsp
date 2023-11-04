<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO"%>
<%@ page import="user.UserDAO"%>
<%@ page import="java.io.PrintWriter"%>
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
	return;
}


UserDTO user = new UserDAO().getUser(userID);

String userPassword = null;
String userName = null;
String userGender = null;
String userEmail = null;
String accountNumber = null;
String userAddress = null;
Boolean userRider = null;



if (request.getParameter("userID") != null) {
	userID = (String) request.getParameter("userID");
}
if (request.getParameter("userPassword") != null) {
	userPassword = (String) request.getParameter("userPassword");
}
if (request.getParameter("userName") != null) {
	userName = (String) request.getParameter("userName");
}
if (request.getParameter("userGender") != null) {
	userGender = (String) request.getParameter("userGender");
}
if (request.getParameter("userEmail") != null) {
	userEmail = (String) request.getParameter("userEmail");
}
if (request.getParameter("accountNumber") != null) {
	accountNumber = (String) request.getParameter("accountNumber");
}
if (request.getParameter("userAddress") != null) {
	userAddress = (String) request.getParameter("userAddress");
}
if (request.getParameter("userRider") != null) {
	userAddress = (String) request.getParameter("userRider");
}

if (userID.equals("") || userPassword.equals("") || userName.equals("") || userGender.equals("") || userEmail.equals("")
		|| accountNumber.equals("") || userAddress.equals("")) {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('입력이 안 된 사항이 있습니다.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
	return;
}
else {
	UserDAO userDAO = new UserDAO();
	int result = userDAO.update(request.getParameter("userID"), request.getParameter("userPassword"), request.getParameter("userName"), request.getParameter("userGender"), request.getParameter("userEmail"), request.getParameter("accountNumber"), request.getParameter("userAddress"), Boolean.parseBoolean(request.getParameter("userRider")));
	if (result == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('수정을 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'userInfo.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
}
%>