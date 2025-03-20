package Model;

import java.util.Date;

public class Ticket {

    private String ticketID;
    private String showTimeID;
    private String customerID;
    private String seatNumber;
    private Date bookingTime;
    private String status;
    private String movieID;
    private int quantity;

    public Ticket() {
    }

    public Ticket(String ticketID, String showTimeID, String customerID, String seatNumber, Date bookingTime,
            String status, String movieID, int quantity) {
        this.ticketID = ticketID;
        this.showTimeID = showTimeID;
        this.customerID = customerID;
        this.seatNumber = seatNumber;
        this.bookingTime = bookingTime;
        this.status = status;
        this.movieID = movieID;
        this.quantity = quantity;
    }

    public String getTicketID() {
        return ticketID;
    }

    public void setTicketID(String ticketID) {
        this.ticketID = ticketID;
    }

    public String getShowTimeID() {
        return showTimeID;
    }

    public void setShowTimeID(String showTimeID) {
        this.showTimeID = showTimeID;
    }

    public String getCustomerID() {
        return customerID;
    }

    public void setCustomerID(String customerID) {
        this.customerID = customerID;
    }

    public String getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(String seatNumber) {
        this.seatNumber = seatNumber;
    }

    public Date getBookingTime() {
        return bookingTime;
    }

    public void setBookingTime(Date bookingTime) {
        this.bookingTime = bookingTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getMovieID() {
        return movieID;
    }

    public void setMovieID(String movieID) {
        this.movieID = movieID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        return "Ticket{"
                + "ticketID='" + ticketID + '\''
                + ", showTimeID='" + showTimeID + '\''
                + ", customerID='" + customerID + '\''
                + ", seatNumber='" + seatNumber + '\''
                + ", bookingTime=" + bookingTime
                + ", status='" + status + '\''
                + ", movieID='" + movieID + '\''
                + ", quantity=" + quantity
                + '}';
    }
}
