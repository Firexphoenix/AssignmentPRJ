package Controller;

import movieDao.MovieDao;
import Model.Movie;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "MovieServlet", urlPatterns = {"/searchMovies"})
public class MovieServlet extends HttpServlet {

    private MovieDao movieDao;

    @Override
    public void init() {
        movieDao = new MovieDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tham số từ request
        String title = request.getParameter("title");
        String genre = request.getParameter("genre");
        String releaseDate = request.getParameter("releaseDate");

        // Kiểm tra và xử lý giá trị null
        title = (title != null) ? title.trim() : "";
        genre = (genre != null) ? genre.trim() : "";
        releaseDate = (releaseDate != null) ? releaseDate.trim() : "";

        try {
            // Gọi phương thức searchMovies
            List<Movie> movies = movieDao.searchMovies(title, genre, releaseDate);
            request.setAttribute("movies", movies);

            // Chuyển tiếp đến JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("movieList.jsp");
            if (dispatcher != null) {
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "JSP file not found");
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên thay bằng log (ví dụ: log4j)
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi trong quá trình tìm kiếm phim: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Xử lý POST giống GET nếu cần
    }
}
