package Controller;

import Model.Ticket;
import Model.Invoice;
import dao.DBconnection;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ticketDao.TicketDao;
import invoiceDao.InvoiceDao;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Random;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    private TicketDao ticketDao;
    private InvoiceDao invoiceDao;

    @Override
    public void init() throws ServletException {
        ticketDao = new TicketDao();
        invoiceDao = new InvoiceDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processCheckout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processCheckout(request, response);
    }

    private void processCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;

        if (userEmail == null) {
            response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=pleaseLogin");
            return;
        }

        List<Ticket> cart = (List<Ticket>) session.getAttribute("cart");
        String errorMessage = null;

        if (cart == null || cart.isEmpty()) {
            errorMessage = "Giỏ hàng của bạn hiện đang trống.";
            request.setAttribute("errorMessage", errorMessage);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/manager/checkout.jsp");
            dispatcher.forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            conn = DBconnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu giao dịch

            // Kiểm tra ShowTimeID và ghế đã đặt
            for (Ticket ticket : cart) {
                if (!ticketDao.isShowTimeIdValid(ticket.getShowTimeID())) {
                    errorMessage = "Suất chiếu " + ticket.getShowTimeID() + " không tồn tại.";
                    break;
                }

                List<String> bookedSeats = ticketDao.getBookedSeats(ticket.getShowTimeID());
                if (bookedSeats.contains(ticket.getSeatNumber())) {
                    errorMessage = "Ghế " + ticket.getSeatNumber() + " đã được đặt bởi người khác. Vui lòng chọn lại ghế.";
                    break;
                }

                // Kiểm tra xem ticket đã được lưu vào database chưa
                if (!ticketDao.isTicketIdExists(ticket.getTicketID())) {
                    ticketDao.insertTicket(ticket); // Lưu lại nếu chưa tồn tại
                }
            }

            // Nếu không có lỗi, tiến hành chuẩn bị dữ liệu để thanh toán qua VNPay
            if (errorMessage == null) {
                // Tạo hóa đơn tạm thời (chưa lưu vào database)
                Invoice invoice = createTemporaryInvoice(cart);

                // Tạo mã giao dịch cho VNPay
                String transactionId = "VNP" + System.currentTimeMillis() + new Random().nextInt(1000);

                // Lưu thông tin tạm thời vào session để sử dụng sau khi thanh toán
                session.setAttribute("pendingInvoice", invoice);
                session.setAttribute("pendingCart", cart);
                session.setAttribute("pendingTransactionId", transactionId);

                conn.commit(); // Xác nhận giao dịch

                // Chuyển hướng đến VNPayServlet để thanh toán
                response.sendRedirect(request.getContextPath() + "/vnpay?action=pay&invoiceId=" + invoice.getInvoiceID() + "&amount=" + invoice.getTotal() + "&transactionId=" + transactionId);
                session.removeAttribute("cart"); // Xóa giỏ hàng
                return;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu có lỗi
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            errorMessage = "Lỗi kiểm tra dữ liệu: " + e.getMessage();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        request.setAttribute("errorMessage", errorMessage);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/manager/checkout.jsp");
        dispatcher.forward(request, response);
    }

    private Invoice createTemporaryInvoice(List<Ticket> cart) throws SQLException {
        // Tạo InvoiceID mới
        String newInvoiceId;
        String maxId = invoiceDao.getMaxInvoiceId();
        int num = (maxId != null) ? Integer.parseInt(maxId.replace("I", "")) + 1 : 1;
        newInvoiceId = String.format("I%03d", num);
        while (invoiceDao.isInvoiceIdExists(newInvoiceId)) {
            num++;
            newInvoiceId = String.format("I%03d", num);
        }

        // Tính tổng tiền
        double total = 0.0;
        for (Ticket ticket : cart) {
            String screenRoomType = ticketDao.getScreenRoomType(ticket.getShowTimeID());
            double ticketPrice = "3D".equals(screenRoomType) ? 0.15 : 0.1; // Giá vé: 0.15 triệu cho 3D, 0.1 triệu cho 2D
            total += ticketPrice * ticket.getQuantity();
        }

        // Lấy ngày và giờ hiện tại
        Date now = new Date();
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
        String time = timeFormat.format(now);

        // Lấy TicketID từ vé đầu tiên trong giỏ hàng
        String ticketId = cart.get(0).getTicketID();

        // Tạo hóa đơn với trạng thái "Paid"
        Invoice invoice = new Invoice(newInvoiceId, ticketId, now, time, total, "Paid");
        return invoice;
    }
}
