<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Welcome | Inventory System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

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
            color: white;
            text-align: center;
            overflow: hidden;
        }
        .hero-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            padding: 60px;
            border-radius: 25px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            max-width: 550px;
            width: 100%;
            transition: transform 0.3s ease;
            opacity: 0;
            animation: fadeInUp 1s ease-out forwards;
        }
        .hero-card:hover {
            transform: translateY(-5px);
        }
        .btn-custom {
            background-color: var(--primary);
            color: white;
            font-weight: 600;
            padding: 14px 40px;
            border-radius: 50px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.9rem;
            border: none;
        }
        .btn-custom:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(99, 102, 241, 0.3);
            background-color: #4f46e5;
        }
        .icon-logo {
            font-size: 4.5rem;
            margin-bottom: 25px;
            color: var(--primary);
            animation: float 3s ease-in-out infinite;
        }
        h1 {
            font-weight: 700;
            letter-spacing: -1px;
        }
        .footer-text {
            margin-top: 30px;
            font-size: 0.8rem;
            opacity: 0.6;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0px); }
        }
    </style>
</head>
<body>

    <div class="hero-card">
        <i class="fa-solid fa-boxes-stacked icon-logo"></i>
        <h1 class="mb-3">Inventory System</h1>
        <p class="mb-5 opacity-75 lead" style="font-size: 1rem;">
            Professional tracking for modern businesses.
        </p>

        <a href="login.jsp" class="btn btn-custom shadow-lg">
            Get Started <i class="fa-solid fa-arrow-right ms-2"></i>
        </a>

        <div class="footer-text">
            <p>&copy; 2024 Inventory Management Project | Group 40</p>
        </div>
    </div>

</body>
</html>