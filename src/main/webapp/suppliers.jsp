<%@ page import="com.inventory.model.User" %>
<%@ page import="com.inventory.dao.SupplierDAO" %>
<%@ page import="com.inventory.model.Supplier" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    SupplierDAO supplierDAO = new SupplierDAO();
    List<Supplier> supplierList = supplierDAO.getAllSuppliers();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Suppliers | Inventory System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css">

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
        .bg-blue { background-color: var(--primary); }
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

        .btn-add {
            background: var(--primary);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s;
        }
        .btn-add:hover { background: #4f46e5; transform: translateY(-2px); box-shadow: 0 4px 10px rgba(99, 102, 241, 0.3); color: white; }

        .btn-action {
            width: 32px; height: 32px;
            display: inline-flex; align-items: center; justify-content: center;
            border-radius: 8px;
            transition: 0.2s;
            border: none;
            margin-right: 5px;
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
            <a href="products.jsp" class="nav-link">
                <i class="fa-solid fa-box-archive"></i> Products
            </a>
            <a href="sales.jsp" class="nav-link">
                <i class="fa-solid fa-receipt"></i> Sales
            </a>
            <a href="suppliers.jsp" class="nav-link active">
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
                <h2>Suppliers</h2>
                <p>Manage your vendor relationships.</p>
            </div>
            <button class="btn-add" data-bs-toggle="modal" data-bs-target="#addSupplierModal">
                <i class="fa-solid fa-plus"></i> Add Supplier
            </button>
        </div>

        <div class="stats-grid">
            <div class="stat-card bg-blue">
                <div class="stat-title">Total Suppliers</div>
                <div class="stat-value"><%= supplierList.size() %></div>
                <i class="fa-solid fa-truck-field stat-icon-bg"></i>
            </div>
        </div>

        <div class="content-card">
            <div class="table-responsive">
                <table id="supplierTable" class="table table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Supplier Name</th>
                            <th>Contact Person</th>
                            <th>Phone</th>
                            <th>Email</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Supplier s : supplierList) { %>
                        <tr>
                            <td class="text-muted">#SUP-<%= s.getId() %></td>
                            <td class="fw-bold text-dark"><%= s.getName() %></td>
                            <td><%= s.getContactPerson() %></td>
                            <td><%= s.getPhone() %></td>
                            <td><%= s.getEmail() %></td>
                            <td>
                                <button class="btn-action btn-edit" onclick="openEditModal('<%= s.getId() %>', '<%= s.getName() %>', '<%= s.getContactPerson() %>', '<%= s.getPhone() %>', '<%= s.getEmail() %>')">
                                    <i class="fa-solid fa-pen"></i>
                                </button>
                                <a href="supplier-servlet?action=delete&id=<%= s.getId() %>" class="btn-action btn-delete" onclick="return confirm('Are you sure?')">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Add Supplier Modal -->
    <div class="modal fade" id="addSupplierModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Add New Supplier</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="supplier-servlet" method="post">
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3"><label class="form-label fw-bold text-muted small">SUPPLIER NAME</label><input type="text" name="name" class="form-control bg-light border-0" required></div>
                        <div class="mb-3"><label class="form-label fw-bold text-muted small">CONTACT PERSON</label><input type="text" name="contact" class="form-control bg-light border-0"></div>
                        <div class="row">
                            <div class="col"><label class="form-label fw-bold text-muted small">PHONE</label><input type="text" name="phone" class="form-control bg-light border-0"></div>
                            <div class="col"><label class="form-label fw-bold text-muted small">EMAIL</label><input type="email" name="email" class="form-control bg-light border-0"></div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4" style="background-color: var(--primary); border: none;">Save Supplier</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Supplier Modal -->
    <div class="modal fade" id="editSupplierModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0">
                    <h5 class="modal-title fw-bold">Edit Supplier</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="supplier-servlet" method="post">
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" id="edit_id">
                        <div class="mb-3"><label class="form-label fw-bold text-muted small">SUPPLIER NAME</label><input type="text" name="name" id="edit_name" class="form-control bg-light border-0" required></div>
                        <div class="mb-3"><label class="form-label fw-bold text-muted small">CONTACT PERSON</label><input type="text" name="contact" id="edit_contact" class="form-control bg-light border-0"></div>
                        <div class="row">
                            <div class="col"><label class="form-label fw-bold text-muted small">PHONE</label><input type="text" name="phone" id="edit_phone" class="form-control bg-light border-0"></div>
                            <div class="col"><label class="form-label fw-bold text-muted small">EMAIL</label><input type="email" name="email" id="edit_email" class="form-control bg-light border-0"></div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-dark rounded-pill px-4">Update Supplier</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function () {
            $('#supplierTable').DataTable({ "pageLength": 10 });
        });

        function openEditModal(id, name, contact, phone, email) {
            $('#edit_id').val(id);
            $('#edit_name').val(name);
            $('#edit_contact').val(contact);
            $('#edit_phone').val(phone);
            $('#edit_email').val(email);
            new bootstrap.Modal(document.getElementById('editSupplierModal')).show();
        }
    </script>
</body>
</html>