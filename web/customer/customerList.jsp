<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Customer Management Application</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <style>
            body {
                background-color: #f8f9fa; /* Màu nền nhẹ */
                font-family: 'Poppins', Arial, sans-serif;
            }
            .container {
                max-width: 1200px; /* Giới hạn chiều rộng */
                margin: 50px auto;
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
            .btn-warning {
                background-color: #ffc107;
                border-color: #ffc107;
            }
            .btn-danger {
                background-color: #dc3545;
                border-color: #dc3545;
            }
            .btn-warning:hover {
                background-color: #e0a800;
                border-color: #e0a800;
            }
            .btn-danger:hover {
                background-color: #c82333;
                border-color: #c82333;
            }
            .table th {
                background-color: #ff5722;
                color: #fff;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="text-center mb-4">
                <h1>Customer Management</h1>
                <a href="customers?action=create" class="btn btn-primary">Add New Customer</a>
            </div>

            <div class="table-responsive">
                <table class="table table-striped table-hover table-bordered">
                    <caption><h2>List of Customers</h2></caption>
                    <thead>
                        <tr>
                            <th>Customer ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone Number</th>
                            <th>Birthday</th>
                            <th>Gender</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="customer" items="${listCustomer}">
                            <tr>
                                <td><c:out value="${customer.customerID}"/></td>
                                <td><c:out value="${customer.customerName}"/></td>
                                <td><c:out value="${customer.email}"/></td>
                                <td><c:out value="${customer.phoneNumber}"/></td>
                                <td><c:out value="${customer.birthday}"/></td>
                                <td><c:out value="${customer.gender}"/></td>
                                <td>
                                    <a href="customers?action=edit&id=${customer.customerID}" class="btn btn-warning btn-sm">Edit</a>
                                    <a href="customers?action=delete&id=${customer.customerID}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="text-center mt-3">
                <a href="<%= request.getContextPath()%>/" class="btn btn-secondary">Home</a>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    </body>
</html>