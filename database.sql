CREATE DATABASE IF NOT EXISTS inventory_system;
USE inventory_system;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS expenses;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL
);

-- 2. Categories Table
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- 3. Suppliers Table
CREATE TABLE suppliers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100)
);

-- 4. Products Table
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    purchase_price DECIMAL(10, 2) DEFAULT 0.00, -- NEW
    price DECIMAL(10, 2) NOT NULL, -- Selling Price
    stock_quantity INT NOT NULL,
    image VARCHAR(255) DEFAULT 'default.png',
    supplier VARCHAR(100) DEFAULT 'Unknown'
);

-- 5. Sales Table
CREATE TABLE sales (
    id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id VARCHAR(50) NOT NULL,
    product_id INT,
    product_name VARCHAR(100),
    quantity INT,
    total_price DECIMAL(10, 2),
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL
);

-- 6. Expenses Table (NEW)
CREATE TABLE expenses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    description VARCHAR(255) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    expense_date DATE NOT NULL
);

-- ==========================================
-- DATA GENERATION (SRI LANKA CONTEXT)
-- ==========================================

INSERT INTO users (username, password, role) VALUES ('admin', '1234', 'ADMIN'), ('staff', '1234', 'STAFF');

-- 10 Real World Categories
INSERT INTO categories (name) VALUES
('Smartphones'), ('Laptops'), ('Tablets'), ('Smart Watches'), ('Headphones'),
('Cameras'), ('Gaming Consoles'), ('PC Components'), ('Monitors'), ('Accessories');

