<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tìm kiếm Phim</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            h2, h3 {
                color: #333;
            }
            form {
                margin-bottom: 20px;
            }
            input {
                margin: 5px;
                padding: 5px;
            }
            button {
                padding: 5px 10px;
                background-color: #4CAF50;
                color: white;
                border: none;
                cursor: pointer;
            }
            button:hover {
                background-color: #45a049;
            }
            ul {
                list-style-type: none;
                padding: 0;
            }
            li {
                border: 1px solid #ddd;
                margin-bottom: 10px;
                padding: 10px;
                background-color: #f9f9f9;
            }
        </style>
    </head>
    <body>
        <!-- Form tìm kiếm phim theo tên, thể loại và ngày phát hành -->
        <h2>Tìm kiếm phim</h2>
        <form action="searchMovies" method="get">
            <input type="text" name="title" placeholder="Nhập tên phim..." />
            <input type="text" name="genre" placeholder="Nhập thể loại..." />
            <input type="text" name="releaseDate" placeholder="Nhập ngày phát hành (yyyy-MM-dd)..." />
            <button type="submit">Tìm kiếm</button>
        </form>

        <!-- Hiển thị kết quả tìm kiếm -->
        <h3>Kết quả tìm kiếm:</h3>
        <c:if test="${not empty movies}">
            <ul>
                <c:forEach var="movie" items="${movies}">
                    <li>
                        <b>Tên phim:</b> ${movie.movieTitle}<br>
                        <b>Thể loại:</b> ${movie.movieGenre}<br>
                        <b>Ngày phát hành:</b> ${movie.releaseDate}<br>
                        <b>Đạo diễn:</b> ${movie.director}<br>
                        <b>Thời lượng:</b> ${movie.movieDuration} phút<br>
                        <b>Ngôn ngữ:</b> ${movie.language}<br>
                        <br>
                    </li>
                </c:forEach>
            </ul>
        </c:if>
        <c:if test="${empty movies}">
            <p>Không tìm thấy phim nào.</p>
        </c:if>
    </body>
</html>