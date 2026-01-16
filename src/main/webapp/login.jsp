<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | Inventory System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --sidebar-bg: #0f172a;
            --primary: #6366f1;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--sidebar-bg);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            padding: 40px;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 400px;
            color: white;
            opacity: 0;
            animation: zoomIn 0.8s cubic-bezier(0.25, 0.8, 0.25, 1) forwards;
        }
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .login-header i {
            font-size: 3rem;
            color: var(--primary);
            margin-bottom: 10px;
            animation: pulse 2s infinite;
        }
        .form-control {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            height: 50px;
            padding-left: 45px;
            border-radius: 10px;
            transition: 0.3s;
        }
        .form-control:focus {
            background: rgba(255, 255, 255, 0.2);
            border-color: var(--primary);
            color: white;
            box-shadow: 0 0 15px rgba(99, 102, 241, 0.2);
        }
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.6);
        }
        .input-icon {
            position: absolute;
            left: 15px;
            top: 42px;
            color: rgba(255, 255, 255, 0.7);
            font-size: 1.1rem;
        }
        .form-group {
            position: relative;
            margin-bottom: 25px;
        }
        .btn-login {
            background: var(--primary);
            color: white;
            font-weight: 600;
            padding: 12px;
            border-radius: 50px;
            border: none;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .btn-login:hover {
            background: #4f46e5;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(99, 102, 241, 0.3);
        }
        .text-muted-light {
            color: rgba(255, 255, 255, 0.6) !important;
        }
        .alert-danger {
            background: rgba(220, 53, 69, 0.2);
            border: 1px solid rgba(220, 53, 69, 0.5);
            color: #ffcdd2;
            animation: shake 0.5s;
        }

        @keyframes zoomIn {
            from { opacity: 0; transform: scale(0.9); }
            to { opacity: 1; transform: scale(1); }
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        @keyframes shake {
            0% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            50% { transform: translateX(5px); }
            75% { transform: translateX(-5px); }
            100% { transform: translateX(0); }
        }
    </style>
</head>
<body>

    <div class="login-card">
        <div class="login-header">
            <i class="fa-solid fa-user-circle"></i>
            <h3 class="fw-bold">Welcome Back</h3>
            <p class="text-muted-light small">Please login to your account</p>
        </div>

        <%
            String error = (String) request.getAttribute("errorMessage");
            if (error != null) {
        %>
            <div class="alert alert-danger text-center p-2 mb-3 small rounded-3">
                <i class="fa-solid fa-circle-exclamation me-1"></i> <%= error %>
            </div>
        <% } %>

        <form action="login" method="post">
            <div class="form-group">
                <label class="form-label fw-bold small text-muted-light">USERNAME</label>
                <i class="fa-solid fa-user input-icon"></i>
                <input type="text" name="username" class="form-control" placeholder="Enter username" required>
            </div>

            <div class="form-group">
                <label class="form-label fw-bold small text-muted-light">PASSWORD</label>
                <i class="fa-solid fa-lock input-icon"></i>
                <input type="password" name="password" class="form-control" placeholder="Enter password" required>
            </div>

            <button type="submit" class="btn btn-login w-100 shadow-sm mt-3">
                LOGIN <i class="fa-solid fa-arrow-right-to-bracket ms-2"></i>
            </button>
        </form>

        <div class="text-center mt-4">
            <a href="index.jsp" class="text-decoration-none text-muted-light small hover-white">
                <i class="fa-solid fa-arrow-left me-1"></i> Back to Home
            </a>
        </div>
    </div>

</body>
</html>