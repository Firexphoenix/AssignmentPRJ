<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Customer, customerDao.CustomerDao, java.text.SimpleDateFormat" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    HttpSession userSession = request.getSession(false);
    String userEmail = (userSession != null) ? (String) userSession.getAttribute("userEmail") : null;
    String userRole = (userSession != null) ? (String) userSession.getAttribute("role") : null;

    if (userEmail == null || !"Customer".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/login/login.jsp");
        return;
    }

    CustomerDao customerDao = new CustomerDao();
    Customer customer = customerDao.getCustomerByEmail(userEmail);

    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/login/login.jsp");
        return;
    }

    request.setAttribute("customer", customer);

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    String birthdayFormatted = (customer.getBirthday() != null) ? sdf.format(customer.getBirthday()) : "N/A";
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Customer Profile</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Poppins', Arial, sans-serif;
            }
            .container {
                max-width: 600px;
                margin: 50px auto;
            }
            .card {
                border: none;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            .card-header {
                background-color: #ff5722;
                color: #fff;
                text-align: center;
                border-radius: 15px 15px 0 0;
                padding: 20px;
            }
            .card-body {
                padding: 30px;
            }
            .table th {
                width: 40%;
                background-color: #fff3e0;
            }
            .btn-primary {
                background-color: #ff5722;
                border-color: #ff5722;
            }
            .btn-primary:hover {
                background-color: #e64a19;
                border-color: #e64a19;
            }
            .btn-secondary {
                background-color: #6c757d;
                border-color: #6c757d;
            }
            .btn-secondary:hover {
                background-color: #5a6268;
                border-color: #5a6268;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="card">
                <div class="card-header">
                    <h4>Welcome, ${customer.customerName}</h4>
                </div>
                <div class="card-body">
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success">
                            ${sessionScope.successMessage}
                            <%
                                session.removeAttribute("successMessage");
                            %>
                        </div>
                    </c:if>
                    <h5 class="text-center mb-4">Customer Information</h5>
                    <table class="table table-bordered">
                        <tr>
                            <th>Email:</th>
                            <td>${customer.email}</td>
                        </tr>
                        <tr>
                            <th>Phone Number:</th>
                            <td>${customer.phoneNumber != null ? customer.phoneNumber : "N/A"}</td>
                        </tr>
                        <tr>
                            <th>Birthday:</th>
                            <td><%= birthdayFormatted%></td>
                        </tr>
                        <tr>
                            <th>Gender:</th>
                            <td>${customer.gender != null ? customer.gender : "N/A"}</td>
                        </tr>
                    </table>
                    <div class="d-flex justify-content-center gap-3 mt-4">
                        <a href="<%= request.getContextPath()%>/" class="btn btn-danger">Home</a>
                        <a href="<%= request.getContextPath()%>/customers?action=edit&id=${customer.customerID}" class="btn btn-primary">Edit Profile</a>
                        <a href="<%= request.getContextPath()%>/cart" class="btn btn-secondary">Cart</a>
                        <a href="<%= request.getContextPath()%>/cart?action=history" class="btn btn-primary">Lịch sử đặt vé</a>
                        <a href="<%= request.getContextPath()%>/logout" class="btn btn-danger">Logout</a>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    </body>
</html>