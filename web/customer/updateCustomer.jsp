<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Edit Customer Profile</title>
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
                    <h2>Edit Customer</h2>
                </div>
                <div class="card-body">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">${errorMessage}</div>
                    </c:if>
                    <c:if test="${empty customer}">
                        <div class="alert alert-danger">Không tìm thấy thông tin khách hàng.</div>
                        <div class="d-flex justify-content-center">
                            <a href="<%= request.getContextPath()%>/customerProfile.jsp" class="btn btn-secondary">Quay lại</a>
                        </div>
                    </c:if>
                    <c:if test="${not empty customer}">
                        <form action="<%= request.getContextPath()%>/customers" method="post">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="id" value="${customer.customerID}">
                            <div class="mb-3">
                                <label for="name" class="form-label">Name:</label>
                                <input type="text" class="form-control" name="name" id="name" value="${customer.customerName}" required />
                            </div>
                            <div class="mb-3">
                                <label for="phoneNumber" class="form-label">Phone Number:</label>
                                <input type="text" class="form-control" name="phoneNumber" id="phoneNumber" value="${customer.phoneNumber}" pattern="\d{10,12}" title="Enter a valid phone number (10-12 digits)" required />
                            </div>
                            <div class="mb-3">
                                <label for="gender" class="form-label">Gender:</label>
                                <select class="form-select" name="gender" id="gender" required>
                                    <option value="Nam" ${customer.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                    <option value="Nữ" ${customer.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="birthday" class="form-label">Birthday:</label>
                                <input type="date" class="form-control" name="birthday" id="birthday" value="${customer.birthday != null ? customer.birthday : ''}" required />
                            </div>
                            <div class="d-flex justify-content-center gap-3">
                                <button type="submit" class="btn btn-primary">Update</button>
                                <a href="<%= request.getContextPath()%>/customer/customerProfile.jsp" class="btn btn-secondary">Cancel</a>
                            </div>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    </body>
</html>