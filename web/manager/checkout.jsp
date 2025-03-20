<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="jakarta.servlet.http.HttpSession"%>
<%
    HttpSession userSession = request.getSession(false);
    String userEmail = (userSession != null) ? (String) userSession.getAttribute("userEmail") : null;

    if (userEmail == null) {
        response.sendRedirect("/CinemaTicketBooking/login/login.jsp?error=pleaseLogin");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>THVB Cinema - Thanh toán</title>
        <link rel="stylesheet" href="css/userStyle.css">
        <script defer src="js/userScript.js"></script>
        <style>
            body {
                background-color: #000;
                color: #f4e4ba;
                font-family: "Courier New", Courier, monospace;
                margin: 0;
                padding: 0;
            }
            .navbar {
                background: #3b2f2f;
                padding: 10px 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .navbar .logo {
                color: #ff6200;
                font-size: 24px;
                font-weight: bold;
                text-decoration: none;
            }
            .search-bar input {
                padding: 5px 10px;
                border: none;
                border-radius: 20px;
                outline: none;
                background-color: #fff;
                color: #000;
                width: 200px;
            }
            .auth-buttons {
                display: flex;
                align-items: center;
                gap: 10px;
                list-style: none;
                padding: 0;
                margin: 0;
            }
            .auth-buttons li {
                list-style: none;
            }
            .auth-buttons a {
                background: #ff6200;
                padding: 10px 20px;
                border-radius: 5px;
                text-decoration: none;
                display: inline-block;
                font-size: 14px;
                font-weight: bold;
                color: black;
                transition: all 0.3s ease;
            }
            .auth-buttons a:hover {
                background: #e65c00;
            }
            .nav-menu {
                background: #2c2c2c;
                padding: 10px 0;
                text-align: center;
            }
            .nav-menu ul {
                list-style: none;
                padding: 0;
                margin: 0;
                display: flex;
                justify-content: center;
                gap: 20px;
            }
            .nav-menu a {
                color: #f4e4ba;
                text-decoration: none;
                font-weight: bold;
            }
            .nav-menu a:hover {
                color: #ff6200;
            }
            .button {
                background: #d4af37;
                color: black;
                border: none;
                padding: 10px 15px;
                cursor: pointer;
                transition: background 0.3s ease;
                font-family: "Courier New", Courier, monospace;
                text-decoration: none;
                display: inline-block;
            }
            .button:hover {
                background: #b8860b;
            }
            .message {
                text-align: center;
                margin: 20px;
            }
            .error {
                color: #ff0000;
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
                <li><a href="#">Movies</a></li>
                <li><a href="#">Showtimes</a></li>
                <li><a href="#">Contact</a></li>
                <li><a href="<%= request.getContextPath()%>/cart?action=view">Cart</a></li>
            </ul>
        </div>

        <div class="message">
            <c:choose>
                <c:when test="${paymentSuccess}">
                    <h1>Thanh toán thành công!</h1>
                    <p>Cảm ơn bạn đã đặt vé. Vui lòng kiểm tra email để xem chi tiết.</p>
                </c:when>
                <c:otherwise>
                    <h1 class="error">Thanh toán thất bại</h1>
                    <p class="error">${errorMessage}</p>
                </c:otherwise>
            </c:choose>
            <a href="<%= request.getContextPath()%>/" class="button">Quay lại trang chủ</a>
        </div>
    </body>
</html>