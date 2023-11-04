package user;

public class UserDTO {

	private String userID;
	private String userPassword;
	private String userName;
	private String userGender;
	private String userEmail;
	private String accountNumber;
	private String userAddress;
	private Boolean userRider;

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getUserPassword() {
		return userPassword;
	}

	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserGender() {
		return userGender;
	}

	public void setUserGender(String userGender) {
		this.userGender = userGender;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	
	public String getAccountNumber() {
		return accountNumber;
	}

	public void setAccountNumber(String accountNumber) {
		this.accountNumber = accountNumber;
	}

	public String getUserAddress() {
		return userAddress;
	}

	public void setUserAddress(String userAddress) {
		this.userAddress = userAddress;
	}
	
	public Boolean getUserRider() {
		return userRider;
	}

	public void setUserRider(Boolean userRider) {
		this.userRider = userRider;
	}

	public UserDTO() {

	}

	public UserDTO(String userID, String userPassword, String userName, String userGender, String userEmail, String accountNumber, 
			String userAddress, Boolean userRider) {
		this.userID = userID;
		this.userPassword = userPassword;
		this.userName = userName;
		this.userGender = userGender;
		this.userEmail = userEmail;
		this.accountNumber = accountNumber;
		this.userAddress = userAddress;
		this.userRider = userRider;
	}
	
	public UserDTO(String userID) {
		this.userID = userID;
	}

}