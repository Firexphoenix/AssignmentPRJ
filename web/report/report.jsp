<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>THVB Cinema - Reports</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            /* Reset mặc định */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', Arial, sans-serif;
            }

            body {
                background-color: #1a1a1a; /* Màu nền tối */
                color: #f4e4ba; /* Màu chữ sáng */
                line-height: 1.6;
                font-size: 16px;
                padding: 20px;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
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

            .session-counter {
                color: #f4e4ba;
                font-size: 16px;
                font-weight: bold;
                background: #4a3f35;
                padding: 8px 15px;
                border-radius: 20px;
            }

            /* Container chính */
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 40px 20px;
                flex-grow: 1;
            }

            .container h2 {
                text-align: center;
                font-size: 32px;
                color: #d4af37; /* Màu vàng nổi bật */
                margin-bottom: 30px;
            }

            /* Section cho từng biểu đồ */
            section {
                background: #2f2525;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 30px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
            }

            section h3 {
                font-size: 24px;
                color: #f4e4ba;
                margin-bottom: 20px;
                text-align: center;
            }

            /* Biểu đồ */
            canvas {
                max-width: 100%;
                height: 400px !important; /* Đảm bảo chiều cao cố định cho biểu đồ */
                background: #3b2f2f; /* Nền tối cho biểu đồ */
                border-radius: 5px;
                padding: 10px;
            }

            /* Nút Back */
            .btn {
                display: inline-block;
                background: linear-gradient(45deg, #ffcc00, #ff6600);
                padding: 12px 30px;
                border-radius: 25px;
                text-decoration: none;
                font-size: 16px;
                font-weight: bold;
                color: #1a1a1a;
                transition: all 0.3s ease;
                text-align: center;
                margin: 20px auto;
                display: block;
                max-width: 200px;
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(255, 204, 0, 0.6);
            }

            /* Footer */
            footer {
                background: #2f2525;
                padding: 20px;
                text-align: center;
                border-top: 1px solid #4a3f35;
                margin-top: auto;
            }

            footer p {
                font-size: 14px;
                color: #f4e4ba;
            }

            /* Responsive design */
            @media (max-width: 768px) {
                .navbar {
                    flex-direction: column;
                    gap: 10px;
                }

                .container {
                    padding: 20px 10px;
                }

                section {
                    padding: 15px;
                }

                canvas {
                    height: 300px !important; /* Giảm chiều cao biểu đồ trên thiết bị di động */
                }

                .btn {
                    max-width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <header>
            <div class="navbar">
                <a href="<%= request.getContextPath()%>/" class="logo">THVB Cinema</a>
            </div>
        </header>

        <main>
            <div class="container">
                <h2>Reports Dashboard</h2>

                <!-- Biểu đồ phim bán vé chạy nhất -->
                <section>
                    <h3>Top Selling Movies (March 1-15, 2025)</h3>
                    <canvas id="topMoviesChart"></canvas>
                </section>

                <!-- Biểu đồ giờ chiếu đông khách -->
                <section>
                    <h3>Busiest Showtimes (March 1-15, 2025)</h3>
                    <canvas id="busiestShowtimesChart"></canvas>
                </section>

                <!-- Biểu đồ doanh thu theo rạp và ngày -->
                <section>
                    <h3>Revenue by Cinema and Day (March 1-15, 2025)</h3>
                    <canvas id="revenueChart"></canvas>
                </section>
            </div>
        </main>

        <footer>
            <p>© 2025 THVB Cinema. All Rights Reserved.</p>
        </footer>

        <a href="<%= request.getContextPath()%>/manager/managerDashboard.jsp" class="btn">Back</a>

        <script>
            // 1. Biểu đồ phim bán vé chạy nhất (Bar Chart)
            const topMoviesCtx = document.getElementById('topMoviesChart').getContext('2d');
            new Chart(topMoviesCtx, {
            type: 'bar',
                    data: {
                    labels: [<c:forEach items="${topMovies}" var="movie" varStatus="loop">'${movie.title}'<c:if test="${!loop.last}">,</c:if></c:forEach>],
                            datasets: [{
                            label: 'Tickets Sold',
                                    data: [<c:forEach items="${topMovies}" var="movie" varStatus="loop">${movie.tickets}<c:if test="${!loop.last}">,</c:if></c:forEach>],
                                    backgroundColor: 'rgba(255, 204, 0, 0.6)',
                                    borderColor: 'rgba(255, 204, 0, 1)',
                                    borderWidth: 1
                            }]
                    },
                    options: {
                    scales: {
                    y: { beginAtZero: true, title: { display: true, text: 'Number of Tickets', color: '#f4e4ba' }, ticks: { color: '#f4e4ba' } },
                            x: { title: { display: true, text: 'Movie Title', color: '#f4e4ba' }, ticks: { color: '#f4e4ba' } }
                    },
                            plugins: {
                            legend: {
                            labels: { color: '#f4e4ba' }
                            }
                            }
                    }
            });
            // 2. Biểu đồ giờ chiếu đông khách (Bar Chart)
            const busiestShowtimesCtx = document.getElementById('busiestShowtimesChart').getContext('2d');
            new Chart(busiestShowtimesCtx, {
            type: 'bar',
                    data: {
                    labels: [<c:forEach items="${busiestShowtimes}" var="showtime" varStatus="loop">'${showtime.hour}'<c:if test="${!loop.last}">,</c:if></c:forEach>],
                            datasets: [{
                            label: 'Tickets Sold',
                                    data: [<c:forEach items="${busiestShowtimes}" var="showtime" varStatus="loop">${showtime.tickets}<c:if test="${!loop.last}">,</c:if></c:forEach>],
                                    backgroundColor: 'rgba(255, 102, 0, 0.6)',
                                    borderColor: 'rgba(255, 102, 0, 1)',
                                    borderWidth: 1
                            }]
                    },
                    options: {
                    scales: {
                    y: { beginAtZero: true, title: { display: true, text: 'Number of Tickets', color: '#f4e4ba' }, ticks: { color: '#f4e4ba' } },
                            x: { title: { display: true, text: 'Show Hour', color: '#f4e4ba' }, ticks: { color: '#f4e4ba' } }
                    },
                            plugins: {
                            legend: {
                            labels: { color: '#f4e4ba' }
                            }
                            }
                    }
            });
            // 3. Biểu đồ doanh thu theo rạp và ngày (Line Chart)
            const revenueCtx = document.getElementById('revenueChart').getContext('2d');
            new Chart(revenueCtx, {
            type: 'line',
                    data: {
                    labels: ['2025-03-01', '2025-03-02', '2025-03-03', '2025-03-04', '2025-03-05',
                            '2025-03-06', '2025-03-07', '2025-03-08', '2025-03-09', '2025-03-10',
                            '2025-03-11', '2025-03-12', '2025-03-13', '2025-03-14', '2025-03-15'],
                            datasets: [
            <c:forEach items="${revenueByCinema}" var="entry" varStatus="loop">
                            {
                            label: '${entry.key}',
                                    data: [
                <c:forEach var="date" items="${['2025-03-01', '2025-03-02', '2025-03-03', '2025-03-04', '2025-03-05',
                                               '2025-03-06', '2025-03-07', '2025-03-08', '2025-03-09', '2025-03-10',
                                               '2025-03-11', '2025-03-12', '2025-03-13', '2025-03-14', '2025-03-15']}"
                           varStatus="dateLoop">
                    <c:set var="revenue" value="0.0"/>
                    <c:forEach items="${entry.value}" var="rev">
                        <c:if test="${rev.date == date}">
                            <c:set var="revenue" value="${rev.revenue}"/>
                        </c:if>
                    </c:forEach>
                    ${revenue}<c:if test="${!dateLoop.last}">,</c:if>
                </c:forEach>
                                    ],
                                    borderColor: 'rgba(${loop.index * 50 % 255}, ${loop.index * 100 % 255}, ${loop.index * 150 % 255}, 1)',
                                    fill: false
                            }<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
                            ]
                    },
                    options: {
                    scales: {
                    y: { beginAtZero: true, title: { display: true, text: 'Revenue (Million VND)', color: '#f4e4ba' }, ticks: { color: '#f4e4ba' } },
                            x: { title: { display: true, text: 'Date', color: '#f4e4ba' }, ticks: { color: '#f4e4ba' } }
                    },
                            plugins: {
                            legend: {
                            labels: { color: '#f4e4ba' }
                            }
                            }
                    }
            });
        </script>
    </body>
</html>