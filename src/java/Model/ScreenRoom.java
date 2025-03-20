package Model;

public class ScreenRoom {

    private String roomID;
    private int capacity;
    private String status;
    private String type;
    private String cinemaID;

    public ScreenRoom() {
    }

    public ScreenRoom(String roomID, int capacity, String status, String type, String cinemaID) {
        this.roomID = roomID;
        this.capacity = capacity;
        this.status = status;
        this.type = type;
        this.cinemaID = cinemaID;
    }

    public String getRoomID() {
        return roomID;
    }

    public void setRoomID(String roomID) {
        this.roomID = roomID;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCinemaID() {
        return cinemaID;
    }

    public void setCinemaID(String cinemaID) {
        this.cinemaID = cinemaID;
    }

    @Override
    public String toString() {
        return "ScreenRoom{" + "roomID=" + roomID + ", capacity=" + capacity + ", status=" 
                + status + ", type=" + type + ", cinemaID=" + cinemaID + '}';
    }
}
