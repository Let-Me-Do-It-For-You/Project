package comment;

public class CommentDTO1 {
	
	private int bbsID;
	private int commentID;
	private String commentContent;
	private String userID;
	private int commentAvailable;
	private boolean commentPrivate;
	
	public int getBbsID() {
		return bbsID;
	}
	public void setBbsID(int bbsID) {
		this.bbsID = bbsID;
	}
	public int getCommentID() {
		return commentID;
	}
	public void setCommentID(int commentID) {
		this.commentID = commentID;
	}
	public String getCommentContent() {
		return commentContent;
	}
	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public int getCommentAvailable() {
		return commentAvailable;
	}
	public void setCommentAvailable(int commentAvailable) {
		this.commentAvailable = commentAvailable;
	}
	public boolean getCommentPrivate() {
		return commentPrivate;
	}
	public void setCommentPrivate(boolean commentPrivate) {
		this.commentPrivate = commentPrivate;
	}
	
	
}
