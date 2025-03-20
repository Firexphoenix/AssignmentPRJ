package employeeDao;

import Model.Employee;
import dao.DBconnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDao implements IEmployeeDao {

    private static final String INSERT_ACCOUNT = "INSERT INTO Account (Email, Password, Role) VALUES (?, ?, ?)";
    private static final String INSERT_EMPLOYEE = "INSERT INTO Employee (EmpID, EmpName, Salary, PhoneNumber, Email, Gender, Birthday, HireDate, Address, CinemaID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String SELECT_EMPLOYEE_BY_ID = "SELECT * FROM Employee WHERE EmpID = ?";
    private static final String SELECT_ALL_EMPLOYEES = "SELECT * FROM Employee";
    private static final String UPDATE_EMPLOYEE = "UPDATE Employee SET EmpName = ?, Salary = ?, PhoneNumber = ?, Email = ?, Gender = ?, Birthday = ?, HireDate = ?, Address = ?, CinemaID = ? WHERE EmpID = ?";
    private static final String DELETE_EMPLOYEE = "DELETE FROM Employee WHERE EmpID = ?";
    private static final String SELECT_EMPLOYEE_BY_EMAIL = "SELECT * FROM Employee WHERE Email = ?";
    private static final String CHECK_EMAIL_EXISTS = "SELECT COUNT(*) FROM Account WHERE Email = ?";

    private void logSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException sqlEx) {
                System.err.println("SQLState: " + sqlEx.getSQLState());
                System.err.println("Error Code: " + sqlEx.getErrorCode());
                System.err.println("Message: " + sqlEx.getMessage());
                Throwable cause = sqlEx.getCause();
                while (cause != null) {
                    System.err.println("Cause: " + cause);
                    cause = cause.getCause();
                }
            }
        }
    }

    @Override
    public void insertEmployee(Employee employee, String password, String role) throws SQLException {
        Connection conn = null;
        PreparedStatement psCheckEmail = null;
        PreparedStatement psAccount = null;
        PreparedStatement psEmployee = null;

        try {
            conn = DBconnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // Kiểm tra email tồn tại trong cùng transaction
            psCheckEmail = conn.prepareStatement(CHECK_EMAIL_EXISTS);
            psCheckEmail.setString(1, employee.getEmail());
            ResultSet rs = psCheckEmail.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                throw new SQLException("Email đã tồn tại trong hệ thống.");
            }

            // Bước 1: Thêm tài khoản vào bảng Account
            psAccount = conn.prepareStatement(INSERT_ACCOUNT);
            psAccount.setString(1, employee.getEmail());
            psAccount.setString(2, password);
            psAccount.setString(3, role);
            psAccount.executeUpdate();

            // Bước 2: Thêm nhân viên vào bảng Employee
            psEmployee = conn.prepareStatement(INSERT_EMPLOYEE);
            psEmployee.setString(1, employee.getEmpID());
            psEmployee.setString(2, employee.getEmpName());
            psEmployee.setDouble(3, employee.getSalary());
            psEmployee.setString(4, employee.getPhoneNumber());
            psEmployee.setString(5, employee.getEmail());
            psEmployee.setString(6, employee.getGender());
            psEmployee.setDate(7, employee.getBirthday() != null ? new Date(employee.getBirthday().getTime()) : null);
            psEmployee.setDate(8, employee.getHireDate() != null ? new Date(employee.getHireDate().getTime()) : null);
            psEmployee.setString(9, employee.getAddress());
            psEmployee.setString(10, employee.getCinemaID());
            psEmployee.executeUpdate();

            conn.commit(); // Xác nhận transaction
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback(); // Nếu có lỗi, rollback lại
            }
            throw new SQLException("Lỗi khi thêm nhân viên: " + e.getMessage(), e);
        } finally {
            if (psCheckEmail != null) {
                psCheckEmail.close();
            }
            if (psAccount != null) {
                psAccount.close();
            }
            if (psEmployee != null) {
                psEmployee.close();
            }
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    @Override
    public Employee selectEmployee(String empID) {
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_EMPLOYEE_BY_ID)) {
            ps.setString(1, empID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractEmployeeFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            logSQLException(e);
        }
        return null;
    }

    @Override
    public List<Employee> selectAllEmployees() {
        List<Employee> employees = new ArrayList<>();
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_ALL_EMPLOYEES); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                employees.add(extractEmployeeFromResultSet(rs));
            }
        } catch (SQLException e) {
            logSQLException(e);
        }
        return employees;
    }

    @Override
    public boolean updateEmployee(Employee emp) throws SQLException {
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(UPDATE_EMPLOYEE)) {
            ps.setString(1, emp.getEmpName());
            ps.setDouble(2, emp.getSalary());
            ps.setString(3, emp.getPhoneNumber());
            ps.setString(4, emp.getEmail());
            ps.setString(5, emp.getGender());
            ps.setDate(6, emp.getBirthday());
            ps.setDate(7, emp.getHireDate());
            ps.setString(8, emp.getAddress());
            ps.setString(9, emp.getCinemaID());
            ps.setString(10, emp.getEmpID());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean deleteEmployee(String empID) throws SQLException {
        boolean rowDeleted;
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(DELETE_EMPLOYEE)) {
            ps.setString(1, empID);
            rowDeleted = ps.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    @Override
    public Employee getEmployeeByEmail(String email) {
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_EMPLOYEE_BY_EMAIL)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractEmployeeFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            logSQLException(e);
        }
        return null;
    }

    private Employee extractEmployeeFromResultSet(ResultSet rs) throws SQLException {
        return new Employee(
                rs.getString("empID"),
                rs.getString("empName"),
                rs.getDouble("Salary"),
                rs.getString("PhoneNumber"),
                rs.getString("Email"),
                rs.getString("Gender"),
                rs.getDate("Birthday"),
                rs.getDate("HireDate"),
                rs.getString("Address"),
                rs.getString("CinemaID")
        );
    }

    @Override
    public Employee getEmployeeById(String empID) {
        Employee employee = null;
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_EMPLOYEE_BY_ID)) {
            ps.setString(1, empID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                employee = new Employee(
                        rs.getString("EmpID"),
                        rs.getString("EmpName"),
                        rs.getDouble("Salary"),
                        rs.getString("PhoneNumber"),
                        rs.getString("Email"),
                        rs.getString("Gender"),
                        rs.getDate("Birthday"),
                        rs.getDate("HireDate"),
                        rs.getString("Address"),
                        rs.getString("CinemaID")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return employee;
    }
}
