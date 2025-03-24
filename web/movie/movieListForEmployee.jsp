<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("role");

    if (userEmail == null || role == null || !"Employee".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login/login.jsp?error=accessDenied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách phim - THVB Cinema</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <style>
            body {
                background-color: #f5f5f5;
                font-family: "Roboto", sans-serif;
                color: #333;
            }

            .container {
                margin-top: 20px;
            }

            h1 {
                text-align: center;
                margin: 20px 0;
                color: #d32f2f;
            }

            table {
                width: 100%;
                margin: 20px 0;
            }

            .error {
                text-align: center;
                color: #d32f2f;
                margin: 20px 0;
            }

            .btn.red a {
                color: white;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Danh sách phim</h1>

            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>

            <c:if test="${not empty movieList}">
                <table class="striped">
                    <thead>
                        <tr>
                            <th>Mã phim</th>
                            <th>Tên phim</th>
                            <th>Thể loại</th>
                            <th>Ngày phát hành</th>
                            <th>Đạo diễn</th>
                            <th>Thời lượng (phút)</th>
                            <th>Ngôn ngữ</th>
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
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <c:if test="${empty movieList}">
                <p class="error">Không có phim nào trong hệ thống.</p>
            </c:if>

            <div class="button-group center">
                <div class="btn red"><a href="<%= request.getContextPath()%>/employee/empDashboard.jsp">Quay lại</a></div>
            </div>
        </div>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
    </body>
</html>