package accountDao;

import Model.Account;
import dao.DBconnection;
import java.sql.*;

public class AccountDao {

    public Account getAccountByEmail(String email) {
        String sql = "SELECT * FROM Account WHERE Email = ?";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Account(rs.getString("Email"), rs.getString("Password"), rs.getString("Role"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertAccount(Account account, Connection conn) throws SQLException {
        String sql = "INSERT INTO Account (Email, Password, Role) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, account.getEmail());
            stmt.setString(2, account.getPassword()); // "" cho Google Login
            stmt.setString(3, account.getRole());

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("✔ Tài khoản Google đã được thêm vào database: " + account.getEmail());
                return true;
            } else {
                System.out.println("❌ Không thể thêm tài khoản Google vào database.");
                return false;
            }
        }
    }

    // Thêm hàm đổi mật khẩu
    public boolean changePassword(String email, String oldPassword, String newPassword) throws SQLException {
        // Kiểm tra mật khẩu cũ
        String checkSql = "SELECT Password FROM Account WHERE Email = ?";
        String updateSql = "UPDATE Account SET Password = ? WHERE Email = ?";

        try (Connection conn = DBconnection.getConnection()) {
            // Bắt đầu giao dịch
            conn.setAutoCommit(false);

            // Kiểm tra mật khẩu cũ
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, email);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    String currentPassword = rs.getString("Password");
                    // Nếu tài khoản đăng nhập bằng Google (password là null hoặc rỗng), không cho phép đổi mật khẩu
                    if (currentPassword == null || currentPassword.trim().isEmpty()) {
                        System.out.println("❌ Tài khoản này đăng nhập bằng Google, không thể đổi mật khẩu.");
                        return false;
                    }
                    // Kiểm tra mật khẩu cũ có khớp không
                    if (!currentPassword.equals(oldPassword)) {
                        System.out.println("❌ Mật khẩu cũ không đúng cho email: " + email);
                        return false;
                    }
                } else {
                    System.out.println("❌ Không tìm thấy tài khoản với email: " + email);
                    return false;
                }
            }

            // Cập nhật mật khẩu mới
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setString(1, newPassword);
                updateStmt.setString(2, email);
                int rowsUpdated = updateStmt.executeUpdate();
                if (rowsUpdated > 0) {
                    System.out.println("✔ Đổi mật khẩu thành công cho email: " + email);
                    conn.commit();
                    return true;
                } else {
                    System.out.println("❌ Không thể đổi mật khẩu cho email: " + email);
                    conn.rollback();
                    return false;
                }
            }
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi đổi mật khẩu: " + e.getMessage());
            throw e;
        }
    }
}
