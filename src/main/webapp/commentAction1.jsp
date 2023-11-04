<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="comment.CommentDAO1" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="comment" class="comment.CommentDTO1" scope="page"/>
<jsp:setProperty name="comment" property="commentContent"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>그거? 내가 해줄게</title>
</head>
<body>
	<%
		int bbsID=1;
		if(request.getParameter("bbsID")!=null){
			bbsID=Integer.parseInt(request.getParameter("bbsID"));
		}
	
		String userID=null;
		if(session.getAttribute("userID")!=null){
			userID=(String)session.getAttribute("userID");
		}
		String checkboxValue = request.getParameter("commentPrivate");
        boolean isChecked = "true".equals(checkboxValue); // 값이 "true"이면 true로 설정
		
		if(userID==null){
			PrintWriter script=response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다.')");
			script.println("location.href='login.jsp'");
			script.println("</script>");	
		}
		else{
			CommentDAO1 commentDAO=new CommentDAO1();
			String action = request.getParameter("action");
			if (action != null) {

				// 댓글 작성
			    if (action.equals("write")) {
					if(comment.getCommentContent()==null){
						PrintWriter script= response.getWriter();
						script.println("<script>");
						script.println("alert('댓글을 입력해주세요.')");
						script.println("history.back()");
						script.println("</script>");
					}
					else{
						int result = commentDAO.write(bbsID, comment.getCommentContent(), userID, isChecked);
						if(result==-1){
							PrintWriter script= response.getWriter();
							script.println("<script>");
							script.println("alert('댓글쓰기에 실패했습니다.')");
							script.println("history.back()");
							script.println("</script>");
						}
						else{
							String url="view1.jsp?bbsID="+bbsID;
							PrintWriter script= response.getWriter();
							script.println("<script>");
							script.println("location.href='"+url+"'");
							script.println("</script>");
						}
					}
			    }
				
				// 댓글 삭제
				else if (action.equals("delete")) {
					int commentID=0;
					if(request.getParameter("commentID")!=null){
						commentID=Integer.parseInt(request.getParameter("commentID"));
						int result = commentDAO.delete(commentID);
						String url="view1.jsp?bbsID="+bbsID;
						PrintWriter script= response.getWriter();
						script.println("<script>");
						script.println("location.href='"+url+"'");
						script.println("</script>");
					}
					
				}
			}
		}
	%>
</body>
</html>