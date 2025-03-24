package Controller;

import Model.Account;
import accountDao.AccountDao;
import customerDao.CustomerDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import listener.SessionCounterListener;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private AccountDao accountDao;

    @Override
    public void init() {
        accountDao = new AccountDao();
        CustomerDao customerDao = new CustomerDao();
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
