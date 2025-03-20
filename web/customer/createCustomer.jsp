<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Add New Customer</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <style>
            body {
                background-color: #f8f9fa; /* Màu nền nhẹ */
                font-family: 'Poppins', Arial, sans-serif;
            }
            .container {
                max-width: 600px; /* Giới hạn chiều rộng form */
                margin-top: 50px;
                padding: 20px;
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            h1, h2 {
                color: #ff5722; /* Màu cam nổi bật */
            }
            .btn-primary {
                background-color: #ff5722;
                border-color: #ff5722;
            }
            .btn-primary:hover {
                background-color: #e64a19;
                border-color: #e64a19;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="text-center mb-4">
                <h1>Customer Management</h1>
                <h2>Add New Customer</h2>
            </div>

            <form method="post" action="customers?action=create">
                <div class="mb-3">
                    <label for="id" class="form-label">Customer ID (CM###):</label>
                    <input type="text" class="form-control" name="id" id="id" pattern="CM\d{3}" title="Format: CM### (e.g., CM123)" required />
                </div>

                <div class="mb-3">
                    <label for="name" class="form-label">Customer Name:</label>
                    <input type="text" class="form-control" name="name" id="name" required />
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Email:</label>
                    <input type="email" class="form-control" name="email" id="email" required />
                </div>

                <div class="mb-3">
                    <label for="phoneNumber" class="form-label">Phone Number:</label>
                    <input type="text" class="form-control" name="phoneNumber" id="phoneNumber" pattern="\d{10,12}" title="Enter a valid phone number (10-12 digits)" required />
                </div>

                <div class="mb-3">
                    <label for="gender" class="form-label">Gender:</label>
                    <select class="form-select" name="gender" id="gender" required>
                        <option value="Nam">Nam</option>
                        <option value="Nữ">Nữ</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="birthday" class="form-label">Birthday:</label>
                    <input type="date" class="form-control" name="birthday" id="birthday" required />
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password:</label>
                    <input type="password" class="form-control" name="password" id="password" minlength="6" placeholder="Default: 123456" required />
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary">Save</button>
                </div>
            </form>
        </div>
        <div class="text-center mt-3">
            <a href="<%= request.getContextPath()%>/" class="btn btn-secondary">Back</a>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    </body>
</html>