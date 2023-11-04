package bbs;

public class BbsDTO1 {

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
	boolean likeClose;
	String rider;
	int riderProgress;
	String restaurant_name;
	String restaurant_address;

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
	
	public Boolean getLikeClose() {
		return likeClose;
	}

	public void setLikeClose(Boolean likeClose) {
		this.likeClose = likeClose;
	}
	
	public String getRider() {
		return rider;
	}

	public void setRider(String rider) {
		this.rider = rider;
	}
	
	public int getRiderProgress() {
		return riderProgress;
	}

	public void setRiderProgress(int riderProgress) {
		this.riderProgress = riderProgress;
	}
	
	public String getRestaurantName() {
		return restaurant_name;
	}

	public void setRestaurantName(String restaurant_name) {
		this.restaurant_name = restaurant_name;
	}
	
	public String getRestaurantAddress() {
		return restaurant_address;
	}

	public void setRestaurantAddress(String restaurant_address) {
		this.restaurant_address = restaurant_address;
	}

	public BbsDTO1() {

	}

	public BbsDTO1(int bbsID, String userID, String hjsy, String bbsTitle, String bbsContent, int money,
			String selectTime, String place, String bbsDate, int likeCount, Boolean likeClose, String rider, int riderProgress, String restaurant_name, String restaurant_address) {
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
		this.likeClose = likeClose;
		this.rider = rider;
		this.riderProgress = riderProgress;
		this.restaurant_name = restaurant_name;
		this.restaurant_address = restaurant_address;
	}

}
