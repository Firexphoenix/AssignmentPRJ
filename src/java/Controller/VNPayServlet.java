package Controller;

import dao.DBconnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;

@WebServlet(name = "VNPayServlet", urlPatterns = {"/vnpay"})
public class VNPayServlet extends HttpServlet {

    // Thông tin cấu hình VNPay (thay bằng thông tin thật từ VNPay)
    private static final String VNP_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    private static final String VNP_TMNCODE = "YWPONW6H"; // Thay bằng mã TmnCode của bạn
    private static final String VNP_HASH_SECRET = "LVL99H2HKL3957TXM1UJ94LNJ4QS59ND"; // Thay bằng secret key của bạn
    private static final String VNP_RETURN_URL = "http://localhost:8080/CinemaTicketBooking/vnpay?action=return";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("pay".equals(action)) {
            processPaymentRequest(request, response);
        } else if ("return".equals(action)) {
            processPaymentReturn(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void processPaymentRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String invoiceId = request.getParameter("invoiceId");
        String amountStr = request.getParameter("amount");

        if (invoiceId == null || amountStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing invoiceId or amount");
            return;
        }

        // Chuyển đổi amount sang VND (VNPay yêu cầu đơn vị là VND, không có số thập phân)
        long amount;
        try {
            amount = (long) (Double.parseDouble(amountStr) * 100); // Nhân 100 vì VNPay yêu cầu đơn vị là đồng
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid amount");
            return;
        }

        // Tạo mã giao dịch duy nhất
        String transactionId = "VNP" + System.currentTimeMillis() + new Random().nextInt(1000);

        // Lưu giao dịch vào cơ sở dữ liệu với trạng thái Pending
        try (Connection conn = DBconnection.getConnection()) {
            String sql = "INSERT INTO PaymentTransaction (TransactionID, InvoiceID, Amount, TransactionStatus) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, transactionId);
            stmt.setString(2, invoiceId);
            stmt.setDouble(3, Double.parseDouble(amountStr));
            stmt.setString(4, "Pending");
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error saving transaction");
            return;
        }

        // Tạo các tham số cho VNPay
        Map<String, String> vnpParams = new HashMap<>();
        vnpParams.put("vnp_Version", "2.1.0");
        vnpParams.put("vnp_Command", "pay");
        vnpParams.put("vnp_TmnCode", VNP_TMNCODE);
        vnpParams.put("vnp_Amount", String.valueOf(amount));
        vnpParams.put("vnp_CurrCode", "VND");
        vnpParams.put("vnp_TxnRef", transactionId);
        vnpParams.put("vnp_OrderInfo", "Thanh toan hoa don " + invoiceId);
        vnpParams.put("vnp_OrderType", "billpayment");
        vnpParams.put("vnp_Locale", "vn");
        vnpParams.put("vnp_ReturnUrl", VNP_RETURN_URL);
        vnpParams.put("vnp_IpAddr", getClientIp(request));

        // Tạo thời gian giao dịch
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnpCreateDate = formatter.format(new Date());
        vnpParams.put("vnp_CreateDate", vnpCreateDate);

        // Sắp xếp các tham số và tạo chuỗi hash
        List<String> fieldNames = new ArrayList<>(vnpParams.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnpParams.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                hashData.append(fieldName).append("=").append(fieldValue);
                query.append(URLEncoder.encode(fieldName, StandardCharsets.UTF_8))
                        .append("=")
                        .append(URLEncoder.encode(fieldValue, StandardCharsets.UTF_8));
                if (itr.hasNext()) {
                    hashData.append("&");
                    query.append("&");
                }
            }
        }

        // Tạo chữ ký (secure hash)
        String vnpSecureHash = hmacSHA512(VNP_HASH_SECRET, hashData.toString());
        query.append("&vnp_SecureHash=").append(vnpSecureHash);

        // Tạo URL thanh toán và chuyển hướng
        String paymentUrl = VNP_PAY_URL + "?" + query.toString();
        response.sendRedirect(paymentUrl);
    }

    private void processPaymentReturn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, String> vnpParams = new HashMap<>();
        for (String paramName : request.getParameterMap().keySet()) {
            if (paramName != null && paramName.startsWith("vnp_")) {
                vnpParams.put(paramName, request.getParameter(paramName));
            }
        }

        String vnpSecureHash = vnpParams.get("vnp_SecureHash");
        vnpParams.remove("vnp_SecureHash");

        // Sắp xếp các tham số để kiểm tra chữ ký
        List<String> fieldNames = new ArrayList<>(vnpParams.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnpParams.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                hashData.append(fieldName).append("=").append(fieldValue);
                if (itr.hasNext()) {
                    hashData.append("&");
                }
            }
        }

        // Kiểm tra chữ ký
        String calculatedHash = hmacSHA512(VNP_HASH_SECRET, hashData.toString());
        if (!calculatedHash.equals(vnpSecureHash)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid secure hash");
            return;
        }

        String transactionId = vnpParams.get("vnp_TxnRef");
        String responseCode = vnpParams.get("vnp_ResponseCode");
        String vnpTransactionNo = vnpParams.get("vnp_TransactionNo");
        String bankCode = vnpParams.get("vnp_BankCode");

        // Cập nhật trạng thái giao dịch
        String transactionStatus = "Failed";
        if ("00".equals(responseCode)) {
            transactionStatus = "Success";
        } else if ("24".equals(responseCode)) {
            transactionStatus = "Cancelled";
        }

        try (Connection conn = DBconnection.getConnection()) {
            String sql = "UPDATE PaymentTransaction SET TransactionStatus = ?, VNPayResponseCode = ?, VNPayBankCode = ?, VNPayTransactionNo = ? WHERE TransactionID = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, transactionStatus);
            stmt.setString(2, responseCode);
            stmt.setString(3, bankCode);
            stmt.setString(4, vnpTransactionNo);
            stmt.setString(5, transactionId);
            stmt.executeUpdate();

            // Nếu giao dịch thành công, cập nhật trạng thái Invoice và Ticket
            if ("Success".equals(transactionStatus)) {
                sql = "UPDATE Invoice SET Status = 'Paid' WHERE InvoiceID = (SELECT InvoiceID FROM PaymentTransaction WHERE TransactionID = ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, transactionId);
                stmt.executeUpdate();

                sql = "UPDATE Ticket SET Status = 'Paid' WHERE TicketID = (SELECT TicketID FROM Invoice WHERE InvoiceID = (SELECT InvoiceID FROM PaymentTransaction WHERE TransactionID = ?))";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, transactionId);
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating transaction");
            return;
        }

        // Chuyển hướng người dùng về trang giỏ hàng với thông báo
        String message = "Thanh toán " + ("Success".equals(transactionStatus) ? "thành công" : "thất bại") + ". Mã giao dịch: " + transactionId;
        response.sendRedirect("cart?action=view&message=" + URLEncoder.encode(message, StandardCharsets.UTF_8));
    }

    private String hmacSHA512(String key, String data) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            byte[] hash = md.digest((key + data).getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error generating HMAC SHA512", e);
        }
    }

    private String getClientIp(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-FORWARDED-FOR");
        if (ipAddress == null || ipAddress.isEmpty()) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
    }
}
