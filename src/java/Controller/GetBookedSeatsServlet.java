package Controller;

import showtimeDao.ShowtimeDao;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet(name = "GetBookedSeatsServlet", urlPatterns = {"/getBookedSeats"})
public class GetBookedSeatsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String showTimeId = request.getParameter("showTimeId");
        if (showTimeId == null || showTimeId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ShowTimeID is required");
            return;
        }

        ShowtimeDao showtimeDao = new ShowtimeDao();
        List<String> bookedSeats = showtimeDao.getBookedSeatsByShowTimeId(showTimeId);

        // Chuyển danh sách ghế đã đặt thành JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();
        String json = gson.toJson(bookedSeats);
        response.getWriter().write(json);
    }
}
