<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <title>Quản lý phim - THVB Cinema</title>
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                font-family: 'Poppins', sans-serif;
                min-height: 100vh;
                margin: 0;
                padding: 20px;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 2rem 0;
            }

            h1 {
                text-align: center;
                color: #d32f2f;
                font-weight: 600;
                margin-bottom: 2rem;
                position: relative;
            }

            h1::after {
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
                text-align: center;
                color: #dc3545;
                font-size: 1rem;
                font-weight: 500;
                margin-bottom: 1.5rem;
            }

            .success {
                text-align: center;
                color: #28a745;
                font-size: 1rem;
                font-weight: 500;
                margin-bottom: 1.5rem;
            }

            .btn-primary {
                background-color: #d32f2f;
                border-color: #d32f2f;
                border-radius: 8px;
                padding: 0.5rem 1.5rem;
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

            .btn-action {
                border-radius: 6px;
                padding: 0.4rem 1rem;
                font-size: 0.9rem;
                transition: transform 0.2s ease;
            }

            .btn-action:hover {
                transform: translateY(-2px);
            }

            .btn-edit {
                background-color: #007bff;
                border-color: #007bff;
            }

            .btn-edit:hover {
                background-color: #0056b3;
                border-color: #0056b3;
            }

            .btn-delete {
                background-color: #dc3545;
                border-color: #dc3545;
            }

            .btn-delete:hover {
                background-color: #b71c1c;
                border-color: #b71c1c;
            }

            .table {
                background-color: #ffffff;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                overflow: hidden;
            }

            .table thead {
                background-color: #d32f2f;
                color: #ffffff;
            }

            .table thead th {
                font-weight: 600;
                padding: 1rem;
            }

            .table tbody tr {
                transition: background-color 0.3s ease;
            }

            .table tbody tr:hover {
                background-color: #f8f9fa;
            }

            .table tbody td {
                padding: 1rem;
                vertical-align: middle;
            }

            .action-buttons {
                display: flex;
                gap: 0.5rem;
            }

            .back-link {
                display: inline-block;
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
        <div class="container">
            <h1>Quản lý phim</h1>

            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>

            <c:if test="${param.message == 'MovieAdded'}">
                <p class="success">Thêm phim thành công!</p>
            </c:if>
            <c:if test="${param.message == 'MovieUpdated'}">
                <p class="success">Cập nhật phim thành công!</p>
            </c:if>
            <c:if test="${param.message == 'MovieDeleted'}">
                <p class="success">Xóa phim thành công!</p>
            </c:if>

            <div class="text-end mb-4">
                <a href="<%= request.getContextPath()%>/movies?action=add" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Thêm phim mới
                </a>
            </div>

            <c:if test="${not empty movieList}">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Mã phim</th>
                                <th>Tên phim</th>
                                <th>Thể loại</th>
                                <th>Ngày phát hành</th>
                                <th>Đạo diễn</th>
                                <th>Thời lượng (phút)</th>
                                <th>Ngôn ngữ</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="movie" items="${movieList}">
                                <tr>
                                    <td>${movie.movieID}</td>
                                    <td>${movie.movieTitle}</td>
                                    <td>${movie.movieGenre}</td>
                                    <td><fmt:formatDate value="${movie.releaseDate}" pattern="dd/MM/yyyy"/></td>
                                    <td>${movie.director}</td>
                                    <td>${movie.movieDuration}</td>
                                    <td>${movie.language}</td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="<%= request.getContextPath()%>/movies?action=edit&movieId=${movie.movieID}" class="btn btn-action btn-edit">
                                                <i class="fas fa-edit"></i> Sửa
                                            </a>
                                            <a href="<%= request.getContextPath()%>/movies?action=delete&movieId=${movie.movieID}" 
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa phim này?');" 
                                               class="btn btn-action btn-delete">
                                                <i class="fas fa-trash-alt"></i> Xóa
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

            <c:if test="${empty movieList}">
                <p class="error">Không có phim nào trong hệ thống.</p>
            </c:if>

            <div class="text-center">
                <a href="<%= request.getContextPath()%>/manager/managerDashboard.jsp" class="back-link">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>
        </div>

        <!-- Bootstrap 5 JS and Popper.js -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
    </body>
</html>