package bbs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import util.DatabaseUtil;

public class BbsDAO2 {

	/* 글작성 */
	public int write(BbsDTO2 bbsDTO2) {
		String SQL = "INSERT INTO BBS2 VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, 0);";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsDTO2.getUserID());
			pstmt.setString(2, bbsDTO2.getHjsy());
			pstmt.setString(3, bbsDTO2.getBbsTitle());
			pstmt.setString(4, bbsDTO2.getBbsContent());
			pstmt.setInt(5, bbsDTO2.getMoney());
			pstmt.setString(6, bbsDTO2.getSelectTime());
			pstmt.setString(7, bbsDTO2.getPlace());
			pstmt.setString(8, getDate());
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
		return -2;
	}

	/* 글 작성시 현재 시간을 가져와 줌 */
	public String getDate() {
		String SQL = "SELECT NOW()";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			// BbsDAO 클래스는 여러개의 함수가 사용되므로 각각 함수 끼리 DB접근에 있어 마찰이 일어나지 않도록 함수 안에 pstmt 선언
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; // 데이터베이스 오류
	}

	/* 검색 기능 */
	public ArrayList<BbsDTO2> getList(String hjsy, String searchType, String search, int pageNumber) {
		if (hjsy.equals("전체")) {
			hjsy = "";
		}
		ArrayList<BbsDTO2> bbsList = null;
		String SQL = "";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if (searchType.equals("최신순")) {
				SQL = "SELECT * FROM BBS2 WHERE hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY bbsID DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("추천순")) {
				SQL = "SELECT * FROM BBS2 WHERE hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY likeCount DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("금액순")) {
				SQL = "SELECT * FROM BBS2 WHERE hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY money DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			}
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + hjsy + "%");
			pstmt.setString(2, "%" + search + "%");
			rs = pstmt.executeQuery();
			bbsList = new ArrayList<BbsDTO2>();

			while (rs.next()) {
				BbsDTO2 bbs = new BbsDTO2(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4),
						rs.getString(5), rs.getInt(6), rs.getString(7), rs.getString(8), rs.getString(9),
						rs.getInt(10));
				bbsList.add(bbs);
			}
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
		return bbsList;
	}

	/* 평가 추천 */
	public int like(String bbsID) {
		String SQL = "UPDATE BBS2 SET likeCount = likeCount + 1 WHERE bbsID = ?";
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

	/* 글삭제 */
	public int delete(String bbsID) {
		String SQL = "DELETE FROM BBS2 WHERE bbsID = ?";
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

	/* 유저 정보 가져오기 */
	public String getUserID(String bbsID) {
		String SQL = "SELECT userID FROM BBS2 WHERE bbsID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(bbsID));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
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
		return null; // 유저 존재 X
	}

}
