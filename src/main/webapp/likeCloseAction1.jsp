<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDTO1"%>
<%@ page import="bbs.BbsDAO1"%>
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

Boolean likeClose = null;

BbsDAO1 bbsDAO = new BbsDAO1();
int result = bbsDAO.likeClose(bbsID, Boolean.parseBoolean(request.getParameter("likeClose"))); 
if (result == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('마감을 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {
		PrintWriter script = response.getWriter();
		String url="view1.jsp?bbsID="+bbsID;
		script.println("<script>");
		script.println("alert('동참 마감을 완료했습니다.');");
		script.println("location.href='"+url+"'");
		script.println("</script>");
		script.close();
		return;
	}
%>