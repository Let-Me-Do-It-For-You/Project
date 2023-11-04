<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="bbs.BbsDAO3"%>
<%@ page import="likey.LikeyDTO3"%>
<%@ page import="java.io.PrintWriter"%>
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
	return;
}

request.setCharacterEncoding("UTF-8");
String bbsID = null;
if (request.getParameter("bbsID") != null) { // 어떤 값을 삭제할 것인지
	bbsID = (String) request.getParameter("bbsID");
}
BbsDAO3 bbsDAO = new BbsDAO3();
if (userID.equals(bbsDAO.getUserID(bbsID))) {
	int result = new BbsDAO3().delete(bbsID);
	if (result == 1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('삭제가 완료되었습니다.');");
		script.println("location.href='bbs3.jsp'");
		script.println("</script>");
		script.close();
		return;
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
} else {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('자신이 쓴 글만 삭제 가능합니다.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
	return;
}
%>