<%@ page import="com.inventory.model.User" %>
<%@ page import="com.inventory.dao.ProductDAO" %>
<%@ page import="com.inventory.dao.CategoryDAO" %>
<%@ page import="com.inventory.dao.SupplierDAO" %>
<%@ page import="com.inventory.model.Product" %>
<%@ page import="com.inventory.model.Supplier" %>
<%@ page import="com.inventory.util.ColorUtil" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    ProductDAO productDAO = new ProductDAO();
    List<Product> productList = productDAO.getAllProducts();

    CategoryDAO categoryDAO = new CategoryDAO();
    List<String> categoryList = categoryDAO.getAllCategories();

    SupplierDAO supplierDAO = new SupplierDAO();
    List<Supplier> supplierList = supplierDAO.getAllSuppliers();

    // Calculate statistics
    int totalProducts = productList.size();
    int lowStockItems = 0;
    double totalInventoryValue = 0;
    for (Product p : productList) {
        if (p.getStockQuantity() < 5) {
            lowStockItems++;
        }
        totalInventoryValue += p.getPrice() * p.getStockQuantity();
    }
    int categoriesCount = categoryList.size();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Products | Inventory System</title>
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

        /* Dashboard Banner Style */
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
            display: inline-flex;
            align-items: center;
        }
        .btn-banner-primary { background: white; color: #4338ca; }
        .btn-banner-primary:hover { background: #f8fafc; color: #4338ca; }
        .btn-banner-outline { background: rgba(255,255,255,0.2); color: white; margin-right: 10px; }
        .btn-banner-outline:hover { background: rgba(255,255,255,0.3); color: white; }

        /* Stats Cards */
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
        .bg-red { background-color: var(--danger); }
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

        /* Content Cards */
        .content-card {
            background: var(--card-bg);
            border-radius: 20px;
            padding: 30px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        /* Table */
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

        .product-img {
            width: 45px;
            height: 45px;
            object-fit: contain;
            border-radius: 10px;
            border: 1px solid #e2e8f0;
            padding: 4px;
            background: white;
        }

        .badge-category { padding: 6px 12px; border-radius: 30px; font-size: 0.75rem; font-weight: 700; color: white; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }

        .btn-action {
            width: 36px;
            height: 36px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            transition: 0.2s;
            border: none;
        }
        .btn-edit { background: #e0e7ff; color: #4f46e5; }
        .btn-edit:hover { background: #4f46e5; color: white; }
        .btn-delete { background: #fee2e2; color: #ef4444; }
        .btn-delete:hover { background: #ef4444; color: white; }
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
        <div class="dashboard-banner">
            <div class="banner-text">
                <h2>Products</h2>
                <p>Manage your inventory items and stock levels.</p>
            </div>
            <div class="banner-actions">
                <button class="btn btn-banner-outline" data-bs-toggle="modal" data-bs-target="#categoryModal">
                    <i class="fa-solid fa-tags me-2"></i> Categories
                </button>
                <button class="btn btn-banner-primary" data-bs-toggle="modal" data-bs-target="#addModal">
                    <i class="fa-solid fa-plus me-2"></i> Add Product
                </button>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card bg-blue">
                <div class="stat-title">Total Products</div>
                <div class="stat-value"><%= totalProducts %></div>
                <i class="fa-solid fa-boxes-stacked stat-icon-bg"></i>
            </div>
            <div class="stat-card bg-red">
                <div class="stat-title">Low Stock Items</div>
                <div class="stat-value"><%= lowStockItems %></div>
                <i class="fa-solid fa-triangle-exclamation stat-icon-bg"></i>
            </div>
            <div class="stat-card bg-green">
                <div class="stat-title">Total Inventory Value</div>
                <div class="stat-value">Rs. <%= String.format("%,.0f", totalInventoryValue) %></div>
                <i class="fa-solid fa-dollar-sign stat-icon-bg"></i>
            </div>
            <div class="stat-card bg-dark">
                <div class="stat-title">Categories Count</div>
                <div class="stat-value"><%= categoriesCount %></div>
                <i class="fa-solid fa-tags stat-icon-bg"></i>
            </div>
        </div>

        <div class="content-card">
            <div class="table-responsive">
                <table id="inventoryTable" class="table">
                    <thead>
                        <tr><th>ID</th><th>Image</th><th>Product</th><th>Category</th><th>Supplier</th><th>Price</th><th>Stock</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        <% for (Product p : productList) { %>
                        <tr>
                            <td class="text-muted">#<%= p.getId() %></td>
                            <td>
                                <img src="images/<%= p.getImage() %>" class="product-img" onerror="this.src='images/default.png'">
                            </td>
                            <td class="fw-bold text-dark"><%= p.getName() %></td>
                            <td>
                                <span class="badge-category" style="background-color: <%= ColorUtil.getColor(p.getCategory()) %>;">
                                    <%= p.getCategory() %>
                                </span>
                            </td>
                            <td class="text-muted small"><%= p.getSupplier() != null ? p.getSupplier() : "-" %></td>
                            <td class="fw-bold">Rs. <%= String.format("%,.0f", p.getPrice()) %></td>
                            <td>
                                <% if(p.getStockQuantity() < 5) { %>
                                    <span class="badge bg-danger bg-opacity-10 text-danger px-3 py-2 rounded-pill">Low: <%= p.getStockQuantity() %></span>
                                <% } else { %>
                                    <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill"><%= p.getStockQuantity() %></span>
                                <% } %>
                            </td>
                            <td>
                                <button class="btn-action btn-edit me-2"
                                        onclick="openEditModal('<%= p.getId() %>', '<%= p.getName() %>', '<%= p.getCategory() %>', '<%= p.getPrice() %>', '<%= p.getStockQuantity() %>', '<%= p.getImage() %>', '<%= p.getSupplier() %>', '<%= p.getPurchasePrice() %>')">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <button class="btn-action btn-delete" onclick="openDeleteModal('<%= p.getId() %>')">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Add Modal -->
    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Add New Product</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="product-servlet" method="post" enctype="multipart/form-data">
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3"><label class="form-label fw-bold text-muted small">PRODUCT NAME</label><input type="text" name="name" class="form-control bg-light border-0" required></div>
                        <div class="row">
                            <div class="col">
                                <label class="form-label fw-bold text-muted small">CATEGORY</label>
                                <select name="category" class="form-select bg-light border-0">
                                    <% for (String cat : categoryList) { %>
                                        <option value="<%= cat %>"><%= cat %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col">
                                <label class="form-label fw-bold text-muted small">SUPPLIER</label>
                                <select name="supplier" class="form-select bg-light border-0">
                                    <option value="">Select Supplier</option>
                                    <% for (Supplier s : supplierList) { %>
                                        <option value="<%= s.getName() %>"><%= s.getName() %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3 mt-3">
                            <label class="form-label fw-bold text-muted small">IMAGE</label>
                            <input type="file" name="image" class="form-control bg-light border-0" accept="image/*">
                        </div>
                        <div class="row mb-3">
                            <div class="col"><label class="form-label fw-bold text-muted small">SELLING PRICE</label><input type="number" step="0.01" name="price" class="form-control bg-light border-0" required></div>
                            <div class="col"><label class="form-label fw-bold text-muted small">PURCHASE PRICE</label><input type="number" step="0.01" name="purchasePrice" class="form-control bg-light border-0"></div>
                        </div>
                        <div class="row">
                            <div class="col"><label class="form-label fw-bold text-muted small">QUANTITY</label><input type="number" name="quantity" class="form-control bg-light border-0" required></div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4" style="background-color: var(--primary); border: none;">Save Product</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Modal -->
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Edit Product</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="product-servlet" method="post" enctype="multipart/form-data">
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" id="edit_id">
                        <input type="hidden" name="oldImage" id="edit_old_image">
                        <div class="mb-3"><label class="form-label fw-bold text-muted small">PRODUCT NAME</label><input type="text" name="name" id="edit_name" class="form-control bg-light border-0" required></div>
                        <div class="row">
                            <div class="col">
                                <label class="form-label fw-bold text-muted small">CATEGORY</label>
                                <select name="category" id="edit_category" class="form-select bg-light border-0">
                                    <% for (String cat : categoryList) { %>
                                        <option value="<%= cat %>"><%= cat %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col">
                                <label class="form-label fw-bold text-muted small">SUPPLIER</label>
                                <select name="supplier" id="edit_supplier" class="form-select bg-light border-0">
                                    <option value="">Select Supplier</option>
                                    <% for (Supplier s : supplierList) { %>
                                        <option value="<%= s.getName() %>"><%= s.getName() %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3 mt-3">
                            <label class="form-label fw-bold text-muted small">NEW IMAGE (OPTIONAL)</label>
                            <input type="file" name="image" class="form-control bg-light border-0" accept="image/*">
                            <small class="text-muted">Leave empty to keep current image</small>
                        </div>
                        <div class="row mb-3">
                            <div class="col"><label class="form-label fw-bold text-muted small">SELLING PRICE</label><input type="number" step="0.01" name="price" id="edit_price" class="form-control bg-light border-0" required></div>
                            <div class="col"><label class="form-label fw-bold text-muted small">PURCHASE PRICE</label><input type="number" step="0.01" name="purchasePrice" id="edit_purchasePrice" class="form-control bg-light border-0"></div>
                        </div>
                        <div class="row">
                            <div class="col"><label class="form-label fw-bold text-muted small">QUANTITY</label><input type="number" name="quantity" id="edit_quantity" class="form-control bg-light border-0" required></div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-dark rounded-pill px-4">Update</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Category Modal -->
    <div class="modal fade" id="categoryModal" tabindex="-1">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0">
                    <h6 class="modal-title fw-bold">Manage Categories</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-3">
                    <form onsubmit="event.preventDefault(); addCategoryAjax();" class="mb-3">
                        <div class="input-group">
                            <input type="text" id="newCatName" class="form-control bg-light border-0" placeholder="New Category" required>
                            <button class="btn btn-success" type="submit"><i class="fa-solid fa-plus"></i></button>
                        </div>
                    </form>
                    <hr>
                    <div class="category-list" id="categoryListContainer" style="max-height: 200px; overflow-y: auto;">
                        <% for (String cat : categoryList) { %>
                        <div class="d-flex justify-content-between align-items-center p-2 border-bottom" id="cat-row-<%= cat.replaceAll("\\s+","") %>">
                            <span class="fw-bold text-dark"><%= cat %></span>
                            <a href="#" class="text-danger" onclick="deleteCategoryAjax('<%= cat %>')">
                                <i class="fa-solid fa-trash-can"></i>
                            </a>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
         <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-body p-4 text-center">
                    <div class="mb-3 text-danger bg-danger bg-opacity-10 rounded-circle d-inline-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                        <i class="fa-solid fa-triangle-exclamation fa-2x"></i>
                    </div>
                    <h5 class="fw-bold">Delete Item?</h5>
                    <p class="text-muted">This action cannot be undone.</p>
                    <div class="d-flex justify-content-center gap-2 mt-4">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <a id="confirmDeleteBtn" href="#" class="btn btn-danger rounded-pill px-4">Delete</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function () { $('#inventoryTable').DataTable({ "pageLength": 10 }); });

        function openEditModal(id, name, cat, price, qty, img, supplier, purchasePrice) {
            $('#edit_id').val(id);
            $('#edit_name').val(name);
            $('#edit_category').val(cat);
            $('#edit_price').val(price);
            $('#edit_quantity').val(qty);
            $('#edit_old_image').val(img);
            $('#edit_supplier').val(supplier);
            $('#edit_purchasePrice').val(purchasePrice);
            new bootstrap.Modal(document.getElementById('editModal')).show();
        }

        function openDeleteModal(id) {
            $('#confirmDeleteBtn').attr('href', 'product-servlet?action=delete&id=' + id);
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }

        function addCategoryAjax() {
            var catName = $('#newCatName').val();
            if(!catName) return;
            $.ajax({
                url: 'product-servlet',
                type: 'POST',
                data: { action: 'addCategory', categoryName: catName },
                success: function(response) {
                    if(response.trim() === "success") {
                        location.reload();
                    } else {
                        alert("Error: Category might already exist.");
                    }
                }
            });
        }

        function deleteCategoryAjax(catName) {
            if(!confirm("Are you sure you want to delete '" + catName + "'?")) return;
            $.ajax({
                url: 'product-servlet',
                type: 'POST',
                data: { action: 'deleteCategory', name: catName },
                success: function(response) {
                    if(response.trim() === "success") {
                        location.reload();
                    } else {
                        alert("Error deleting category.");
                    }
                }
            });
        }
    </script>
</body>
</html>