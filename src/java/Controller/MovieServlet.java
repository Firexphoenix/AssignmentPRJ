package Controller;

import Model.Movie;
import movieDao.MovieDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet(name = "MovieServlet", urlPatterns = {"/movies"})
public class MovieServlet extends HttpServlet {

    private MovieDao movieDao;

    @Override
    public void init() throws ServletException {
        movieDao = new MovieDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        // Kiểm tra quyền truy cập: Chỉ Manager và Employee được phép truy cập
        if (userEmail == null || role == null || !("Manager".equalsIgnoreCase(role) || "Employee".equalsIgnoreCase(role))) {
            response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=accessDenied");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        // Nếu là Employee, chỉ được xem danh sách phim
        if ("Employee".equalsIgnoreCase(role)) {
            if (!"list".equals(action)) {
                response.sendRedirect(request.getContextPath() + "/movies?error=accessDenied");
                return;
            }
            listMoviesForEmployee(request, response);
            return;
        }

        // Nếu là Manager, xử lý các hành động CRUD
        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteMovie(request, response);
                break;
            default:
                listMovies(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        // Kiểm tra quyền truy cập: Chỉ Manager được phép chỉnh sửa
        if (userEmail == null || role == null || !"Manager".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=adminAccessRequired");
            return;
        }

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addMovie(request, response);
        } else if ("update".equals(action)) {
            updateMovie(request, response);
        } else {
            listMovies(request, response);
        }
    }

    // Hiển thị danh sách phim cho Manager (có quyền chỉnh sửa)
    private void listMovies(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Movie> movieList = movieDao.getAllMovies();
        request.setAttribute("movieList", movieList);
        request.getRequestDispatcher("/movie/movieList.jsp").forward(request, response);
    }

    // Hiển thị danh sách phim cho Employee (chỉ xem)
    private void listMoviesForEmployee(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Movie> movieList = movieDao.getAllMovies();
        request.setAttribute("movieList", movieList);
        request.getRequestDispatcher("/movie/movieListForEmployee.jsp").forward(request, response);
    }

    // Hiển thị form thêm phim (chỉ cho Manager)
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/movie/addMovie.jsp").forward(request, response);
    }

