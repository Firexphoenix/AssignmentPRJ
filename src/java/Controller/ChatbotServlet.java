package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import org.apache.http.client.fluent.Request;
import org.apache.http.entity.ContentType;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@WebServlet(name = "ChatbotServlet", urlPatterns = {"/chatbot"})
public class ChatbotServlet extends HttpServlet {

    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userMessage = request.getParameter("message");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            response.getWriter().write("Vui lòng nhập tin nhắn!");
            return;
        }

        try {
            String apiKey = Constant.Iconstant.GEMINI_API_KEY;
            String apiResponse = Request.Post(GEMINI_API_URL + apiKey)
                    .bodyString(
                            "{\"contents\": [{\"parts\": [{\"text\": \"" + userMessage + "\"}]}]}",
                            ContentType.APPLICATION_JSON
                    )
                    .execute()
                    .returnContent()
                    .asString();

            // Sửa cách phân tích JSON cho tương thích với Gson cũ
            JsonParser parser = new JsonParser();
            JsonObject jsonObject = (JsonObject) parser.parse(apiResponse);
            String botReply = jsonObject.getAsJsonArray("candidates")
                    .get(0).getAsJsonObject()
                    .getAsJsonObject("content")
                    .getAsJsonArray("parts")
                    .get(0).getAsJsonObject()
                    .get("text")
                    .getAsString();

            response.setContentType("text/plain;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.print(botReply);
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Có lỗi khi xử lý: " + e.getMessage());
        }
    }
}
