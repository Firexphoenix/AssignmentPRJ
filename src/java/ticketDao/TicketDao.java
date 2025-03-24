package ticketDao;

import Model.Ticket;
import dao.DBconnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TicketDao {

    // Thêm vé mới vào cơ sở dữ liệu
    public void insertTicket(Ticket ticket) throws SQLException {
        String query = "INSERT INTO Ticket (TicketID, ShowTimeID, CustomerID, SeatNumber, BookingTime, Status, MovieID, Quantity) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, ticket.getTicketID());
            ps.setString(2, ticket.getShowTimeID());
            ps.setString(3, ticket.getCustomerID());
            ps.setString(4, ticket.getSeatNumber());
            ps.setTimestamp(5, new java.sql.Timestamp(ticket.getBookingTime().getTime()));
            ps.setString(6, ticket.getStatus());
            ps.setString(7, ticket.getMovieID());
            ps.setInt(8, ticket.getQuantity());
            ps.executeUpdate();
        }
    }

    // Lấy danh sách ghế đã đặt theo ShowTimeID
    public List<String> getBookedSeats(String showTimeId) throws SQLException {
        List<String> bookedSeats = new ArrayList<>();
        String query = "SELECT SeatNumber FROM Ticket WHERE ShowTimeID = ? AND Status = 'Paid'";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, showTimeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookedSeats.add(rs.getString("SeatNumber"));
                }
            }
        }
        return bookedSeats;
    }

    // Kiểm tra ShowTimeID có hợp lệ không
    public boolean isShowTimeIdValid(String showTimeId) throws SQLException {
        String query = "SELECT COUNT(*) FROM Showtime WHERE ShowTimeID = ?";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, showTimeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    // Lấy TicketID lớn nhất từ cơ sở dữ liệu
    public String getMaxTicketId() throws SQLException {
        String query = "SELECT MAX(TicketID) AS maxId FROM Ticket";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getString("maxId");
            }
            return null;
        }
    }

    // Kiểm tra xem TicketID đã tồn tại chưa
    public boolean isTicketIdExists(String ticketId) throws SQLException {
        String query = "SELECT COUNT(*) FROM Ticket WHERE TicketID = ?";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    // Lấy loại phòng chiếu (2D/3D) dựa trên ShowTimeID
    public String getScreenRoomType(String showTimeId) throws SQLException {
        String query = "SELECT sr.Type "
                + "FROM Showtime s "
                + "JOIN ScreenRoom sr ON s.RoomID = sr.RoomID "
                + "WHERE s.ShowTimeID = ?";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, showTimeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("Type");
                }
            }
        }
        return null;
    }

    public List<Ticket> getTicketHistoryByEmail(String email) throws SQLException {
        List<Ticket> ticketHistory = new ArrayList<>();
        String query = "SELECT t.TicketID, t.ShowTimeID, t.CustomerID, t.MovieID, t.SeatNumber, t.BookingTime, t.Status, t.Quantity "
                + "FROM Ticket t "
                + "JOIN Customer c ON t.CustomerID = c.CustomerID "
                + "WHERE c.Email = ? "
                + "ORDER BY t.BookingTime DESC";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ticket ticket = new Ticket(
                            rs.getString("TicketID"),
                            rs.getString("ShowTimeID"),
                            rs.getString("CustomerID"),
                            rs.getString("SeatNumber"),
                            rs.getTimestamp("BookingTime"),
                            rs.getString("Status"),
                            rs.getString("MovieID"),
                            rs.getInt("Quantity")
                    );
                    ticketHistory.add(ticket);
                }
            }
        }
        return ticketHistory;
    }

    public List<Ticket> getAllTicketHistory() throws SQLException {
        List<Ticket> ticketHistory = new ArrayList<>();
        String sql = "SELECT * FROM Ticket ORDER BY BookingTime DESC";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Ticket ticket = new Ticket();
                ticket.setTicketID(rs.getString("TicketID"));
                ticket.setShowTimeID(rs.getString("ShowTimeID"));
                ticket.setCustomerID(rs.getString("CustomerID"));
                ticket.setSeatNumber(rs.getString("SeatNumber"));
                ticket.setBookingTime(rs.getTimestamp("BookingTime"));
                ticket.setStatus(rs.getString("Status"));
                ticket.setMovieID(rs.getString("MovieID"));
                ticket.setQuantity(rs.getInt("Quantity"));
                ticketHistory.add(ticket);
            }
        }
        return ticketHistory;
    }

    public void deleteTicket(String ticketId) throws SQLException {
        String sql = "DELETE FROM Ticket WHERE TicketID = ?";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ticketId);
            stmt.executeUpdate();
        }
    }
}
