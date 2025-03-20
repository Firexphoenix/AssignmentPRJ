package Controller;

import Model.Customer;
import customerDao.CustomerDao;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;

@WebServlet(name = "customerServlet", urlPatterns = {"/customers"})
public class CustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private CustomerDao customerDAO;

    @Override
    public void init() {
        customerDAO = new CustomerDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;
        String userRole = (session != null) ? (String) session.getAttribute("role") : null;

        if (userEmail == null || !"Customer".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        try {
            switch (action) {
                case "create":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteCustomer(request, response);
                    break;
                default:
                    listCustomers(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;
        String userRole = (session != null) ? (String) session.getAttribute("role") : null;

        if (userEmail == null || !"Customer".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        try {
            switch (action) {
                case "create":
                    insertCustomer(request, response);
                    break;
                case "edit":
                    updateCustomer(request, response);
                    break;
                case "delete":
                    deleteCustomer(request, response);
                    break;
                default:
                    listCustomers(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void insertCustomer(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String customerID = request.getParameter("id");
        String customerName = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String birthdayStr = request.getParameter("birthday");
        String gender = request.getParameter("gender");
        String password = request.getParameter("password");

        if (password == null || password.isEmpty()) {
            password = "123456";
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email không hợp lệ.");
            request.getRequestDispatcher("customer/createCustomer.jsp").forward(request, response);
            return;
        }

        Date birthday = null;
        if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
            try {
                birthday = Date.valueOf(birthdayStr);
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", "Ngày sinh không hợp lệ.");
                request.getRequestDispatcher("customer/createCustomer.jsp").forward(request, response);
                return;
            }
        }

        Customer newCustomer = new Customer(customerID, customerName, email, phoneNumber, birthday, gender);

        try {
            customerDAO.insertCustomer(newCustomer, password);
            response.sendRedirect("customers");
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Lỗi khi thêm khách hàng: " + ex.getMessage());
            request.getRequestDispatcher("customer/createCustomer.jsp").forward(request, response);
        }
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;
        String userRole = (session != null) ? (String) session.getAttribute("role") : null;

        if (userEmail == null || !"Customer".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login/login.jsp");
            return;
        }

        String customerID = request.getParameter("id");
        Customer existingCustomer = customerDAO.getCustomerById(customerID);
        if (existingCustomer == null) {
            request.setAttribute("errorMessage", "Không tìm thấy khách hàng.");
            response.sendRedirect(request.getContextPath() + "/customer/customerProfile.jsp");
            return;
        }

        if (!existingCustomer.getEmail().equals(userEmail)) {
            request.setAttribute("errorMessage", "Bạn không có quyền chỉnh sửa thông tin của người dùng khác.");
            response.sendRedirect(request.getContextPath() + "/customer/customerProfile.jsp");
            return;
        }

        String customerName = request.getParameter("name");
        String phoneNumber = request.getParameter("phoneNumber");
        String birthdayStr = request.getParameter("birthday");
        String gender = request.getParameter("gender");
        String email = existingCustomer.getEmail();

        Date birthday = null;
        if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
            try {
                birthday = Date.valueOf(birthdayStr);
            } catch (IllegalArgumentException e) {
                request.setAttribute("errorMessage", "Ngày sinh không hợp lệ.");
                showEditForm(request, response);
                return;
            }
        }

        Customer updatedCustomer = new Customer(customerID, customerName, email, phoneNumber, birthday, gender);

        try {
            customerDAO.updateCustomer(updatedCustomer);
            session.setAttribute("successMessage", "Cập nhật hồ sơ thành công!");
            response.sendRedirect(request.getContextPath() + "/customer/customerProfile.jsp");
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Lỗi khi cập nhật khách hàng: " + ex.getMessage());
            showEditForm(request, response);
        }
    }

    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String customerID = request.getParameter("id");
        Customer customer = customerDAO.getCustomerById(customerID);
        if (customer != null) {
            customerDAO.deleteCustomer(customerID);
        }
        response.sendRedirect("customers");
    }

    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<Customer> listCustomer = customerDAO.getAllCustomers();
        request.setAttribute("listCustomer", listCustomer);
        RequestDispatcher dispatcher = request.getRequestDispatcher("customer/customerList.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("customer/createCustomer.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;
        String userRole = (session != null) ? (String) session.getAttribute("role") : null;

        if (userEmail == null || !"Customer".equalsIgnoreCase(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login/login.jsp");
            return;
        }

        String customerID = request.getParameter("id");
        if (customerID == null || customerID.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Không tìm thấy mã khách hàng.");
            response.sendRedirect(request.getContextPath() + "/customer/customerProfile.jsp");
            return;
        }

        Customer existingCustomer = customerDAO.getCustomerById(customerID);
        if (existingCustomer == null) {
            request.setAttribute("errorMessage", "Không tìm thấy khách hàng.");
            response.sendRedirect(request.getContextPath() + "/customer/customerProfile.jsp");
            return;
        }

        if (!existingCustomer.getEmail().equals(userEmail)) {
            request.setAttribute("errorMessage", "Bạn không có quyền chỉnh sửa thông tin của người dùng khác.");
            response.sendRedirect(request.getContextPath() + "/customer/customerProfile.jsp");
            return;
        }

        request.setAttribute("customer", existingCustomer);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/customer/updateCustomer.jsp");
        dispatcher.forward(request, response);
    }
}
