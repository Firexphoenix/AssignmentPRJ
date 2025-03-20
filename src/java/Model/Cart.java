package Model;

import java.util.ArrayList;
import java.util.List;

public class Cart {
    private List<Ticket> tickets;

    // Constructor
    public Cart() {
        this.tickets = new ArrayList<>();
    }

    // Thêm vé vào giỏ hàng
    public void addTicket(Ticket ticket) {
        tickets.add(ticket);
    }

    // Lấy danh sách vé
    public List<Ticket> getTickets() {
        return tickets;
    }

    // Xóa vé khỏi giỏ hàng (nếu cần)
    public void removeTicket(String ticketID) {
        tickets.removeIf(ticket -> ticket.getTicketID().equals(ticketID));
    }

    // Xóa toàn bộ giỏ hàng
    public void clear() {
        tickets.clear();
    }

    // Lấy tổng số lượng vé
    public int getTotalQuantity() {
        return tickets.stream().mapToInt(Ticket::getQuantity).sum();
    }

    @Override
    public String toString() {
        return "Cart{" +
                "tickets=" + tickets +
                '}';
    }
}