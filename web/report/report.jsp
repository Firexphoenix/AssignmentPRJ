<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>PHIM3CONHEO - Reports</title>
        <link rel="stylesheet" href="css/userStyle.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body>
        <header>
            <div class="navbar">
                <a href="<%= request.getContextPath()%>/" class="logo">PHIM3CONHEO</a>
                <div class="session-counter">
                    Active Sessions: <%= (Integer) application.getAttribute("activeSessions") != null ? application.getAttribute("activeSessions") : 0%>
                </div>
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
            <p>© 2025 PHIM3CONHEO. All Rights Reserved.</p>
        </footer>

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
                    y: { beginAtZero: true, title: { display: true, text: 'Number of Tickets' } },
                            x: { title: { display: true, text: 'Movie Title' } }
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
                    y: { beginAtZero: true, title: { display: true, text: 'Number of Tickets' } },
                            x: { title: { display: true, text: 'Show Hour' } }
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
                    y: { beginAtZero: true, title: { display: true, text: 'Revenue (Million VND)' } },
                            x: { title: { display: true, text: 'Date' } }
                    }
                    }
            });
        </script>
    </body>
</html>