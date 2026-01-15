<%@ page import="com.inventory.model.User" %>
<%@ page import="com.inventory.dao.SalesDAO" %>
<%@ page import="com.inventory.model.Sale" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    SalesDAO salesDAO = new SalesDAO();
    List<Sale> transactionList = salesDAO.getAllTransactions();
    double totalRevenue = salesDAO.getTotalRevenue();
    int totalItemsSold = salesDAO.getTotalItemsSold();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sales History | Inventory System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">

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

                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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
                        .bg-green { background-color: var(--success); }
                        .bg-blue { background-color: var(--primary); }
                        .bg-dark { background-color: #1f2937; }
                        .stat-title { font-size: 0.85rem; font-weight: 600; text-transform: uppercase; opacity: 0.9; margin-bottom: 10px; }
                        .stat-value { font-size: 1.8rem; font-weight: 800; margin-bottom: 5px; }
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
                        }

                        .table { margin: 0; }
                        .table thead th {
                            background-color: #f8fafc;
                            color: #64748b;
                            font-weight: 600;
                            text-transform: uppercase;
                            font-size: 0.75rem;
                            letter-spacing: 0.5px;
                            border-bottom: 1px solid #e2e8f0;
                            padding: 15px 20px;
                        }
                        .table tbody td { padding: 15px 20px; vertical-align: middle; color: #334155; font-weight: 500; border-bottom: 1px solid #f1f5f9; }
                        .table tbody tr:last-child td { border-bottom: none; }
                        .table tbody tr:hover { background-color: #f8fafc; }

                        .status-badge { padding: 5px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; background: #d1fae5; color: #065f46; }

                        .btn-action {
                            width: 36px; height: 36px;
                            display: inline-flex; align-items: center; justify-content: center;
                            border-radius: 10px;
                            transition: 0.2s;
                            border: none;
                            margin-right: 5px;
                            cursor: pointer;
                        }
                        .btn-view { background: #e0e7ff; color: var(--primary); }
                                .btn-view:hover { background: var(--primary); color: white; }
                                .btn-pdf { background: #fee2e2; color: #ef4444; }
                                .btn-pdf:hover { background: #ef4444; color: white; }
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
                                    <a href="dashboard.jsp" class="nav-link">
                                        <i class="fa-solid fa-home"></i> Dashboard
                                    </a>
                                    <a href="products.jsp" class="nav-link">
                                        <i class="fa-solid fa-box-archive"></i> Products
                                    </a>
                                    <a href="sales.jsp" class="nav-link active">
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

                            <!-- Main Content -->
                            <main class="main-content">
                                <div class="dashboard-banner">
                                    <div class="banner-text">
                                        <h2>Sales History</h2>
                                        <p>View lifetime sales and download invoices.</p>
                                    </div>
                                </div>

                                <div class="stats-grid">
                                    <div class="stat-card bg-green">
                                        <div class="stat-title">Total Revenue</div>
                                        <div class="stat-value">Rs. <%= String.format("%,.0f", totalRevenue) %></div>
                                        <i class="fa-solid fa-money-bill-wave stat-icon-bg"></i>
                                    </div>
                                    <div class="stat-card bg-blue">
                                        <div class="stat-title">Total Transactions</div>
                                        <div class="stat-value"><%= transactionList.size() %></div>
                                        <i class="fa-solid fa-file-invoice-dollar stat-icon-bg"></i>
                                    </div>
                                    <div class="stat-card bg-dark">
                                        <div class="stat-title">Items Sold</div>
                                        <div class="stat-value"><%= totalItemsSold %></div>
                                        <i class="fa-solid fa-cart-arrow-down stat-icon-bg"></i>
                                    </div>
                                </div>