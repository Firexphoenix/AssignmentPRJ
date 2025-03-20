package Controller;

import Model.Employee;
import employeeDao.EmployeeDao;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;

@WebServlet(name = "employeeServlet", urlPatterns = {"/employees"})
public class EmployeeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private EmployeeDao employeeDAO;

    public void init() {
        employeeDAO = new EmployeeDao();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        try {
            switch (action) {
                case "create":
                    insertEmployee(request, response);
                    break;
                case "edit":
                    updateEmployee(request, response);
                    break;
                case "delete":
                    deleteEmployee(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
                    deleteEmployee(request, response);
                    break;
                default:
                    listEmployee(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void insertEmployee(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String empID = request.getParameter("id");
        String empName = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String salaryStr = request.getParameter("salary");
        String birthdayStr = request.getParameter("birthday");
        String hireDateStr = request.getParameter("hireDate");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String cinemaID = request.getParameter("cinemaID");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Kiểm tra email có hợp lệ không
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email không hợp lệ.");
            request.getRequestDispatcher("employee/createEmployee.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu, nếu rỗng thì đặt mặc định
        if (password == null || password.isEmpty()) {
            password = "123456"; // Mật khẩu mặc định
        }

        // Chuyển đổi lương
        double salary = 0;
        try {
            salary = Double.parseDouble(salaryStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Lương không hợp lệ.");
            request.getRequestDispatcher("employee/createEmployee.jsp").forward(request, response);
            return;
        }

        // Chuyển đổi ngày sinh và ngày nhận việc
        Date birthday = null, hireDate = null;
        try {
            if (birthdayStr != null && !birthdayStr.isEmpty()) {
                birthday = Date.valueOf(birthdayStr);
            }
            if (hireDateStr != null && !hireDateStr.isEmpty()) {
                hireDate = Date.valueOf(hireDateStr);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", "Ngày sinh hoặc ngày nhận việc không hợp lệ.");
            request.getRequestDispatcher("employee/createEmployee.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng Employee
        Employee newEmployee = new Employee(empID, empName, salary, phoneNumber, email, gender, birthday, hireDate, address, cinemaID);

        // Gọi DAO để thêm nhân viên vào DB
        try {
            employeeDAO.insertEmployee(newEmployee, password, role);
            response.sendRedirect("employees");
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Lỗi khi thêm nhân viên: " + ex.getMessage());
            request.getRequestDispatcher("employee/createEmployee.jsp").forward(request, response);
            return;
        }
    }

    private void updateEmployee(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String empID = request.getParameter("id");
        String empName = request.getParameter("name");
        String salaryStr = request.getParameter("salary");
        String phoneNumber = request.getParameter("phoneNumber");
        String email = request.getParameter("email");
        String gender = request.getParameter("gender");
        String birthdayStr = request.getParameter("birthday");
        String hireDateStr = request.getParameter("hireDate");
        String address = request.getParameter("address");
        String cinemaID = request.getParameter("cinemaID");

        // Khởi tạo các biến cần thiết
        double salary;
        Date birthday = null;
        Date hireDate = null;

        // Validate dữ liệu
        try {
            // Kiểm tra empName
            if (empName == null || empName.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên không được để trống.");
            }

            // Chuyển đổi salary
            salary = Double.parseDouble(salaryStr);
            if (salary < 0) {
                throw new IllegalArgumentException("Lương không thể âm.");
            }

            // Kiểm tra phoneNumber
            if (phoneNumber == null || !phoneNumber.matches("\\d{10,12}")) {
                throw new IllegalArgumentException("Số điện thoại phải có 10-12 chữ số.");
            }

            // Kiểm tra email
            if (email == null || email.trim().isEmpty() || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                throw new IllegalArgumentException("Email không hợp lệ.");
            }

            // Chuyển đổi ngày sinh
            if (birthdayStr != null && !birthdayStr.isEmpty()) {
                birthday = Date.valueOf(birthdayStr);
            } else {
                throw new IllegalArgumentException("Ngày sinh không được để trống.");
            }

            // Chuyển đổi ngày nhận việc
            if (hireDateStr != null && !hireDateStr.isEmpty()) {
                hireDate = Date.valueOf(hireDateStr);
            } else {
                throw new IllegalArgumentException("Ngày nhận việc không được để trống.");
            }

            // Kiểm tra gender
            if (gender == null || (!gender.equals("Nam") && !gender.equals("Nữ"))) {
                throw new IllegalArgumentException("Giới tính không hợp lệ.");
            }

            // Kiểm tra address và cinemaID
            if (address == null || address.trim().isEmpty()) {
                throw new IllegalArgumentException("Địa chỉ không được để trống.");
            }
            if (cinemaID == null || cinemaID.trim().isEmpty()) {
                throw new IllegalArgumentException("Cinema ID không được để trống.");
            }

        } catch (IllegalArgumentException e) {
            // Nếu có lỗi, trả về trang edit với thông báo
            Employee existingEmployee = employeeDAO.selectEmployee(empID);
            request.setAttribute("employee", existingEmployee);
            request.setAttribute("errorMessage", e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("employee/updateEmployee.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Tạo đối tượng Employee với dữ liệu đã validate
        Employee updatedEmployee = new Employee(empID, empName, salary, phoneNumber, email, gender, birthday, hireDate, address, cinemaID);

        // Gọi DAO để cập nhật nhân viên
        try {
            employeeDAO.updateEmployee(updatedEmployee);
            request.setAttribute("successMessage", "Cập nhật nhân viên thành công!");
            response.sendRedirect("employees");
        } catch (SQLException ex) {
            // Nếu có lỗi SQL, trả về trang edit với thông báo lỗi
            Employee existingEmployee = employeeDAO.selectEmployee(empID);
            request.setAttribute("employee", existingEmployee);
            request.setAttribute("errorMessage", "Lỗi khi cập nhật nhân viên: " + ex.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("employee/updateEmployee.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void deleteEmployee(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String empID = request.getParameter("id");
        Employee employee = employeeDAO.getEmployeeById(empID);
        if (employee != null) {
            employeeDAO.deleteEmployee(empID);
        }
        response.sendRedirect("employees");
    }

    private void listEmployee(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        List<Employee> listEmployee = employeeDAO.selectAllEmployees();
        request.setAttribute("listEmployee", listEmployee);
        RequestDispatcher dispatcher = request.getRequestDispatcher("employee/employeeList.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("employee/createEmployee.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String empID = request.getParameter("id");
        Employee existingEmployee = employeeDAO.selectEmployee(empID);
        request.setAttribute("employee", existingEmployee);
        RequestDispatcher dispatcher = request.getRequestDispatcher("employee/updateEmployee.jsp");
        dispatcher.forward(request, response);
    }
}
