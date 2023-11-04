package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {
	
	public static Connection getConnection() { // static 다른 클래스에서 사용할 수 있도록
		try {
			String dbURL = "jdbc:mysql://localhost:3306/CapstoneDesign";
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.jdbc.Driver");	// MySQL에 접속할 수 있도록 해주는 매개체 역할을 해주는 하나의 라이브러리
			return DriverManager.getConnection(dbURL, dbID, dbPassword);	// conn 객체 안에 접속된 정보가 담김
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
