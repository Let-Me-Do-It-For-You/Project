package likey;

public class LikeyDTO3 {
	String userID;
	int evaluationID;
	String userIP;

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public int getEvaluationID() {
		return evaluationID;
	}

	public void setEvaluationID(int evaluationID) {
		this.evaluationID = evaluationID;
	}

	public String getUserIP() {
		return userIP;
	}

	public void setUserIP(String userIP) {
		this.userIP = userIP;
	}

	public LikeyDTO3() {

	}

	public LikeyDTO3(String userID, int evaluationID, String userIP) {
		super();
		this.userID = userID;
		this.evaluationID = evaluationID;
		this.userIP = userIP;
	}
}
