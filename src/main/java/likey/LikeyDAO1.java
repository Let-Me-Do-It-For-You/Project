package likey;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import user.UserDTO;
import util.DatabaseUtil;

public class LikeyDAO1 {

	/* 추천 누르는 함수 */
	public int like(String userID, String evaluationID, String userIP) {
		String SQL = "INSERT INTO LIKEY1 VALUES (?, ?, ?)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, evaluationID);
			pstmt.setString(3, userIP);
			return pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			try {
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			try {
				if (rs != null)
					rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1; // 추천 실패
	}
	
	/* 추천 취소 함수 DB에 명단이 없어짐 */
	public int unlike(String userID, String bbsID, String userIP) {
		String SQL = "DELETE FROM LIKEY1 WHERE bbsID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(bbsID));
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			try {
				if (pstmt != null)
					pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
			try {
				if (rs != null)
					rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return -1;
	}

	/* 동참자 검색 기능 */
	public ArrayList<LikeyDTO1> getList() {
		String SQL = "SELECT userID FROM likey1 WHERE bbsID=1";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<LikeyDTO1> joinlist = new ArrayList<LikeyDTO1>();
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			
			rs = pstmt.executeQuery();

			while (rs.next()) {
				LikeyDTO1 join = new LikeyDTO1(rs.getString(1));
				joinlist.add(join);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// 리소스 정리
			try {
				if (rs != null) {
					rs.close();
				}
				if (pstmt != null) {
					pstmt.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return joinlist; // 데이터베이스 오류
	}
	
	/* 동참자 블러오는 함수 */
	public ArrayList<LikeyDTO1> getLikey (int bbsID) {
		String SQL = "SELECT userID FROM LIKEY1 WHERE bbsID=?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<LikeyDTO1> joinlist= new ArrayList<LikeyDTO1>();
		
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				LikeyDTO1 likey = new LikeyDTO1();
				likey.setUserID(rs.getString(1));
				joinlist.add(likey);
				
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return joinlist;	// 글이 존재하지 않으면 null 반환
	}
}
