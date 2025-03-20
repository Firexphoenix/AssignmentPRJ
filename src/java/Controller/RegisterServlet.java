package Controller;

import Model.Account;
import Model.Customer;
import accountDao.AccountDao;
import customerDao.CustomerDao;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.DBconnection;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private CustomerDao customerDAO;
    private AccountDao accountDAO;

    @Override
    public void init() {
        customerDAO = new CustomerDao();
        accountDAO = new AccountDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị trang đăng ký khi truy cập bằng GET
        request.getRequestDispatcher("login/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String customerName = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String birthdayStr = request.getParameter("birthday");
        String gender = request.getParameter("gender");
        String password = request.getParameter("password");

        // Kiểm tra dữ liệu đầu vào
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email không hợp lệ.");
            request.getRequestDispatcher("login/register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            password = "123456"; // Mật khẩu mặc định nếu không cung cấp
        }

        // Chuyển đổi ngày sinh
        Date birthday = null;
        if (birthdayStr != null && !birthdayStr.isEmpty()) {
            try {
                birthday = Date.valueOf(birthdayStr);
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", "Ngày sinh không hợp lệ.");
                request.getRequestDispatcher("login/register.jsp").forward(request, response);
                return;
            }
        }

        // Chuẩn hóa giới tính theo cơ sở dữ liệu (N'Nam' hoặc N'Nữ')
        if (gender != null && !gender.isEmpty()) {
            if (gender.equalsIgnoreCase("Male") || gender.equalsIgnoreCase("Nam")) {
                gender = "Nam";
            } else if (gender.equalsIgnoreCase("Female") || gender.equalsIgnoreCase("Nữ")) {
                gender = "Nữ";
            } else {
                gender = null; // Nếu không hợp lệ, để null
            }
        }

        // Tạo đối tượng Account và Customer
        Account newAccount = new Account(email, password, "Customer");
        Connection conn = null;
        try {
            conn = DBconnection.getConnection();
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu.");
            }
            conn.setAutoCommit(false); // Bắt đầu transaction

            // Sinh CustomerID trong transaction
            String newCustomerID = customerDAO.generateNewCustomerID(conn);
            Customer newCustomer = new Customer(newCustomerID, customerName, email, phoneNumber, birthday, gender);

            // Bước 1: Thêm vào bảng Account trước
            if (accountDAO.getAccountByEmail(email) != null) {
                throw new SQLException("Email đã tồn tại trong hệ thống.");
            }
            accountDAO.insertAccount(newAccount, conn);

            // Bước 2: Thêm vào bảng Customer sau khi Account đã được thêm
            customerDAO.insertGoogleCustomer(newCustomer, conn); // Chỉ thêm vào Customer

            conn.commit(); // Commit transaction
            request.getSession().setAttribute("successMessage", "Đăng ký thành công, vui lòng đăng nhập!");
            response.sendRedirect(request.getContextPath() + "/login");
        } catch (SQLException ex) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu có lỗi
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            request.setAttribute("errorMessage", "Lỗi khi đăng ký: " + ex.getMessage());
            request.getRequestDispatcher("login/register.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException closeEx) {
                    closeEx.printStackTrace();
                }
            }
        }
    }
}