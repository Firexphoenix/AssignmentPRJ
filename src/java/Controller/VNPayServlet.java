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
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

@WebServlet(name = "VNPayServlet", urlPatterns = {"/vnpay"})
public class VNPayServlet extends HttpServlet {

    // Thông tin cấu hình VNPay
    private static final String VNP_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    private static final String VNP_TMNCODE = "YWPONW6H";
    private static final String VNP_HASH_SECRET = "LVL99H2HKL3957TXM1UJ94LNJ4QS59ND";
    // Cập nhật URL công khai tại đây
    private static final String VNP_RETURN_URL = "http://localhost:8080/CinemaTicketBooking/vnpay?action=return"; // Thay bằng URL công khai của bạn

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
        String transactionId = request.getParameter("transactionId");

        if (invoiceId == null || amountStr == null || transactionId == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing invoiceId, amount, or transactionId");
            return;
        }

        // Chuyển đổi amount sang VND (VNPay yêu cầu đơn vị là VND, không có số thập phân)
        long amount;
        try {
            double totalInMillionVND = Double.parseDouble(amountStr);
            double totalInVND = totalInMillionVND * 1_000_000;
            amount = (long) (totalInVND * 100);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid amount");
            return;
        }

        // Kiểm tra số tiền hợp lệ
        if (amount < 500000 || amount >= 100_000_000_000L) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Số tiền không hợp lệ. Số tiền hợp lệ từ 5,000 đến dưới 1 tỷ đồng.");
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
        vnpParams.put("vnp_OrderInfo", "ThanhToanHoaDon" + invoiceId);
        vnpParams.put("vnp_OrderType", "billpayment");
        vnpParams.put("vnp_Locale", "vn");
        vnpParams.put("vnp_ReturnUrl", VNP_RETURN_URL);
        vnpParams.put("vnp_IpAddr", getClientIp(request));

        // Tạo thời gian giao dịch
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        String vnpCreateDate = formatter.format(cld.getTime());
        vnpParams.put("vnp_CreateDate", vnpCreateDate);

        // Thêm vnp_ExpireDate (hết hạn sau 15 phút)
        cld.add(Calendar.MINUTE, 15);
        String vnpExpireDate = formatter.format(cld.getTime());
        vnpParams.put("vnp_ExpireDate", vnpExpireDate);

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
                hashData.append(fieldName).append("=").append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
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

        // Debug: In ra chuỗi hash và chữ ký
        System.out.println("Hash Data: " + hashData.toString());
        System.out.println("Secure Hash: " + vnpSecureHash);

        query.append("&vnp_SecureHash=").append(vnpSecureHash);

        // Tạo URL thanh toán và chuyển hướng
        String paymentUrl = VNP_PAY_URL + "?" + query.toString();
        System.out.println("Payment URL: " + paymentUrl);
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
                hashData.append(fieldName).append("=").append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
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
            transactionStatus = "Paid";
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

            // Nếu giao dịch thất bại hoặc bị hủy, cập nhật trạng thái Invoice và Ticket
            if (!"Paid".equals(transactionStatus)) {
                sql = "UPDATE Invoice SET Status = ? WHERE InvoiceID = (SELECT InvoiceID FROM PaymentTransaction WHERE TransactionID = ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, "Cancelled");
                stmt.setString(2, transactionId);
                stmt.executeUpdate();

                sql = "UPDATE Ticket SET Status = 'Cancelled' WHERE TicketID = (SELECT TicketID FROM Invoice WHERE InvoiceID = (SELECT InvoiceID FROM PaymentTransaction WHERE TransactionID = ?))";
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
        String message = "Thanh toán " + ("Paid".equals(transactionStatus) ? "thành công" : "thất bại") + ". Mã giao dịch: " + transactionId;
        response.sendRedirect("cart?action=view&message=" + URLEncoder.encode(message, StandardCharsets.UTF_8));
    }

    private String hmacSHA512(String key, String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            mac.init(secretKeySpec);
            byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            return bytesToHex(hash);
        } catch (Exception e) {
            throw new RuntimeException("Error generating HMAC SHA512", e);
        }
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder hexString = new StringBuilder();
        for (byte b : bytes) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString().toLowerCase();
    }

    private String getClientIp(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-FORWARDED-FOR");
        if (ipAddress == null || ipAddress.isEmpty()) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
    }
}