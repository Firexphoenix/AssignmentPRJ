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

            /* Hero Banner */
            .hero-banner {
                position: relative;
                background: url('image/retro-banner.jpg') no-repeat center center;
                background-size: cover;
                padding: 80px 20px;
                text-align: center;
                overflow: hidden;
            }

            .hero-banner::after {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.6);
            }

            .hero-banner h1 {
                font-size: 48px;
                font-weight: bold;
                margin-bottom: 20px;
                position: relative;
                z-index: 1;
            }

            .hero-banner p {
                font-size: 20px;
                margin-bottom: 30px;
                position: relative;
                z-index: 1;
            }

            .hero-banner .btn-primary {
                background: #d4af37;
                padding: 15px 30px;
                border-radius: 25px;
                text-decoration: none;
                font-weight: bold;
                color: #1a1a1a;
                position: relative;
                z-index: 1;
                transition: all 0.3s ease;
            }

            .hero-banner .btn-primary:hover {
                background: #b8860b;
                transform: translateY(-3px);
                box-shadow: 0 5px 15px rgba(255, 204, 0, 0.6);
            }

            /* Movie Section */
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 40px 20px;
            }

            .container h2 {
                text-align: center;
                margin-bottom: 20px;
                font-size: 24px;
                color: #f4e4ba;
            }

            .movie-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
                padding: 20px;
            }

            .movie-card {
                background: #4a3f35;
                border-radius: 10px;
                overflow: hidden;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                display: flex;
                flex-direction: column;
                height: 520px;
            }

            .movie-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.5);
            }

            .movie-card img {
                width: 100%;
                height: 350px;
                object-fit: cover;
            }

            .movie-info {
                padding: 15px;
                text-align: center;
                flex-grow: 1;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                color: #fff;
            }

            .movie-info h3 {
                font-size: 20px;
                margin-bottom: 10px;
                text-transform: uppercase;
            }

            .movie-info p {
                font-size: 14px;
                margin-bottom: 15px;
                flex-grow: 1;
                color: #ccc;
            }

            .movie-card button {
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

            .movie-card button a {
                text-decoration: none;
                color: #000;
            }

            .movie-card button:hover {
                background: #b8860b;
                transform: scale(1.05);
            }

            /* Pagination styles */
            .pagination {
                text-align: center;
                margin: 20px 0;
            }

            .pagination button {
                background-color: #f5c518;
                border: none;
                padding: 10px 20px;
                margin: 0 5px;
                cursor: pointer;
                border-radius: 5px;
            }

            .pagination button:disabled {
                background-color: #ccc;
                cursor: not-allowed;
            }

            /* Footer */
            footer {
                background: #2f2525;
                padding: 20px;
                text-align: center;
                border-top: 1px solid #4a3f35;
            }

            footer p {
                font-size: 14px;
            }

            .hidden {
                display: none !important;
            }
        </style>
    </head>
    <body>
        <header>
            <div class="navbar">
                <a href="<%= request.getContextPath()%>/" class="logo">THVBCINEMA</a>
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
                <li><a href="<%= request.getContextPath()%>/cart">Cart</a></li>
                <li><a href="<%= request.getContextPath()%>/cart?action=history">Booking History</a></li>
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
                <div class="movie-grid" id="movieGrid">
                    <div class="movie-card" data-title="Nghề Siêu Khó Nói" data-genre="Comedy, Romance">
                        <img src="image/posternghe.jpg" alt="Nghề Siêu Khó Nói" />
                        <div class="movie-info">
                            <div>
                                <h3>NGHỀ SIÊU KHÓ NÓI</h3>
                                <p>Duration: 2h 15m | Genre: Comedy, Romance</p>
                            </div>
                            <button><a href="https://motchillk.org/nghe-sieu-kho-noi">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Nhà Gia Tiên" data-genre="Horror, Thriller">
                        <img src="image/postergiatien.jpg" alt="Nhà Gia Tiên" />
                        <div class="movie-info">
                            <div>
                                <h3>NHÀ GIA TIÊN</h3>
                                <p>Duration: 2h 15m | Genre: Horror, Thriller</p>
                            </div>
                            <button><a href="https://flix.sensacinema.site/vi/movie/1396079">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Tiếng Vọng Kinh Hoàng" data-genre="Horror, Thriller">
                        <img src="image/postertiengvong.jpg" alt="Tiếng Vọng Kinh Hoàng" />
                        <div class="movie-info">
                            <div>
                                <h3>TIẾNG VỌNG KINH HOÀNG</h3>
                                <p>Duration: 2h 15m | Genre: Horror, Thriller</p>
                            </div>
                            <button><a href="https://www.youtube.com/watch?v=tUCU2qidmOI">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Emma và Vương Quốc Tí Hon" data-genre="Fantasy">
                        <img src="image/posteremma.jpg" alt="Emma và Vương Quốc Tí Hon" />
                        <div class="movie-info">
                            <div>
                                <h3>EMMA VÀ VƯƠNG QUỐC TÍ HON</h3>
                                <p>Duration: 2h15m | Genre: Fantasy</p>
                            </div>
                            <button><a href="https://www.youtube.com/watch?v=kraUpgr_IE4">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Âm Dương Lộ" data-genre="Horror, Mystery">
                        <img src="image/posteramduong.jpg" alt="Âm Dương Lộ" />
                        <div class="movie-info">
                            <div>
                                <h3>ÂM DƯƠNG LỘ</h3>
                                <p>Duration: 2h 15m | Genre: Horror, Mystery</p>
                            </div>
                            <button><a href="https://www.youtube.com/watch?v=V_EK5jZQjtc">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Doraemon: Nobita's Art World Tales" data-genre="Animation">
                        <img src="image/posterdoraemon.jpg" alt="Doraemon: Nobita's Art World Tales" />
                        <div class="movie-info">
                            <div>
                                <h3>DORAEMON: NOBITA'S ART WORLD TALES</h3>
                                <p>Duration: 2h15m | Genre: Animation</p>
                            </div>
                            <button><a href="https://www.youtube.com/watch?v=1b2sSI51Edw">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Trêu Nhầm Sắc Son 2025" data-genre="Comedy, Romance">
                        <img src="image/postertreunham.jpg" alt="Trêu Nhầm Sắc Son 2025" />
                        <div class="movie-info">
                            <div>
                                <h3>TRÊU NHẦM SẮC SON 2025</h3>
                                <p>Duration: 2h 15m | Genre: Comedy, Romance</p>
                            </div>
                            <button><a href="https://motphim.ca/phim/treu-nham-sac-son">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Xứ Sở Robot" data-genre="Animation, Adventure">
                        <img src="image/posterxuso.jpg" alt="Xứ Sở Robot" />
                        <div class="movie-info">
                            <div>
                                <h3>XỨ SỞ ROBOT</h3>
                                <p>Duration: 2h 15m | Genre: Animation, Adventure</p>
                            </div>
                            <button><a href="https://motchillzz.me/xu-so-robot-the-electric-state-13693.html">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Cẩu Trận" data-genre="Comedy, Romance">
                        <img src="image/postercautran.jpg" alt="Cẩu Trận" />
                        <div class="movie-info">
                            <div>
                                <h3>CẨU TRẬN</h3>
                                <p>Duration: 2h 15m | Genre: Comedy, Romance</p>
                            </div>
                            <button><a href="https://motchillzz.me/cau-tran-black-dog-13683.html">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Phi Vụ Lớn" data-genre="Action">
                        <img src="image/posterphivu.jpg" alt="Phi Vụ Lớn" />
                        <div class="movie-info">
                            <div>
                                <h3>PHI VỤ LỚN</h3>
                                <p>Duration: 2h 15m | Genre: Action</p>
                            </div>
                            <button><a href="https://motchillzz.me/phi-vu-lon-cash-out-13702.html">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Không Lực" data-genre="Action">
                        <img src="image/posterkhongluc.jpg" alt="Không Lực" />
                        <div class="movie-info">
                            <div>
                                <h3>KHÔNG LỰC</h3>
                                <p>Duration: 2h 15m | Genre: Action</p>
                            </div>
                            <button><a href="https://motchillzz.me/khong-luc-sky-force-13697.html">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Mèo Ma Bê Tha" data-genre="Animation">
                        <img src="image/postermeoma.jpg" alt="Mèo Ma Bê Tha" />
                        <div class="movie-info">
                            <div>
                                <h3>MÈO MA BÊ THA</h3>
                                <p>Duration: 2h 15m | Genre: Animation</p>
                            </div>
                            <button><a href="https://motchillzz.me/meo-ma-be-tha-ghost-cat-anzu-13685.html">Watch Me</a></button>
                        </div>
                    </div>
                </div>
                <!-- Pagination controls -->
                <div class="pagination">
                    <button id="prevBtn" onclick="prevPage()" disabled>Previous</button>
                    <button id="nextBtn" onclick="nextPage()">Next</button>
                </div>
            </section>
        </main>
        <footer>
            <p>© 2025 THVBCINEMA. All Rights Reserved.</p>
        </footer>

        <script>
            const moviesPerPage = 6; // 6 phim mỗi trang
            const movieGrid = document.getElementById('movieGrid');
            const movieCards = movieGrid.getElementsByClassName('movie-card');
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            const searchInput = document.getElementById("search-input"); // Lấy thanh tìm kiếm
            let currentPage = 1;
            let filteredMovies = Array.from(movieCards); // Danh sách phim sau khi lọc

            // Hàm debounce giúp tối ưu hiệu suất tìm kiếm
            function debounce(func, delay) {
                let timeout;
                return (...args) => {
                    clearTimeout(timeout);
                    timeout = setTimeout(() => func(...args), delay);
                };
            }

            // Hàm chuẩn hóa chuỗi tiếng Việt (loại bỏ dấu)
            function removeVietnameseTones(str) {
                str = str.normalize("NFD").replace(/[\u0300-\u036f]/g, ""); // Chuẩn hóa Unicode và bỏ dấu
                return str.replace(/đ/g, "d").replace(/Đ/g, "D"); // Xử lý riêng chữ "đ"
            }

            // Hàm lọc phim theo từ khóa (tìm cả theo Title và Genre)
            function filterMovies() {
                const query = searchInput.value.trim().toLowerCase(); // Lấy chuỗi tìm kiếm, chuyển về chữ thường
                const queryNoTones = removeVietnameseTones(query); // Loại bỏ dấu tiếng Việt

                filteredMovies = Array.from(movieCards).filter(movie => {
                    const title = movie.getAttribute("data-title").toLowerCase().trim(); // Lấy tiêu đề phim
                    const genre = movie.getAttribute("data-genre").toLowerCase().trim(); // Lấy thể loại phim

                    const titleNoTones = removeVietnameseTones(title); // Tiêu đề không dấu
                    const genreNoTones = removeVietnameseTones(genre); // Thể loại không dấu

                    // Kiểm tra xem từ khóa có khớp với tiêu đề hoặc thể loại không
                    return (
                            title.includes(query) ||
                            titleNoTones.includes(queryNoTones) ||
                            genre.includes(query) ||
                            genreNoTones.includes(queryNoTones)
                            );
                });

                // Reset về trang đầu tiên sau khi lọc
                currentPage = 1;
                showPage(currentPage);
            }

            // Hàm hiển thị trang
            function showPage(page) {
                // Ẩn tất cả các thẻ phim
                for (let i = 0; i < movieCards.length; i++) {
                    movieCards[i].style.display = 'none';
                }

                // Tính toán chỉ số bắt đầu và kết thúc cho trang hiện tại
                const start = (page - 1) * moviesPerPage;
                const end = Math.min(start + moviesPerPage, filteredMovies.length);

                // Hiển thị các thẻ phim cho trang hiện tại
                for (let i = start; i < end; i++) {
                    filteredMovies[i].style.display = 'flex'; // Giữ flex cho bố cục bên trong thẻ
                }

                // Cập nhật trạng thái nút
                const totalPages = Math.ceil(filteredMovies.length / moviesPerPage);
                prevBtn.disabled = page === 1;
                nextBtn.disabled = page === totalPages;
            }

            function prevPage() {
                if (currentPage > 1) {
                    currentPage--;
                    showPage(currentPage);
                }
            }

            function nextPage() {
                const totalPages = Math.ceil(filteredMovies.length / moviesPerPage);
                if (currentPage < totalPages) {
                    currentPage++;
                    showPage(currentPage);
                }
            }

            // Lắng nghe sự kiện nhập liệu
            searchInput.addEventListener("input", debounce(filterMovies, 300));

            // Hiển thị trang đầu tiên khi tải
            showPage(currentPage);
        </script>
    </body>
</html>