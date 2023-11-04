package comment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class CommentDAO1 {
	
	private Connection conn;
	private ResultSet rs;
	
	public ArrayList<CommentDTO1> getList(int bbsID, int pageNumber, int commentID, boolean commentPrivate){
		String SQL="SELECT * FROM COMMENT1 WHERE commentID<? AND commentAvailable=1 AND bbsID=? ORDER BY commentID DESC LIMIT 10";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<CommentDTO1> list=new ArrayList<CommentDTO1>();
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,getNext()-(pageNumber-1)*10);
			pstmt.setInt(2, bbsID);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				CommentDTO1 cmt = new CommentDTO1();
				cmt.setUserID(rs.getString(1));
				cmt.setCommentID(rs.getInt(2));
				cmt.setCommentContent(rs.getString(3));
				cmt.setBbsID(bbsID);
				cmt.setCommentAvailable(1); // rs.getInt(5) => out of index 오류
				cmt.setCommentPrivate(rs.getBoolean(6));
				list.add(cmt);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public int getNext() {
		String SQL="select commentID FROM COMMENT1 ORDER BY commentID DESC";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1)+1;  // 현재 인덱스(현재 게시글 개수) +1 반환
			}
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	public int write(int bbsID, String commentContent, String userID, boolean commentPrivate) {
		String SQL="insert into COMMENT1 values(?, ?, ?, ?, ?, ?)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,userID);
			pstmt.setInt(2, getNext());
			pstmt.setString(3, commentContent);
			pstmt.setInt(4,bbsID);
			pstmt.setInt(5,1);
			pstmt.setBoolean(6, commentPrivate);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int delete(int commentID) {
		String SQL="delete from COMMENT1 where commentID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, commentID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

}
