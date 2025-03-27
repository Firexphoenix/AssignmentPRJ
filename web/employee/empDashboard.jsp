<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Employee, employeeDao.EmployeeDao" %>
<%@page import="jakarta.servlet.http.HttpSession" %>

<%
    HttpSession userSession = request.getSession(false);
    String userEmail = (userSession != null) ? (String) userSession.getAttribute("userEmail") : null;
    String userRole = (userSession != null) ? (String) userSession.getAttribute("role") : null;

    if (userEmail == null || !"Employee".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/login/login.jsp");
        return;
    }

    // Lấy thông tin Employee từ database
    EmployeeDao employeeDao = new EmployeeDao();
    Employee employee = employeeDao.getEmployeeByEmail(userEmail);

    if (employee == null) {
        response.sendRedirect(request.getContextPath() + "/login/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Employee Dashboard - THVB Cinema</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <style>
            body {
                background-color: #f5f5f5;
                font-family: "Roboto", sans-serif;
                color: #333;
            }

            .container {
                margin-top: 50px;
                max-width: 600px;
            }

            h4 {
                color: #d32f2f;
            }

            table {
                margin: 20px 0;
            }

            .btn.red {
                background-color: #d32f2f;
                margin: 10px;
            }

            .btn.red:hover {
                background-color: #b71c1c;
            }

            .btn.red a {
                color: white;
                text-decoration: none;
            }

            .list {
                margin: 20px 0;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="btn red"><a href="<%= request.getContextPath()%>/">Home</a></div>
            <h4 class="center">Welcome, <%= employee.getEmpName()%> (Employee)</h4>
            <table class="striped">
                <tr><th>Email:</th><td><%= employee.getEmail()%></td></tr>
                <tr><th>Phone Number:</th><td><%= employee.getPhoneNumber()%></td></tr>
                <tr><th>Salary:</th><td><%= employee.getSalary()%></td></tr>
                <tr><th>Hire Date:</th><td><%= employee.getHireDate()%></td></tr>
                <tr><th>Role:</th><td><%= userRole%></td></tr>
            </table>
            <div class="list">
                <a href="<%= request.getContextPath()%>/movies" class="btn red">Movies List</a>
            </div>
            <div class="center">
                <a href="<%= request.getContextPath()%>/login?action=changePassword" class="btn red">Change Password</a>
                <a href="<%= request.getContextPath()%>/logout" class="btn red">Logout</a>
            </div>
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
    </body>
</html>