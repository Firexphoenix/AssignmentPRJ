<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Add New Employee</title>
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
