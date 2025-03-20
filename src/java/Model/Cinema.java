package Model;

public class Cinema {

    private String cinemaID;
    private String cinemaName;
    private String phoneNumber;
    private String address;

    public Cinema() {
    }
    
    public Cinema(String cinemaID, String cinemaName, String phoneNumber, String address) {
        this.cinemaID = cinemaID;
        this.cinemaName = cinemaName;
        this.phoneNumber = phoneNumber;
        this.address = address;
    }

    public String getCinemaID() {
        return cinemaID;
    }

    public void setCinemaID(String cinemaID) {
        this.cinemaID = cinemaID;
    }

    public String getCinemaName() {
        return cinemaName;
    }

    public void setCinemaName(String cinemaName) {
        this.cinemaName = cinemaName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Override
    public String toString() {
        return "Cinema{" + "cinemaID=" + cinemaID + ", cinemaName=" + cinemaName + ", phoneNumber=" + phoneNumber + ", address=" + address + '}';
    }

    
}
