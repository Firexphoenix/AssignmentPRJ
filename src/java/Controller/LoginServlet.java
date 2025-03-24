package Controller;

import Model.Account;
import Model.Customer;
import Model.GoogleAccount;
import accountDao.AccountDao;
import customerDao.CustomerDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.SQLException;
import listener.SessionCounterListener;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private AccountDao accountDao;
    private CustomerDao customerDao;

    @Override
    public void init() {
        accountDao = new AccountDao();
        customerDao = new CustomerDao();
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String code = request.getParameter("code");
        if (code == null || code.isEmpty()) {
            System.out.println("No OAuth code received, redirecting to login page.");
            response.sendRedirect("login/login.jsp");
            return;
        }

        String accessToken;
        try {
            accessToken = GoogleLogin.getToken(code);
            System.out.println("Google Access Token: " + accessToken);
        } catch (IOException e) {
            System.out.println("Error getting Google token: " + e.getMessage());
            response.sendRedirect("login/login.jsp");
            return;
        }

        GoogleAccount googleAccount;
        try {
            googleAccount = GoogleLogin.getUserInfo(accessToken);
            System.out.println("Google OAuth Code: " + code);
            System.out.println("Google User Info: " + googleAccount);
        } catch (IOException e) {
            System.out.println("Error getting Google user info: " + e.getMessage());
            response.sendRedirect("login/login.jsp");
            return;
        }

        if (googleAccount == null) {
            System.out.println("GoogleAccount is null, redirecting to login page.");
            response.sendRedirect("login/login.jsp");
            return;
        }

        Account account = accountDao.getAccountByEmail(googleAccount.getEmail());
        Customer customer = customerDao.getCustomerByEmail(googleAccount.getEmail());

        Connection conn = null;
        try {
            conn = dao.DBconnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu giao dịch
            System.out.println("Database connection established.");

            // Nếu tài khoản chưa tồn tại, thêm mới vào Account
            if (account == null) {
                System.out.println("Account not found, creating new account: " + googleAccount.getEmail());
                account = new Account(googleAccount.getEmail(), null, "Customer"); // Đặt password là null
                boolean accountInserted = accountDao.insertAccount(account, conn);
                if (!accountInserted) {
                    throw new SQLException("Failed to insert account into database.");
                }
            } else {
                System.out.println("Account already exists: " + googleAccount.getEmail());
            }

            // Nếu khách hàng chưa tồn tại, thêm mới vào Customer
            if (customer == null) {
                System.out.println("Customer not found, creating new customer: " + googleAccount.getEmail());
                String newCustomerID = customerDao.generateNewCustomerID(conn);
                System.out.println("Generated new CustomerID: " + newCustomerID);
                customer = new Customer();
                customer.setCustomerID(newCustomerID);
                customer.setCustomerName(googleAccount.getName());
                customer.setEmail(googleAccount.getEmail());
                customer.setPhoneNumber("000000000000"); // Giá trị mặc định
                customer.setBirthday(null);
                customer.setGender("Nam"); // Giá trị mặc định hợp lệ

                boolean customerInserted = customerDao.insertGoogleCustomer(customer, conn);
                if (!customerInserted) {
                    throw new SQLException("Failed to insert customer into database.");
                }
            } else {
                System.out.println("Customer already exists: " + googleAccount.getEmail());
            }

            conn.commit(); // Commit giao dịch
            System.out.println("✔ Google Login successful: " + googleAccount.getEmail() + ", CustomerID: " + customer.getCustomerID());
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu có lỗi
                    System.out.println("❌ Transaction rolled back: " + e.getMessage());
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            response.sendRedirect("login/login.jsp");
            return;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                    System.out.println("Database connection closed.");
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        createSession(request, account.getEmail(), account.getRole());
        System.out.println("Session created for: " + googleAccount.getEmail());
        redirectToDashboard(request.getSession(), response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action != null && action.equals("changePassword")) {
            // Hiển thị trang đổi mật khẩu
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userEmail") == null) {
                response.sendRedirect("login/login.jsp?error=pleaseLogin");
                return;
            }
            request.getRequestDispatcher("login/changePassword.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userEmail") != null) {
            redirectToDashboard(session, response);
            return;
        }
        request.getRequestDispatcher("login/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null && action.equals("changePassword")) {
            changePassword(request, response);
            return;
        }

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email và mật khẩu không được để trống!");
            request.getRequestDispatcher("login/login.jsp").forward(request, response);
            return;
        }

        Account account = accountDao.getAccountByEmail(email);

        if (account == null || !password.equals(account.getPassword())) {
            request.setAttribute("errorMessage", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login/login.jsp").forward(request, response);
            return;
        }

        createSession(request, account.getEmail(), account.getRole());
        redirectToDashboard(request.getSession(), response);
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login/login.jsp?error=pleaseLogin");
            return;
        }

        String email = (String) session.getAttribute("userEmail");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra dữ liệu đầu vào
        if (oldPassword == null || oldPassword.trim().isEmpty()
                || newPassword == null || newPassword.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng điền đầy đủ các trường!");
            request.getRequestDispatcher("login/changePassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
            request.getRequestDispatcher("login/changePassword.jsp").forward(request, response);
            return;
        }

        // Kiểm tra độ dài mật khẩu mới (tùy chọn)
        if (newPassword.length() < 6) {
            request.setAttribute("errorMessage", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("login/changePassword.jsp").forward(request, response);
            return;
        }

        try {
            boolean success = accountDao.changePassword(email, oldPassword, newPassword);
            if (success) {
                request.setAttribute("successMessage", "Đổi mật khẩu thành công! Vui lòng đăng nhập lại.");
                session.invalidate(); // Hủy session để yêu cầu đăng nhập lại
                request.getRequestDispatcher("login/login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Mật khẩu cũ không đúng hoặc tài khoản này không hỗ trợ đổi mật khẩu (đăng nhập bằng Google).");
                request.getRequestDispatcher("login/changePassword.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi đổi mật khẩu: " + e.getMessage());
            request.getRequestDispatcher("login/changePassword.jsp").forward(request, response);
        }
    }

    private void createSession(HttpServletRequest request, String email, String role) {
        HttpSession session = request.getSession();
        session.setAttribute("userEmail", email);
        session.setAttribute("role", role);
        SessionCounterListener.userLoggedIn();
    }

    private void redirectToDashboard(HttpSession session, HttpServletResponse response) throws IOException {
        String role = (String) session.getAttribute("role");

        if (role == null) {
            response.sendRedirect("login/login.jsp");
            return;
        }

        switch (role) {
            case "Customer" ->
                response.sendRedirect("customer/customerProfile.jsp");
            case "Manager" ->
                response.sendRedirect("manager/managerDashboard.jsp");
            case "Employee" ->
                response.sendRedirect("employee/empDashboard.jsp");
            default ->
                response.sendRedirect("login/login.jsp");
        }
    }
}
