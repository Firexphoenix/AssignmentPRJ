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
        <title>THVB Cinema - Movie</title>
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
                <h1>Explore Movies</h1>
                <p>Book tickets for the latest movies now!</p>
                <a href="#series" class="btn-primary">Explore Movies</a>
            </div>
            <section id="series" class="container">
                <h2>Popular Movies</h2>
                <div class="movie-grid" id="movieGrid">
                    <div class="movie-card" data-title="Khi Cuộc Đời Cho Bạn Quả Quýt" data-genre="Romance">
                        <img src="image/posterquaquyt.jpg" alt="Khi Cuộc Đời Cho Bạn Quả Quýt" />
                        <div class="movie-info">
                            <div>
                                <h3>KHI CUỘC ĐỜI CHO BẠN QUẢ QUÝT</h3>
                                <p>Duration: 18 Episodes | Genre: Romance</p>
                            </div>
                            <button><a href="https://motphimchillh.com/khi-cuoc-doi-cho-ban-qua-quyt">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Hẻm Núi" data-genre="Comedy, Romance">
                        <img src="image/posterhemnui.jpg" alt="Hẻm Núi" />
                        <div class="movie-info">
                            <div>
                                <h3>HẺM NÚI</h3>
                                <p>Duration: 18 Episodes | Genre: Comedy, Romance</p>
                            </div>
                            <button><a href="https://motchillzz.me/hem-nui-the-gorge-13594.html">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Điệp Vụ Thanh Xuân" data-genre="Action, Youth">
                        <img src="image/posterdiepvu.jpg" alt="Điệp Vụ Thanh Xuân" />
                        <div class="movie-info">
                            <div>
                                <h3>ĐIỆP VỤ THANH XUÂN</h3>
                                <p>Duration: 16 Episodes | Genre: Action, Youth</p>
                            </div>
                            <button><a href="https://phimbom.sbs/phim/diep-vu-thanh-xuan-4bc57.html">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Bậc Thầy Đàm Phán" data-genre="Horror, Thriller">
                        <img src="image/posterbacthay.jpg" alt="Bậc Thầy Đàm Phán" />
                        <div class="movie-info">
                            <div>
                                <h3>BẬC THẦY ĐÀM PHÁN</h3>
                                <p>Duration: 18 Episodes | Genre: Horror, Thriller</p>
                            </div>
                            <button><a href="https://phimmoichillzz.com/phim-bo/bac-thay-dam-phan-1741183878">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Hỏi Các Vì Sao" data-genre="Horror, Thriller">
                        <img src="image/posterhoi.jpg" alt="Hỏi Các Vì Sao" />
                        <div class="movie-info">
                            <div>
                                <h3>HỎI CÁC VÌ SAO</h3>
                                <p>Duration: 7 Episodes | Genre: Horror, Thriller</p>
                            </div>
                            <button><a href="https://motphim.es/phim/hoi-cac-vi-sao">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Nhà Nghỉ California" data-genre="Comedy, Romance">
                        <img src="image/posternhanghi.jpg" alt="Nhà Nghỉ California" />
                        <div class="movie-info">
                            <div>
                                <h3>NHÀ NGHỈ CALIFORNIA</h3>
                                <p>Duration: 16 Episodes | Genre: Comedy, Romance</p>
                            </div>
                            <button><a href="https://motphim.pet/phim/nha-nghi-california">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Kẻ Thù Dấu Yêu" data-genre="Comedy, Romance">
                        <img src="image/posterkethu.jpg" alt="Kẻ Thù Dấu Yêu" />
                        <div class="movie-info">
                            <div>
                                <h3>KẺ THÙ DẤU YÊU</h3>
                                <p>Duration: 14 Episodes | Genre: Comedy, Romance</p>
                            </div>
                            <button><a href="https://motchillzz.me/ke-thu-dau-yeu-my-dearest-nemesis-13608.html">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Bắc Thượng" data-genre="Comedy, Romance">
                        <img src="image/posterbacthuong.jpg" alt="Bắc Thượng" />
                        <div class="movie-info">
                            <div>
                                <h3>BẮC THƯỢNG</h3>
                                <p>Duration: 8 Episodes | Genre: Comedy, Romance</p>
                            </div>
                            <button><a href="https://motchillzz.me/bac-thuong-northward-12856.html">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Tự Cấm" data-genre="Comedy, Romance">
                        <img src="image/postertucam.jpg" alt="Tự Cấm" />
                        <div class="movie-info">
                            <div>
                                <h3>TỰ CẤM</h3>
                                <p>Duration: 20 Episodes | Genre: Comedy, Romance</p>
                            </div>
                            <button><a href="https://motchillzz.me/tu-cam-si-jin-13638.html">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Trò Chơi Tình Ái" data-genre="Comedy, Romance">
                        <img src="image/postertrochoitinhai.jpg" alt="Trò Chơi Tình Ái" />
                        <div class="movie-info">
                            <div>
                                <h3>TRÒ CHƠI TÌNH ÁI</h3>
                                <p>Duration: 15 Episodes | Genre: Comedy, Romance</p>
                            </div>
                            <button><a href="https://motchillzz.me/tro-choi-tinh-ai-ban-trung-game-of-true-love-13707.html">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Vua Sói" data-genre="Comedy, Animation">
                        <img src="image/postervuasoi.jpg" alt="Vua Sói" />
                        <div class="movie-info">
                            <div>
                                <h3>VUA SÓI</h3>
                                <p>Duration: 8 Episodes | Genre: Comedy, Animation</p>
                            </div>
                            <button><a href="https://phimmoichillzz.com/phim-bo/vua-soi-1742471974">Watch Me</a></button>
                        </div>
                    </div>
                    <div class="movie-card" data-title="Trái Tim Chôn Vùi" data-genre="Comedy, Romance">
                        <img src="image/posterchonvui.jpg" alt="Trái Tim Chôn Vùi" />
                        <div class="movie-info">
                            <div>
                                <h3>TRÁI TIM CHÔN VÙI</h3>
                                <p>Duration: 10 Episodes | Genre: Comedy, Romance</p>
                            </div>
                            <button><a href="https://motchillzz.me/trai-tim-chon-vui-buried-hearts-13622.html">Watch Me</a></button>
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