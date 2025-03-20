package invoiceDao;

import Model.Invoice;
import dao.DBconnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class InvoiceDao {

    // Thêm hóa đơn mới vào cơ sở dữ liệu
    public void insertInvoice(Invoice invoice) throws SQLException {
        String query = "INSERT INTO Invoice (InvoiceID, TicketID, Date, Time, Total, Status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, invoice.getInvoiceID());
            ps.setString(2, invoice.getTicketID());
            ps.setDate(3, new java.sql.Date(invoice.getDate().getTime()));
            ps.setString(4, invoice.getTime());
            ps.setDouble(5, invoice.getTotal());
            ps.setString(6, invoice.getStatus());
            ps.executeUpdate();
        }
    }

    // Lấy InvoiceID lớn nhất từ cơ sở dữ liệu
    public String getMaxInvoiceId() throws SQLException {
        String query = "SELECT MAX(InvoiceID) AS maxId FROM Invoice";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getString("maxId");
            }
            return null;
        }
    }

    // Kiểm tra xem InvoiceID đã tồn tại chưa
    public boolean isInvoiceIdExists(String invoiceId) throws SQLException {
        String query = "SELECT COUNT(*) FROM Invoice WHERE InvoiceID = ?";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }
}
