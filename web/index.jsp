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
        <link rel="stylesheet" href="css/userStyle.css">
        <script defer src="js/userScript.js"></script>
    </head>
    <script>
        function addToCart(movieId) {
            // Redirect to seat selection page with movieId
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
                                        profileLink = request.getContextPath() + "/"; // Trang mặc định nếu role không xác định
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
                <li><a href="<%= request.getContextPath()%>/manager/shoppingCart.jsp">Cart</a></li>
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

                    <div class="movie-card" data-title="Linh Miu" data-genre="Horror">
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
    </body>
</html>