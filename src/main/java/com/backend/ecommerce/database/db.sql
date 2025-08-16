-- E-commerce Database Schema - Expanded Version
-- Drop database if exists and create new one
DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- Categories table
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    parent_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Suppliers table
CREATE TABLE suppliers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100),
    tax_id VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Products table (based on your ProductEntity)
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    cost_price DECIMAL(10, 2),
    sku VARCHAR(100) UNIQUE,
    category_id INT,
    supplier_id INT,
    brand VARCHAR(100),
    weight DECIMAL(8, 2),
    dimensions VARCHAR(100),
    stock_quantity INT DEFAULT 0,
    min_stock_level INT DEFAULT 0,
    max_stock_level INT DEFAULT 1000,
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    rating DECIMAL(3, 2) DEFAULT 0.00,
    review_count INT DEFAULT 0,
    views_count INT DEFAULT 0,
    sales_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE SET NULL,
    INDEX idx_name (name),
    INDEX idx_category (category_id),
    INDEX idx_price (price),
    INDEX idx_active (is_active),
    INDEX idx_featured (is_featured)
);

-- Product attributes table
CREATE TABLE product_attributes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_value VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_product_attribute (product_id, attribute_name)
);

-- Product images table
CREATE TABLE product_images (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    alt_text VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Inventory movements table
CREATE TABLE inventory_movements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    movement_type ENUM('IN', 'OUT', 'ADJUSTMENT') NOT NULL,
    quantity INT NOT NULL,
    reference_type ENUM('PURCHASE', 'SALE', 'RETURN', 'ADJUSTMENT', 'DAMAGE') NOT NULL,
    reference_id INT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_product_date (product_id, created_at)
);

-- Users table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    date_of_birth DATE,
    gender ENUM('MALE', 'FEMALE', 'OTHER'),
    avatar_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    email_verified_at TIMESTAMP NULL,
    role ENUM('CUSTOMER', 'ADMIN', 'MANAGER', 'STAFF') DEFAULT 'CUSTOMER',
    last_login_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_username (username),
    INDEX idx_role (role)
);

-- User addresses table
CREATE TABLE user_addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    address_type ENUM('BILLING', 'SHIPPING', 'BOTH') DEFAULT 'BOTH',
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    company VARCHAR(100),
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Shopping cart table
CREATE TABLE shopping_cart (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id)
);

-- Orders table
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    status ENUM('PENDING', 'CONFIRMED', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'REFUNDED') DEFAULT 'PENDING',
    total_amount DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) DEFAULT 0.00,
    shipping_amount DECIMAL(10, 2) DEFAULT 0.00,
    discount_amount DECIMAL(10, 2) DEFAULT 0.00,
    payment_method ENUM('CREDIT_CARD', 'DEBIT_CARD', 'PAYPAL', 'BANK_TRANSFER', 'CASH_ON_DELIVERY'),
    payment_status ENUM('PENDING', 'PAID', 'FAILED', 'REFUNDED') DEFAULT 'PENDING',
    shipping_address_id INT,
    billing_address_id INT,
    coupon_id INT,
    tracking_number VARCHAR(100),
    shipped_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    FOREIGN KEY (shipping_address_id) REFERENCES user_addresses(id),
    FOREIGN KEY (billing_address_id) REFERENCES user_addresses(id),
    FOREIGN KEY (coupon_id) REFERENCES coupons(id),
    INDEX idx_user (user_id),
    INDEX idx_status (status),
    INDEX idx_order_number (order_number),
    INDEX idx_created_at (created_at)
);

-- Order items table
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
);

-- Payments table
CREATE TABLE payments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_method ENUM('CREDIT_CARD', 'DEBIT_CARD', 'PAYPAL', 'BANK_TRANSFER', 'CASH_ON_DELIVERY') NOT NULL,
    payment_status ENUM('PENDING', 'COMPLETED', 'FAILED', 'CANCELLED', 'REFUNDED') DEFAULT 'PENDING',
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    transaction_id VARCHAR(255),
    gateway_response TEXT,
    processed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_order (order_id),
    INDEX idx_status (payment_status)
);

-- Product reviews table
CREATE TABLE product_reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    order_id INT,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(255),
    comment TEXT,
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    is_approved BOOLEAN DEFAULT FALSE,
    helpful_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
    UNIQUE KEY unique_user_product_order (user_id, product_id, order_id)
);

