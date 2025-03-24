<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("role");

    if (userEmail == null || role == null || (!"Manager".equalsIgnoreCase(role) && !"Employee".equalsIgnoreCase(role))) {
        response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=adminAccessRequired");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý lịch sử đặt vé - THVB Cinema</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <style>
            body {
                background-color: #f5f5f5;
                font-family: "Roboto", sans-serif;
                color: #333;
            }

            .container {
                margin-top: 20px;
            }

            h1 {
                text-align: center;
                margin: 20px 0;
                color: #d32f2f;
            }

            table {
                width: 100%;
                margin: 20px 0;
            }

            .error {
                text-align: center;
                color: #d32f2f;
                margin: 20px 0;
            }

            .success {
                text-align: center;
                color: #4caf50;
                margin: 20px 0;
            }

            .btn.red a {
                color: white;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Quản lý lịch sử đặt vé</h1>

            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>

            <c:if test="${param.message == 'TicketDeleted'}">
                <p class="success">Xóa vé thành công!</p>
            </c:if>

            <c:if test="${not empty allTicketHistory}">
                <table class="striped">
                    <thead>
                        <tr>
                            <th>Mã vé</th>
                            <th>Suất chiếu</th>
                            <th>Email khách hàng</th>
                            <th>Ghế</th>
                            <th>Thời gian đặt</th>
                            <th>Trạng thái</th>
                            <th>Tên phim</th>
                            <th>Số lượng</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="ticket" items="${allTicketHistory}">
                        <tr>
                            <td>${ticket.ticketID}</td>
                            <td>${ticket.showTimeID}</td>
                            <td>${customerEmails[ticket.customerID]}</td>
                            <td>${ticket.seatNumber}</td>
                            <td><fmt:formatDate value="${ticket.bookingTime}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                        <td>${ticket.status}</td>
                        <td>${movieTitles[ticket.movieID]}</td>
                        <td>${ticket.quantity}</td>
                        <td>
                            <a href="<%= request.getContextPath()%>/cart?action=deleteTicket&ticketId=${ticket.ticketID}" 
                               onclick="return confirm('Bạn có chắc chắn muốn xóa vé này?');" 
                               class="btn-small red">Xóa</a>
                        </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <div class="button-group center">
                <div class="btn red"><a href="<%= request.getContextPath()%>/manager/managerDashboard.jsp">Quay lại</a></div>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
    </body>
</html>