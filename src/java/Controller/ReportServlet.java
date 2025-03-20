package Controller;

import dao.DBconnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ReportServlet", urlPatterns = {"/report"})
public class ReportServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = DBconnection.getConnection()) {
            if (conn == null) {
                throw new SQLException("Failed to establish database connection.");
            }

            // 1. Phim bán vé chạy nhất
            List<Map<String, Object>> topMovies = new ArrayList<>();
            String topMoviesQuery = "SELECT m.MovieTitle, COUNT(t.MovieID) AS TotalTicketsSold "
                    + "FROM Movie m "
                    + "JOIN Showtime s ON m.MovieID = s.MovieID "
                    + "JOIN Ticket t ON s.ShowTimeID = t.ShowTimeID "
                    + "JOIN Invoice i ON t.TicketID = i.TicketID "
                    + "WHERE i.Date BETWEEN '2025-03-01' AND '2026-03-15' "
                    + "AND t.Status = 'Paid' "
                    + "AND i.Status = 'Paid' "
                    + "GROUP BY m.MovieID, m.MovieTitle "
                    + "ORDER BY TotalTicketsSold DESC";
            try (PreparedStatement stmt = conn.prepareStatement(topMoviesQuery); ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> movie = new HashMap<>();
                    movie.put("title", rs.getString("MovieTitle"));
                    movie.put("tickets", rs.getInt("TotalTicketsSold"));
                    topMovies.add(movie);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                throw new ServletException("Error executing Top Movies query: " + e.getMessage());
            }
            request.setAttribute("topMovies", topMovies);

            // 2. Giờ chiếu đông khách
            List<Map<String, Object>> busiestShowtimes = new ArrayList<>();
            String busiestShowtimesQuery = "SELECT FORMAT(s.StartTime, 'HH:00') AS ShowHour, "
                    + "SUM(t.Quantity) AS TotalTicketsSold "
                    + "FROM Showtime s "
                    + "JOIN Ticket t ON s.ShowTimeID = t.ShowTimeID "
                    + "JOIN Invoice i ON t.TicketID = i.TicketID "
                    + "WHERE t.BookingTime BETWEEN '2025-03-01' AND '2026-03-15' "
                    + "AND t.Status = 'Paid' "
                    + "AND i.Status = 'Paid' "
                    + "GROUP BY FORMAT(s.StartTime, 'HH:00') "
                    + "ORDER BY TotalTicketsSold DESC";
            try (PreparedStatement stmt = conn.prepareStatement(busiestShowtimesQuery); ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> showtime = new HashMap<>();
                    showtime.put("hour", rs.getString("ShowHour"));
                    showtime.put("tickets", rs.getInt("TotalTicketsSold"));
                    busiestShowtimes.add(showtime);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                throw new ServletException("Error executing Busiest Showtimes query: " + e.getMessage());
            }
            request.setAttribute("busiestShowtimes", busiestShowtimes);

            // 3. Doanh thu theo rạp và ngày
            Map<String, List<Map<String, Object>>> revenueByCinema = new HashMap<>();
            String revenueQuery = "SELECT c.CinemaName, i.Date, SUM(i.Total) AS Revenue "
                    + "FROM Cinema c "
                    + "JOIN ScreenRoom sr ON c.CinemaID = sr.CinemaID "
                    + "JOIN Showtime s ON sr.RoomID = s.RoomID "
                    + "JOIN Ticket t ON s.ShowTimeID = t.ShowTimeID "
                    + "JOIN Invoice i ON t.TicketID = i.TicketID "
                    + "WHERE i.Date BETWEEN '2025-03-01' AND '2026-03-15' "
                    + "AND i.Status = 'Paid' "
                    + "AND t.Status = 'Paid' "
                    + "GROUP BY c.CinemaID, c.CinemaName, i.Date "
                    + "ORDER BY c.CinemaName, i.Date";
            try (PreparedStatement stmt = conn.prepareStatement(revenueQuery); ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String cinemaName = rs.getString("CinemaName");
                    Map<String, Object> revenue = new HashMap<>();
                    revenue.put("date", rs.getString("Date"));
                    revenue.put("revenue", rs.getDouble("Revenue"));
                    revenueByCinema.computeIfAbsent(cinemaName, k -> new ArrayList<>()).add(revenue);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                throw new ServletException("Error executing Revenue query: " + e.getMessage());
            }
            request.setAttribute("revenueByCinema", revenueByCinema);

            // Chuyển tiếp đến JSP
            request.getRequestDispatcher("report/report.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
}
