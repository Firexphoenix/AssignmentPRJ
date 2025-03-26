<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Add New Employee</title>
        <style>
            /* Reset mặc định */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', Arial, sans-serif;
            }

            body {
                background-color: #1a1a1a; /* Màu nền tối */
                color: #f4e4ba; /* Màu chữ sáng */
                line-height: 1.6;
                font-size: 16px;
                padding: 20px;
                display: flex;
                flex-direction: column;
                align-items: center;
                min-height: 100vh;
            }

            /* Tiêu đề chính */
            h1 {
                font-size: 36px;
                font-weight: bold;
                color: #d4af37; /* Màu vàng nổi bật */
                margin-bottom: 10px;
                text-align: center;
            }

            /* Tiêu đề phụ và liên kết */
            h2 {
                font-size: 24px;
                margin-bottom: 20px;
                text-align: center;
            }

            h2 a {
                color: #f4e4ba;
                text-decoration: none;
                padding: 8px 16px;
                border-radius: 20px;
                background: linear-gradient(45deg, #ffcc00, #ff6600);
                transition: all 0.3s ease;
            }

            h2 a:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(255, 204, 0, 0.6);
                color: #1a1a1a;
            }

            /* Container chính */
            .form-container {
                background: #2f2525; /* Màu nền tối cho form */
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
                width: 100%;
                max-width: 600px; /* Giới hạn chiều rộng tối đa */
                margin: 0 auto;
            }

            /* Tiêu đề của form */
            caption h2 {
                font-size: 28px;
                color: #d4af37;
                margin-bottom: 20px;
            }

            /* Bảng */
            table {
                width: 100%;
                border-collapse: collapse;
                background: #3b2f2f; /* Màu nền cho bảng */
                border-radius: 10px;
                overflow: hidden;
            }

            th, td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid #4a3f35; /* Đường viền nhẹ giữa các hàng */
            }

            th {
                background: #4a3f35; /* Màu nền cho tiêu đề cột */
                color: #f4e4ba;
                font-weight: bold;
                width: 30%; /* Đảm bảo cột tiêu đề không quá rộng */
            }

            td {
                background: #2f2525; /* Màu nền cho ô dữ liệu */
            }

            /* Input, Select */
            input[type="text"],
            input[type="number"],
            input[type="email"],
            input[type="date"],
            input[type="password"],
            select {
                width: 100%;
                padding: 10px;
                border: none;
                border-radius: 5px;
                background: #4a3f35;
                color: #f4e4ba;
                font-size: 14px;
                outline: none;
                transition: all 0.3s ease;
            }

            input[type="text"]:focus,
            input[type="number"]:focus,
            input[type="email"]:focus,
            input[type="date"]:focus,
            input[type="password"]:focus,
            select:focus {
                background: #5a4f45;
                box-shadow: 0 0 5px rgba(255, 204, 0, 0.5);
            }

            /* Nút Submit */
            input[type="submit"] {
                background: linear-gradient(45deg, #ffcc00, #ff6600);
                border: none;
                padding: 12px 30px;
                border-radius: 25px;
                font-size: 16px;
                font-weight: bold;
                color: #1a1a1a;
                cursor: pointer;
                transition: all 0.3s ease;
                width: 100%;
                max-width: 200px;
                margin-top: 10px;
            }

            input[type="submit"]:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(255, 204, 0, 0.6);
            }

            /* Responsive design */
            @media (max-width: 768px) {
                .form-container {
                    padding: 20px;
                }

                th, td {
                    display: block;
                    width: 100%;
                    text-align: center;
                }

                th {
                    background: #4a3f35;
                    border-bottom: none;
                }

                td {
                    border-bottom: 1px solid #4a3f35;
                }

                input[type="submit"] {
                    max-width: 100%;
                }
            }
        </style>
    </head>
    <body>
    <center>
        <h1>Employee Management</h1>
        <h2><a href="employees?action=employees">List All Employees</a></h2>
    </center>

    <div align="center">
        <form method="post" action="employees?action=create">
            <table border="1" cellpadding="5">
                <caption><h2>Add New Employee</h2></caption>

                <tr>
                    <th>Employee ID (E###):</th>
                    <td>
                        <input type="text" name="id" id="id" pattern="E\d{3}" title="Format: E### (e.g., E123)" required />
                    </td>
                </tr>

                <tr>
                    <th>Employee Name:</th>
                    <td>
                        <input type="text" name="name" id="name" required />
                    </td>
                </tr>

                <tr>
                    <th>Salary:</th>
                    <td>
                        <input type="number" name="salary" id="salary" step="0.01" min="0" value="0" required />
                    </td>
                </tr>

                <tr>
                    <th>Phone Number:</th>
                    <td>
                        <input type="text" name="phoneNumber" id="phoneNumber" pattern="\d{10,12}" title="Enter a valid phone number (10-12 digits)" required />
                    </td>
                </tr>

                <tr>
                    <th>Email:</th>
                    <td>
                        <input type="email" name="email" id="email" required />
                    </td>
                </tr>

                <tr>
                    <th>Gender:</th>
                    <td>
                        <select name="gender" id="gender" required>
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                        </select>
                    </td>
                </tr>

                <tr>
                    <th>Birthday:</th>
                    <td>
                        <input type="date" name="birthday" id="birthday" required />
                    </td>
                </tr>

                <tr>
                    <th>Hire Date:</th>
                    <td>
                        <input type="date" name="hireDate" id="hireDate" required />
                    </td>
                </tr>

                <tr>
                    <th>Address:</th>
                    <td>
                        <input type="text" name="address" id="address" required />
                    </td>
                </tr>

                <tr>
                    <th>Password:</th>
                    <td>
                        <input type="password" name="password" id="password" minlength="6" placeholder="Default: 123456" />
                    </td>
                </tr>

                <tr>
                    <th>Role:</th>
                    <td>
                        <select name="role" id="role">
                            <option value="Employee" selected>Employee</option>
                            <option value="Manager">Manager</option>
                        </select>
                    </td>
                </tr>

                <tr>
                    <th>Cinema ID:</th>
                    <td>
                        <input type="text" name="cinemaID" id="cinemaID" required />
                    </td>
                </tr>

                <tr>
                    <td colspan="2" align="center">
                        <input type="submit" value="Save" />
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
