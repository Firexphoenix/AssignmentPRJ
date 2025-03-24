<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession userSession = request.getSession(false);
    String userEmail = (userSession != null) ? (String) userSession.getAttribute("userEmail") : null;
    String userRole = (userSession != null) ? (String) userSession.getAttribute("role") : null;

    if (userEmail == null) {
        response.sendRedirect("/CinemaTicketBooking/login/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>THVB Cinema - Lịch sử đặt vé</title>
        <link rel="stylesheet" href="css/userStyle.css">
        <style>
            table {
                width: 100%;
                border-collapse: collapse;
                background-color: #3b2f2f;
            }
            th, td {
                padding: 10px;
                text-align: left;
                border-bottom: 1px solid #f4e4ba;
            }
            th {
                background-color: #555;
            }
            tr:hover {
                background-color: #4a3c3c;
            }
        </style>
    </head>
    <body>
        <header>
            <div class="navbar">
                <a href="<%= request.getContextPath()%>/" class="logo">THVB Cinema</a>
                <nav>
                    <ul class="auth-buttons">
                        <% if (userEmail != null && userRole != null) {
                                String profileLink;
                                switch (userRole.toLowerCase()) {
                                    case "customer":
                                        profileLink = request.getContextPath() + "/customer/customerProfile.jsp";
                                        break;
                                    case "manager":
                                        profileLink = request.getContextPath() + "/manager/managerDashboard.jsp";
                                        break;
                                    case "employee":
                                        profileLink = request.getContextPath() + "/employee/empDashboard.jsp";
                                        break;
                                    default:
                                        profileLink = request.getContextPath() + "/"; // Trang mặc định nếu role không xác định
                                        break;
                                }
                        %>
                        <li><a href="<%= profileLink%>"><%= userEmail%></a></li>
                        <li><a href="<%= request.getContextPath()%>/logout">Logout</a></li>
                            <% } else { %>
                        <li><a href="login/login.jsp">Login</a></li>
                        <li><a href="customers?action=create">Register</a></li>
                            <% }%>
                    </ul>
                </nav>
            </div>
        </header>
        <div class="nav-menu">
            <ul>
                <li><a href="<%= request.getContextPath()%>/">Home</a></li>
                <li><a href="<%= request.getContextPath()%>/Movie.jsp">Movie</a></li>
                <li><a href="<%= request.getContextPath()%>/TV_Series.jsp">TV Series</a></li>
                <li><a href="<%= request.getContextPath()%>/cart">Cart</a></li>
                <li><a href="<%= request.getContextPath()%>/cart?action=history">Booking History</a></li>
            </ul>
        </div>

        <div class="container">
            <h1 style="text-align: center;">Lịch sử đặt vé</h1>

            <c:if test="${not empty error}">
                <p style="text-align: center; color: #ff0000;">${error}</p>
            </c:if>

            <c:choose>
                <c:when test="${empty ticketHistory}">
                    <p style="text-align: center;">Bạn chưa có lịch sử đặt vé nào.</p>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>Mã vé</th>
                                <th>Mã suất chiếu</th>
                                <th>Tên phim</th>
                                <th>Ghế</th>
                                <th>Thời gian đặt</th>
                                <th>Trạng thái</th>
                                <th>Số lượng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ticket" items="${ticketHistory}">
                                <tr>
                                    <td>${ticket.ticketID}</td>
                                    <td>${ticket.showTimeID}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty ticket.movieID}">
                                                <c:choose>
                                                    <c:when test="${not empty movieTitles[ticket.movieID]}">
                                                        ${movieTitles[ticket.movieID]}
                                                    </c:when>
                                                    <c:otherwise>
                                                        [Không tìm thấy tên phim cho MovieID: ${ticket.movieID}]
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                [MovieID không tồn tại]
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${ticket.seatNumber}</td>
                                    <td><fmt:formatDate value="${ticket.bookingTime}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                    <td>${ticket.status}</td>
                                    <td>${ticket.quantity}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
</html>