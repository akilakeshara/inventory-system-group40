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