<%@page import="employeeDao.EmployeeDao"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Employee"%>
<%@ page import="listener.SessionCounterListener" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("role");

    if (userEmail == null || !"Manager".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login/login.jsp");
        return;
    }

    EmployeeDao employeeDao = new EmployeeDao();
    Employee manager = employeeDao.getEmployeeByEmail(userEmail);
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Manager Profile</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <style>
            /* Giữ nguyên style cũ, chỉ thêm style cho session counter */
            .session-counter {
                position: absolute;
                top: 20px;
                right: 20px;
                background-color: #e0e0e0;
                padding: 10px 15px;
                border-radius: 15px;
                font-size: 14px;
                color: #666;
                line-height: 1.5;
            }
            .btn.red a {
                color: white;
                text-decoration: none;
            }
            /* Rest of your existing styles... */
        </style>
    </head>
    <body>
        <div class="container">
            <div class="session-counter">
                Total Active Sessions: <%= SessionCounterListener.getTotalActiveSessions()%><br>
                Logged-in Users: <%= SessionCounterListener.getLoggedInUsers()%>
            </div>

            <div class="header-section">
                <h4 class="center">Welcome, <%= manager.getEmpName()%> (Manager)</h4>
            </div>

            <div class="table-container">
                <table class="striped">
                    <tr><th>Email</th><td><%= manager.getEmail()%></td></tr>
                    <tr><th>Phone Number</th><td><%= manager.getPhoneNumber()%></td></tr>
                    <tr><th>Salary</th><td><%= manager.getSalary()%></td></tr>
                    <tr><th>Hire Date</th><td><%= manager.getHireDate()%></td></tr>
                    <tr><th>Role</th><td><%= role%></td></tr>
                </table>
            </div>

            <div class="button-group">
                <div class="btn red"><a href="<%= request.getContextPath()%>/employees">Employee List</a></div>
                <div class="btn red"><a href="<%= request.getContextPath()%>/report">Report</a></div>
                <div class="btn red"><a href="<%= request.getContextPath()%>/">Home</a></div>
                <div class="btn red"><a href="<%= request.getContextPath()%>/cart?action=history">Lịch sử đặt vé</a></div>
                <div class="btn red"><a href="<%= request.getContextPath()%>/logout">Logout</a></div>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
    </body>
</html>