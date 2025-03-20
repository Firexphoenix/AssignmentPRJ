package customerDao;

import Model.Customer;
import dao.DBconnection;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerDao implements ICustomerDao {

    private static final String INSERT_CUSTOMER = "INSERT INTO Customer (CustomerID, CustomerName, Email, PhoneNumber, Birthday, Gender) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String INSERT_ACCOUNT = "INSERT INTO Account (Email, Password, Role) VALUES (?, ?, 'Customer')";
    private static final String SELECT_CUSTOMER_BY_ID = "SELECT * FROM Customer WHERE CustomerID = ?";
    private static final String SELECT_CUSTOMER_BY_EMAIL = "SELECT * FROM Customer WHERE Email = ?";
    private static final String UPDATE_CUSTOMER = "UPDATE Customer SET CustomerName = ?, PhoneNumber = ?, Birthday = ?, Gender = ? WHERE CustomerID = ?";
    private static final String DELETE_CUSTOMER = "DELETE FROM Customer WHERE CustomerID = ?";
    private static final String SELECT_ALL_CUSTOMERS = "SELECT * FROM Customer";
    private static final String CHECK_LOGIN = "SELECT * FROM Account WHERE Email = ? AND Password = ? AND Role = 'Customer'";
    private static final String CHECK_EMAIL_EXISTS = "SELECT COUNT(*) FROM Account WHERE Email = ?";

    @Override
    public void insertCustomer(Customer customer, String password) throws SQLException {
        Connection conn = null;
        PreparedStatement psCheckEmail = null;
        PreparedStatement psAccount = null;
        PreparedStatement psCustomer = null;

        try {
            conn = DBconnection.getConnection();
            conn.setAutoCommit(false);

            // Kiểm tra email tồn tại
            psCheckEmail = conn.prepareStatement(CHECK_EMAIL_EXISTS);
            psCheckEmail.setString(1, customer.getEmail());
            ResultSet rs = psCheckEmail.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                throw new SQLException("Email đã tồn tại trong hệ thống.");
            }

            // Thêm tài khoản
            psAccount = conn.prepareStatement(INSERT_ACCOUNT);
            psAccount.setString(1, customer.getEmail());
            psAccount.setString(2, password);
            psAccount.executeUpdate();

            // Thêm khách hàng
            psCustomer = conn.prepareStatement(INSERT_CUSTOMER);
            psCustomer.setString(1, customer.getCustomerID());
            psCustomer.setString(2, customer.getCustomerName());
            psCustomer.setString(3, customer.getEmail());
            psCustomer.setString(4, customer.getPhoneNumber());
            psCustomer.setDate(5, customer.getBirthday() != null ? new Date(customer.getBirthday().getTime()) : null);
            psCustomer.setString(6, customer.getGender());
            psCustomer.executeUpdate();

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw new SQLException("Lỗi khi thêm khách hàng: " + e.getMessage(), e);
        } finally {
            if (psCheckEmail != null) {
                psCheckEmail.close();
            }
            if (psAccount != null) {
                psAccount.close();
            }
            if (psCustomer != null) {
                psCustomer.close();
            }
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public String createCustomer(String email) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBconnection.getConnection();
            conn.setAutoCommit(false);

            // Kiểm tra email tồn tại
            String existingCustomerId = getCustomerIdByEmail(email);
            if (existingCustomerId != null) {
                return existingCustomerId;
            }

            // Tạo CustomerID mới
            String newCustomerId = generateNewCustomerID(conn);
            Customer customer = new Customer(newCustomerId, "Unknown", email, "", null, "Nam");

            // Thêm vào bảng Customer (không cần Account nếu chỉ dùng email)
            ps = conn.prepareStatement(INSERT_CUSTOMER);
            ps.setString(1, customer.getCustomerID());
            ps.setString(2, customer.getCustomerName());
            ps.setString(3, customer.getEmail());
            ps.setString(4, customer.getPhoneNumber());
            ps.setDate(5, customer.getBirthday() != null ? new Date(customer.getBirthday().getTime()) : null);
            ps.setString(6, customer.getGender());
            ps.executeUpdate();

            conn.commit();
            return newCustomerId;
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw new SQLException("Lỗi tạo khách hàng: " + e.getMessage(), e);
        } finally {
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    public String generateNewCustomerID(Connection conn) throws SQLException {
        String sql = "SELECT MAX(CustomerID) AS MaxID FROM Customer";
        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                String maxID = rs.getString("MaxID");
                if (maxID == null) {
                    return "CM001";
                }
                int num = Integer.parseInt(maxID.substring(2)) + 1;
                return String.format("CM%03d", num);
            }
            return "CM001";
        }
    }

    public String getCustomerIdByEmail(String email) throws SQLException {
        String query = "SELECT CustomerID FROM Customer WHERE Email = ?";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("CustomerID");
                }
            }
        }
        return null;
    }

    public String getEmailByCustomerId(String customerId) throws SQLException {
        String query = "SELECT Email FROM Customer WHERE CustomerID = ?";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("Email");
                }
            }
        }
        return null;
    }

    @Override
    public Customer getCustomerById(String customerID) {
        Customer customer = null;
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_CUSTOMER_BY_ID)) {
            ps.setString(1, customerID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                customer = new Customer(
                        rs.getString("CustomerID"),
                        rs.getString("CustomerName"),
                        rs.getString("Email"),
                        rs.getString("PhoneNumber"),
                        rs.getDate("Birthday"),
                        rs.getString("Gender")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }

    @Override
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_ALL_CUSTOMERS); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                customers.add(new Customer(
                        rs.getString("CustomerID"),
                        rs.getString("CustomerName"),
                        rs.getString("Email"),
                        rs.getString("PhoneNumber"),
                        rs.getDate("Birthday"),
                        rs.getString("Gender")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    @Override
    public boolean updateCustomer(Customer customer) throws SQLException {
        boolean rowUpdated;
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(UPDATE_CUSTOMER)) {
            ps.setString(1, customer.getCustomerName());
            ps.setString(2, customer.getPhoneNumber());
            ps.setDate(3, customer.getBirthday() != null ? new Date(customer.getBirthday().getTime()) : null);
            ps.setString(4, customer.getGender());
            ps.setString(5, customer.getCustomerID());
            rowUpdated = ps.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    @Override
    public boolean deleteCustomer(String customerID) throws SQLException {
        boolean rowDeleted;
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(DELETE_CUSTOMER)) {
            ps.setString(1, customerID);
            rowDeleted = ps.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    @Override
    public Customer loginCustomer(String email, String password) {
        Customer customer = null;
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(CHECK_LOGIN)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                customer = getCustomerByEmail(email);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }

    @Override
    public Customer getCustomerByEmail(String email) {
        Customer customer = null;
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_CUSTOMER_BY_EMAIL)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                customer = new Customer(
                        rs.getString("CustomerID"),
                        rs.getString("CustomerName"),
                        rs.getString("Email"),
                        rs.getString("PhoneNumber"),
                        rs.getDate("Birthday"),
                        rs.getString("Gender")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }

    public boolean insertGoogleCustomer(Customer customer, Connection conn) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(INSERT_CUSTOMER)) {
            stmt.setString(1, customer.getCustomerID());
            stmt.setString(2, customer.getCustomerName());
            stmt.setString(3, customer.getEmail());
            stmt.setString(4, customer.getPhoneNumber());
            stmt.setDate(5, customer.getBirthday() != null ? new java.sql.Date(customer.getBirthday().getTime()) : null);
            stmt.setString(6, customer.getGender());

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                System.out.println("✔ Khách hàng đã được thêm vào database: " + customer.getEmail());
                return true;
            } else {
                System.out.println("❌ Không thể thêm khách hàng vào database.");
                return false;
            }
        }
    }
}
