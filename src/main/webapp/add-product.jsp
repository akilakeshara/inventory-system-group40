<%@ page import="com.inventory.model.User" %>
<%@ page import="com.inventory.dao.CategoryDAO" %>
<%@ page import="com.inventory.dao.SupplierDAO" %>
<%@ page import="com.inventory.model.Supplier" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    CategoryDAO categoryDAO = new CategoryDAO();
    List<String> categoryList = categoryDAO.getAllCategories();

    SupplierDAO supplierDAO = new SupplierDAO();
    List<Supplier> supplierList = supplierDAO.getAllSuppliers();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Product | Inventory System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --sidebar-width: 280px;
            --sidebar-bg: #0f172a;
            --primary: #6366f1;
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
        .btn-logout:hover { background: #ef4444; color: white; }

        /* Main Content */
        .main-content { margin-left: var(--sidebar-width); padding: 40px; }

        .page-header { margin-bottom: 40px; display: flex; justify-content: space-between; align-items: center; }
        .page-title { font-weight: 800; font-size: 2rem; color: #111827; margin: 0; letter-spacing: -1px; }
        .page-subtitle { color: #6b7280; font-size: 1rem; margin-top: 5px; }

        /* Content Card */
        .content-card {
            background: var(--card-bg);
            border-radius: 20px;
            padding: 40px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            max-width: 800px;
            margin: 0 auto;
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
            <a href="dashboard.jsp" class="nav-link">
                <i class="fa-solid fa-grid-2"></i> Dashboard
            </a>
            <a href="products.jsp" class="nav-link active">
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

    <!-- Main Content -->
    <main class="main-content">
        <div class="page-header">
            <div>
                <h1 class="page-title">Add Product</h1>
                <p class="page-subtitle">Create a new inventory item.</p>
            </div>
            <a href="products.jsp" class="btn btn-light rounded-pill px-4 fw-bold border">
                <i class="fa-solid fa-arrow-left me-2"></i> Back
            </a>
        </div>

        <div class="content-card">
            <form action="product-servlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">

                <div class="mb-4">
                    <label class="form-label fw-bold text-muted small">PRODUCT NAME</label>
                    <input type="text" name="name" class="form-control bg-light border-0 py-3" required placeholder="Enter product name">
                </div>

                <div class="row mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-muted small">CATEGORY</label>
                        <select name="category" class="form-select bg-light border-0 py-3">
                            <% for (String cat : categoryList) { %>
                                <option value="<%= cat %>"><%= cat %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-muted small">SUPPLIER</label>
                        <select name="supplier" class="form-select bg-light border-0 py-3">
                            <option value="">Select Supplier</option>
                            <% for (Supplier s : supplierList) { %>
                                <option value="<%= s.getName() %>"><%= s.getName() %></option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold text-muted small">PRODUCT IMAGE</label>
                    <input type="file" name="image" class="form-control bg-light border-0" accept="image/*">
                </div>

                <div class="row mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-muted small">SELLING PRICE (Rs.)</label>
                        <input type="number" step="0.01" name="price" class="form-control bg-light border-0 py-3" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-muted small">PURCHASE PRICE (Rs.)</label>
                        <input type="number" step="0.01" name="purchasePrice" class="form-control bg-light border-0 py-3">
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold text-muted small">INITIAL STOCK QUANTITY</label>
                    <input type="number" name="quantity" class="form-control bg-light border-0 py-3" required>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary rounded-pill py-3 fw-bold" style="background-color: var(--primary); border: none;">
                        <i class="fa-solid fa-save me-2"></i> Save Product
                    </button>
                </div>
            </form>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>