    // Hiển thị form chỉnh sửa phim (chỉ cho Manager)
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String movieId = request.getParameter("movieId");
        Movie movie = movieDao.getMovieById(movieId);
        if (movie == null) {
            request.setAttribute("error", "Phim không tồn tại.");
            listMovies(request, response);
            return;
        }
        request.setAttribute("movie", movie);
        request.getRequestDispatcher("/movie/editMovie.jsp").forward(request, response);
    }

    // Thêm phim mới (chỉ cho Manager)
    private void addMovie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String movieId = movieDao.generateNewMovieID();
            String movieTitle = request.getParameter("movieTitle");
            String movieGenre = request.getParameter("movieGenre");
            String releaseDateStr = request.getParameter("releaseDate");
            String director = request.getParameter("director");
            int movieDuration = Integer.parseInt(request.getParameter("movieDuration"));
            String language = request.getParameter("language");

            // Kiểm tra dữ liệu đầu vào
            if (movieTitle == null || movieTitle.trim().isEmpty()
                    || movieGenre == null || movieGenre.trim().isEmpty()
                    || language == null || language.trim().isEmpty()
                    || movieDuration <= 0) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin và đảm bảo thời lượng phim lớn hơn 0.");
                request.getRequestDispatcher("/movie/addMovie.jsp").forward(request, response);
                return;
            }

            // Chuyển đổi ngày phát hành
            Date releaseDate = null;
            if (releaseDateStr != null && !releaseDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    java.util.Date parsedDate = sdf.parse(releaseDateStr);
                    releaseDate = new Date(parsedDate.getTime());
                } catch (ParseException e) {
                    request.setAttribute("error", "Định dạng ngày phát hành không hợp lệ (yyyy-MM-dd).");
                    request.getRequestDispatcher("/movie/addMovie.jsp").forward(request, response);
                    return;
                }
            }

            Movie movie = new Movie();
            movie.setMovieID(movieId);
            movie.setMovieTitle(movieTitle);
            movie.setMovieGenre(movieGenre);
            movie.setReleaseDate(releaseDate);
            movie.setDirector(director);
            movie.setMovieDuration(movieDuration);
            movie.setLanguage(language);

            boolean success = movieDao.addMovie(movie);
            if (success) {
                response.sendRedirect("movies?message=MovieAdded");
            } else {
                request.setAttribute("error", "Không thể thêm phim. Vui lòng thử lại.");
                request.getRequestDispatcher("/movie/addMovie.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi thêm phim: " + e.getMessage());
            request.getRequestDispatcher("/movie/addMovie.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Thời lượng phim phải là một số nguyên dương.");
            request.getRequestDispatcher("/movie/addMovie.jsp").forward(request, response);
        }
    }

    // Cập nhật phim (chỉ cho Manager)
    private void updateMovie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String movieId = request.getParameter("movieId");
            String movieTitle = request.getParameter("movieTitle");
            String movieGenre = request.getParameter("movieGenre");
            String releaseDateStr = request.getParameter("releaseDate");
            String director = request.getParameter("director");
            int movieDuration = Integer.parseInt(request.getParameter("movieDuration"));
            String language = request.getParameter("language");

            // Kiểm tra dữ liệu đầu vào
            if (movieId == null || movieId.trim().isEmpty()
                    || movieTitle == null || movieTitle.trim().isEmpty()
                    || movieGenre == null || movieGenre.trim().isEmpty()
                    || language == null || language.trim().isEmpty()
                    || movieDuration <= 0) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin và đảm bảo thời lượng phim lớn hơn 0.");
                request.setAttribute("movie", movieDao.getMovieById(movieId));
                request.getRequestDispatcher("/movie/editMovie.jsp").forward(request, response);
                return;
            }

            // Chuyển đổi ngày phát hành
            Date releaseDate = null;
            if (releaseDateStr != null && !releaseDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    java.util.Date parsedDate = sdf.parse(releaseDateStr);
                    releaseDate = new Date(parsedDate.getTime());
                } catch (ParseException e) {
                    request.setAttribute("error", "Định dạng ngày phát hành không hợp lệ (yyyy-MM-dd).");
                    request.setAttribute("movie", movieDao.getMovieById(movieId));
                    request.getRequestDispatcher("/movie/editMovie.jsp").forward(request, response);
                    return;
                }
            }

            Movie movie = new Movie();
            movie.setMovieID(movieId);
            movie.setMovieTitle(movieTitle);
            movie.setMovieGenre(movieGenre);
            movie.setReleaseDate(releaseDate);
            movie.setDirector(director);
            movie.setMovieDuration(movieDuration);
            movie.setLanguage(language);

            boolean success = movieDao.updateMovie(movie);
            if (success) {
                response.sendRedirect("movies?message=MovieUpdated");
            } else {
                request.setAttribute("error", "Không thể cập nhật phim. Vui lòng thử lại.");
                request.setAttribute("movie", movie);
                request.getRequestDispatcher("/movie/editMovie.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật phim: " + e.getMessage());
            request.setAttribute("movie", movieDao.getMovieById(request.getParameter("movieId")));
            request.getRequestDispatcher("/movie/editMovie.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Thời lượng phim phải là một số nguyên dương.");
            request.setAttribute("movie", movieDao.getMovieById(request.getParameter("movieId")));
            request.getRequestDispatcher("/movie/editMovie.jsp").forward(request, response);
        }
    }

    // Xóa phim (chỉ cho Manager)
    private void deleteMovie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String movieId = request.getParameter("movieId");
        try {
            boolean success = movieDao.deleteMovie(movieId);
            if (success) {
                response.sendRedirect("movies?message=MovieDeleted");
            } else {
                request.setAttribute("error", "Không thể xóa phim. Vui lòng thử lại.");
                listMovies(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xóa phim: " + e.getMessage());
            listMovies(request, response);
        }
    }
}
