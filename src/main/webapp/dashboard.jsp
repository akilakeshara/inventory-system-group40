<%@ page import="com.inventory.model.User" %>
<%@ page import="com.inventory.dao.ProductDAO" %>
<%@ page import="com.inventory.dao.CategoryDAO" %>
<%@ page import="com.inventory.dao.SalesDAO" %>
<%@ page import="com.inventory.dao.ExpenseDAO" %>
<%@ page import="com.inventory.model.Product" %>
<%@ page import="com.inventory.model.Sale" %>
<%@ page import="com.inventory.util.ColorUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    ProductDAO productDAO = new ProductDAO();
    SalesDAO salesDAO = new SalesDAO();
    CategoryDAO categoryDAO = new CategoryDAO();
    ExpenseDAO expenseDAO = new ExpenseDAO();

    List<Product> productList = productDAO.getAllProducts();
    List<String> allCategories = categoryDAO.getAllCategories();
    Map<String, List<Sale>> recentSales = salesDAO.getRecentTransactionGroups();
    Map<String, Double> revenueTrend = salesDAO.getLast7DaysRevenue();

    double totalRevenue = salesDAO.getTotalRevenue();
    double totalCOGS = salesDAO.getTotalCOGS();
    double totalExpenses = expenseDAO.getTotalExpenses();
    double netProfit = totalRevenue - totalCOGS - totalExpenses;

    int totalItemsSold = salesDAO.getTotalItemsSold();
    double totalInventoryValue = 0;
    int lowStockCount = 0;
    int outOfStockCount = 0;
    Map<String, Integer> categoryMap = new HashMap<>();

    for (Product p : productList) {
        totalInventoryValue += (p.getPrice() * p.getStockQuantity());
        if (p.getStockQuantity() == 0) outOfStockCount++;
        else if (p.getStockQuantity() < 5) lowStockCount++;
        categoryMap.put(p.getCategory(), categoryMap.getOrDefault(p.getCategory(), 0) + p.getStockQuantity());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | Inventory System</title>
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

            /* Dashboard specific colors */
            --card-green: #10b981;
            --card-blue: #3b82f6;
            --card-red: #ef4444;
            --card-dark: #1f2937;
        }

        body { font-family: 'Inter', sans-serif; background-color: var(--light); color: var(--text-main); }

        /* Sidebar */
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

        /* Main Content */
        .main-content { margin-left: var(--sidebar-width); padding: 40px; }

        /* Dashboard Banner */
        .dashboard-banner {
            background: linear-gradient(135deg, #4f46e5 0%, #4338ca 100%);
            border-radius: 16px;
            padding: 30px;
            color: white;
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 30px;
            box-shadow: 0 10px 25px -5px rgba(79, 70, 229, 0.4);
        }
        .banner-text h2 { font-weight: 700; font-size: 1.8rem; margin: 0; }
        .banner-text p { margin: 5px 0 0; opacity: 0.8; }

        .banner-actions .btn {
            border: none;
            padding: 10px 20px;
            font-weight: 600;
            border-radius: 8px;
            text-decoration: none;
        }
        .btn-banner-primary { background: white; color: #4338ca; }
        .btn-banner-outline { background: rgba(255,255,255,0.2); color: white; margin-left: 10px; }
        .btn-banner-outline:hover { background: rgba(255,255,255,0.3); color: white; }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            padding: 25px;
            border-radius: 16px;
            color: white;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-5px); }

        .bg-green { background-color: var(--card-green); }
        .bg-blue { background-color: var(--card-blue); }
        .bg-red { background-color: var(--card-red); }
        .bg-dark { background-color: var(--card-dark); }

        .stat-title { font-size: 0.85rem; font-weight: 600; text-transform: uppercase; opacity: 0.9; margin-bottom: 10px; }
        .stat-value { font-size: 1.8rem; font-weight: 800; margin-bottom: 5px; }
        .stat-badge {
            background: rgba(255,255,255,0.2);
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
        }
        .stat-icon-bg {
            position: absolute;
            right: -10px; bottom: -10px;
            font-size: 5rem;
            opacity: 0.15;
            transform: rotate(-15deg);
        }

        /* Content Cards */
        .content-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            height: 100%;
        }
        .section-title { font-weight: 700; color: #374151; margin-bottom: 20px; }

        /* Table Styling */
        .table-custom thead th {
            background: #f9fafb;
            font-size: 0.75rem;
            text-transform: uppercase;
            color: #6b7280;
            padding: 15px;
            border-bottom: 1px solid #e5e7eb;
        }
        .table-custom tbody td {
            padding: 15px;
            vertical-align: middle;
            font-weight: 500;
            border-bottom: 1px solid #f3f4f6;
        }
        .transaction-group {
            border-bottom: 5px solid #e5e7eb;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <nav class="sidebar">
        <div class="sidebar-brand">
            <i class="fa-solid fa-boxes-stacked"></i>
            <span>Inventory Management<br>System</span>
        </div>

        <div class="nav-menu">
            <a href="dashboard.jsp" class="nav-link active">
                <i class="fa-solid fa-home"></i> Dashboard
            </a>
            <a href="products.jsp" class="nav-link">
                <i class="fa-solid fa-box-archive"></i> Products
            </a>
            <a href="sales.jsp" class="nav-link">
                <i class="fa-solid fa-receipt"></i> Sales
            </a>
            <a href="suppliers.jsp" class="nav-link">
                <i class="fa-solid fa-truck-field"></i> Suppliers
            </a>
            <a href="expenses.jsp" class="nav-link">
                <i class="fa-solid fa-file-invoice-dollar"></i> Expenses
            </a>
            <a href="reports.jsp" class="nav-link">
                <i class="fa-solid fa-chart-pie"></i> Reports
            </a>
        </div>

        <div class="user-profile">
            <div>
                <div class="user-info"><%= user.getUsername() %></div>
                <div class="user-role">Administrator</div>
            </div>
            <a href="logout" class="btn-logout" title="Logout">
                <i class="fa-solid fa-power-off"></i>
            </a>
        </div>
    </nav>

    <div class="main-content">

        <div class="dashboard-banner">
            <div class="banner-text">
                <h2>Dashboard Overview</h2>
                <p>Welcome back, <%= user.getUsername() %></p>
            </div>
            <div class="banner-actions">
                <a href="expenses.jsp" class="btn btn-banner-outline"><i class="fa-solid fa-file-invoice-dollar"></i> Expenses</a>
                <a href="products.jsp" class="btn btn-banner-outline"><i class="fa-solid fa-list-check"></i> Manage Products</a>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card bg-green">
                <div class="stat-title">Total Revenue</div>
                <div class="stat-value">Rs. <%= String.format("%,.0f", totalRevenue) %></div>
                <div class="stat-badge"><i class="fa-solid fa-check"></i> Lifetime</div>
                <i class="fa-solid fa-money-bill-wave stat-icon-bg"></i>
            </div>

            <div class="stat-card bg-blue">
                <div class="stat-title">Net Profit</div>
                <div class="stat-value">Rs. <%= String.format("%,.0f", netProfit) %></div>
                <div class="stat-badge"><i class="fa-solid fa-arrow-trend-up"></i> After Expenses</div>
                <i class="fa-solid fa-coins stat-icon-bg"></i>
            </div>

            <div class="stat-card bg-red">
                <div class="stat-title">Stock Alerts</div>
                <div class="stat-value"><%= lowStockCount %> Items</div>
                <div class="stat-badge">Refill Needed</div>
                <i class="fa-solid fa-triangle-exclamation stat-icon-bg"></i>
            </div>

            <div class="stat-card bg-dark">
                <div class="stat-title">Items Sold</div>
                <div class="stat-value"><%= totalItemsSold %></div>
                <div class="stat-badge">Total Processed</div>
                <i class="fa-solid fa-cart-arrow-down stat-icon-bg"></i>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-lg-6 mb-3">
                <div class="content-card">
                    <h5 class="section-title">Stock Distribution</h5>
                    <div style="height: 300px;">
                        <canvas id="categoryChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-lg-6 mb-3">
                <div class="content-card">
                    <h5 class="section-title">Revenue Trend</h5>
                    <div style="height: 300px;">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <div class="content-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="section-title mb-0">Recent Sales</h5>
                <small class="text-muted">Realtime transactions</small>
            </div>

            <div class="table-responsive">
                <table class="table table-custom table-hover">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Bill #</th>
                            <th>Qty</th>
                            <th>Total</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (recentSales.isEmpty()) { %>
                            <tr><td colspan="5" class="text-center py-3">No recent sales.</td></tr>
                        <% } else {
                            for (Map.Entry<String, List<Sale>> entry : recentSales.entrySet()) {
                                String transactionId = entry.getKey();
                                List<Sale> salesInGroup = entry.getValue();
                                double groupTotal = 0;
                                for (Sale s : salesInGroup) {
                                    groupTotal += s.getTotalPrice();
                                }
                        %>
                            <tr class="transaction-group">
                                <td colspan="3">
                                    <div class="fw-bold text-dark">Bill #<%= transactionId %></div>
                                    <div class="text-muted small"><%= salesInGroup.size() %> items</div>
                                </td>
                                <td class="fw-bold fs-5">Rs. <%= String.format("%,.0f", groupTotal) %></td>
                                <td class="text-secondary"><%= new SimpleDateFormat("yyyy-MM-dd").format(salesInGroup.get(0).getSaleDate()) %></td>
                            </tr>
                            <% for (Sale s : salesInGroup) { %>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div style="width: 30px; height: 30px; background: #e0e7ff; color: #4338ca; border-radius: 6px; display: flex; align-items: center; justify-content: center;"><i class="fa-solid fa-box-open"></i></div>
                                            <span class="fw-bold text-dark"><%= s.getProductName() %></span>
                                        </div>
                                    </td>
                                    <td></td>
                                    <td><%= s.getQuantity() %></td>
                                    <td class="fw-bold">Rs. <%= String.format("%,.0f", s.getTotalPrice()) %></td>
                                    <td></td>
                                </tr>
                            <% } %>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        // --- Stock Distribution (Bar Chart) ---
        const catLabels = [<% for (String cat : allCategories) { %>"<%= cat %>",<% } %>];
        const catData = [<% for (String cat : allCategories) { %><%= categoryMap.getOrDefault(cat, 0) %>,<% } %>];
        const barColors = [<% for (String cat : allCategories) { %>"<%= ColorUtil.getColor(cat) %>",<% } %>];

        new Chart(document.getElementById('categoryChart'), {
            type: 'bar',
            data: {
                labels: catLabels,
                datasets: [{
                    label: 'Stock Quantity',
                    data: catData,
                    backgroundColor: barColors,
                    borderRadius: 6,
                    barPercentage: 0.6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { display: true, borderDash: [5, 5] } },
                    x: { grid: { display: false } }
                }
            }
        });

        // --- Revenue Trend (Green Area Chart) ---
        const revLabels = [<% for (String date : revenueTrend.keySet()) { %>"<%= date %>",<% } %>];
        const revData = [<% for (Double val : revenueTrend.values()) { %><%= val %>,<% } %>];
        const ctxRev = document.getElementById('revenueChart').getContext('2d');

        let gradient = ctxRev.createLinearGradient(0, 0, 0, 400);
        gradient.addColorStop(0, 'rgba(16, 185, 129, 0.4)');
        gradient.addColorStop(1, 'rgba(16, 185, 129, 0.0)');

        new Chart(ctxRev, {
            type: 'line',
            data: {
                labels: revLabels,
                datasets: [{
                    label: 'Revenue',
                    data: revData,
                    borderColor: '#10b981',
                    backgroundColor: gradient,
                    borderWidth: 2,
                    pointBackgroundColor: '#ffffff',
                    pointBorderColor: '#10b981',
                    pointRadius: 4,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: { borderDash: [5, 5] },
                        ticks: { callback: function(val) { return 'Rs. ' + (val/1000) + 'k'; } }
                    },
                    x: { grid: { display: false } }
                }
            }
        });
    </script>
</body>
</html>