-- Coupons table
CREATE TABLE coupons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    discount_type ENUM('PERCENTAGE', 'FIXED_AMOUNT') NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL,
    minimum_order_amount DECIMAL(10, 2) DEFAULT 0.00,
    maximum_discount_amount DECIMAL(10, 2),
    usage_limit INT,
    usage_limit_per_user INT DEFAULT 1,
    used_count INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_until TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_code (code),
    INDEX idx_active (is_active)
);

-- Coupon usage table
CREATE TABLE coupon_usage (
    id INT PRIMARY KEY AUTO_INCREMENT,
    coupon_id INT NOT NULL,
    user_id INT NOT NULL,
    order_id INT NOT NULL,
    discount_amount DECIMAL(10, 2) NOT NULL,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    UNIQUE KEY unique_coupon_order (coupon_id, order_id)
);

-- Wishlist table
CREATE TABLE wishlist (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id)
);

-- Notifications table
CREATE TABLE notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('ORDER', 'PROMOTION', 'SYSTEM', 'REVIEW', 'STOCK') NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    reference_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_read (user_id, is_read),
    INDEX idx_created_at (created_at)
);

-- Product views table (for analytics)
CREATE TABLE product_views (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_product_date (product_id, viewed_at)
);

-- Shipping methods table
CREATE TABLE shipping_methods (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    base_cost DECIMAL(10, 2) NOT NULL,
    cost_per_kg DECIMAL(10, 2) DEFAULT 0.00,
    estimated_days_min INT DEFAULT 1,
    estimated_days_max INT DEFAULT 7,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Order tracking table
CREATE TABLE order_tracking (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    status ENUM('ORDER_PLACED', 'PAYMENT_CONFIRMED', 'PROCESSING', 'SHIPPED', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED') NOT NULL,
    location VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_order_date (order_id, created_at)
);

-- Insert sample data
-- Categories
INSERT INTO categories (name, description, parent_id) VALUES
('Electronics', 'Electronic devices and accessories', NULL),
('Smartphones', 'Mobile phones and accessories', 1),
('Laptops', 'Laptops and computer accessories', 1),
('Audio', 'Headphones, speakers, and audio equipment', 1),
('Clothing', 'Fashion and apparel', NULL),
('Men\'s Clothing', 'Clothing for men', 5),
('Women\'s Clothing', 'Clothing for women', 5),
('Shoes', 'Footwear for all', 5),
('Books', 'Books and literature', NULL),
('Fiction', 'Fiction books', 9),
('Non-Fiction', 'Non-fiction books', 9),
('Home & Garden', 'Home improvement and garden supplies', NULL),
('Furniture', 'Home furniture', 12),
('Kitchen', 'Kitchen appliances and tools', 12),
('Sports', 'Sports equipment and accessories', NULL),
('Fitness', 'Fitness equipment', 15),
('Outdoor', 'Outdoor sports equipment', 15);

-- Suppliers
INSERT INTO suppliers (name, contact_person, email, phone, address, city, country) VALUES
('Apple Inc.', 'John Smith', 'supplier@apple.com', '+1-555-0101', '1 Apple Park Way', 'Cupertino', 'USA'),
('Samsung Electronics', 'Kim Lee', 'supplier@samsung.com', '+82-555-0102', 'Samsung Digital City', 'Seoul', 'South Korea'),
('Nike Inc.', 'Mike Johnson', 'supplier@nike.com', '+1-555-0103', '1 Bowerman Drive', 'Beaverton', 'USA'),
('Levi Strauss & Co.', 'Sarah Wilson', 'supplier@levi.com', '+1-555-0104', '1155 Battery Street', 'San Francisco', 'USA'),
('Penguin Random House', 'David Brown', 'supplier@penguin.com', '+1-555-0105', '1745 Broadway', 'New York', 'USA'),
('Sony Corporation', 'Takeshi Yamamoto', 'supplier@sony.com', '+81-555-0106', '1-7-1 Konan', 'Tokyo', 'Japan'),
('Dell Technologies', 'Robert Davis', 'supplier@dell.com', '+1-555-0107', 'One Dell Way', 'Round Rock', 'USA'),
('Adidas AG', 'Hans Mueller', 'supplier@adidas.com', '+49-555-0108', 'Adi-Dassler-Strasse 1', 'Herzogenaurach', 'Germany');

-- Shipping methods
INSERT INTO shipping_methods (name, description, base_cost, cost_per_kg, estimated_days_min, estimated_days_max) VALUES
('Standard Shipping', 'Regular delivery service', 5.99, 0.50, 3, 7),
('Express Shipping', 'Fast delivery service', 12.99, 1.00, 1, 3),
('Overnight Shipping', 'Next day delivery', 24.99, 2.00, 1, 1),
('Free Shipping', 'Free delivery for orders over $50', 0.00, 0.00, 5, 10);

-- Sample products (expanded)
INSERT INTO products (name, description, price, cost_price, sku, category_id, supplier_id, brand, stock_quantity, min_stock_level, is_featured) VALUES
('iPhone 15 Pro', 'Latest iPhone with advanced features and titanium design', 999.99, 750.00, 'IPH15PRO001', 2, 1, 'Apple', 50, 10, TRUE),
('iPhone 15', 'Standard iPhone 15 with great performance', 799.99, 600.00, 'IPH15STD001', 2, 1, 'Apple', 75, 15, TRUE),
('Samsung Galaxy S24', 'Premium Android smartphone with AI features', 899.99, 650.00, 'SGS24001', 2, 2, 'Samsung', 30, 5, TRUE),
('Samsung Galaxy S24+', 'Larger screen Galaxy S24 with enhanced battery', 999.99, 720.00, 'SGS24PLUS001', 2, 2, 'Samsung', 25, 5, FALSE),
('MacBook Air M3', 'Lightweight laptop with M3 chip', 1299.99, 950.00, 'MBA13M3001', 3, 1, 'Apple', 20, 3, TRUE),
('MacBook Pro 14"', 'Professional laptop for power users', 1999.99, 1500.00, 'MBP14M3001', 3, 1, 'Apple', 15, 2, TRUE),
('Dell XPS 13', 'Premium Windows ultrabook', 1199.99, 850.00, 'DXPS13001', 3, 7, 'Dell', 25, 5, FALSE),
('Sony WH-1000XM5', 'Premium noise-canceling headphones', 399.99, 250.00, 'SWXM5001', 4, 6, 'Sony', 40, 8, TRUE),
('AirPods Pro 2', 'Apple wireless earbuds with ANC', 249.99, 150.00, 'APP2001', 4, 1, 'Apple', 60, 12, TRUE),
('Nike Air Max 270', 'Comfortable running shoes with Air Max technology', 150.00, 80.00, 'NAM270001', 8, 3, 'Nike', 100, 20, TRUE),
('Nike Air Force 1', 'Classic basketball shoes', 110.00, 60.00, 'NAF1001', 8, 3, 'Nike', 120, 25, FALSE),
('Adidas Ultraboost 22', 'High-performance running shoes', 180.00, 100.00, 'AUB22001', 8, 8, 'Adidas', 80, 15, TRUE),
('Levi\'s 501 Jeans', 'Classic straight-leg jeans', 89.99, 45.00, 'LEV501001', 6, 4, 'Levi\'s', 75, 15, FALSE),
('Levi\'s 511 Slim Jeans', 'Modern slim-fit jeans', 79.99, 40.00, 'LEV511001', 6, 4, 'Levi\'s', 90, 18, FALSE),
('Nike Dri-FIT T-Shirt', 'Moisture-wicking athletic t-shirt', 29.99, 15.00, 'NDFT001', 6, 3, 'Nike', 200, 40, FALSE),
('The Great Gatsby', 'Classic American novel by F. Scott Fitzgerald', 12.99, 6.00, 'TGG001', 10, 5, 'Scribner', 200, 50, FALSE),
('To Kill a Mockingbird', 'Pulitzer Prize-winning novel', 13.99, 7.00, 'TKAM001', 10, 5, 'Harper Lee', 150, 30, FALSE),
('1984', 'Dystopian novel by George Orwell', 14.99, 8.00, 'NE1984001', 10, 5, 'Penguin', 180, 35, TRUE),
('Atomic Habits', 'Self-help book about building good habits', 18.99, 10.00, 'AH001', 11, 5, 'Avery', 120, 25, TRUE),
('Sapiens', 'A brief history of humankind', 19.99, 12.00, 'SAP001', 11, 5, 'Harper', 100, 20, TRUE);

-- Product attributes
INSERT INTO product_attributes (product_id, attribute_name, attribute_value) VALUES
(1, 'Color', 'Natural Titanium'),
(1, 'Storage', '128GB'),
(1, 'Screen Size', '6.1 inch'),
(2, 'Color', 'Blue'),
(2, 'Storage', '128GB'),
(2, 'Screen Size', '6.1 inch'),
(3, 'Color', 'Phantom Black'),
(3, 'Storage', '256GB'),
(3, 'Screen Size', '6.2 inch'),
(5, 'Color', 'Midnight'),
(5, 'RAM', '8GB'),
(5, 'Storage', '256GB'),
(10, 'Size', '10.5'),
(10, 'Color', 'Black/White'),
(13, 'Size', '32x34'),
(13, 'Color', 'Dark Blue');

-- Sample users (expanded)
INSERT INTO users (username, email, password_hash, first_name, last_name, phone, role, is_verified) VALUES
('admin', 'admin@ecommerce.com', '$2a$10$example_hash', 'Admin', 'User', '+1-555-0001', 'ADMIN', TRUE),
('manager1', 'manager@ecommerce.com', '$2a$10$example_hash', 'Store', 'Manager', '+1-555-0002', 'MANAGER', TRUE),
('john_doe', 'john@example.com', '$2a$10$example_hash', 'John', 'Doe', '+1-555-1001', 'CUSTOMER', TRUE),
('jane_smith', 'jane@example.com', '$2a$10$example_hash', 'Jane', 'Smith', '+1-555-1002', 'CUSTOMER', TRUE),
('mike_wilson', 'mike@example.com', '$2a$10$example_hash', 'Mike', 'Wilson', '+1-555-1003', 'CUSTOMER', TRUE),
('sarah_johnson', 'sarah@example.com', '$2a$10$example_hash', 'Sarah', 'Johnson', '+1-555-1004', 'CUSTOMER', TRUE),
('david_brown', 'david@example.com', '$2a$10$example_hash', 'David', 'Brown', '+1-555-1005', 'CUSTOMER', FALSE),
('lisa_davis', 'lisa@example.com', '$2a$10$example_hash', 'Lisa', 'Davis', '+1-555-1006', 'CUSTOMER', TRUE),
('tom_miller', 'tom@example.com', '$2a$10$example_hash', 'Tom', 'Miller', '+1-555-1007', 'CUSTOMER', TRUE),
('amy_garcia', 'amy@example.com', '$2a$10$example_hash', 'Amy', 'Garcia', '+1-555-1008', 'CUSTOMER', TRUE);

-- User addresses
INSERT INTO user_addresses (user_id, address_type, first_name, last_name, address_line1, city, state, postal_code, country, is_default) VALUES
(3, 'BOTH', 'John', 'Doe', '123 Main St', 'New York', 'NY', '10001', 'USA', TRUE),
(4, 'BOTH', 'Jane', 'Smith', '456 Oak Ave', 'Los Angeles', 'CA', '90210', 'USA', TRUE),
(5, 'SHIPPING', 'Mike', 'Wilson', '789 Pine St', 'Chicago', 'IL', '60601', 'USA', TRUE),
(5, 'BILLING', 'Mike', 'Wilson', '321 Elm St', 'Chicago', 'IL', '60602', 'USA', FALSE),
(6, 'BOTH', 'Sarah', 'Johnson', '654 Maple Dr', 'Houston', 'TX', '77001', 'USA', TRUE),
(8, 'BOTH', 'Lisa', 'Davis', '987 Cedar Ln', 'Phoenix', 'AZ', '85001', 'USA', TRUE),
(9, 'BOTH', 'Tom', 'Miller', '147 Birch Rd', 'Philadelphia', 'PA', '19101', 'USA', TRUE),
(10, 'BOTH', 'Amy', 'Garcia', '258 Spruce St', 'San Antonio', 'TX', '78201', 'USA', TRUE);

-- Coupons
INSERT INTO coupons (code, description, discount_type, discount_value, minimum_order_amount, usage_limit, valid_until) VALUES
('WELCOME10', 'Welcome discount for new customers', 'PERCENTAGE', 10.00, 50.00, 1000, '2024-12-31 23:59:59'),
('SAVE20', '20% off on orders over $100', 'PERCENTAGE', 20.00, 100.00, 500, '2024-12-31 23:59:59'),
('FREESHIP', 'Free shipping on any order', 'FIXED_AMOUNT', 5.99, 0.00, 2000, '2024-12-31 23:59:59'),
('ELECTRONICS15', '15% off electronics', 'PERCENTAGE', 15.00, 200.00, 300, '2024-12-31 23:59:59'),
('NEWUSER25', '$25 off first order', 'FIXED_AMOUNT', 25.00, 100.00, 1000, '2024-12-31 23:59:59');

-- Sample orders
INSERT INTO orders (user_id, order_number, status, total_amount, subtotal, tax_amount, shipping_amount, payment_method, payment_status, shipping_address_id, billing_address_id) VALUES
(3, 'ORD-2024-001', 'DELIVERED', 1049.98, 999.99, 80.00, 12.99, 'CREDIT_CARD', 'PAID', 1, 1),
(4, 'ORD-2024-002', 'SHIPPED', 429.98, 399.99, 32.00, 5.99, 'PAYPAL', 'PAID', 2, 2),
(5, 'ORD-2024-003', 'PROCESSING', 179.99, 150.00, 12.00, 12.99, 'CREDIT_CARD', 'PAID', 3, 4),
(6, 'ORD-2024-004', 'CONFIRMED', 89.99, 79.99, 6.40, 5.99, 'DEBIT_CARD', 'PAID', 5, 5),
(8, 'ORD-2024-005', 'PENDING', 249.99, 249.99, 20.00, 0.00, 'CREDIT_CARD', 'PENDING', 6, 6),
(9, 'ORD-2024-006', 'DELIVERED', 32.98, 29.99, 2.40, 5.99, 'PAYPAL', 'PAID', 7, 7),
(10, 'ORD-2024-007', 'CANCELLED', 199.99, 180.00, 14.40, 5.59, 'CREDIT_CARD', 'REFUNDED', 8, 8);

-- Order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES
(1, 1, 1, 999.99, 999.99),
(2, 8, 1, 399.99, 399.99),
(3, 10, 1, 150.00, 150.00),
(4, 13, 1, 89.99, 89.99),
(5, 9, 1, 249.99, 249.99),
(6, 15, 1, 29.99, 29.99),
(7, 12, 1, 180.00, 180.00);

-- Product reviews
INSERT INTO product_reviews (product_id, user_id, order_id, rating, title, comment, is_verified_purchase, is_approved) VALUES
(1, 3, 1, 5, 'Amazing phone!', 'The iPhone 15 Pro is incredible. The titanium build feels premium and the camera is outstanding.', TRUE, TRUE),
(8, 4, 2, 4, 'Great headphones', 'Excellent noise cancellation, but a bit pricey. Sound quality is top-notch.', TRUE, TRUE),
(10, 5, 3, 5, 'Perfect running shoes', 'Very comfortable for long runs. Great cushioning and style.', TRUE, TRUE),
(13, 6, 4, 4, 'Classic jeans', 'Good quality denim, fits well. A bit stiff at first but breaks in nicely.', TRUE, TRUE),
(15, 9, 6, 3, 'Decent shirt', 'Good for workouts, but the fit is a bit loose for my liking.', TRUE, TRUE);

-- Shopping cart items
INSERT INTO shopping_cart (user_id, product_id, quantity) VALUES
(3, 5, 1),
(3, 16, 2),
(4, 11, 1),
(5, 2, 1),
(6, 19, 1),
(8, 12, 1),
(10, 14, 2);

-- Wishlist items
INSERT INTO wishlist (user_id, product_id) VALUES
(3, 6),
(3, 20),
(4, 1),
(4, 5),
(5, 8),
(6, 11),
(8, 18),
(9, 3),
(10, 7);

-- Notifications
INSERT INTO notifications (user_id, title, message, type, reference_id) VALUES
(3, 'Order Delivered', 'Your order ORD-2024-001 has been delivered successfully.', 'ORDER', 1),
(4, 'Order Shipped', 'Your order ORD-2024-002 is on its way!', 'ORDER', 2),
(5, 'New Promotion', 'Get 20% off on all electronics this weekend!', 'PROMOTION', NULL),
(6, 'Order Confirmed', 'Your order ORD-2024-004 has been confirmed.', 'ORDER', 4),
(8, 'Payment Pending', 'Please complete payment for order ORD-2024-005.', 'ORDER', 5),
(9, 'Order Delivered', 'Your order ORD-2024-006 has been delivered.', 'ORDER', 6),
(10, 'Order Cancelled', 'Your order ORD-2024-007 has been cancelled and refunded.', 'ORDER', 7);

-- Payments
INSERT INTO payments (order_id, payment_method, payment_status, amount, transaction_id, processed_at) VALUES
(1, 'CREDIT_CARD', 'COMPLETED', 1049.98, 'TXN_001_2024', '2024-01-15 10:30:00'),
(2, 'PAYPAL', 'COMPLETED', 429.98, 'PP_002_2024', '2024-01-16 14:20:00'),
(3, 'CREDIT_CARD', 'COMPLETED', 179.99, 'TXN_003_2024', '2024-01-17 09:15:00'),
(4, 'DEBIT_CARD', 'COMPLETED', 89.99, 'TXN_004_2024', '2024-01-18 16:45:00'),
(5, 'CREDIT_CARD', 'PENDING', 249.99, NULL, NULL),
(6, 'PAYPAL', 'COMPLETED', 32.98, 'PP_006_2024', '2024-01-20 11:30:00'),
(7, 'CREDIT_CARD', 'REFUNDED', 199.99, 'TXN_007_2024', '2024-01-21 13:00:00');

-- Order tracking
INSERT INTO order_tracking (order_id, status, location, description) VALUES
(1, 'ORDER_PLACED', 'Online', 'Order has been placed successfully'),
(1, 'PAYMENT_CONFIRMED', 'Payment Gateway', 'Payment has been confirmed'),
(1, 'PROCESSING', 'Warehouse NY', 'Order is being prepared for shipment'),
(1, 'SHIPPED', 'Warehouse NY', 'Order has been shipped'),
(1, 'DELIVERED', 'New York, NY', 'Order delivered successfully'),
(2, 'ORDER_PLACED', 'Online', 'Order has been placed successfully'),
(2, 'PAYMENT_CONFIRMED', 'PayPal', 'Payment confirmed via PayPal'),
(2, 'SHIPPED', 'Warehouse CA', 'Order shipped from California warehouse'),
(3, 'ORDER_PLACED', 'Online', 'Order has been placed successfully'),
(3, 'PROCESSING', 'Warehouse IL', 'Order is being processed');

-- Product views (for analytics)
INSERT INTO product_views (product_id, user_id, ip_address) VALUES
(1, 3, '192.168.1.100'),
(1, 4, '192.168.1.101'),
(1, NULL, '192.168.1.102'),
(2, 5, '192.168.1.103'),
(8, 4, '192.168.1.101'),
(10, 5, '192.168.1.103'),
(13, 6, '192.168.1.104'),
(1, NULL, '192.168.1.105'),
(5, 3, '192.168.1.100'),
(20, 10, '192.168.1.108');

-- Inventory movements
INSERT INTO inventory_movements (product_id, movement_type, quantity, reference_type, reference_id, notes) VALUES
(1, 'IN', 100, 'PURCHASE', NULL, 'Initial stock from supplier'),
(1, 'OUT', 1, 'SALE', 1, 'Sold via order ORD-2024-001'),
(8, 'IN', 50, 'PURCHASE', NULL, 'Restocked headphones'),
(8, 'OUT', 1, 'SALE', 2, 'Sold via order ORD-2024-002'),
(10, 'OUT', 1, 'SALE', 3, 'Sold via order ORD-2024-003'),
(13, 'OUT', 1, 'SALE', 4, 'Sold via order ORD-2024-004'),
(15, 'OUT', 1, 'SALE', 6, 'Sold via order ORD-2024-006');

-- Create indexes for better performance
CREATE INDEX idx_products_name_active ON products(name, is_active);
CREATE INDEX idx_products_category_active ON products(category_id, is_active);
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
CREATE INDEX idx_order_items_order_product ON order_items(order_id, product_id);
CREATE INDEX idx_reviews_product_approved ON product_reviews(product_id, is_approved);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX idx_inventory_product_date ON inventory_movements(product_id, created_at);
CREATE INDEX idx_product_views_date ON product_views(viewed_at);
CREATE INDEX idx_payments_order_status ON payments(order_id, payment_status);