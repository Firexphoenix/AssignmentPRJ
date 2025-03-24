package movieDao;

import Model.Movie; // Updated import
import dao.DBconnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MovieDao {

    private static final String SELECT_ALL_MOVIES = "SELECT * FROM Movie"; // Adjusted table name
    private static final String SELECT_MOVIE_BY_ID = "SELECT * FROM Movie WHERE movieID = ?";

    private void printSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                e.printStackTrace(System.err);
                System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                System.err.println("Message: " + e.getMessage());
                Throwable t = ex.getCause();
                while (t != null) {
                    System.out.println("Cause: " + t);
                    t = t.getCause();
                }
            }
        }
    }

    // Fetch all movies from the database
    public List<Movie> getAllMovies() {
        List<Movie> movies = new ArrayList<>();
        try (Connection conn = DBconnection.getConnection(); PreparedStatement preparedStatement = conn.prepareStatement(SELECT_ALL_MOVIES)) {
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                String movieID = rs.getString("movieID");
                String movieTitle = rs.getString("movieTitle");
                String movieGenre = rs.getString("movieGenre");
                Date releaseDate = rs.getDate("releaseDate");
                String director = rs.getString("director");
                int movieDuration = rs.getInt("movieDuration");
                String language = rs.getString("language");
                movies.add(new Movie(movieID, movieTitle, movieGenre, releaseDate, director, movieDuration, language));
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return movies;
    }

    // Fetch a single movie by movieID
    public Movie getMovieById(String movieID) {
        Movie movie = null;
        try (Connection conn = DBconnection.getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_MOVIE_BY_ID)) {
            ps.setString(1, movieID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                movie = new Movie(
                        rs.getString("movieID"),
                        rs.getString("movieTitle"),
                        rs.getString("movieGenre"),
                        rs.getDate("releaseDate"),
                        rs.getString("director"),
                        rs.getInt("movieDuration"),
                        rs.getString("language")
                );
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return movie;
    }

    public List<Movie> searchMovies(String title, String genre, String releaseDate) throws SQLException {
        List<Movie> movieList = new ArrayList<>();

        // Tạo câu lệnh SQL với các điều kiện tìm kiếm
        String query = "SELECT * FROM Movie WHERE MovieTitle LIKE ? AND MovieGenre LIKE ? AND ReleaseDate LIKE ?";

        // Kết nối cơ sở dữ liệu và thực thi truy vấn
        try (Connection connection = DBconnection.getConnection(); PreparedStatement statement = connection.prepareStatement(query)) {

            // Đặt các tham số
            statement.setString(1, "%" + (title != null ? title : "") + "%"); // Tìm kiếm theo tên phim
            statement.setString(2, "%" + (genre != null ? genre : "") + "%");  // Tìm kiếm theo thể loại
            statement.setString(3, "%" + (releaseDate != null ? releaseDate : "") + "%"); // Tìm kiếm theo ngày phát hành

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Movie movie = new Movie();
                movie.setMovieID(resultSet.getString("MovieID"));
                movie.setMovieTitle(resultSet.getString("MovieTitle"));
                movie.setMovieGenre(resultSet.getString("MovieGenre"));
                movie.setReleaseDate(resultSet.getDate("ReleaseDate"));
                movie.setDirector(resultSet.getString("Director"));
                movie.setMovieDuration(resultSet.getInt("MovieDuration"));
                movie.setLanguage(resultSet.getString("Language"));
                movieList.add(movie);
            }
        }
        return movieList;
    }

    // Thêm phim mới
    public boolean addMovie(Movie movie) throws SQLException {
        String sql = "INSERT INTO Movie (MovieID, MovieTitle, MovieGenre, ReleaseDate, Director, MovieDuration, Language) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, movie.getMovieID());
            stmt.setString(2, movie.getMovieTitle());
            stmt.setString(3, movie.getMovieGenre());
            stmt.setDate(4, movie.getReleaseDate() != null ? new java.sql.Date(movie.getReleaseDate().getTime()) : null);
            stmt.setString(5, movie.getDirector());
            stmt.setInt(6, movie.getMovieDuration());
            stmt.setString(7, movie.getLanguage());
            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        }
    }

    // Cập nhật phim
    public boolean updateMovie(Movie movie) throws SQLException {
        String sql = "UPDATE Movie SET MovieTitle = ?, MovieGenre = ?, ReleaseDate = ?, Director = ?, MovieDuration = ?, Language = ? WHERE MovieID = ?";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, movie.getMovieTitle());
            stmt.setString(2, movie.getMovieGenre());
            stmt.setDate(3, movie.getReleaseDate() != null ? new java.sql.Date(movie.getReleaseDate().getTime()) : null);
            stmt.setString(4, movie.getDirector());
            stmt.setInt(5, movie.getMovieDuration());
            stmt.setString(6, movie.getLanguage());
            stmt.setString(7, movie.getMovieID());
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        }
    }

    // Xóa phim
    public boolean deleteMovie(String movieId) throws SQLException {
        String sql = "DELETE FROM Movie WHERE MovieID = ?";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, movieId);
            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;
        }
    }

    // Tạo MovieID mới
    public String generateNewMovieID() throws SQLException {
        String sql = "SELECT MAX(MovieID) AS MaxID FROM Movie";
        try (Connection conn = DBconnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                String maxID = rs.getString("MaxID");
                if (maxID == null) {
                    return "MV001";
                }
                int num = Integer.parseInt(maxID.substring(2)) + 1;
                return String.format("MV%03d", num);
            }
            return "MV001";
        }
    }
}
