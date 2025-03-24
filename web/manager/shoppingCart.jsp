<%@page import="customerDao.CustomerDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="jakarta.servlet.http.HttpSession, Model.Ticket, java.sql.SQLException"%>
<%
    HttpSession userSession = request.getSession(false);
    String userEmail = (userSession != null) ? (String) userSession.getAttribute("userEmail") : null;

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
        <title>THVB Cinema - Giỏ hàng vé xem phim</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/userStyle.css">
        <style>
            .shopping-cart-page {
                background-color: #1a1a1a; /* Giữ màu nền từ userStyle.css */
                font-family: "Courier New", Courier, monospace; /* Ghi đè font-family */
                min-height: 100vh; /* Đảm bảo trang chiếm toàn bộ chiều cao */
                display: flex;
                flex-direction: column;
            }

            /* Container chính */
            .shopping-cart-page .cart-container {
                flex: 1;
                padding: 40px 20px;
                max-width: 1200px;
                margin: 0 auto;
            }

            /* Tiêu đề */
            .shopping-cart-page h1 {
                text-align: center;
                font-size: 36px;
                color: #ff6200;
                margin-bottom: 40px;
                text-transform: uppercase;
                letter-spacing: 2px;
                text-shadow: 0 0 10px rgba(255, 98, 0, 0.5);
            }

            /* Table Styles */
            .shopping-cart-page table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                background: #2f2525;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
            }

            .shopping-cart-page th, .shopping-cart-page td {
                border: none;
                padding: 15px;
                text-align: center;
                color: #f4e4ba;
                font-size: 15px;
            }

            .shopping-cart-page th {
                background: linear-gradient(45deg, #ff6200, #ffcc00);
                color: #1a1a1a;
                font-size: 16px;
                font-weight: bold;
                text-transform: uppercase;
            }

            .shopping-cart-page tr {
                transition: background 0.3s ease;
            }

            .shopping-cart-page tr:nth-child(even) {
                background: #3b2f2f;
            }

            .shopping-cart-page tr:hover {
                background: #4a3f35;
            }

            /* Style cho thông báo giỏ hàng trống */
            .shopping-cart-page .empty-cart {
                font-size: 18px;
                color: #ff6200;
                text-align: center;
                padding: 20px;
                background: #2f2525;
                border-radius: 10px;
                margin: 20px 0;
            }

            /* Style cho nút */
            .shopping-cart-page .button {
                background: linear-gradient(45deg, #ff6200, #ffcc00);
                color: #1a1a1a;
                border: none;
                padding: 10px 20px;
                border-radius: 20px;
                cursor: pointer;
                font-family: "Courier New", Courier, monospace;
                font-weight: bold;
                transition: all 0.3s ease;
                display: inline-block;
                text-decoration: none;
                box-shadow: 0 5px 15px rgba(255, 98, 0, 0.3);
            }

            .shopping-cart-page .button:hover {
                background: linear-gradient(45deg, #e65c00, #b8860b);
                transform: scale(1.05);
                box-shadow: 0 5px 20px rgba(255, 98, 0, 0.5);
            }

            /* Style cho nút "Xóa" trong bảng */
            .shopping-cart-page .button.remove {
                background: linear-gradient(45deg, #dc3545, #ff0000);
                color: #fff;
            }

            .shopping-cart-page .button.remove:hover {
                background: linear-gradient(45deg, #c82333, #cc0000);
            }

            /* Style cho container nút dưới bảng */
            .shopping-cart-page .action-buttons {
                text-align: center;
                margin-top: 30px;
                display: flex;
                justify-content: center;
                gap: 20px;
            }

            /* Style cho thông báo message */
            .shopping-cart-page .message {
                text-align: center;
                font-size: 18px;
                color: #28a745;
                background: #2f2525;
                padding: 15px;
                border-radius: 10px;
                margin: 20px 0;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
            }

            /* Footer đơn giản */
            .shopping-cart-page footer {
                background: #2c2c2c;
                padding: 15px;
                text-align: center;
                color: #f4e4ba;
                font-size: 14px;
            }
        </style>
    </head>
    <body class="shopping-cart-page">
        <header>
            <div class="navbar">
                <a href="<%= request.getContextPath()%>/" class="logo">THVB Cinema</a>
                <nav>
                    <ul class="auth-buttons">
                        <% if (userEmail != null) {%>
                        <li><a href="#"><%= userEmail%></a></li>
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

        <div class="cart-container">
            <h1>Giỏ hàng vé xem phim</h1>

            <c:if test="${not empty param.message}">
                <p class="message">${param.message}</p>
            </c:if>

            <table>
                <tr>
                    <th>Mã vé</th>
                    <th>Tên phim</th>
                    <th>Mã suất chiếu</th>
                    <th>Email khách hàng</th>
                    <th>Số ghế</th>
                    <th>Thời gian đặt</th>
                    <th>Trạng thái</th>
                    <th>Số lượng</th>
                    <th>Hành động</th>
                </tr>
                <c:if test="${not empty sessionScope.cart}">
                    <c:forEach var="ticket" items="${sessionScope.cart}">
                        <%
                            Ticket ticketObj = (Ticket) pageContext.getAttribute("ticket");
                            String customerId = (ticketObj != null) ? ticketObj.getCustomerID() : "";
                            CustomerDao customerDao = new CustomerDao();
                            String email = null;
                            try {
                                email = customerDao.getEmailByCustomerId(customerId);
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                            if (email == null) {
                                email = "Không tìm thấy email";
                            }
                            pageContext.setAttribute("email", email);
                        %>
                        <tr>
                            <td>${ticket.ticketID}</td>
                            <td>
                                <c:forEach var="movie" items="${applicationScope.movieList}">
                                    <c:if test="${movie.movieID == ticket.movieID}">
                                        ${movie.movieTitle}
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td>${ticket.showTimeID}</td>
                            <td>${email}</td>
                            <td>${ticket.seatNumber}</td>
                            <td>
                                <fmt:formatDate value="${ticket.bookingTime}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </td>
                            <td>${ticket.status}</td>
                            <td>${ticket.quantity}</td>
                            <td>
                                <a href="cart?action=remove&ticketID=${ticket.ticketID}" class="button remove">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                <c:if test="${empty sessionScope.cart}">
                    <tr>
                        <td colspan="9" class="empty-cart">Giỏ hàng của bạn hiện đang trống.</td>
                    </tr>
                </c:if>
            </table>

            <div class="action-buttons">
                <c:if test="${not empty sessionScope.cart}">
                    <a href="<%= request.getContextPath()%>/checkout" class="button">Thanh toán qua VNPay</a>
                </c:if>
                <a href="cart?action=clear" class="button">Xóa toàn bộ giỏ hàng</a>
            </div>
        </div>

        <footer>
            <p>© 2025 THVB Cinema. All rights reserved.</p>
        </footer>
    </body>
</html>