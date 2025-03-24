<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - THVB Cinema</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
    <style>
        body {
            background-color: #f5f5f5;
            font-family: "Roboto", sans-serif;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        h2 {
            text-align: center;
            color: #d32f2f;
            margin-bottom: 20px;
        }

        .error {
            color: #d32f2f;
            text-align: center;
            margin-bottom: 15px;
        }

        .success {
            color: #4caf50;
            text-align: center;
            margin-bottom: 15px;
        }

        .btn {
            width: 100%;
            background-color: #d32f2f;
        }

        .btn:hover {
            background-color: #b71c1c;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Đổi mật khẩu</h2>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <p class="error"><%= request.getAttribute("errorMessage") %></p>
        <% } %>

        <% if (request.getAttribute("successMessage") != null) { %>
            <p class="success"><%= request.getAttribute("successMessage") %></p>
        <% } %>

        <form action="<%= request.getContextPath()%>/login" method="post">
            <input type="hidden" name="action" value="changePassword">
            <div class="input-field">
                <input type="password" id="oldPassword" name="oldPassword" required>
                <label for="oldPassword">Mật khẩu cũ</label>
            </div>
            <div class="input-field">
                <input type="password" id="newPassword" name="newPassword" required>
                <label for="newPassword">Mật khẩu mới</label>
            </div>
            <div class="input-field">
                <input type="password" id="confirmPassword" name="confirmPassword" required>
                <label for="confirmPassword">Xác nhận mật khẩu mới</label>
            </div>
            <button type="submit" class="btn">Đổi mật khẩu</button>
        </form>

        <div class="center" style="margin-top: 15px;">
            <a href="<%= request.getContextPath()%>/login" class="red-text">Quay lại đăng nhập</a>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
</body>
</html>