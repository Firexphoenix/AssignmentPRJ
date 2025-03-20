package Model;

import java.util.Date;

public class ShowTime {

    private String showTimeID;
    private Date startTime;
    private Date endTime;
    private String roomID;
    private String movieID;

    public ShowTime() {
    }

    public ShowTime(String showTimeID, Date startTime, Date endTime, String roomID, String movieID) {
        this.showTimeID = showTimeID;
        this.startTime = startTime;
        this.endTime = endTime;
        this.roomID = roomID;
        this.movieID = movieID;
    }

    public String getShowTimeID() {
        return showTimeID;
    }

    public void setShowTimeID(String showTimeID) {
        this.showTimeID = showTimeID;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public String getRoomID() {
        return roomID;
    }

    public void setRoomID(String roomID) {
        this.roomID = roomID;
    }

    public String getMovieID() {
        return movieID;
    }

    public void setMovieID(String movieID) {
        this.movieID = movieID;
    }

    @Override
    public String toString() {
        return "ShowTime{" + "showTimeID=" + showTimeID + ", startTime=" + startTime + ", endTime="
                + endTime + ", roomID=" + roomID + ", movieID=" + movieID + '}';
    }
}
