<%@ page import="com.inventory.model.User" %>
<%@ page import="com.inventory.dao.ProductDAO" %>
<%@ page import="com.inventory.dao.CategoryDAO" %>
<%@ page import="com.inventory.dao.SalesDAO" %>
<%@ page import="com.inventory.dao.ExpenseDAO" %>
<%@ page import="com.inventory.model.Product" %>
<%@ page import="com.inventory.util.ColorUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    ProductDAO productDAO = new ProductDAO();
    CategoryDAO categoryDAO = new CategoryDAO();
    SalesDAO salesDAO = new SalesDAO();
    ExpenseDAO expenseDAO = new ExpenseDAO();

    List<Product> productList = productDAO.getAllProducts();
    List<String> allCategories = categoryDAO.getAllCategories();

    Map<String, Integer> categoryStockMap = new HashMap<>();
    for (Product p : productList) {
        categoryStockMap.put(p.getCategory(), categoryStockMap.getOrDefault(p.getCategory(), 0) + p.getStockQuantity());
    }

    double totalRevenue = salesDAO.getTotalRevenue();
    double totalCOGS = salesDAO.getTotalCOGS();
    double totalExpenses = expenseDAO.getTotalExpenses();
    double netProfit = totalRevenue - totalCOGS - totalExpenses;
    int totalItemsSold = salesDAO.getTotalItemsSold();

    Map<String, Double> salesTrend = salesDAO.getRevenueTrend(30);
    Map<String, Integer> topProducts = salesDAO.getTopSellingProducts(5);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports | Inventory System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --sidebar-width: 280px;
            --sidebar-bg: #0f172a;
            --primary: #6366f1;
            --secondary: #ec4899;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --light: #f3f4f6;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
        }

        body { font-family: 'Inter', sans-serif; background-color: var(--light); color: var(--text-main); }

        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            background-color: var(--sidebar-bg);
            position: fixed;
            top: 0;
            left: 0;
            display: flex;
            flex-direction: column;
            z-index: 1000;
        }

        .sidebar-brand {
            padding: 30px 25px;
            color: white;
            font-size: 1.2rem;
            font-weight: 800;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            gap: 15px;
            letter-spacing: -0.5px;
        }
        .sidebar-brand i { color: var(--primary); font-size: 2.5rem; margin-bottom: 5px; }

        .nav-menu { padding: 10px 15px; flex-grow: 1; }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 16px 20px;
            color: #94a3b8;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95rem;
            border-radius: 12px;
            margin-bottom: 5px;
            transition: all 0.2s ease;
        }

        .nav-link:hover {
            background-color: rgba(255,255,255,0.05);
            color: white;
            transform: translateX(5px);
        }

        .nav-link.active {
            background: linear-gradient(90deg, var(--primary) 0%, #818cf8 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.4);
        }

        .nav-link i { width: 24px; margin-right: 12px; font-size: 1.1rem; }

        .user-profile {
            padding: 25px;
            border-top: 1px solid rgba(255,255,255,0.05);
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: rgba(0,0,0,0.2);
        }
        .user-info { color: white; font-size: 0.95rem; font-weight: 600; }
        .user-role { color: #94a3b8; font-size: 0.8rem; }
        .btn-logout {
            color: #fca5a5;
            background: rgba(239, 68, 68, 0.1);
            width: 40px; height: 40px;
            display: flex; align-items: center; justify-content: center;
            border-radius: 10px;
            transition: 0.2s;
            text-decoration: none;
        }
        .btn-logout:hover { background: var(--danger); color: white; }

        .main-content { margin-left: var(--sidebar-width); padding: 40px; }

        .dashboard-banner {
            background: linear-gradient(135deg, #4f46e5 0%, #4338ca 100%);
            border-radius: 16px;
            padding: 30px;
            color: white;
            margin-bottom: 30px;
        }
        .banner-text h2 { font-weight: 700; font-size: 1.8rem; margin: 0; }
        .banner-text p { margin: 5px 0 0; opacity: 0.8; }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            padding: 25px;
            border-radius: 16px;
            color: white;
            position: relative;
            overflow: hidden;
        }
        .bg-success { background-color: var(--success); }
        .bg-primary { background-color: var(--primary); }
        .bg-dark { background-color: #1f2937; }
        .stat-title { font-size: 0.85rem; font-weight: 600; text-transform: uppercase; opacity: 0.9; margin-bottom: 10px; }
        .stat-value { font-size: 1.8rem; font-weight: 800; }
        .stat-icon-bg {
            position: absolute;
            right: -10px; bottom: -10px;
            font-size: 5rem;
            opacity: 0.15;
            transform: rotate(-15deg);
        }

        .content-card {
            background: var(--card-bg);
            border-radius: 20px;
            padding: 30px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            height: 100%;
        }
        .card-title { font-weight: 700; font-size: 1.2rem; color: #111827; margin-bottom: 25px; }
    </style>
</head>
<body>

    <nav class="sidebar">
        <div class="sidebar-brand">
            <i class="fa-solid fa-boxes-stacked"></i>
            <span>Inventory Management<br>System</span>
        </div>
        <div class="nav-menu">
            <a href="dashboard.jsp" class="nav-link"><i class="fa-solid fa-home"></i> Dashboard</a>
            <a href="products.jsp" class="nav-link"><i class="fa-solid fa-box-archive"></i> Products</a>
            <a href="sales.jsp" class="nav-link"><i class="fa-solid fa-receipt"></i> Sales</a>
            <a href="suppliers.jsp" class="nav-link"><i class="fa-solid fa-truck-field"></i> Suppliers</a>
            <a href="expenses.jsp" class="nav-link"><i class="fa-solid fa-file-invoice-dollar"></i> Expenses</a>
            <a href="reports.jsp" class="nav-link active"><i class="fa-solid fa-chart-pie"></i> Reports</a>
        </div>
        <div class="user-profile">
            <div>
                <div class="user-info"><%= user.getUsername() %></div>
                <div class="user-role">Administrator</div>
            </div>
            <a href="logout" class="btn-logout" title="Logout"><i class="fa-solid fa-power-off"></i></a>
        </div>
    </nav>

    <main class="main-content">
        <div class="dashboard-banner">
            <div class="banner-text">
                <h2>Analytics & Reports</h2>
                <p>Deep dive into your inventory and sales data.</p>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card bg-success">
                <div class="stat-title">Net Profit</div>
                <div class="stat-value">Rs. <%= String.format("%,.0f", netProfit) %></div>
                <i class="fa-solid fa-coins stat-icon-bg"></i>
            </div>
            <div class="stat-card bg-primary">
                <div class="stat-title">Total Items Sold</div>
                <div class="stat-value"><%= totalItemsSold %></div>
                <i class="fa-solid fa-cart-arrow-down stat-icon-bg"></i>
            </div>
            <div class="stat-card bg-dark">
                <div class="stat-title">Total Products</div>
                <div class="stat-value"><%= productList.size() %></div>
                <i class="fa-solid fa-boxes-stacked stat-icon-bg"></i>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-12">
                <div class="content-card">
                    <h5 class="card-title">30-Day Sales Revenue</h5>
                    <div style="height: 350px;"><canvas id="salesTrendChart"></canvas></div>
                </div>
            </div>
            <div class="col-lg-8">
                <div class="content-card">
                    <h5 class="card-title">Top 5 Selling Products</h5>
                    <div style="height: 400px;"><canvas id="topProductsChart"></canvas></div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="content-card">
                    <h5 class="card-title">Stock by Category</h5>
                    <div style="height: 400px;"><canvas id="categoryStockChart"></canvas></div>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // 30-Day Sales Trend
        new Chart(document.getElementById('salesTrendChart'), {
            type: 'line',
            data: {
                labels: [<% for(String date : salesTrend.keySet()) { %>"<%= date %>",<% } %>],
                datasets: [{
                    label: 'Revenue',
                    data: [<% for(Double val : salesTrend.values()) { %><%= val %>,<% } %>],
                    borderColor: 'var(--primary)',
                    backgroundColor: 'rgba(99, 102, 241, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true } }
            }
        });

        // Top 5 Selling Products
        new Chart(document.getElementById('topProductsChart'), {
            type: 'bar',
            data: {
                labels: [<% for(String name : topProducts.keySet()) { %>"<%= name %>",<% } %>],
                datasets: [{
                    label: 'Units Sold',
                    data: [<% for(Integer val : topProducts.values()) { %><%= val %>,<% } %>],
                    backgroundColor: [
                        'rgba(99, 102, 241, 0.8)',
                        'rgba(99, 102, 241, 0.7)',
                        'rgba(99, 102, 241, 0.6)',
                        'rgba(99, 102, 241, 0.5)',
                        'rgba(99, 102, 241, 0.4)'
                    ],
                    borderRadius: 5
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } }
            }
        });

        // Stock by Category
        new Chart(document.getElementById('categoryStockChart'), {
            type: 'doughnut',
            data: {
                labels: [<% for(String cat : allCategories) { %>"<%= cat %>",<% } %>],
                datasets: [{
                    data: [<% for(String cat : allCategories) { %><%= categoryStockMap.getOrDefault(cat, 0) %>,<% } %>],
                    backgroundColor: [<% for(String cat : allCategories) { %>"<%= ColorUtil.getColor(cat) %>",<% } %>]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'bottom' } }
            }
        });
    </script>
</body>
</html>