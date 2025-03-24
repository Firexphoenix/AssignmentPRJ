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
        <title>THVB Cinema - Kết quả thanh toán</title>
        <link rel="stylesheet" href="css/userStyle.css">
        <!-- Thêm Font Awesome để sử dụng icon -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            .payment-result-page {
                background-color: #000; /* Ghi đè background-color từ userStyle.css */
                font-family: "Courier New", Courier, monospace; /* Ghi đè font-family từ userStyle.css */
                min-height: 100vh; /* Đảm bảo trang chiếm toàn bộ chiều cao màn hình */
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .payment-result-page .navbar {
                background: #3b2f2f; /* Ghi đè nếu cần */
                padding: 10px 20px; /* Ghi đè padding */
            }

            .payment-result-page .navbar .logo {
                color: #ff6200; /* Ghi đè màu logo */
            }

            .payment-result-page .nav-menu {
                background: #2c2c2c; /* Ghi đè background */
                padding: 10px 0; /* Ghi đè padding */
            }

            .payment-result-page .nav-menu ul {
                gap: 20px; /* Ghi đè gap */
            }

            .payment-result-page .nav-menu a:hover {
                color: #ff6200; /* Ghi đè màu hover */
            }

            .payment-result-page .auth-buttons {
                gap: 10px; /* Ghi đè gap */
            }

            .payment-result-page .auth-buttons a {
                background: #ff6200;
                padding: 10px 20px;
                border-radius: 5px;
                color: black;
            }

            .payment-result-page .auth-buttons a:hover {
                background: #e65c00;
                transform: none; /* Bỏ hiệu ứng transform từ userStyle.css */
                box-shadow: none; /* Bỏ hiệu ứng box-shadow từ userStyle.css */
            }

            /* Container chính để căn giữa nội dung */
            .payment-result-page .result-container {
                flex: 1;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                text-align: center;
                padding: 40px 20px;
                background: radial-gradient(circle, rgba(255, 98, 0, 0.1) 0%, rgba(0, 0, 0, 0.8) 100%); /* Gradient nền nhẹ */
            }

            /* Style cho thông báo */
            .payment-result-page .message {
                background: #1a1a1a;
                padding: 40px;
                border-radius: 15px;
                max-width: 600px;
                width: 100%;
                position: relative;
                overflow: hidden;
                animation: slideIn 0.7s ease-in-out;
                transition: all 0.3s ease;
            }

            /* Hiệu ứng slide-in */
            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateY(50px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Viền gradient cho thông báo */
            .payment-result-page .message::before {
                content: '';
                position: absolute;
                top: -2px;
                left: -2px;
                right: -2px;
                bottom: -2px;
                background: linear-gradient(45deg, #ff6200, #28a745, #dc3545, #ff6200);
                z-index: -1;
                border-radius: 17px;
                animation: gradientBorder 5s infinite linear;
            }

            /* Hiệu ứng gradient cho viền */
            @keyframes gradientBorder {
                0% {
                    background-position: 0% 50%;
                }
                100% {
                    background-position: 400% 50%;
                }
            }

            /* Hiệu ứng glow khi hover */
            .payment-result-page .message:hover {
                box-shadow: 0 0 20px rgba(255, 98, 0, 0.5);
            }

            /* Style cho icon */
            .payment-result-page .message .icon {
                font-size: 70px; /* Tăng kích thước icon */
                margin-bottom: 25px;
                animation: bounce 0.5s ease;
            }

            /* Hiệu ứng bounce cho icon */
            @keyframes bounce {
                0%, 20%, 50%, 80%, 100% {
                    transform: translateY(0);
                }
                40% {
                    transform: translateY(-20px);
                }
                60% {
                    transform: translateY(-10px);
                }
            }

            .payment-result-page .message .success .icon {
                color: #28a745; /* Màu xanh lá cho thành công */
            }

            .payment-result-page .message .error .icon {
                color: #dc3545; /* Màu đỏ cho lỗi */
            }

            /* Style cho tiêu đề */
            .payment-result-page .message h1 {
                font-size: 32px; /* Tăng kích thước tiêu đề */
                margin-bottom: 20px;
                text-transform: uppercase; /* Chữ in hoa */
                letter-spacing: 2px; /* Tăng khoảng cách giữa các chữ */
            }

            .payment-result-page .message .success h1 {
                color: #28a745;
                text-shadow: 0 0 10px rgba(40, 167, 69, 0.5); /* Hiệu ứng ánh sáng */
            }

            .payment-result-page .message .error h1 {
                color: #dc3545;
                text-shadow: 0 0 10px rgba(220, 53, 69, 0.5); /* Hiệu ứng ánh sáng */
            }

            /* Style cho đoạn văn */
            .payment-result-page .message p {
                font-size: 18px; /* Tăng kích thước chữ */
                margin-bottom: 30px;
                color: #f4e4ba;
                line-height: 1.5; /* Tăng khoảng cách dòng */
            }

            .payment-result-page .message .error p {
                color: #ff0000;
            }

            /* Style cho nút quay lại */
            .payment-result-page .button {
                background: #ff6200;
                color: #fff;
                border: none;
                padding: 12px 30px;
                border-radius: 25px;
                cursor: pointer;
                transition: all 0.3s ease;
                font-family: "Courier New", Courier, monospace;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                font-weight: bold;
                box-shadow: 0 5px 15px rgba(255, 98, 0, 0.3);
            }

            .payment-result-page .button:hover {
                background: #e65c00;
                transform: scale(1.05);
                box-shadow: 0 5px 20px rgba(255, 98, 0, 0.5);
            }

            /* Footer đơn giản */
            .payment-result-page footer {
                background: #2c2c2c;
                padding: 15px;
                text-align: center;
                color: #f4e4ba;
                font-size: 14px;
            }
        </style>
    </head>
    <body class="payment-result-page">
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
                <li><a href="<%= request.getContextPath()%>/cart?action=view">Cart</a></li>
            </ul>
        </div>

        <div class="result-container">
            <div class="message">
                <c:choose>
                    <c:when test="${paymentSuccess}">
                        <div class="success">
                            <i class="fas fa-check-circle icon"></i>
                            <h1>Thanh toán thành công!</h1>
                            <p>Cảm ơn bạn đã đặt vé. Vui lòng kiểm tra email để xem chi tiết.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="error">
                            <i class="fas fa-times-circle icon"></i>
                            <h1>Thanh toán thất bại</h1>
                            <p>${errorMessage}</p>
                        </div>
                    </c:otherwise>
                </c:choose>
                <a href="<%= request.getContextPath()%>/" class="button">Quay lại trang chủ</a>
            </div>
        </div>

        <footer>
            <p>© 2025 THVB Cinema. All rights reserved.</p>
        </footer>
    </body>
</html>