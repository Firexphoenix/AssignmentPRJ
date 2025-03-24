package Controller;

import Model.Ticket;
import Model.Movie;
import customerDao.CustomerDao;
import movieDao.MovieDao;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import ticketDao.TicketDao;

@WebServlet(name = "ShoppingCartServlet", urlPatterns = {"/cart"})
public class ShoppingCartServlet extends HttpServlet {

    private MovieDao movieDAO;
    private TicketDao ticketDAO;
    private CustomerDao customerDao;

    @Override
    public void init() throws ServletException {
        movieDAO = new MovieDao();
        ticketDAO = new TicketDao();
        customerDao = new CustomerDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        List<Movie> movieList = movieDAO.getAllMovies();
        request.getServletContext().setAttribute("movieList", movieList);

        switch (action) {
            case "selectSeats":
                try {
                    selectSeats(request, response);
                } catch (SQLException e) {
                    e.printStackTrace();
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi lấy danh sách ghế: " + e.getMessage());
                }
                break;
            case "add":
                try {
                    addToCart(request, response);
                } catch (SQLException e) {
                    e.printStackTrace();
                    try {
                        handleAddToCartError(request, response, e);
                    } catch (SQLException ex) {
                        Logger.getLogger(ShoppingCartServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                break;
            case "remove":
                removeFromCart(request, response);
                break;
            case "update":
                updateCart(request, response);
                break;
            case "clear":
                clearCart(request, response);
                break;
            case "history":
                try {
                    viewTicketHistory(request, response);
                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Lỗi khi lấy lịch sử đặt vé: " + e.getMessage());
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/manager/ticketHistory.jsp");
                    dispatcher.forward(request, response);
                }
                break;
            case "adminHistory":
                try {
                    viewAllTicketHistory(request, response);
                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Lỗi khi lấy toàn bộ lịch sử đặt vé: " + e.getMessage());
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/manager/adminTicketHistory.jsp"); // Cập nhật đường dẫn
                    dispatcher.forward(request, response);
                }
                break;
            case "deleteTicket":
                try {
                    deleteTicket(request, response);
                } catch (SQLException e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Lỗi khi xóa vé: " + e.getMessage());
                    try {
                        viewAllTicketHistory(request, response);
                    } catch (SQLException ex) {
                        Logger.getLogger(ShoppingCartServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
                break;
            default:
                viewCart(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            try {
                addToCart(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
                try {
                    handleAddToCartError(request, response, e);
                } catch (SQLException ex) {
                    Logger.getLogger(ShoppingCartServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        } else {
            doGet(request, response);
        }
    }

    private void selectSeats(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String movieId = request.getParameter("movieId");
        String showTimeId = request.getParameter("showTimeId");
        if (movieId == null || movieId.trim().isEmpty()) {
            response.sendRedirect("cart?action=view");
            return;
        }

        List<String> bookedSeats = new ArrayList<>();
        if (showTimeId != null && !showTimeId.trim().isEmpty()) {
            if (!ticketDAO.isShowTimeIdValid(showTimeId)) {
                request.setAttribute("error", "Suất chiếu " + showTimeId + " không tồn tại.");
            } else {
                bookedSeats = ticketDAO.getBookedSeats(showTimeId);
            }
        }

        request.setAttribute("movieId", movieId);
        request.setAttribute("showTimeId", showTimeId);
        request.setAttribute("bookedSeats", bookedSeats);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/manager/seatSelection.jsp");
        dispatcher.forward(request, response);
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String userEmail = (String) request.getSession().getAttribute("userEmail");
        if (userEmail == null || userEmail.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=pleaseLogin");
            return;
        }

        String movieId = request.getParameter("movieId");
        String showTimeId = request.getParameter("showTimeId");
        String[] seats = request.getParameterValues("seats");

        if (movieId == null || movieId.trim().isEmpty() || showTimeId == null || showTimeId.trim().isEmpty() || seats == null || seats.length == 0) {
            request.setAttribute("error", "Vui lòng chọn phim, suất chiếu và ít nhất một ghế.");
            selectSeats(request, response);
            return;
        }

        if (showTimeId.length() > 5) {
            request.setAttribute("error", "ShowTimeID vượt quá độ dài cho phép (tối đa 5 ký tự).");
            selectSeats(request, response);
            return;
        }

        if (!ticketDAO.isShowTimeIdValid(showTimeId)) {
            request.setAttribute("error", "Suất chiếu " + showTimeId + " không tồn tại.");
            selectSeats(request, response);
            return;
        }

        List<String> bookedSeats = ticketDAO.getBookedSeats(showTimeId);
        for (String seat : seats) {
            if (bookedSeats.contains(seat.trim())) {
                request.setAttribute("error", "Ghế " + seat + " đã được đặt bởi người khác.");
                selectSeats(request, response);
                return;
            }
        }

        List<Ticket> cart = getOrCreateCart(request);
        for (String seat : seats) {
            for (Ticket existingTicket : cart) {
                if (existingTicket.getShowTimeID().equals(showTimeId) && existingTicket.getSeatNumber().equals(seat.trim())) {
                    request.setAttribute("error", "Ghế " + seat + " cho suất chiếu " + showTimeId + " đã có trong giỏ hàng.");
                    selectSeats(request, response);
                    return;
                }
            }
        }

        Movie movie = movieDAO.getMovieById(movieId);
        if (movie == null) {
            request.setAttribute("error", "Phim không tồn tại.");
            selectSeats(request, response);
            return;
        }

        String newTicketId;
        try {
            String maxId = ticketDAO.getMaxTicketId();
            int num = (maxId != null) ? Integer.parseInt(maxId.replace("T", "")) + 1 : 1;
            newTicketId = String.format("T%03d", num);

            while (ticketDAO.isTicketIdExists(newTicketId) || isTicketIdInCart(cart, newTicketId)) {
                num++;
                newTicketId = String.format("T%03d", num);
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi tạo mã vé: " + e.getMessage());
        }

        String customerID;
        try {
            customerID = customerDao.getCustomerIdByEmail(userEmail);
            if (customerID == null) {
                customerID = customerDao.createCustomer(userEmail);
                if (customerID == null || customerID.length() > 5) {
                    throw new SQLException("Không thể tạo mã khách hàng hợp lệ.");
                }
            } else if (customerID.length() > 5) {
                throw new SQLException("Mã khách hàng vượt quá độ dài cho phép.");
            }
        } catch (SQLException e) {
            throw new SQLException("Lỗi xử lý khách hàng: " + e.getMessage());
        }

        for (String seat : seats) {
            String ticketID = newTicketId;
            Date bookingTime = new Date();
            String status = "Pending";
            int quantity = 1;

            Ticket ticket = new Ticket(ticketID, showTimeId, customerID, seat.trim(), bookingTime, status, movieId, quantity);
            cart.add(ticket);

            newTicketId = generateNextTicketId(newTicketId);
            while (ticketDAO.isTicketIdExists(newTicketId) || isTicketIdInCart(cart, newTicketId)) {
                newTicketId = generateNextTicketId(newTicketId);
            }
        }

        request.getSession().setAttribute("cart", cart);
        response.sendRedirect("cart?action=view");
    }

    private void handleAddToCartError(HttpServletRequest request, HttpServletResponse response, SQLException e)
            throws ServletException, IOException, SQLException {
        String errorMessage = e.getMessage();
        if (errorMessage.contains("Lỗi tạo mã vé")) {
            request.setAttribute("error", "Không thể tạo mã vé. Vui lòng thử lại.");
        } else if (errorMessage.contains("Lỗi xử lý khách hàng")) {
            request.setAttribute("error", "Không thể xử lý thông tin khách hàng. Vui lòng thử lại.");
        } else {
            request.setAttribute("error", "Lỗi thêm vé: " + e.getMessage());
        }
        selectSeats(request, response);
    }

    private String generateNextTicketId(String currentId) {
        int num = Integer.parseInt(currentId.replace("T", "")) + 1;
        return String.format("T%03d", num);
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ticketID = request.getParameter("ticketID");

        if (ticketID != null) {
            List<Ticket> cart = getOrCreateCart(request);
            cart.removeIf(ticket -> ticket.getTicketID().equals(ticketID));
            request.getSession().setAttribute("cart", cart);
        }
        response.sendRedirect("cart?action=view");
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ticketID = request.getParameter("ticketID");
        int quantity = parseIntParameter(request, "quantity", 1);

        if (ticketID != null && quantity >= 0) {
            List<Ticket> cart = getOrCreateCart(request);
            for (Ticket ticket : cart) {
                if (ticket.getTicketID().equals(ticketID)) {
                    ticket.setQuantity(quantity);
                    if (quantity == 0) {
                        cart.remove(ticket);
                    }
                    break;
                }
            }
            request.getSession().setAttribute("cart", cart);
        }
        response.sendRedirect("cart?action=view");
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("cart");
        response.sendRedirect("cart?action=view");
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/manager/shoppingCart.jsp");
        dispatcher.forward(request, response);
    }

    @SuppressWarnings("unchecked")
    private List<Ticket> getOrCreateCart(HttpServletRequest request) {
        HttpSession session = request.getSession();
        List<Ticket> cart = (List<Ticket>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private int parseIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        try {
            String paramValue = request.getParameter(paramName);
            if (paramValue != null && !paramValue.trim().isEmpty()) {
                return Integer.parseInt(paramValue);
            }
        } catch (NumberFormatException e) {
            // Log lỗi nếu cần
        }
        return defaultValue;
    }

    private boolean isTicketIdInCart(List<Ticket> cart, String ticketId) {
        for (Ticket ticket : cart) {
            if (ticket.getTicketID().equals(ticketId)) {
                return true;
            }
        }
        return false;
    }

    private void viewTicketHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String userEmail = (String) request.getSession().getAttribute("userEmail");
        if (userEmail == null || userEmail.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=pleaseLogin");
            return;
        }

        List<Ticket> ticketHistory = ticketDAO.getTicketHistoryByEmail(userEmail);
        Set<String> movieIds = new HashSet<>();
        for (Ticket ticket : ticketHistory) {
            String movieId = ticket.getMovieID();
            if (movieId != null) {
                movieIds.add(movieId);
            }
        }

        Map<String, String> movieTitles = new HashMap<>();
        for (String movieId : movieIds) {
            Movie movie = movieDAO.getMovieById(movieId);
            if (movie != null && movie.getMovieTitle() != null) {
                movieTitles.put(movieId, movie.getMovieTitle());
            }
        }

        if (ticketHistory == null || ticketHistory.isEmpty()) {
            request.setAttribute("error", "Không tìm thấy lịch sử đặt vé cho email: " + userEmail);
        } else {
            request.setAttribute("ticketHistory", ticketHistory);
            request.setAttribute("movieTitles", movieTitles);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/manager/ticketHistory.jsp");
        dispatcher.forward(request, response);
    }

    private void viewAllTicketHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        if (userEmail == null || role == null || (!"Manager".equalsIgnoreCase(role) && !"Employee".equalsIgnoreCase(role))) {
            response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=adminAccessRequired");
            return;
        }

        List<Ticket> allTicketHistory = ticketDAO.getAllTicketHistory();
        Set<String> customerIds = new HashSet<>();
        Set<String> movieIds = new HashSet<>();
        for (Ticket ticket : allTicketHistory) {
            customerIds.add(ticket.getCustomerID());
            movieIds.add(ticket.getMovieID());
        }

        Map<String, String> customerEmails = new HashMap<>();
        for (String customerId : customerIds) {
            String email = customerDao.getEmailByCustomerId(customerId);
            if (email != null) {
                customerEmails.put(customerId, email);
            }
        }

        Map<String, String> movieTitles = new HashMap<>();
        for (String movieId : movieIds) {
            Movie movie = movieDAO.getMovieById(movieId);
            if (movie != null && movie.getMovieTitle() != null) {
                movieTitles.put(movieId, movie.getMovieTitle());
            }
        }

        if (allTicketHistory == null || allTicketHistory.isEmpty()) {
            request.setAttribute("error", "Không có lịch sử đặt vé nào trong hệ thống.");
        } else {
            request.setAttribute("allTicketHistory", allTicketHistory);
            request.setAttribute("customerEmails", customerEmails);
            request.setAttribute("movieTitles", movieTitles);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/manager/adminTicketHistory.jsp"); // Cập nhật đường dẫn
        dispatcher.forward(request, response);
    }

    private void deleteTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        if (userEmail == null || role == null || (!"Manager".equalsIgnoreCase(role) && !"Employee".equalsIgnoreCase(role))) {
            response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=adminAccessRequired");
            return;
        }

        String ticketId = request.getParameter("ticketId");
        if (ticketId != null) {
            ticketDAO.deleteTicket(ticketId);
            response.sendRedirect("cart?action=adminHistory&message=TicketDeleted");
        } else {
            request.setAttribute("error", "Không tìm thấy mã vé để xóa.");
            viewAllTicketHistory(request, response);
        }
    }
}
