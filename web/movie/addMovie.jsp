<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("role");

    if (userEmail == null || role == null || !"Manager".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=adminAccessRequired");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thêm phim mới - THVB Cinema</title>
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                font-family: 'Poppins', sans-serif;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                margin: 0;
                padding: 20px;
            }

            .form-container {
                background-color: #ffffff;
                padding: 2.5rem;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 550px;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .form-container:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
            }

            h2 {
                text-align: center;
                color: #d32f2f;
                font-weight: 600;
                margin-bottom: 1.5rem;
                position: relative;
            }

            h2::after {
                content: '';
                width: 50px;
                height: 3px;
                background: #d32f2f;
                position: absolute;
                bottom: -10px;
                left: 50%;
                transform: translateX(-50%);
            }

            .error {
                color: #dc3545;
                text-align: center;
                margin-bottom: 1rem;
                font-size: 0.9rem;
                font-weight: 500;
            }

            .form-label {
                font-weight: 500;
                color: #333;
                margin-bottom: 0.5rem;
            }

            .form-control {
                border-radius: 8px;
                border: 1px solid #ced4da;
                padding: 0.75rem;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }

            .form-control:focus {
                border-color: #d32f2f;
                box-shadow: 0 0 0 0.2rem rgba(211, 47, 47, 0.25);
            }

            .btn-primary {
                background-color: #d32f2f;
                border-color: #d32f2f;
                border-radius: 8px;
                padding: 0.75rem;
                font-weight: 500;
                transition: background-color 0.3s ease, transform 0.2s ease;
            }

            .btn-primary:hover {
                background-color: #b71c1c;
                border-color: #b71c1c;
                transform: translateY(-2px);
            }

            .btn-primary:active {
                transform: translateY(0);
            }

            .back-link {
                display: block;
                text-align: center;
                margin-top: 1.5rem;
                color: #d32f2f;
                font-weight: 500;
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .back-link:hover {
                color: #b71c1c;
                text-decoration: underline;
            }

            .back-link i {
                margin-right: 5px;
            }
        </style>
    </head>
    <body>
        <div class="form-container">
            <h2>Thêm phim mới</h2>

            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>

            <form action="<%= request.getContextPath()%>/movies" method="post">
                <input type="hidden" name="action" value="add">

                <div class="mb-3">
                    <label for="movieTitle" class="form-label">Tên phim <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="movieTitle" name="movieTitle" required>
                </div>

                <div class="mb-3">
                    <label for="movieGenre" class="form-label">Thể loại <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="movieGenre" name="movieGenre" required>
                </div>

                <div class="mb-3">
                    <label for="releaseDate" class="form-label">Ngày phát hành</label>
                    <input type="date" class="form-control" id="releaseDate" name="releaseDate">
                </div>

                <div class="mb-3">
                    <label for="director" class="form-label">Đạo diễn</label>
                    <input type="text" class="form-control" id="director" name="director">
                </div>

                <div class="mb-3">
                    <label for="movieDuration" class="form-label">Thời lượng (phút) <span class="text-danger">*</span></label>
                    <input type="number" class="form-control" id="movieDuration" name="movieDuration" required min="1">
                </div>

                <div class="mb-3">
                    <label for="language" class="form-label">Ngôn ngữ <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" id="language" name="language" required>
                </div>

                <button type="submit" class="btn btn-primary w-100">Thêm phim</button>
            </form>

            <a href="<%= request.getContextPath()%>/movies" class="back-link"><i class="fas fa-arrow-left"></i> Quay lại danh sách phim</a>
        </div>

        <!-- Bootstrap 5 JS and Popper.js -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
    </body>
</html>