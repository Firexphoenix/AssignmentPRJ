<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="jakarta.servlet.http.HttpSession, Model.Invoice, Model.Ticket, java.util.List"%>
<%
    HttpSession userSession = request.getSession(false);
    String userEmail = (userSession != null) ? (String) userSession.getAttribute("userEmail") : null;

    if (userEmail == null) {
        response.sendRedirect("/CinemaTicketBooking/login/login.jsp?error=pleaseLogin");
        return;
    }

    Invoice invoice = (Invoice) userSession.getAttribute("pendingInvoice");
    List<Ticket> cartTickets = (List<Ticket>) userSession.getAttribute("cartTickets");

    if (invoice == null || cartTickets == null) {
        response.sendRedirect("/CinemaTicketBooking/cart?action=view");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>THVB Cinema - Hóa đơn</title>
        <link rel="stylesheet" href="../css/userStyle.css">
        <script defer src="js/userScript.js"></script>
        <style>
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
                font-family: 'Poppins', Arial, sans-serif;
                text-decoration: none;
                display: inline-block;
            }
            .button:hover {
                background: #b8860b;
            }
            .invoice-container {
                max-width: 800px;
                margin: 20px auto;
                padding: 20px;
                background: #2c2c2c;
                border-radius: 10px;
            }
            .invoice-container h1 {
                text-align: center;
            }
            .invoice-details, .ticket-details {
                margin-bottom: 20px;
            }
            .invoice-details p, .ticket-details p {
                margin: 5px 0;
            }
            .ticket-details table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            .ticket-details th, .ticket-details td {
                padding: 10px;
                border: 1px solid #f4e4ba;
                text-align: left;
            }
            .ticket-details th {
                background: #3b2f2f;
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

        <div class="invoice-container">
            <h1>Hóa đơn</h1>
            <div class="invoice-details">
                <p><strong>Mã hóa đơn:</strong> <%= invoice.getInvoiceID()%></p>
                <p><strong>Ngày:</strong> <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(invoice.getDate())%></p>
                <p><strong>Giờ:</strong> <%= invoice.getTime()%></p>
                <p><strong>Tổng tiền:</strong> <%= String.format("%.2f", invoice.getTotal())%> triệu đồng</p>
                <p><strong>Trạng thái:</strong> <%= invoice.getStatus()%></p>
            </div>
            <div class="ticket-details">
                <h2>Chi tiết vé</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Mã vé</th>
                            <th>Suất chiếu</th>
                            <th>Ghế</th>
                            <th>Mã phim</th>
                            <th>Số lượng</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Ticket ticket : cartTickets) {%>
                        <tr>
                            <td><%= ticket.getTicketID()%></td>
                            <td><%= ticket.getShowTimeID()%></td>
                            <td><%= ticket.getSeatNumber()%></td>
                            <td><%= ticket.getMovieID()%></td>
                            <td><%= ticket.getQuantity()%></td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
            </div>
            <div style="text-align: center;">
                <form action="<%= request.getContextPath()%>/confirmInvoice" method="post">
                    <input type="hidden" name="invoiceId" value="<%= invoice.getInvoiceID()%>">
                    <button type="submit" class="button">Xác nhận thanh toán</button>
                </form>
                <a href="<%= request.getContextPath()%>/" class="button">Hủy</a>
            </div>
        </div>
    </body>
</html>