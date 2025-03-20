package Model;

import java.util.Date;

public class Invoice {

    private String invoiceID;
    private String ticketID;
    private Date date;
    private String time;
    private double total;
    private String status;

    public Invoice() {
    }

    public Invoice(String invoiceID, String ticketID, Date date, String time, double total, String status) {
        this.invoiceID = invoiceID;
        this.ticketID = ticketID;
        this.date = date;
        this.time = time;
        this.total = total;
        this.status = status;
    }

    public String getInvoiceID() {
        return invoiceID;
    }

    public void setInvoiceID(String invoiceID) {
        this.invoiceID = invoiceID;
    }

    public String getTicketID() {
        return ticketID;
    }

    public void setTicketID(String ticketID) {
        this.ticketID = ticketID;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Invoice{" + "invoiceID=" + invoiceID + ", ticketID=" + ticketID + ", date=" 
                + date + ", time=" + time + ", total=" + total + ", status=" + status + '}';
    }
}
