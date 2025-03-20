<%@page import="customerDao.CustomerDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="jakarta.servlet.http.HttpSession, Model.Ticket, java.sql.SQLException"%> <!-- Thêm import cần thiết -->
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
        <link rel="stylesheet" href="css/userStyle.css">
        <script defer src="js/userScript.js"></script>
        <style>
            /* Reset mặc định */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', Arial, sans-serif;
            }

            body {
                background-color: #1a1a1a;
                color: #f4e4ba;
                line-height: 1.6;
                font-size: 16px;
            }

            /* Navbar */
            .navbar {
                background: #2f2525;
                padding: 15px 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .navbar .logo {
                color: #f4e4ba;
                font-size: 24px;
                font-weight: bold;
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .navbar .logo:hover {
                color: #ffcc00;
            }

            .search-bar input {
                padding: 8px 15px;
                border: none;
                border-radius: 20px;
                background: #3b2f2f;
                color: #f4e4ba;
                font-family: "Courier New", Courier, monospace;
                outline: none;
                transition: all 0.3s ease;
            }

            .search-bar input:focus {
                background: #4a3f35;
                box-shadow: 0 0 5px rgba(255, 204, 0, 0.5);
            }

            /* Auth Buttons */
            .auth-buttons {
                display: flex;
                align-items: center;
                gap: 15px;
                list-style: none;
            }

            .auth-buttons a {
                background: linear-gradient(45deg, #ffcc00, #ff6600);
                padding: 10px 25px;
                border-radius: 25px;
                text-decoration: none;
                font-size: 14px;
                font-weight: bold;
                color: #1a1a1a;
                transition: all 0.3s ease;
            }

            .auth-buttons a:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(255, 204, 0, 0.6);
            }

            /* Nav Menu */
            .nav-menu {
                background: linear-gradient(90deg, #2f2525, #3b2f2f);
                padding: 15px 20px;
                border-bottom: 2px solid #d4af37;
                box-shadow: 0 2px 15px rgba(0, 0, 0, 0.7);
            }

            .nav-menu ul {
                display: flex;
                justify-content: center;
                gap: 40px;
                list-style: none;
            }

            .nav-menu a {
                color: #f4e4ba;
                text-decoration: none;
                font-size: 18px;
                font-weight: bold;
                padding: 10px 15px;
                border-radius: 15px;
                transition: all 0.3s ease;
                position: relative;
            }

            .nav-menu a:hover {
                color: #ffcc00;
                background: rgba(212, 175, 55, 0.2);
                box-shadow: 0 5px 10px rgba(255, 204, 0, 0.4);
            }

            .nav-menu a:hover::after {
                content: "";
                position: absolute;
                width: 80%;
                height: 2px;
                background: #ffcc00;
                left: 10%;
                bottom: 5px;
            }

            /* Table Styles */
            table {
                width: 80%;
                border-collapse: collapse;
                margin: 40px auto;
            }

            th, td {
                border: 1px solid #4a3f35;
                padding: 12px;
                text-align: center;
                color: #f4e4ba;
            }

            th {
                background: #2f2525;
                font-size: 16px;
            }

            .button {
                background: #d4af37;
                color: #1a1a1a;
                border: none;
                padding: 10px 20px;
                border-radius: 20px;
                cursor: pointer;
                font-family: "Courier New", Courier, monospace;
                font-weight: bold;
                transition: all 0.3s ease;
            }

            .button:hover {
                background: #b8860b;
                transform: scale(1.05);
            }

            /* Heading */
            h1 {
                text-align: center;
                margin: 20px 0;
                font-size: 32px;
            }
        </style>
    </head>
    <body>
        <header>
            <div class="navbar">
                <a href="<%= request.getContextPath()%>/" class="logo">THVB Cinema</a>
                <div class="search-bar">
                    <input type="text" id="search-input" placeholder="Search movies...">
                </div>
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
                <li><a href="<%= request.getContextPath()%>/manager/shoppingCart.jsp">Cart</a></li>
            </ul>
        </div>

        <h1 style="text-align: center;">Giỏ hàng vé xem phim</h1>

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
                        // Truy cập ticket từ pageContext
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
                            <a href="cart?action=remove&ticketID=${ticket.ticketID}" class="button">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </c:if>
            <c:if test="${empty sessionScope.cart}">
                <tr>
                    <td colspan="9">Giỏ hàng của bạn hiện đang trống.</td>
                </tr>
            </c:if>
        </table>

        <div style="text-align: center; margin-top: 20px;">
            <a href="cart?action=clear" class="button">Xóa toàn bộ giỏ hàng</a>
            <a href="<%= request.getContextPath()%>/checkout" class="button">Thanh toán</a>
        </div>
    </body>
</html>