<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="bbs.BbsDTO1"%>
<%@ page import="bbs.BbsDAO1"%>
<%@ page import="java.io.PrintWriter"%>
<%
String userID = null;
String rider = null;
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
if (session.getAttribute("userID") != null) {
	rider = (String) session.getAttribute("userID");
}

request.setCharacterEncoding("UTF-8");
String bbsID = null;
String approve = null;
if (request.getParameter("bbsID") != null) { // 어떤 값을 삭제할 것인지
	bbsID = (String) request.getParameter("bbsID");
}
if (request.getParameter("approve") != null) {
	approve = (String) request.getParameter("approve");
}

BbsDAO1 bbsDAO = new BbsDAO1();
if (approve.equals("y")) {
	int result = new BbsDAO1().approve(bbsID, rider);
	if (result == 1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('승인이 완료되었습니다.');");
		script.println("history.back();");
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
}

if (approve.equals("n")){
	int result = new BbsDAO1().refusal(bbsID);
	if (result == 0) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('요청이 거절되었습니다.');");
		script.println("history.back();");
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
}

if (approve.equals("p")){
	int result = new BbsDAO1().pickUp(bbsID, rider);
	if (result == 1) {
		PrintWriter script = response.getWriter();
		String url="requestList3.jsp?bbsID="+bbsID;
		script.println("<script>");
		script.println("alert('픽업을 하였습니다.');");
		script.println("location.href='"+url+"'");
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
}

if (approve.equals("d")){
	int result = new BbsDAO1().delivery(bbsID, rider);
	if (result == 1) {
		PrintWriter script = response.getWriter();
		String url="requestList3.jsp?bbsID="+bbsID;
		script.println("<script>");
		script.println("alert('배달 진행중입니다.');");
		script.println("location.href='"+url+"'");
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
}

if (approve.equals("c")){
	int result = new BbsDAO1().deliveryComplete(bbsID, rider);
	if (result == 1) {
		PrintWriter script = response.getWriter();
		String url="requestList3.jsp?bbsID="+bbsID;
		script.println("<script>");
		script.println("alert('배달을 완료했습니다.');");
		script.println("location.href='"+url+"'");
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
}
%>