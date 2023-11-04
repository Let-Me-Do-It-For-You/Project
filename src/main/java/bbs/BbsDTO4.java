package bbs;

public class BbsDTO4 {

	int bbsID;
	String userID;
	String hjsy;
	String bbsTitle;
	String bbsContent;
	int money;
	String selectTime;
	String place;
	String bbsDate;
	int likeCount;

	public int getBbsID() {
		return bbsID;
	}

	public void setBbsID(int bbsID) {
		this.bbsID = bbsID;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getHjsy() {
		return hjsy;
	}

	public void setHjsy(String hjsy) {
		this.hjsy = hjsy;
	}

	public String getBbsTitle() {
		return bbsTitle;
	}

	public void setBbsTitle(String bbsTitle) {
		this.bbsTitle = bbsTitle;
	}

	public String getBbsContent() {
		return bbsContent;
	}

	public void setBbsContent(String bbsContent) {
		this.bbsContent = bbsContent;
	}

	public int getMoney() {
		return money;
	}

	public void setMoney(int money) {
		this.money = money;
	}

	public String getSelectTime() {
		return selectTime;
	}

	public void setSelectTime(String selectTime) {
		this.selectTime = selectTime;
	}

	public String getPlace() {
		return place;
	}

	public void setPlace(String place) {
		this.place = place;
	}

	public String getBbsDate() {
		return bbsDate;
	}

	public void setBbsDate(String bbsDate) {
		this.bbsDate = bbsDate;
	}

	public int getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}

	public BbsDTO4() {

	}

	public BbsDTO4(int bbsID, String userID, String hjsy, String bbsTitle, String bbsContent, int money,
			String selectTime, String place, String bbsDate, int likeCount) {
		super();
		this.bbsID = bbsID;
		this.userID = userID;
		this.hjsy = hjsy;
		this.bbsTitle = bbsTitle;
		this.bbsContent = bbsContent;
		this.money = money;
		this.selectTime = selectTime;
		this.place = place;
		this.bbsDate = bbsDate;
		this.likeCount = likeCount;
	}

}
