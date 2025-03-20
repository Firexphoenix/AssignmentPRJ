package showtimeDao;

import dao.DBconnection;
import Model.Showtime;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ShowtimeDao {

    // Phương thức hiện có: lấy danh sách suất chiếu theo MovieID
    public List<Showtime> getShowtimesByMovieId(String movieId) {
        List<Showtime> showtimes = new ArrayList<>();
        String query = "SELECT * FROM Showtime WHERE MovieID = ?";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, movieId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Showtime showtime = new Showtime();
                    showtime.setShowTimeID(rs.getString("ShowTimeID"));
                    showtime.setStartTime(rs.getTimestamp("StartTime"));
                    showtime.setEndTime(rs.getTimestamp("EndTime"));
                    showtime.setRoomID(rs.getString("RoomID"));
                    showtime.setMovieID(rs.getString("MovieID"));
                    showtimes.add(showtime);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return showtimes;
    }

    // Phương thức mới: lấy danh sách ghế đã đặt theo ShowTimeID
    public List<String> getBookedSeatsByShowTimeId(String showTimeId) {
        List<String> bookedSeats = new ArrayList<>();
        String query = "SELECT SeatNumber FROM Ticket WHERE ShowTimeID = ? AND Status = 'Paid'";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, showTimeId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookedSeats.add(rs.getString("SeatNumber"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookedSeats;
    }
}
