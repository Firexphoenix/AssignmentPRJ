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
}
