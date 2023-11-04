<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="bbs.BbsDAO1"%>
<%@ page import="likey.LikeyDAO1"%>
<%@ page import="java.io.PrintWriter"%>
<%!
	/* 선언문 */
	/* IP주소를 알아냄 */
	public static String getClientIP(HttpServletRequest request) {
	    String ip = request.getHeader("X-FORWARDED-FOR"); 
	    if (ip == null || ip.length() == 0) {
	        ip = request.getHeader("Proxy-Client-IP");
	    }
	    if (ip == null || ip.length() == 0) {
	        ip = request.getHeader("WL-Proxy-Client-IP");
	    }
	    if (ip == null || ip.length() == 0) {
	        ip = request.getRemoteAddr() ;
	    }
	    return ip;
	}
%>
<%
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null) {
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
	
	if(request.getParameter("bbsID") != null) {
		bbsID = (String) request.getParameter("bbsID");
	}
	
	BbsDAO1 bbsDAO = new BbsDAO1();
	
	LikeyDAO1 likeyDAO = new LikeyDAO1();
	
	int result = likeyDAO.unlike(userID, bbsID, getClientIP(request));
	
	if (result == 1) {
		result = bbsDAO.unlike(bbsID);
		if (result == 1) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('동참 취소가 완료되었습니다.');");
			script.println("location.href='view1.jsp'");
			script.println("</script>");
			script.close();
			return;
		}
		else {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다.');");
			script.println("history.back();");
			script.println("</script>");
			script.close();
			return;
		}
	}
	else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 동참을 취소 누른 글입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
%>