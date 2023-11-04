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

String hjsy = null;
String bbsTitle = null;
String bbsContent = null;
int money = 0;
String selectTime = null;
String place = null;
String bbsDate = null;

if (request.getParameter("hjsy") != null) {
	hjsy = (String) request.getParameter("hjsy");
}
if (request.getParameter("bbsTitle") != null) {
	bbsTitle = (String) request.getParameter("bbsTitle");
}
if (request.getParameter("bbsContent") != null) {
	bbsContent = (String) request.getParameter("bbsContent");
}
if (request.getParameter("money") != null) {
	try {
		money = Integer.parseInt(request.getParameter("money"));
	} catch (Exception e) {
		System.out.println("금액 오류");
	}
}
if (request.getParameter("selectTime") != null) {
	selectTime = (String) request.getParameter("selectTime");
}
if (request.getParameter("place") != null) {
	place = (String) request.getParameter("place");
}

if (hjsy.equals("") || bbsTitle.equals("") || bbsContent.equals("") || money == 0 || selectTime.equals("")
		|| place.equals("")) {
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('입력이 안 된 사항이 있습니다.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
	return;
} else {
	BbsDAO1 bbsDAO = new BbsDAO1();
	int result = bbsDAO.update(bbsID, request.getParameter("hjsy"), request.getParameter("bbsTitle"), request.getParameter("bbsContent"), money, request.getParameter("selectTime"), request.getParameter("place"));
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
		script.println("location.href = 'bbs1.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
}
%>