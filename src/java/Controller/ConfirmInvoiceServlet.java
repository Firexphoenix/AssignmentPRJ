package Controller;

import Model.Invoice;
import invoiceDao.InvoiceDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "ConfirmInvoiceServlet", urlPatterns = {"/confirmInvoice"})
public class ConfirmInvoiceServlet extends HttpServlet {

    private InvoiceDao invoiceDao;

    @Override
    public void init() throws ServletException {
        invoiceDao = new InvoiceDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;

        if (userEmail == null) {
            response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=pleaseLogin");
            return;
        }

        Invoice invoice = (Invoice) session.getAttribute("pendingInvoice");
        String invoiceId = request.getParameter("invoiceId");

        if (invoice == null || invoiceId == null || !invoiceId.equals(invoice.getInvoiceID())) {
            response.sendRedirect(request.getContextPath() + "/cart?action=view");
            return;
        }

        try {
            // Cập nhật trạng thái hóa đơn thành "Paid"
            invoice.setStatus("Paid");

            // Lưu hóa đơn vào database
            invoiceDao.insertInvoice(invoice);

            // Xóa thông tin hóa đơn và vé khỏi session
            session.removeAttribute("pendingInvoice");
            session.removeAttribute("cartTickets");

            // Chuyển hướng đến trang xác nhận thành công
            session.setAttribute("paymentSuccess", true);
            response.sendRedirect(request.getContextPath() + "/manager/checkout.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi xác nhận hóa đơn: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/invoice.jsp");
        }
    }
}
