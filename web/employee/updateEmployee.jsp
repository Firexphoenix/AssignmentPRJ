<%@page import="Model.Employee, java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Employee employee = (Employee) request.getAttribute("employee");
    if (employee == null) {
        response.sendRedirect("employees"); // Quay lại danh sách nếu không có employee
        return;
    }

    // Định dạng ngày cho input date
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String birthdayFormatted = (employee.getBirthday() != null) ? sdf.format(employee.getBirthday()) : "";
    String hireDateFormatted = (employee.getHireDate() != null) ? sdf.format(employee.getHireDate()) : "";
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Employee</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <style>
            body {
                background-color: #f8f9fa; /* Màu nền nhẹ */
                font-family: 'Poppins', Arial, sans-serif;
            }
            .container {
                max-width: 600px; /* Giới hạn chiều rộng */
                margin: 50px auto;
            }
            .card {
                border: none;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            .card-header {
                background-color: #ff5722; /* Màu cam */
                color: #fff;
                text-align: center;
                border-radius: 15px 15px 0 0;
                padding: 20px;
            }
            .card-body {
                padding: 30px;
            }
            .btn-primary {
                background-color: #ff5722;
                border-color: #ff5722;
            }
            .btn-primary:hover {
                background-color: #e64a19;
                border-color: #e64a19;
            }
            .btn-secondary {
                background-color: #6c757d;
                border-color: #6c757d;
            }
            .btn-secondary:hover {
                background-color: #5a6268;
                border-color: #5a6268;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="card">
                <div class="card-header">
                    <h2>Edit Employee</h2>
                </div>
                <div class="card-body">
                    <form action="employees?action=edit" method="post">
                        <input type="hidden" name="id" value="<%= employee.getEmpID()%>">

                        <div class="mb-3">
                            <label for="name" class="form-label">Name:</label>
                            <input type="text" class="form-control" name="name" id="name" value="<%= employee.getEmpName()%>" required />
                        </div>

                        <div class="mb-3">
                            <label for="salary" class="form-label">Salary:</label>
                            <input type="number" step="0.01" class="form-control" name="salary" id="salary" value="<%= employee.getSalary()%>" required />
                        </div>

                        <div class="mb-3">
                            <label for="phoneNumber" class="form-label">Phone Number:</label>
                            <input type="text" class="form-control" name="phoneNumber" id="phoneNumber" value="<%= employee.getPhoneNumber()%>" pattern="\d{10,12}" title="Enter a valid phone number (10-12 digits)" required />
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label">Email:</label>
                            <input type="email" class="form-control" name="email" id="email" value="<%= employee.getEmail()%>" required />
                        </div>

                        <div class="mb-3">
                            <label for="gender" class="form-label">Gender:</label>
                            <select class="form-select" name="gender" id="gender" required>
                                <option value="Nam" <%= "Nam".equals(employee.getGender()) ? "selected" : ""%>>Nam</option>
                                <option value="Nữ" <%= "Nữ".equals(employee.getGender()) ? "selected" : ""%>>Nữ</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="birthday" class="form-label">Birthday:</label>
                            <input type="date" class="form-control" name="birthday" id="birthday" value="<%= birthdayFormatted%>" required />
                        </div>

                        <div class="mb-3">
                            <label for="hireDate" class="form-label">Hire Date:</label>
                            <input type="date" class="form-control" name="hireDate" id="hireDate" value="<%= hireDateFormatted%>" required />
                        </div>

                        <div class="mb-3">
                            <label for="address" class="form-label">Address:</label>
                            <input type="text" class="form-control" name="address" id="address" value="<%= employee.getAddress() != null ? employee.getAddress() : ""%>" required />
                        </div>

                        <div class="mb-3">
                            <label for="cinemaID" class="form-label">Cinema ID:</label>
                            <input type="text" class="form-control" name="cinemaID" id="cinemaID" value="<%= employee.getCinemaID() != null ? employee.getCinemaID() : ""%>" required />
                        </div>

                        <div class="d-flex justify-content-center gap-3">
                            <button type="submit" class="btn btn-primary">Update</button>
                            <a href="employees" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    </body>
</html>