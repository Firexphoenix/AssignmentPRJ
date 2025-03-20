package listener;

import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

@WebListener
public class SessionCounterListener implements HttpSessionListener {

    private static int totalActiveSessions = 0;  // Tổng số session đang hoạt động
    private static int loggedInUsers = 0;        // Số user đã login

    // Getter cho tổng số session
    public static int getTotalActiveSessions() {
        return totalActiveSessions;
    }

    // Getter cho số user đã login
    public static int getLoggedInUsers() {
        return loggedInUsers;
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        totalActiveSessions++;  // Tăng tổng số session bất kể login hay không
        // Không kiểm tra userEmail ngay tại đây vì có thể chưa được set
        System.out.println("Session created. Total sessions: " + totalActiveSessions
                + ", Logged-in users: " + loggedInUsers);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        if (totalActiveSessions > 0) {
            totalActiveSessions--;  // Giảm tổng số session
            // Kiểm tra nếu session bị hủy là của user đã login
            if (se.getSession().getAttribute("userEmail") != null && loggedInUsers > 0) {
                loggedInUsers--;
            }
        }
        System.out.println("Session destroyed. Total sessions: " + totalActiveSessions
                + ", Logged-in users: " + loggedInUsers);
    }

    // Phương thức để tăng loggedInUsers khi login thành công
    public static void userLoggedIn() {
        loggedInUsers++;
        System.out.println("User logged in. Logged-in users: " + loggedInUsers);
    }

    // Phương thức để giảm loggedInUsers thủ công nếu cần
    public static void userLoggedOut() {
        if (loggedInUsers > 0) {
            loggedInUsers--;
            System.out.println("User logged out manually. Logged-in users: " + loggedInUsers);
        }
    }
}
