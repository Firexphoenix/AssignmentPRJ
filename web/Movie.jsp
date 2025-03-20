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
        <title>THVB Cinema - TV Series</title>
        <link rel="stylesheet" href="css/userStyle.css">
        <script defer src="js/userScript.js"></script>
    </head>
    <script>
        function addToCart(seriesId) {
            // Redirect to seat selection page with seriesId
            window.location.href = "cart?action=selectSeats&seriesId=" + seriesId;
        }
    </script>
    <body>
        <header>
            <div class="navbar">
                <a href="<%= request.getContextPath()%>/" class="logo">PHIM3CONHEO</a>
                <div class="search-bar">
                    <input type="text" id="search-input" placeholder="Search series...">
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
                <li><a href="<%= request.getContextPath()%>/manager/shoppingCart.jsp">Cart</a></li>
            </ul>
        </div>
        <main>
            <div class="hero-banner">
                <h1>Explore TV Series</h1>
                <p>Book tickets for the latest series now!</p>
                <a href="#series" class="btn-primary">Explore Series</a>
            </div>
            <section id="series" class="container">
                <h2>Popular TV Series</h2>
                <div class="movie-grid">
                    <div class="movie-card" data-title="Khi Cuộc Đời Cho Bạn Quả Quýt" data-genre="Comedy, Drama">
                        <img src="image/posterquaquyt.jpg" alt="Khi Cuộc Đời Cho Bạn Quả Quýt" />
                        <div class="movie-info">
                            <h3>KHI CUỘC ĐỜI CHO BẠN QUẢ QUÝT</h3>
                            <p>Duration: 2h 15m | Genre: Comedy, Drama</p>
                            <button><a href="https://motphimchillh.com/khi-cuoc-doi-cho-ban-qua-quyt">Watch Me</a></button>
                        </div>
                    </div>

                    <div class="movie-card" data-title="Suỵt, Quốc Vương Đang Ngủ Đông" data-genre="Comedy, Romance">
                        <img src="image/posterquocvuong.jpg" alt="Suỵt, Quốc Vương Đang Ngủ Đông" />
                        <div class="movie-info">
                            <h3>SUỴT, QUỐC VƯƠNG ĐANG NGỦ ĐÔNG</h3>
                            <p>Duration: 2h 15m | Genre: Comedy, Romance</p>
                            <button><a href="https://motchillfc.net/phim/suyt-nha-vua-dang-ngu-dong">Watch Me</a></button>
                        </div>
                    </div>

                    <div class="movie-card" data-title="Điệp Vụ Thanh Xuân" data-genre="Action, Youth">
                        <img src="image/posterdiepvu.jpg" alt="Điệp Vụ Thanh Xuân" />
                        <div class="movie-info">
                            <h3>ĐIỆP VỤ THANH XUÂN</h3>
                            <p>Duration: 2h 15m | Genre: Action, Youth</p>
                            <button><a href="https://motchill.fi/phim-bo/diep-vu-thanh-xuan/">Watch Me</a></button>
                        </div>
                    </div>

                    <div class="movie-card" data-title="Bậc Thầy Đàm Phán" data-genre="Horror, Thriller">
                        <img src="image/posterbacthay.jpg" alt="Bậc Thầy Đàm Phán" />
                        <div class="movie-info">
                            <h3>BẬC THẦY ĐÀM PHÁN</h3>
                            <p>Duration: 2h 15m | Genre: Horror, Thriller</p>
                            <button><a href="https://motchill.fi/seasons/bac-thay-dam-phan/">Watch Me</a></button>
                        </div>
                    </div>

                    <div class="movie-card" data-title="Hỏi Các Vì Sao" data-genre="Horror, Thriller">
                        <img src="image/posterhoi.jpg" alt="Hỏi Các Vì Sao" />
                        <div class="movie-info">
                            <h3>HỎI CÁC VÌ SAO</h3>
                            <p>Duration: 2h 15m | Genre: Horror, Thriller</p>
                            <button><a href="https://motphim.pet/phim/hoi-cac-vi-sao/tap-1">Watch Me</a></button>
                        </div>
                    </div>

                    <div class="movie-card" data-title="Nhà Nghỉ California" data-genre="Comedy, Romance">
                        <img src="image/posternhanghi.jpg" alt="Nhà Nghỉ California" />
                        <div class="movie-info">
                            <h3>NHÀ NGHỈ CALIFORNIA</h3>
                            <p>Duration: 2h 15m | Genre: Comedy, Romance</p>
                            <button><a href="https://motphim.pet/phim/nha-nghi-california">Watch Me</a></button>
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