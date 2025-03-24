<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="jakarta.servlet.http.HttpSession"%>

<%
    HttpSession userSession = request.getSession(false);
    String userEmail = (userSession != null) ? (String) userSession.getAttribute("userEmail") : null;
    String userRole = (userSession != null) ? (String) userSession.getAttribute("role") : null;
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>THVB CINEMA - Movie Ticket Booking</title>
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/userStyle.css">
        <script defer src="js/userScript.js"></script>
        <style>
            /* CSS cho chatbot */
            .chatbot-container {
                position: fixed;
                bottom: 20px;
                right: 20px;
                width: 300px;
                height: 400px;
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
                display: none;
                flex-direction: column;
                z-index: 1000;
            }
            .chatbot-header {
                background-color: #007bff !important;
                color: white !important;
                padding: 10px !important;
                border-top-left-radius: 10px !important;
                border-top-right-radius: 10px !important;
                display: flex !important;
                justify-content: space-between !important;
                align-items: center !important;
            }
            .chatbot-body {
                flex: 1;
                padding: 10px;
                overflow-y: auto;
            }
            .chatbot-input {
                display: flex;
                padding: 10px;
                border-top: 1px solid #ddd;
            }
            .chatbot-input input {
                flex: 1;
                padding: 5px;
                border: none;
                outline: none;
            }
            .chatbot-input button {
                padding: 5px 10px;
                background: #007bff;
                color: white;
                border: none;
                cursor: pointer;
            }
            .chatbot-toggle {
                position: fixed;
                bottom: 20px;
                right: 20px;
                width: 50px;
                height: 50px;
                background: #007bff;
                color: white;
                border-radius: 50%;
                text-align: center;
                line-height: 50px;
                cursor: pointer;
                z-index: 1000;
            }
            .message {
                margin: 5px 0;
                padding: 8px;
                border-radius: 5px;
                color:black;
            }
            .user-message {
                background: #007bff;
                color: black;
                text-align: right;
            }
            .bot-message {
                background: #f1f1f1;
                color: black;
            }
            .chatbot-header .close-btn {
                cursor: pointer !important;
                font-size: 20px !important;
            }
        </style>
    </head>
    <script>
        function addToCart(movieId) {
            window.location.href = "cart?action=selectSeats&movieId=" + movieId;
        }
    </script>
    <body>
        <header>
            <div class="navbar">
                <a href="<%= request.getContextPath()%>/" class="logo">THVB Cinema</a>
                <div class="search-bar">
                    <input type="text" id="search-input" placeholder="Search movies...">
                </div>
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
                                        profileLink = request.getContextPath() + "/";
                                        break;
                                }
                        %>
                        <li><a href="<%= profileLink%>"><%= userEmail%></a></li>
                        <li><a href="<%= request.getContextPath()%>/logout">Logout</a></li>
                            <% } else { %>
                        <li><a href="login/login.jsp">Login</a></li>
                        <li><a href="login/register.jsp">Register</a></li>
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
        <main>
            <div class="hero-banner">
                <h1>Welcome to THVB Cinema</h1>
                <p>Book tickets for the latest movies now!</p>
                <a href="#movies" class="btn-primary">Explore Movies</a>
            </div>
            <section id="movies" class="container">
                <h2>Now Showing</h2>
                <div class="movie-grid">
                    <div class="movie-card" data-title="Chị Dâu" data-genre="Drama">
                        <img src="image/posterchidau.jpg" alt="Chi Dau" />
                        <div class="movie-info">
                            <h3>CHỊ DÂU</h3>
                            <p>Duration: 3h | Genre: Drama</p>
                            <button onclick="addToCart('MV001')">Book Now</button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Bộ Tứ Báo Thủ" data-genre="Comedy, Romance">
                        <img src="image/posterbaothu.jpg" alt="Bao Thu" />
                        <div class="movie-info">
                            <h3>BỘ TỨ BÁO THỦ</h3>
                            <p>Duration: 2h 28m | Genre: Comedy, Romance</p>
                            <button onclick="addToCart('MV002')">Book Now</button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Linh Miêu" data-genre="Horror">
                        <img src="image/posterlinhmiu.jpg" alt="Linh Miêu" />
                        <div class="movie-info">
                            <h3>LINH MIÊU</h3>
                            <p>Duration: 2h 56m | Genre: Horror</p>
                            <button onclick="addToCart('MV003')">Book Now</button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Lạc Trôi" data-genre="Adventure, Action">
                        <img src="image/posterlactroi.jpg" alt="Lac Troi" />
                        <div class="movie-info">
                            <h3>LẠC TRÔI</h3>
                            <p>Duration: 2h 15m | Genre: Adventure, Action</p>
                            <button onclick="addToCart('MV004')">Book Now</button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Sát Thủ Vô Cùng Cực" data-genre="Comedy, Action">
                        <img src="image/postersatthu.jpg" alt="Sat Thu" />
                        <div class="movie-info">
                            <h3>SÁT THỦ VÔ CÙNG CỰC</h3>
                            <p>Duration: 2h 15m | Genre: Comedy, Action</p>
                            <button onclick="addToCart('MV005')">Book Now</button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Quỷ Nhập Tràng" data-genre="Thriller, Horror">
                        <img src="image/posterquy.jpg" alt="Quy Nhap Trang" />
                        <div class="movie-info">
                            <h3>QUỶ NHẬP TRÀNG</h3>
                            <p>Duration: 2h 15m | Genre: Thriller, Horror</p>
                            <button onclick="addToCart('MV006')">Book Now</button>
                        </div>
                    </div>
                </div>
            </section>
        </main>
        <footer>
            <p>© 2025 PHIM3CONHEO. All Rights Reserved.</p>
        </footer>

        <!-- Nút bật/tắt chatbot -->
        <div class="chatbot-toggle" onclick="toggleChatbot()">💬</div>

        <!-- Container chatbot -->
        <div class="chatbot-container" id="chatbot">
            <div class="chatbot-header">
                <h3>Hỗ trợ viên AI</h3>
                <span class="close-btn" onclick="toggleChatbot()">×</span>
            </div>
            <div class="chatbot-body" id="chatbot-body"></div>
            <div class="chatbot-input">
                <input type="text" id="user-input" placeholder="Nhập tin nhắn...">
                <button onclick="sendMessage()">Gửi</button>
            </div>
        </div>

        <script>
            function toggleChatbot() {
                const chatbot = document.getElementById('chatbot');
                const toggleButton = document.querySelector('.chatbot-toggle');
                if (chatbot.style.display === 'none' || chatbot.style.display === '') {
                    chatbot.style.display = 'flex';
                    toggleButton.style.display = 'none';
                } else {
                    chatbot.style.display = 'none';
                    toggleButton.style.display = 'block';
                }
            }

            function displayMessage(message, className) {
                const chatbotBody = document.getElementById('chatbot-body');
                const div = document.createElement('div');
                div.className = `message ${className}`;
                div.textContent = message;
                chatbotBody.appendChild(div);
                chatbotBody.scrollTop = chatbotBody.scrollHeight;
            }

            function sendMessage() {
                const input = document.getElementById('user-input');
                const message = input.value.trim();
                if (message) {
                    displayMessage(message, 'user-message');
                    input.value = '';
                    getBotResponse(message);
                }
            }

            async function getBotResponse(message) {
                displayMessage('Đang xử lý...', 'bot-message');
                try {
                    const response = await fetch('<%= request.getContextPath()%>/chatbot', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                        body: 'message=' + encodeURIComponent(message)
                    });
                    const botReply = await response.text();
                    const chatbotBody = document.getElementById('chatbot-body');
                    chatbotBody.lastChild.remove();
                    displayMessage(botReply, 'bot-message');
                } catch (error) {
                    const chatbotBody = document.getElementById('chatbot-body');
                    chatbotBody.lastChild.remove();
                    displayMessage('Có lỗi xảy ra!', 'bot-message');
                    console.error(error);
                }
            }

            document.getElementById('user-input').addEventListener('keypress', function (e) {
                if (e.key === 'Enter')
                    sendMessage();
            });
        </script>
    </body>
</html>