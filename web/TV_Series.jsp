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
                    <div class="movie-card" data-title="Nghề Siêu Khó Nói" data-genre="Comedy, Romance">
                        <img src="image/posternghe.jpg" alt="Nghề Siêu Khó Nói" />
                        <div class="movie-info">
                            <h3>NGHỀ SIÊU KHÓ NÓI</h3>
                            <p>Duration: 2h 15m | Genre: Comedy, Romance</p>
                            <button><a href="https://motchillk.org/nghe-sieu-kho-noi">Watch Me</a></button>
                        </div>
                    </div>

                    <div class="movie-card" data-title="Nhà Gia Tiên" data-genre="Horror, Thriller">
                        <img src="image/postergiatien.jpg" alt="Nhà Gia Tiên" />
                        <div class="movie-info">
                            <h3>NHÀ GIA TIÊN</h3>
                            <p>Duration: 2h 15m | Genre: Horror, Thriller</p>
                            <button><a href="https://flix.sensacinema.site/vi/movie/1396079">Watch Me</a></button>
                        </div>
                    </div>

                    <div class="movie-card" data-title="Tiếng Vọng Kinh Hoàng" data-genre="Horror, Thriller">
                        <img src="image/postertiengvong.jpg" alt="Tiếng Vọng Kinh Hoàng" />
                        <div class="movie-info">
                            <h3>TIẾNG VỌNG KINH HOÀNG</h3>
                            <p>Duration: 2h 15m | Genre: Horror, Thriller</p>
                            <button><a href="https://www.youtube.com/watch?v=tUCU2qidmOI">Watch Me</a></button>
                        </div>
                    </div>

                    <div class="movie-card" data-title="Emma và Vương Quốc Tí Hon" data-genre="Fantasy, Adventure">
                        <img src="image/posteremma.jpg" alt="Emma và Vương Quốc Tí Hon" />
                        <div class="movie-info">
                            <h3>EMMA VÀ VƯƠNG QUỐC TÍ HON</h3>
                            <p>Duration: 2h 15m | Genre: Fantasy, Adventure</p>
                            <button><a href="https://www.youtube.com/watch?v=kraUpgr_IE4">Watch Me</a></button>
                        </div>
                    </div>

                    <div class="movie-card" data-title="Âm Dương Lộ" data-genre="Horror, Mystery">
                        <img src="image/posteramduong.jpg" alt="Âm Dương Lộ" />
                        <div class="movie-info">
                            <h3>ÂM DƯƠNG LỘ</h3>
                            <p>Duration: 2h 15m | Genre: Horror, Mystery</p>
                            <button><a href="https://www.youtube.com/watch?v=V_EK5jZQjtc">Watch Me</a></button>
                        </div>
                    </div>

                    <div class="movie-card" data-title="Doraemon: Nobita's Art World Tales" data-genre="Animation, Adventure">
                        <img src="image/posterdoraemon.jpg" alt="Doraemon: Nobita's Art World Tales" />
                        <div class="movie-info">
                            <h3>DORAEMON: NOBITA'S ART WORLD TALES</h3>
                            <p>Duration: 2h 15m | Genre: Animation, Adventure</p>
                            <button><a href="https://www.youtube.com/watch?v=1b2sSI51Edw">Watch Me</a></button>
                        </div>
                    </div>

                    <div class="movie-card" data-title="Trêu Nhầm Sắc Son 2025" data-genre="Comedy, Romance">
                        <img src="image/postertreunham.jpg" alt="Trêu Nhầm Sắc Son 2025" />
                        <div class="movie-info">
                            <h3>TRÊU NHẦM SẮC SON 2025</h3>
                            <p>Duration: 2h 15m | Genre: Comedy, Romance</p>
                            <button><a href="https://motphim.ca/phim/treu-nham-sac-son">Watch Me</a></button>
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