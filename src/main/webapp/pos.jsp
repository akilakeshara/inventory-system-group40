<%@ page import="com.inventory.model.User" %>
<%@ page import="com.inventory.dao.CategoryDAO" %>
<%@ page import="com.inventory.util.ColorUtil" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    CategoryDAO categoryDAO = new CategoryDAO();
    List<String> categoryList = categoryDAO.getAllCategories();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>POS Terminal | Inventory System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
            --secondary: #ec4899;
            --sidebar-bg: #0f172a;
            --light-bg: #f1f5f9;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
        }

        body { font-family: 'Inter', sans-serif; background-color: var(--light-bg); height: 100vh; overflow: hidden; }

        .pos-container { display: flex; height: 100vh; }

        .product-area { flex: 1; display: flex; flex-direction: column; overflow: hidden; }

        .pos-header {
            background: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            z-index: 10;
        }
        .search-bar { position: relative; width: 400px; }
        .search-input {
            width: 100%;
            padding: 12px 20px 12px 45px;
            border-radius: 50px;
            border: 1px solid var(--border-color);
            background: var(--light-bg);
            transition: 0.3s;
        }
        .search-input:focus { background: white; border-color: var(--primary); outline: none;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2); }
        .search-icon { position: absolute;
            left: 15px; top: 50%; transform: translateY(-50%); color: var(--text-muted); }

        .category-bar {
            padding: 15px 30px;
            background: white;
            overflow-x: auto;
            white-space: nowrap;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            gap: 10px;
        }
        .cat-chip {
            padding: 8px 20px;
            border-radius: 30px;
            background: var(--light-bg);
            color: var(--text-muted);
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
            transition: 0.2s;
            border: 1px solid transparent;
        }
        .cat-chip:hover { background: #e0e7ff; color: var(--primary); }
        .cat-chip.active { background: var(--primary); color: white;
            box-shadow: 0 4px 10px rgba(99, 102, 241, 0.3); }

        .product-grid-wrapper { flex: 1;
            overflow-y: auto; padding: 30px; }
        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px; }

        .product-card {
            background: white;
            border-radius: 16px;
            border: 1px solid var(--border-color);
            overflow: hidden;
            cursor: pointer;
            transition: all 0.2s ease;
            position: relative;
        }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1); border-color: var(--primary); }
        .product-card:active { transform: scale(0.98); }

        .card-img-box {
            height: 140px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8fafc;
            position: relative;
        }
        .product-img { max-height: 100px; max-width: 80%; object-fit: contain; }

        .stock-badge {
            position: absolute;
            top: 10px; right: 10px;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
            background: rgba(255,255,255,0.9);
            backdrop-filter: blur(4px);
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .stock-low { color: #ef4444; background: #fee2e2; }
        .stock-ok { color: #10b981; background: #d1fae5; }

        .card-details { padding: 15px; }
        .p-name { font-weight: 700; color: var(--text-main); margin-bottom: 5px; white-space: nowrap; overflow: hidden;
            text-overflow: ellipsis; }
        .p-cat { font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; }
        .p-price { font-size: 1.1rem; font-weight: 800; color: var(--primary); margin-top: 8px; }

        .cart-area {
            width: 450px;
            background: #ffffff;
            border-left: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            box-shadow: -10px 0 30px rgba(0,0,0,0.03);
            z-index: 20;
        }

        .cart-header {
            padding: 25px;
            background: #ffffff;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .cart-title { font-size: 1.25rem; font-weight: 800; color: var(--text-main); letter-spacing: -0.5px; display: flex;
            align-items: center; gap: 10px; }

        .btn-clear {
            color: #ef4444;
            background: #fee2e2;
            border: none;
            padding: 8px 15px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.85rem;
            cursor: pointer;
            transition: 0.2s;
        }
        .btn-clear:hover { background: #ef4444; color: white; }

        .cart-items {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
            background: #f8fafc;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .cart-item {
            background: white;
            border-radius: 16px;
            padding: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
            border: 1px solid transparent;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            animation: slideIn 0.3s ease;
        }
        .cart-item:hover {
            border-color: var(--primary);
            box-shadow: 0 5px 15px rgba(99, 102, 241, 0.08);
            transform: translateY(-2px);
        }

        .item-left { flex: 1; min-width: 0; }
        .item-title { font-weight: 700; color: var(--text-main); font-size: 0.95rem; margin-bottom: 4px; white-space: nowrap;
            overflow: hidden; text-overflow: ellipsis; }
        .item-meta { font-size: 0.8rem; color: #94a3b8; display: flex;
            align-items: center; gap: 5px; }
        .item-total { font-weight: 800; color: var(--primary); font-size: 1rem; }

        .item-right { display: flex; align-items: center; gap: 15px; }

        .qty-stepper {
            display: flex;
            align-items: center;
            background: #f1f5f9;
            border-radius: 10px;
            padding: 3px;
        }
        .btn-qty {
            width: 28px;
            height: 28px;
            display: flex; align-items: center; justify-content: center;
            background: white;
            border-radius: 8px;
            color: var(--text-main);
            cursor: pointer;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            transition: 0.2s;
            font-size: 0.8rem;
        }
        .btn-qty:hover { background: var(--primary);
            color: white; }
        .qty-display { width: 30px; text-align: center; font-weight: 700; font-size: 0.9rem;
            color: #334155; }

        .btn-remove {
            width: 32px;
            height: 32px;
            display: flex; align-items: center; justify-content: center;
            color: #ef4444;
            background: #fee2e2;
            border-radius: 10px;
            cursor: pointer;
            transition: 0.2s;
            font-size: 0.9rem;
        }
        .btn-remove:hover { background: #ef4444; color: white; }

        .cart-footer {
            background: white;
            padding: 25px;
            border-top: 1px solid #f1f5f9;
            box-shadow: 0 -10px 30px rgba(0,0,0,0.02);
        }
        .summary-item { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 0.95rem; color: #64748b;
            font-weight: 500; }
        .summary-total { display: flex; justify-content: space-between; margin-top: 15px; padding-top: 15px;
            border-top: 2px dashed #e2e8f0; }
        .total-label { font-size: 1.1rem; font-weight: 800; color: var(--text-main); }
        .total-amount { font-size: 1.5rem; font-weight: 800; color: var(--primary); }

        .btn-pay {
            width: 100%;
            margin-top: 20px;
            padding: 18px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 16px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 10px 20px rgba(99, 102, 241, 0.3);
            transition: 0.3s;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .btn-pay:hover { background: var(--primary-dark); transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(99, 102, 241, 0.4); }
        .btn-pay span { display: flex;
            align-items: center; gap: 10px; }

        .empty-cart {
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            opacity: 0.6;
        }
        .empty-cart i { font-size: 5rem; margin-bottom: 20px; color: #cbd5e1; }

        @keyframes slideIn { from { opacity: 0; transform: translateX(20px);
        } to { opacity: 1; transform: translateX(0); } }
    </style>
</head>
<body>

<div class="pos-container">

    <div class="product-area">
        <div class="pos-header">
            <div class="d-flex align-items-center gap-3">
                <a href="dashboard.jsp" class="text-decoration-none">
                    <div class="bg-dark text-white rounded-circle d-flex align-items-center justify-content-center" style="width: 45px; height: 45px;">
                        <i class="fa-solid fa-cube fs-5"></i>
                    </div>
                </a>
                <div>
                    <h5 class="m-0 fw-bold text-dark">POS Terminal</h5>
                    <small class="text-muted">Staff: <%= user.getUsername() %></small>
                </div>
            </div>

            <div class="search-bar">
                <i class="fa-solid fa-search search-icon"></i>
                <input type="text" id="searchInput" class="search-input" placeholder="Search products..." onkeyup="filterProducts()">
            </div>

            <a href="logout" class="btn btn-outline-danger rounded-pill px-4 fw-bold">
                <i class="fa-solid fa-power-off me-2"></i> Logout
            </a>
        </div>

        <div class="category-bar">
            <div class="cat-chip active" onclick="filterCategory('all', this)">All Items</div>
            <% for (String cat : categoryList) { %>
                <div class="cat-chip" onclick="filterCategory('<%= cat %>', this)"><%= cat %></div>
            <% } %>
        </div>

        <div class="product-grid-wrapper">
            <div class="product-grid" id="productGrid">
                <%-- Products will be loaded dynamically via JavaScript --%>
            </div>
        </div>
    </div>

    <div class="cart-area">
        <div class="cart-header">
            <div class="cart-title">
                <i class="fa-solid fa-bag-shopping text-primary"></i> Current Order
            </div>
            <button class="btn-clear" onclick="clearCart()" title="Clear Cart"><i class="fa-solid fa-trash-can me-1"></i> Clear All</button>
        </div>

        <div class="cart-items" id="cartItemsContainer">
            <div class="empty-cart">
                <i class="fa-solid fa-cart-shopping"></i>
                <p class="fw-bold">Cart is Empty</p>
                <small>Select items to add to order</small>
            </div>
        </div>

        <div class="cart-footer">
            <div class="summary-item">
                <span>Subtotal</span>
                <span id="subtotal">Rs. 0</span>
            </div>
            <div class="summary-item">
                <span>Tax (0%)</span>
                <span>Rs. 0</span>
            </div>
            <div class="summary-total">
                <span class="total-label">Total Payable</span>
                <span class="total-amount" id="total">Rs. 0</span>
            </div>
            <button class="btn-pay" onclick="openPaymentModal()">
                <span><i class="fa-solid fa-credit-card"></i> Pay Now</span>
                <i class="fa-solid fa-arrow-right"></i>
            </button>
        </div>
    </div>
</div>

<div class="modal fade" id="paymentModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header bg-dark text-white border-0" style="background-color: var(--sidebar-bg) !important;">
                <h5 class="modal-title fw-bold"><i class="fa-solid fa-wallet me-2"></i>Payment</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="text-center mb-4">
                    <small class="text-muted text-uppercase fw-bold">Total Amount</small>
                    <h1 class="fw-bold text-primary display-4" id="modalTotal">Rs. 0</h1>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Cash Tendered</label>
                    <div class="input-group input-group-lg">
                        <span class="input-group-text bg-light border-0">Rs.</span>
                        <input type="number" id="cashInput" class="form-control bg-light border-0 fw-bold" placeholder="0.00" oninput="calculateChange()">
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center p-3 bg-success bg-opacity-10 rounded-3 border border-success border-opacity-25">
                    <span class="fw-bold text-success">Change Due:</span>
                    <span class="fw-bold text-success fs-4" id="changeDisplay">Rs. 0.00</span>
                </div>
            </div>
            <div class="modal-footer border-0 p-4 pt-0">
                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary rounded-pill px-5 fw-bold" onclick="processCheckout()">
                    Complete Sale <i class="fa-solid fa-check ms-2"></i>
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let cart = [];
    let currentTotal = 0;
    let activeCategory = 'all';

    const categoryColors = {};
    <% for (String cat : categoryList) { %>
        categoryColors['<%= cat %>'] = '<%= ColorUtil.getColor(cat) %>';
    <% } %>

    $(document).ready(function() {
        filterProducts(); // Load initial products
    });

    document.addEventListener('keydown', function(event) {
        if (event.key === 'F9') {
            event.preventDefault();
            openPaymentModal();
        }
    });

    function filterProducts() {
        let term = $('#searchInput').val().toLowerCase();
        $.ajax({
            url: 'product-servlet',
            type: 'GET',
            data: {
                action: 'search',
                q: term,
                category: activeCategory
            },
            dataType: 'json',
            success: function(products) {
                renderProductGrid(products);
            },
            error: function() {
                $('#productGrid').html('<div class="col-12 text-center text-muted mt-5"><h5>Error loading products.</h5></div>');
            }
        });
    }

    function renderProductGrid(products) {
        let grid = $('#productGrid');
        grid.empty();
        if (products.length === 0) {
            grid.html('<div class="col-12 text-center text-muted mt-5"><h5>No products found</h5></div>');
            return;
        }

        products.forEach(p => {
            let lowStock = p.stock < 5;
            let stockClass = lowStock ? "stock-low" : "stock-ok";
            let safeName = p.name.replace(/"/g, '&quot;').replace(/'/g, '&#39;');
            let color = categoryColors[p.category] || '#64748b';

            let card = `
                <div class="product-card"
                     data-id="\${p.id}"
                     data-name="\${safeName}"
                     data-price="\${p.price}"
                     data-stock="\${p.stock}"
                     data-category="\${p.category}"
                     onclick="addToCart(this)">
                    <div class="card-img-box">
                        <span class="stock-badge \${stockClass}">
                             \${p.stock} left
                        </span>
                        <img src="images/\${p.image}" class="product-img" onerror="this.src='images/default.png'">
                    </div>
                    <div class="card-details">
                        <div class="p-cat" style="color: \${color}">\${p.category}</div>
                        <div class="p-name">\${p.name}</div>
                        <div class="p-price">Rs. \${p.price.toLocaleString()}</div>
                    </div>
                </div>
            `;
            grid.append(card);
        });
    }

    function addToCart(element) {
        let id = element.getAttribute('data-id');
        let name = element.getAttribute('data-name');
        let price = parseFloat(element.getAttribute('data-price'));
        let maxStock = parseInt(element.getAttribute('data-stock'));

        let existingItem = cart.find(item => item.id == id);
        if (existingItem) {
            if (existingItem.qty < maxStock) {
                existingItem.qty++;
            } else {
                alert("Max stock reached for " + name);
                return;
            }
        } else {
            if (maxStock > 0) {
                cart.push({ id: id, name: name, price: price, qty: 1, max: maxStock });
            } else {
                alert("Item is out of stock!");
                return;
            }
        }
        renderCart();
    }

    function removeFromCart(id) {
        cart = cart.filter(item => item.id != id);
        renderCart();
    }

    function clearCart() {
        if(cart.length > 0 && confirm("Clear current order?")) {
            cart = [];
            renderCart();
        }
    }

    function updateQty(id, change) {
        let item = cart.find(item => item.id == id);
        if (item) {
            let newQty = item.qty + change;
            if (newQty > 0 && newQty <= item.max) {
                item.qty = newQty;
            } else if (newQty <= 0) {
                removeFromCart(id);
                return;
            } else {
                alert("Max stock reached!");
            }
        }
        renderCart();
    }

    function renderCart() {
        let container = $('#cartItemsContainer');
        container.empty();
        let total = 0;

        if (cart.length === 0) {
            container.html('<div class="empty-cart"><i class="fa-solid fa-cart-shopping"></i><p class="fw-bold">Cart is Empty</p><small>Select items to add to order</small></div>');
        } else {
            cart.forEach(item => {
                let itemTotal = item.price * item.qty;
                total += itemTotal;

                let html = '<div class="cart-item">' +
                           '<div class="item-left">' +
                           '<div class="item-title">' + item.name + '</div>' +
                           '<div class="item-meta">' +
                           '<span>Rs. ' + item.price.toLocaleString() + '</span>' +
                           '<span class="text-muted">x ' + item.qty + '</span>' +
                           '</div>' +
                           '</div>' +
                           '<div class="item-right">' +
                           '<div class="item-total">Rs. ' + itemTotal.toLocaleString() + '</div>' +
                           '<div class="qty-stepper">' +
                           '<div class="btn-qty" onclick="updateQty(\'' + item.id + '\', -1)"><i class="fa-solid fa-minus"></i></div>' +
                           '<div class="qty-display">' + item.qty + '</div>' +
                           '<div class="btn-qty" onclick="updateQty(\'' + item.id + '\', 1)"><i class="fa-solid fa-plus"></i></div>' +
                           '</div>' +
                           '<div class="btn-remove" onclick="removeFromCart(\'' + item.id + '\')"><i class="fa-solid fa-trash-can"></i></div>' +
                           '</div>' +
                           '</div>';

                container.append(html);
            });
        }

        currentTotal = total;
        $('#subtotal').text('Rs. ' + total.toLocaleString());
        $('#total').text('Rs. ' + total.toLocaleString());
        $('#modalTotal').text('Rs. ' + total.toLocaleString());
    }

    function filterCategory(category, element) {
        $('.cat-chip').removeClass('active');
        $(element).addClass('active');
        activeCategory = category;
        filterProducts();
    }

    function openPaymentModal() {
        if (cart.length === 0) {
            alert("Cart is empty!");
            return;
        }
        $('#modalTotal').text('Rs. ' + currentTotal.toLocaleString());
        $('#cashInput').val('');
        $('#changeDisplay').text('Rs. 0.00');
        new bootstrap.Modal(document.getElementById('paymentModal')).show();
    }

    function calculateChange() {
        let cash = parseFloat($('#cashInput').val()) || 0;
        let change = cash - currentTotal;
        if (change < 0) change = 0;
        $('#changeDisplay').text('Rs. ' + change.toLocaleString(undefined, {minimumFractionDigits: 2, maximumFractionDigits: 2}));
    }

    function processCheckout() {
        let cash = parseFloat($('#cashInput').val()) || 0;
        if (cash < currentTotal) {
            alert("Insufficient cash tendered!");
            return;
        }

        $.ajax({
            url: 'checkout-servlet',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(cart),
            success: function(response) {
                if(response.trim() === "success") {
                    alert("Order Placed Successfully!");
                    cart = [];
                    renderCart();
                    location.reload();
                } else {
                    alert("Checkout Failed: " + response);
                }
            },
            error: function() {
                alert("Error processing request.");
            }
        });
    }
</script>

</body>
</html>