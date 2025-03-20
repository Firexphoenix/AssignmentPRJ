<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="jakarta.servlet.http.HttpSession, showtimeDao.ShowtimeDao, java.util.List, Model.Showtime" %>
<%
    HttpSession userSession = request.getSession(false);
    String userEmail = (userSession != null) ? (String) userSession.getAttribute("userEmail") : null;

    if (userEmail == null) {
        response.sendRedirect("/CinemaTicketBooking/login/login.jsp");
        return;
    }

    String movieId = request.getParameter("movieId");
    if (movieId == null || movieId.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }

    ShowtimeDao showtimeDao = new ShowtimeDao();
    List<Showtime> showtimeList = showtimeDao.getShowtimesByMovieId(movieId);
    pageContext.setAttribute("showtimeList", showtimeList);
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>THVB Cinema - Chọn ghế</title>
        <link rel="stylesheet" href="css/userStyle.css">
        <script defer src="js/userScript.js"></script>
        <style>
            body {
                background-color: #2c2c2c;
                color: #f4e4ba;
                font-family: "Courier New", Courier, monospace;
                margin: 0;
                padding: 0;
            }
            .navbar, .nav-menu {
                background: #3b2f2f;
            }
            .navbar a, .nav-menu a {
                color: #f4e4ba;
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
                background: linear-gradient(45deg, #ffcc00, #ff6600);
                font-family: "Courier New", Courier, monospace;
                padding: 10px 20px;
                border-radius: 8px;
                text-decoration: none;
                display: inline-block;
                font-size: 14px;
                font-weight: bold;
                color: black;
                transition: all 0.3s ease;
            }
            .auth-buttons a:hover {
                transform: scale(1.05);
                box-shadow: 0px 4px 10px rgba(255, 204, 0, 0.6);
            }
            .screen {
                background: repeating-linear-gradient(45deg, #444, #444 10px, #555 10px, #555 20px);
                height: 20px;
                margin: 20px auto;
                width: 50%;
                line-height: 20px;
                font-weight: bold;
            }
            .seat-grid {
                display: grid;
                grid-template-columns: repeat(12, 40px);
                gap: 2px;
                justify-content: center;
                margin: 20px auto;
                width: fit-content;
            }
            .seat {
                width: 40px;
                height: 40px;
                background-color: #666;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                border-radius: 5px;
                font-size: 14px;
            }
            .seat.selected {
                background-color: #ff6200;
            }
            .seat.booked {
                background-color: #999;
                cursor: not-allowed;
            }
            .row-label {
                position: relative;
                top: 10px;
                left: -10px;
                font-weight: bold;
            }
            .note {
                margin: 20px 0;
                font-size: 14px;
                text-align: center;
            }
            .note span {
                display: inline-block;
                width: 20px;
                height: 20px;
                margin-right: 5px;
                vertical-align: middle;
            }
            .note .available {
                background-color: #666;
            }
            .note .selected {
                background-color: #ff6200;
            }
            .note .booked {
                background-color: #999;
            }
            .confirm-btn {
                background: #d4af37;
                color: black;
                border: none;
                padding: 10px 15px;
                cursor: pointer;
                transition: background 0.3s ease;
                font-family: "Courier New", Courier, monospace;
                margin: 20px;
            }
            .confirm-btn:hover {
                background: #b8860b;
            }
        </style>
        <script>
            let selectedSeats = [];
            const maxSeats = 8;

            function toggleSeat(seatElement, seatId) {
                if (seatElement.classList.contains('booked'))
                    return;

                if (seatElement.classList.contains('selected')) {
                    seatElement.classList.remove('selected');
                    selectedSeats = selectedSeats.filter(id => id !== seatId);
                } else if (selectedSeats.length < maxSeats) {
                    seatElement.classList.add('selected');
                    selectedSeats.push(seatId);
                } else {
                    alert("Bạn chỉ có thể chọn tối đa 8 ghế!");
                }

                document.getElementById('selected-count').innerText = selectedSeats.length;
            }

            function confirmSeats() {
                if (selectedSeats.length === 0) {
                    alert("Vui lòng chọn ít nhất 1 ghế!");
                    return;
                }

                const movieId = "${movieId}";
                const showTimeId = document.getElementById('showTime').value;
                if (!showTimeId) {
                    alert("Vui lòng chọn suất chiếu!");
                    return;
                }

                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%=request.getContextPath()%>/cart?action=add';

                const movieIdInput = document.createElement('input');
                movieIdInput.type = 'hidden';
                movieIdInput.name = 'movieId';
                movieIdInput.value = movieId;
                form.appendChild(movieIdInput);

                const showTimeIdInput = document.createElement('input');
                showTimeIdInput.type = 'hidden';
                showTimeIdInput.name = 'showTimeId';
                showTimeIdInput.value = showTimeId;
                form.appendChild(showTimeIdInput);

                selectedSeats.forEach(seat => {
                    const seatInput = document.createElement('input');
                    seatInput.type = 'hidden';
                    seatInput.name = 'seats';
                    seatInput.value = seat;
                    form.appendChild(seatInput);
                });

                document.body.appendChild(form);
                form.submit();
            }

            function updateBookedSeats() {
                const showTimeId = document.getElementById('showTime').value;
                if (showTimeId) {
                    window.location.href = "<%=request.getContextPath()%>/cart?action=selectSeats&movieId=${movieId}&showTimeId=" + showTimeId;
                }
            }

            window.onload = function () {
                const bookedSeats = [
            <c:forEach var="seat" items="${bookedSeats}" varStatus="loop">
                '${seat}'${loop.last ? '' : ','}
            </c:forEach>
                ];

                bookedSeats.forEach(seatId => {
                    const seat = document.getElementById(seatId);
                    if (seat)
                        seat.classList.add('booked');
                });

                document.getElementById('showTime').addEventListener('change', updateBookedSeats);

                // Đặt giá trị mặc định cho dropdown nếu showTimeId tồn tại
                const showTimeId = "${showTimeId}";
                if (showTimeId) {
                    document.getElementById('showTime').value = showTimeId;
                }
            };
        </script>
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

        <h1 style="text-align: center;">Chọn ghế</h1>
        <label>Chọn suất chiếu: </label>
        <select id="showTime">
            <option value="">-- Chọn suất chiếu --</option>
            <c:forEach var="showtime" items="${showtimeList}">
                <option value="${showtime.showTimeID}">
                    <fmt:formatDate value="${showtime.startTime}" pattern="dd/MM/yyyy HH:mm"/> - Phòng ${showtime.roomID}
                </option>
            </c:forEach>
        </select>
        <span style="float: right;">Cỡ thể chọn tối đa 8 người (Max: 8)</span>

        <c:if test="${not empty error}">
            <p style="text-align: center; color: #ff0000;">${error}</p>
        </c:if>
        <c:if test="${empty showtimeList}">
            <p style="text-align: center; color: #ff0000;">Không có suất chiếu cho phim này. Vui lòng chọn phim khác.</p>
        </c:if>

        <div class="note">
            <span class="available"></span> Ghế trống
            <span class="selected"></span> Ghế đang chọn
            <span class="booked"></span> Ghế đã đặt
        </div>

        <div class="screen">Screen</div>

        <div style="display: flex; justify-content: center;">
            <div>
                <c:forEach var="row" items="A,B,C,D,E,F,G,H,I,J,K,L">
                    <div style="display: flex; align-items: center;">
                        <span class="row-label">${row}</span>
                        <div class="seat-grid">
                            <c:forEach var="col" begin="1" end="12">
                                <c:set var="seatId" value="${row}${col}" />
                                <div class="seat" onclick="toggleSeat(this, '${seatId}')" id="${seatId}">
                                    ${col}
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div style="text-align: center; margin: 20px 0;">
            Số ghế đã chọn: <span id="selected-count">0</span>
        </div>

        <div style="text-align: center;">
            <button class="confirm-btn" onclick="confirmSeats()">Xác nhận</button>
        </div>
    </body>
</html>