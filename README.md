# Inventory Management System 📦

A comprehensive, web-based Inventory Management System developed by **Group 40**. This application streamlines product tracking, stock management, sales reporting, supplier management, and expense tracking with a responsive, user-friendly interface.

## 🚀 Key Features

### 🔹 1. Dashboard & Analytics
- **Real-Time Overview:** Instantly view Total Inventory Value, Low Stock Alerts, and Total Product Counts.
- **Visual Charts:**
    - **Doughnut Chart:** Visualizes stock distribution across categories.
    - **Dynamic Colors:** Categories are automatically assigned unique, consistent colors based on their names.

### 🔹 2. Point of Sale (POS) & Billing
- **Streamlined Checkout:** Efficient interface for processing sales transactions.
- **Bill Generation:** Automatically generates bills for transactions.
- **Real-time Stock Updates:** Deducts stock immediately upon sale.

### 🔹 3. Product Management
- **Image Support:** Upload product images directly when adding or editing items.
- **CRUD Operations:** Add, Edit, and Delete products seamlessly.
- **Smart Validation:** Prevents invalid inputs (e.g., negative prices).
- **Searchable Table:** Built-in sorting, pagination, and filtering using DataTables.

### 🔹 4. Supplier & Expense Management
- **Supplier Directory:** Manage supplier contact details and information.
- **Expense Tracking:** Record and monitor operational expenses (e.g., bills, rent).

### 🔹 5. Advanced Category Management
- **AJAX-Powered Manager:** Add or Delete categories **without reloading the page**.
- **Dynamic Tagging:** Categories in tables are displayed with auto-generated colored badges.

### 🔹 6. Reporting Module
- **Sales Reports:** View transaction history and sales performance.
- **Stock Level Analysis:** Bar charts showing exact stock quantities per category.
- **System Stats:** Quick summary of active categories and total products.

### 🔹 7. Security
- **Role-Based Access:** Secure login system (Admin/Staff).
- **Session Management:** Auto-redirects unauthenticated users to the login page.
- **Auth Filters:** Protects sensitive routes from unauthorized access.

---

## 🛠️ Tech Stack

- **Backend:** Java (Jakarta EE / Servlets)
- **Frontend:** JSP, JSTL, HTML5, CSS3
- **Styling:** Bootstrap 5 (Responsive Design)
- **Scripting:** jQuery (AJAX), Chart.js (Data Visualization)
- **Database:** MySQL 8.0
- **Build Tool:** Maven

---

## ⚙️ Setup Instructions

### 1. Database Configuration
1. Open **MySQL Workbench** or **phpMyAdmin**.
2. Run the SQL script provided in `database.sql` (located in the project root).
3. This will create the `inventory_system` database and tables (`users`, `products`, `categories`, `sales`, `suppliers`, `expenses`).
4. **Data Generation:** The script includes stored procedures to generate realistic sample data (Sri Lanka context) for products, suppliers, and sales history.

### 2. Application Configuration
1. Open the project in **IntelliJ IDEA** (or your preferred IDE).
2. Navigate to `src/main/java/com/inventory/dao/DBConnection.java`.
3. Update the `getConnection()` method with your local MySQL credentials:
   ```java
   String url = "jdbc:mysql://localhost:3306/inventory_system";
   String username = "root";  // Your MySQL Username
   String password = "your_password"; // Your MySQL Password
   ```

### 3. Running the Server
1. Configure Apache Tomcat 10.1 in your IDE.
2. Deploy the artifact (war exploded).
3. Run the server.
4. Access the app at: `http://localhost:8080/InventorySystem` (or your configured context path).

---

## 🔐 Default Credentials
Use these credentials to log in for the first time:
- **Admin:** `admin` / `1234`
- **Staff:** `staff` / `1234`

---

## 📂 Project Structure

This directory structure reflects the core files and packages used in the project:

```text
InventorySystem/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/inventory/
│   │   │       ├── controller/
│   │   │       │   ├── AuthFilter.java        # Security Filter
│   │   │       │   ├── LoginServlet.java      # Authentication
│   │   │       │   ├── LogoutServlet.java     # Session Cleanup
│   │   │       │   ├── ProductServlet.java    # Product CRUD
│   │   │       │   ├── CheckoutServlet.java   # POS Transaction Handling
│   │   │       │   ├── BillServlet.java       # Bill Generation
│   │   │       │   ├── SupplierServlet.java   # Supplier Management
│   │   │       │   └── ExpenseServlet.java    # Expense Tracking
│   │   │       ├── dao/
│   │   │       │   ├── DBConnection.java      # JDBC Connection
│   │   │       │   ├── ProductDAO.java        # Product DB Operations
│   │   │       │   ├── CategoryDAO.java       # Category DB Operations
│   │   │       │   └── SalesDAO.java          # Sales DB Operations
│   │   │       └── model/
│   │   │           ├── User.java              # User Entity
│   │   │           └── Product.java           # Product Entity
│   │   └── webapp/
│   │       ├── images/                        # Product Image Uploads
│   │       ├── css/                           # Custom Stylesheets
│   │       ├── js/                            # Custom Scripts
│   │       ├── dashboard.jsp                  # Main Admin Dashboard
│   │       ├── pos.jsp                        # Point of Sale Interface
│   │       ├── products.jsp                   # Product Management
│   │       ├── suppliers.jsp                  # Supplier Management
│   │       ├── expenses.jsp                   # Expense Management
│   │       ├── sales.jsp                      # Sales History
│   │       ├── reports.jsp                    # Analytics & Charts
│   │       └── login.jsp                      # Login Page
├── database.sql                               # MySQL Database Setup & Data Gen
├── pom.xml                                    # Maven Dependencies
├── LICENSE                                    # License File
└── README.md                                  # Project Documentation
```