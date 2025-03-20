<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Login - Professional</title>
        <style>
            /* Reset cơ bản */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                font-family: 'Arial', sans-serif;
            }

            .login-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
                padding: 2.5rem;
                width: 100%;
                max-width: 400px;
                transition: transform 0.3s ease;
            }

            .login-card:hover {
                transform: translateY(-5px);
            }

            .text-center {
                text-align: center;
            }

            h1 {
                font-size: 2.5rem;
                font-weight: bold;
                color: #333;
                margin-bottom: 0.5rem;
            }

            .text-muted {
                color: #6c757d;
                font-size: 1rem;
            }

            .input-group {
                position: relative;
                margin-bottom: 1.5rem;
            }

            .input-group i {
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: #666;
            }

            input[type="email"],
            input[type="password"] {
                width: 100%;
                padding: 0.75rem 0.75rem 0.75rem 2.5rem;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 1rem;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }

            input[type="email"]:focus,
            input[type="password"]:focus {
                outline: none;
                border-color: #007bff;
                box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
            }

            input::placeholder {
                color: #aaa;
            }

            .form-check {
                display: flex;
                align-items: center;
                margin-bottom: 1.5rem;
            }

            .form-check input {
                margin-right: 0.5rem;
            }

            .form-check-label {
                color: #555;
                font-size: 0.9rem;
            }

            .text-end a {
                color: #007bff;
                text-decoration: none;
                font-size: 0.9rem;
            }

            .text-end a:hover {
                text-decoration: underline;
            }

            button {
                width: 100%;
                padding: 0.9rem;
                background-color: #007bff;
                border: none;
                border-radius: 8px;
                color: white;
                font-size: 1.1rem;
                font-weight: bold;
                cursor: pointer;
                transition: background-color 0.3s ease, transform 0.3s ease;
            }

            button:hover {
                background-color: #0056b3;
                transform: translateY(-2px);
            }

            button i {
                margin-right: 0.5rem;
            }

            .signup-link {
                margin-top: 1.5rem;
            }

            .signup-link a {
                color: #007bff;
                font-weight: bold;
                text-decoration: none;
            }

            .signup-link a:hover {
                text-decoration: underline;
            }

            /* Responsive */
            @media (max-width: 480px) {
                .login-card {
                    padding: 1.5rem;
                    margin: 1rem;
                }
                h1 {
                    font-size: 2rem;
                }
            }
        </style>
    </head>
    <body>
        <section>
            <div class="login-card">
                <div class="text-center">
                    <h1>Sign In</h1>
                    <p class="text-muted">Access your account securely</p>
                </div>

                <form action="${pageContext.request.contextPath}/login" method="post">
                    <div class="input-group">
                        <i>✉️</i>
                        <input type="email" name="email" id="email" 
                               placeholder="Enter your email" required>
                    </div>

                    <div class="input-group">
                        <i>🔒</i>
                        <input type="password" name="password" id="password" 
                               placeholder="Enter your password" required>
                    </div>

                    <button type="submit">
                        <i>→</i>Log In
                    </button>
                </form>

                <div class="text-center signup-link">
                    <p>Don't have an account? <a href="${pageContext.request.contextPath}/login/register.jsp">Sign Up</a></p>
                </div>
            </div>
        </section>
    </body>
</html>