-- 50 Real World Suppliers
INSERT INTO suppliers (name, contact_person, phone, email) VALUES
('Abans PLC', 'Kamal Perera', '+94 77 123 4567', 'sales@abans.lk'),
('Singer Sri Lanka', 'Nimal Silva', '+94 71 234 5678', 'info@singer.lk'),
('Softlogic Holdings', 'Sunil Fernando', '+94 75 345 6789', 'contact@softlogic.lk'),
('Dialog Axiata', 'Ruwan De Silva', '+94 77 777 7777', 'business@dialog.lk'),
('Metropolitan', 'Chathura Gunawardena', '+94 11 234 5678', 'sales@metropolitan.lk'),
('CameraLK', 'Anushka Dissanayake', '+94 71 111 2222', 'info@cameralk.com'),
('Redline Technologies', 'Zaffran Zain', '+94 77 987 6543', 'sales@redlinetech.lk'),
('Nanotek Computer', 'Rizwan Anver', '+94 77 555 4444', 'info@nanotek.lk'),
('Barclays Computers', 'Feroz Ahmed', '+94 11 255 5555', 'sales@barclays.lk'),
('Wisdom Q', 'Mahesh Kumara', '+94 71 888 9999', 'info@wisdomq.lk'),
('Tech Zone', 'Dinesh Priyantha', '+94 77 222 3333', 'sales@techzone.lk'),
('Unity Plaza Vendors', 'Saman Ekanayake', '+94 11 250 1234', 'unity@vendors.lk'),
('Future World', 'Kasun Rajapakshe', '+94 77 666 5555', 'sales@futureworld.lk'),
('iStore Sri Lanka', 'Dilshan Perera', '+94 77 444 3333', 'info@istore.lk'),
('Daraz Sellers', 'Online Vendor', '+94 11 757 5600', 'seller@daraz.lk'),
('Kapruka', 'E-commerce Team', '+94 11 212 3456', 'support@kapruka.com'),
('Takas.lk', 'Sales Team', '+94 11 777 8888', 'info@takas.lk'),
('Urban.lk', 'Kalana', '+94 77 999 0000', 'sales@urban.lk'),
('Celltronics', 'Rifkhan', '+94 77 123 0987', 'info@celltronics.lk'),
('GQ Mobile', 'Gayan', '+94 71 234 0987', 'sales@gqmobile.lk'),
('Divine Cell', 'Damith', '+94 75 345 0987', 'info@divine.lk'),
('Life Mobile', 'Lahiru', '+94 77 777 0987', 'sales@lifemobile.lk'),
('Doctor Mobile', 'Dr. Saman', '+94 11 234 0987', 'doc@mobile.lk'),
('Tharanga Electronics', 'Tharanga', '+94 71 111 0987', 'info@tharanga.lk'),
('Winsoft', 'Wasantha', '+94 77 987 0987', 'sales@winsoft.lk'),
('Sense Micro', 'Sanjeewa', '+94 77 555 0987', 'info@sense.lk'),
('PC House', 'Pradeep', '+94 11 255 0987', 'sales@pchouse.lk'),
('E-Globe Solutions', 'Eranda', '+94 71 888 0987', 'info@eglobe.lk'),
('Techno City', 'Thilak', '+94 77 222 0987', 'sales@techno.lk'),
('Laptop.lk', 'Lalith', '+94 11 250 0987', 'info@laptop.lk'),
('MyStore.lk', 'Manjula', '+94 77 666 0987', 'sales@mystore.lk'),
('BuyAbans', 'Online Team', '+94 77 444 0987', 'support@buyabans.com'),
('Singer Plus', 'Branch Manager', '+94 11 757 0987', 'plus@singer.lk'),
('Softlogic Max', 'Showroom', '+94 11 212 0987', 'max@softlogic.lk'),
('Damro', 'Customer Care', '+94 11 777 0987', 'care@damro.lk'),
('Arpico', 'Supercentre', '+94 77 999 0987', 'info@arpico.com'),
('Cargills', 'Food City', '+94 77 123 1111', 'contact@cargills.lk'),
('Keells', 'Super', '+94 71 234 1111', 'info@keells.com'),
('Laugfs', 'Supermarket', '+94 75 345 1111', 'sales@laugfs.lk'),
('Glomark', 'Softlogic', '+94 77 777 1111', 'info@glomark.lk'),
('Spar', 'Supermarket', '+94 11 234 1111', 'contact@spar.lk'),
('Cool Planet', 'Fashion', '+94 71 111 1111', 'info@coolplanet.lk'),
('Nolimit', 'Clothing', '+94 77 987 1111', 'sales@nolimit.lk'),
('Fashion Bug', 'Store', '+94 77 555 1111', 'info@fashionbug.lk'),
('Odel', 'Department Store', '+94 11 255 1111', 'sales@odel.lk'),
('House of Fashions', 'Manager', '+94 71 888 1111', 'info@hof.lk'),
('Kandy', 'Selection', '+94 77 222 1111', 'sales@kandy.lk'),
('Thilakawardhana', 'Textiles', '+94 11 250 1111', 'info@thilak.lk'),
('CIB', 'Shopping Centre', '+94 77 666 1111', 'sales@cib.lk'),
('Lady J', 'Fashion', '+94 77 444 1111', 'info@ladyj.lk');

