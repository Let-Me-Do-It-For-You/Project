package bbs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;


import util.DatabaseUtil;

public class BbsDAO1 {

	/* 글작성 */
	public int write(BbsDTO1 bbsDTO1) {
		String SQL = "INSERT INTO BBS1 VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, 1, ?, ?, ?, ?, ?);";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsDTO1.getUserID());
			pstmt.setString(2, bbsDTO1.getHjsy());
			pstmt.setString(3, bbsDTO1.getBbsTitle());
			pstmt.setString(4, bbsDTO1.getBbsContent());
			pstmt.setInt(5, bbsDTO1.getMoney());
			pstmt.setString(6, bbsDTO1.getSelectTime());
			pstmt.setString(7, bbsDTO1.getPlace());
			pstmt.setString(8, getDate());
			pstmt.setBoolean(9, bbsDTO1.getLikeClose());
			pstmt.setString(10, bbsDTO1.getRider());
			pstmt.setInt(11, bbsDTO1.getRiderProgress());
			pstmt.setString(12, bbsDTO1.getRestaurantName());
			pstmt.setString(13, bbsDTO1.getRestaurantAddress());
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
	
	/* 글수정 */
	public int update(int bbsID, String hjsy, String bbsTitle, String bbsContent, int money, String selectTime, String place) {
		String SQL = "UPDATE BBS1 SET hjsy = ?, bbsTitle = ?, bbsContent = ?, money = ?, selectTime = ?, place = ? WHERE bbsID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			
			pstmt.setString(1, hjsy);
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, bbsContent);
			pstmt.setInt(4, money);
			pstmt.setString(5, selectTime);
			pstmt.setString(6, place);
			pstmt.setInt(7, bbsID);
			
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
	public ArrayList<BbsDTO1> getList(String hjsy, String searchType, String search, int pageNumber) {
		if (hjsy.equals("전체")) {
			hjsy = "";
		}
		ArrayList<BbsDTO1> bbsList = null;
		String SQL = "";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if (searchType.equals("최신순")) {
				SQL = "SELECT * FROM BBS1 WHERE hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY bbsID DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("동참순")) {
				SQL = "SELECT * FROM BBS1 WHERE hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY likeCount DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("금액순")) {
				SQL = "SELECT * FROM BBS1 WHERE hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY money DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			}
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + hjsy + "%");
			pstmt.setString(2, "%" + search + "%");
			rs = pstmt.executeQuery();
			bbsList = new ArrayList<BbsDTO1>();

			while (rs.next()) {
				BbsDTO1 bbs = new BbsDTO1(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4),
						rs.getString(5), rs.getInt(6), rs.getString(7), rs.getString(8), rs.getString(9), rs.getInt(10),
						rs.getBoolean(11), rs.getString(12), rs.getInt(13), rs.getString(14), rs.getString(15));
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

	/* 동참 버튼 - 단순히 숫자만 카운트 */
	public int like(String bbsID) {
		String SQL = "UPDATE BBS1 SET likeCount = likeCount + 1 WHERE bbsID = ?";
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

	/* 동참 취소 버튼 - 단순히 숫자만 카운트 */
	public int unlike(String bbsID) {
		String SQL = "UPDATE BBS1 SET likeCount = likeCount - 1 WHERE bbsID = ?";
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
		String SQL = "DELETE FROM BBS1 WHERE bbsID = ?";
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
		String SQL = "SELECT userID FROM BBS1 WHERE bbsID = ?";
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

	/* 게시글 블러오는 함수 */
	public BbsDTO1 getBbs(int bbsID) {
		String SQL = "SELECT * FROM BBS1 WHERE bbsID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			// BbsDAO 클래스는 여러개의 함수가 사용되므로 각각 함수 끼리 DB접근에 있어 마찰이 일어나지 않도록 함수 안에 pstmt 선언
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				BbsDTO1 bbs = new BbsDTO1();
				bbs.setBbsID(rs.getInt(1));
				bbs.setUserID(rs.getString(2));
				bbs.setHjsy(rs.getString(3));
				bbs.setBbsTitle(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setMoney(rs.getInt(6));
				bbs.setSelectTime(rs.getString(7));
				bbs.setPlace(rs.getString(8));
				bbs.setBbsDate(rs.getString(9));
				bbs.setLikeCount(rs.getInt(10));
				bbs.setLikeClose(rs.getBoolean(11));
				bbs.setRider(rs.getString(12));
				bbs.setRiderProgress(rs.getInt(13));
				bbs.setRestaurantName(rs.getString(14));
				bbs.setRestaurantAddress(rs.getString(15));

				return bbs;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null; // 글이 존재하지 않으면 null 반환
	}
	
	/* 라이더 요청글 블러오는 함수 */
	public ArrayList<BbsDTO1> getRiderList(String userID, String hjsy, String searchType, String search, int pageNumber) {
		if (hjsy.equals("전체")) {
			hjsy = "";
		}
		ArrayList<BbsDTO1> bbsList = null;
		String SQL = "";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if (searchType.equals("최신순")) {
				SQL = "SELECT * FROM BBS1 WHERE rider=? AND riderProgress = 1 AND hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY bbsID DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("동참순")) {
				SQL = "SELECT * FROM BBS1 WHERE rider=? AND riderProgress = 1 AND hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY likeCount DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("금액순")) {
				SQL = "SELECT * FROM BBS1 WHERE rider=? AND riderProgress = 1 AND hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY money DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			}
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, "%" + hjsy + "%");
			pstmt.setString(3, "%" + search + "%");
			rs = pstmt.executeQuery();
			bbsList = new ArrayList<BbsDTO1>();

			while (rs.next()) {
				BbsDTO1 bbs = new BbsDTO1(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4),
						rs.getString(5), rs.getInt(6), rs.getString(7), rs.getString(8), rs.getString(9), rs.getInt(10),
						rs.getBoolean(11), rs.getString(12), rs.getInt(13), rs.getString(14), rs.getString(15));
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
	
	/* 라이더 진행사항 블러오는 함수 */
	public ArrayList<BbsDTO1> getProgressList(String userID, String hjsy, String searchType, String search, int pageNumber) {
		if (hjsy.equals("전체")) {
			hjsy = "";
		}
		ArrayList<BbsDTO1> bbsList = null;
		String SQL = "";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if (searchType.equals("최신순")) {
				SQL = "SELECT * FROM bbs1 WHERE rider=? AND riderProgress = 2 OR riderProgress = 3 OR riderProgress = 4 AND hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY bbsID DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("동참순")) {
				SQL = "SELECT * FROM bbs1 WHERE rider=? AND riderProgress = 2 OR riderProgress = 3 OR riderProgress = 4 AND hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY likeCount DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("금액순")) {
				SQL = "SELECT * FROM bbs1 WHERE rider=? AND riderProgress = 2 OR riderProgress = 3 OR riderProgress = 4 AND hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY money DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			}
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, "%" + hjsy + "%");
			pstmt.setString(3, "%" + search + "%");
			rs = pstmt.executeQuery();
			bbsList = new ArrayList<BbsDTO1>();

			while (rs.next()) {
				BbsDTO1 bbs = new BbsDTO1(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4),
						rs.getString(5), rs.getInt(6), rs.getString(7), rs.getString(8), rs.getString(9), rs.getInt(10),
						rs.getBoolean(11), rs.getString(12), rs.getInt(13), rs.getString(14), rs.getString(15));
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

	/* 라이더 진행사항 블러오는 함수 */
	public ArrayList<BbsDTO1> getCompleteList(String userID, String hjsy, String searchType, String search, int pageNumber) {
		if (hjsy.equals("전체")) {
			hjsy = "";
		}
		ArrayList<BbsDTO1> bbsList = null;
		String SQL = "";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if (searchType.equals("최신순")) {
				SQL = "SELECT * FROM bbs1 WHERE rider=? AND riderProgress = 5 AND hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY bbsID DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("동참순")) {
				SQL = "SELECT * FROM bbs1 WHERE rider=? AND riderProgress = 5 AND hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY likeCount DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("금액순")) {
				SQL = "SELECT * FROM bbs1 WHERE rider=? AND riderProgress = 5 AND hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY money DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			}
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, "%" + hjsy + "%");
			pstmt.setString(3, "%" + search + "%");
			rs = pstmt.executeQuery();
			bbsList = new ArrayList<BbsDTO1>();

			while (rs.next()) {
				BbsDTO1 bbs = new BbsDTO1(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4),
						rs.getString(5), rs.getInt(6), rs.getString(7), rs.getString(8), rs.getString(9), rs.getInt(10),
						rs.getBoolean(11), rs.getString(12), rs.getInt(13), rs.getString(14), rs.getString(15));
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

	/* 라이더 요청 승인 */
	public int approve(String bbsID, String rider) {
		String SQL = "UPDATE bbs1 SET rider = ?, riderProgress = ? WHERE bbsID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			// BbsDAO 클래스는 여러개의 함수가 사용되므로 각각 함수 끼리 DB접근에 있어 마찰이 일어나지 않도록 함수 안에 pstmt 선언
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, rider);
			pstmt.setInt(2, 2);
			pstmt.setString(3, bbsID);
			pstmt.execute();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return 1;
	}
	
	/* 라이더 승인 거절 */
	public int refusal(String bbsID) {
		String SQL = "UPDATE bbs1 SET rider = ?, riderProgress = ? WHERE bbsID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			// BbsDAO 클래스는 여러개의 함수가 사용되므로 각각 함수 끼리 DB접근에 있어 마찰이 일어나지 않도록 함수 안에 pstmt 선언
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, null);
			pstmt.setInt(2, 0);
			pstmt.setString(3, bbsID);
			pstmt.execute();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	/* 라이더 픽업 */
	public int pickUp(String bbsID, String rider) {
		String SQL = "UPDATE bbs1 SET rider = ?, riderProgress = ? WHERE bbsID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			// BbsDAO 클래스는 여러개의 함수가 사용되므로 각각 함수 끼리 DB접근에 있어 마찰이 일어나지 않도록 함수 안에 pstmt 선언
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, rider);
			pstmt.setInt(2, 3);
			pstmt.setString(3, bbsID);
			pstmt.execute();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return 1;
	}	

	/* 라이더 배달중 */
	public int delivery(String bbsID, String rider) {
		String SQL = "UPDATE bbs1 SET rider = ?, riderProgress = ? WHERE bbsID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			// BbsDAO 클래스는 여러개의 함수가 사용되므로 각각 함수 끼리 DB접근에 있어 마찰이 일어나지 않도록 함수 안에 pstmt 선언
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, rider);
			pstmt.setInt(2, 4);
			pstmt.setString(3, bbsID);
			pstmt.execute();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return 1;
	}
	
	/* 라이더 배달 완료 */
	public int deliveryComplete(String bbsID, String rider) {
		String SQL = "UPDATE bbs1 SET rider = ?, riderProgress = ? WHERE bbsID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			// BbsDAO 클래스는 여러개의 함수가 사용되므로 각각 함수 끼리 DB접근에 있어 마찰이 일어나지 않도록 함수 안에 pstmt 선언
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, rider);
			pstmt.setInt(2, 5);
			pstmt.setString(3, bbsID);
			pstmt.execute();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return 1;
	}
	
	// 승인 대기 목록
	public ArrayList<BbsDTO1> getRequestList(String hjsy, String searchType, String search, int pageNumber) {
		if (hjsy.equals("전체")) {
			hjsy = "";
		}
		ArrayList<BbsDTO1> bbsList = null;
		String SQL = "";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if (searchType.equals("최신순")) {
				SQL = "SELECT * FROM BBS1 WHERE riderProgress = 0 AND hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY bbsID DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("동참순")) {
				SQL = "SELECT * FROM BBS1 WHERE riderProgress = 0 AND hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY likeCount DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("금액순")) {
				SQL = "SELECT * FROM BBS1 WHERE riderProgress = 0 AND hjsy LIKE ? AND CONCAT(userID, hjsy, bbsTitle, bbsContent) LIKE ? ORDER BY money DESC LIMIT "
						+ pageNumber * 5 + ", " + pageNumber * 5 + 6;
			}
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + hjsy + "%");
			pstmt.setString(2, "%" + search + "%");
			rs = pstmt.executeQuery();
			bbsList = new ArrayList<BbsDTO1>();

			while (rs.next()) {
				BbsDTO1 bbs = new BbsDTO1(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4),
						rs.getString(5), rs.getInt(6), rs.getString(7), rs.getString(8), rs.getString(9), rs.getInt(10),
						rs.getBoolean(11), rs.getString(12), rs.getInt(13), rs.getString(14), rs.getString(15));
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

	/* 동참 마감 */
	public int likeClose(int bbsID, Boolean likeClose) {
		String SQL = "UPDATE BBS1 SET likeClose = true WHERE bbsID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
		
			pstmt.setInt(1, bbsID);
			
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
	
}