-- Generate 200 Real World Products (LKR Prices)
DELIMITER $$
DROP PROCEDURE IF EXISTS generate_real_products$$
CREATE PROCEDURE generate_real_products()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE p_name VARCHAR(100);
  DECLARE p_cat VARCHAR(50);
  DECLARE p_price DECIMAL(10,2);
  DECLARE p_purchase_price DECIMAL(10,2); -- NEW
  DECLARE sup_name VARCHAR(100);

  WHILE i <= 200 DO
    -- Pick a random supplier
    SELECT name INTO sup_name FROM suppliers ORDER BY RAND() LIMIT 1;

    -- Logic to pick category and generate name based on index
    IF i <= 20 THEN SET p_cat = 'Smartphones'; SET p_name = CONCAT('iPhone ', 11 + FLOOR(RAND()*5), ' Pro'); SET p_price = 250000.00 + RAND()*150000;
    ELSEIF i <= 40 THEN SET p_cat = 'Laptops'; SET p_name = CONCAT('MacBook Air M', 1 + FLOOR(RAND()*2)); SET p_price = 350000.00 + RAND()*200000;
    ELSEIF i <= 60 THEN SET p_cat = 'Tablets'; SET p_name = CONCAT('iPad ', 9 + FLOOR(RAND()*2), 'th Gen'); SET p_price = 120000.00 + RAND()*80000;
    ELSEIF i <= 80 THEN SET p_cat = 'Smart Watches'; SET p_name = CONCAT('Apple Watch SE ', 2 + FLOOR(RAND()*2)); SET p_price = 95000.00 + RAND()*50000;
    ELSEIF i <= 100 THEN SET p_cat = 'Headphones'; SET p_name = CONCAT('JBL Tune ', 500 + FLOOR(RAND()*200)); SET p_price = 25000.00 + RAND()*30000;
    ELSEIF i <= 120 THEN SET p_cat = 'Cameras'; SET p_name = CONCAT('Canon EOS ', 200 + FLOOR(RAND()*800), 'D'); SET p_price = 180000.00 + RAND()*300000;
    ELSEIF i <= 140 THEN SET p_cat = 'Gaming Consoles'; SET p_name = CONCAT('PS', 4 + FLOOR(RAND()*2), ' Slim'); SET p_price = 145000.00 + RAND()*50000;
    ELSEIF i <= 160 THEN SET p_cat = 'Monitors'; SET p_name = CONCAT('Samsung ', 22 + FLOOR(RAND()*10), ' inch IPS'); SET p_price = 45000.00 + RAND()*60000;
    ELSEIF i <= 180 THEN SET p_cat = 'PC Components'; SET p_name = CONCAT('Kingston RAM ', 8 + FLOOR(RAND()*24), 'GB'); SET p_price = 12000.00 + RAND()*25000;
    ELSE SET p_cat = 'Accessories'; SET p_name = CONCAT('Anker PowerBank ', 10000 + FLOOR(RAND()*10000), 'mAh'); SET p_price = 8500.00 + RAND()*15000;
    END IF;

    -- Set purchase price to be 70-90% of selling price
    SET p_purchase_price = p_price * (0.7 + (RAND() * 0.2));

    INSERT INTO products (name, category, purchase_price, price, stock_quantity, supplier)
    VALUES (p_name, p_cat, p_purchase_price, p_price, FLOOR(RAND() * 50) + 5, sup_name);

    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;
CALL generate_real_products();

-- Generate 150 Real World Sales (Grouped into ~50 Transactions)
DELIMITER $$
DROP PROCEDURE IF EXISTS generate_real_sales$$
CREATE PROCEDURE generate_real_sales()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE trx_id VARCHAR(50);
  DECLARE items_in_bill INT;
  DECLARE j INT;
  DECLARE p_id INT;
  DECLARE p_price DECIMAL(10,2);
  DECLARE p_name VARCHAR(100);
  DECLARE qty INT;

  WHILE i <= 50 DO -- Create 50 Bills (approx 150 items total)
    SET trx_id = CONCAT('TRX-', UUID_SHORT());
    SET items_in_bill = FLOOR(RAND() * 4) + 1; -- 1 to 4 items per bill
    SET j = 1;

    WHILE j <= items_in_bill DO
        SET p_id = FLOOR(RAND() * 200) + 1;
        SELECT name, price INTO p_name, p_price FROM products WHERE id = p_id LIMIT 1;
        SET qty = FLOOR(RAND() * 3) + 1;

        INSERT INTO sales (transaction_id, product_id, product_name, quantity, total_price, sale_date)
        VALUES (
            trx_id, p_id, p_name, qty, p_price * qty,
            -- Distribute dates over last 7 days for chart
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 7) DAY)
        );
        SET j = j + 1;
    END WHILE;

    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;
CALL generate_real_sales();

-- Generate Random Expensess
INSERT INTO expenses (description, amount, expense_date) VALUES
('Electricity Bill', 15000.00, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
('Water Bill', 2500.00, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
('Internet Subscription', 4500.00, DATE_SUB(CURDATE(), INTERVAL 10 DAY)),
('Shop Rent', 50000.00, DATE_SUB(CURDATE(), INTERVAL 15 DAY)),
('Staff Welfare', 5000.00, DATE_SUB(CURDATE(), INTERVAL 1 DAY));
