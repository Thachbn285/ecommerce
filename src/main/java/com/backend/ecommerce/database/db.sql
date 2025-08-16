-- E-commerce Database Schema - PostgreSQL Version
-- Drop database if exists and create new one
DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;

-- Connect to the database
\c ecommerce_db;

-- Create ENUM types first
CREATE TYPE gender_enum AS ENUM ('MALE', 'FEMALE', 'OTHER');
CREATE TYPE user_role_enum AS ENUM ('CUSTOMER', 'ADMIN', 'MANAGER', 'STAFF');
CREATE TYPE address_type_enum AS ENUM ('BILLING', 'SHIPPING', 'BOTH');
CREATE TYPE order_status_enum AS ENUM ('PENDING', 'CONFIRMED', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'REFUNDED');
CREATE TYPE payment_method_enum AS ENUM ('CREDIT_CARD', 'DEBIT_CARD', 'PAYPAL', 'BANK_TRANSFER', 'CASH_ON_DELIVERY');
CREATE TYPE payment_status_enum AS ENUM ('PENDING', 'PAID', 'FAILED', 'REFUNDED');
CREATE TYPE movement_type_enum AS ENUM ('IN', 'OUT', 'ADJUSTMENT');
CREATE TYPE reference_type_enum AS ENUM ('PURCHASE', 'SALE', 'RETURN', 'ADJUSTMENT', 'DAMAGE');
CREATE TYPE discount_type_enum AS ENUM ('PERCENTAGE', 'FIXED_AMOUNT');
CREATE TYPE notification_type_enum AS ENUM ('ORDER', 'PROMOTION', 'SYSTEM', 'REVIEW', 'STOCK');
CREATE TYPE tracking_status_enum AS ENUM ('ORDER_PLACED', 'PAYMENT_CONFIRMED', 'PROCESSING', 'SHIPPED', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED');

-- Categories table
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    parent_id INTEGER,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Suppliers table
CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    cost_price DECIMAL(10, 2),
    sku VARCHAR(100) UNIQUE,
    category_id INTEGER,
    supplier_id INTEGER,
    brand VARCHAR(100),
    weight DECIMAL(8, 2),
    dimensions VARCHAR(100),
    stock_quantity INTEGER DEFAULT 0,
    min_stock_level INTEGER DEFAULT 0,
    max_stock_level INTEGER DEFAULT 1000,
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    rating DECIMAL(3, 2) DEFAULT 0.00,
    review_count INTEGER DEFAULT 0,
    views_count INTEGER DEFAULT 0,
    sales_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE SET NULL
);

-- Create indexes for products
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_active ON products(is_active);
CREATE INDEX idx_products_featured ON products(is_featured);

-- Product attributes table
CREATE TABLE product_attributes (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_value VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE INDEX idx_product_attributes ON product_attributes(product_id, attribute_name);

-- Product images table
CREATE TABLE product_images (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    alt_text VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    date_of_birth DATE,
    gender gender_enum,
    avatar_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    email_verified_at TIMESTAMP NULL,
    role user_role_enum DEFAULT 'CUSTOMER',
    last_login_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_role ON users(role);

-- User addresses table
CREATE TABLE user_addresses (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    address_type address_type_enum DEFAULT 'BOTH',
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
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Coupons table
CREATE TABLE coupons (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    discount_type discount_type_enum NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL,
    minimum_order_amount DECIMAL(10, 2) DEFAULT 0.00,
    maximum_discount_amount DECIMAL(10, 2),
    usage_limit INTEGER,
    usage_limit_per_user INTEGER DEFAULT 1,
    used_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_until TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_coupons_code ON coupons(code);
CREATE INDEX idx_coupons_active ON coupons(is_active);

-- Orders table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    status order_status_enum DEFAULT 'PENDING',
    total_amount DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) DEFAULT 0.00,
    shipping_amount DECIMAL(10, 2) DEFAULT 0.00,
    discount_amount DECIMAL(10, 2) DEFAULT 0.00,
    payment_method payment_method_enum,
    payment_status payment_status_enum DEFAULT 'PENDING',
    shipping_address_id INTEGER,
    billing_address_id INTEGER,
    coupon_id INTEGER,
    tracking_number VARCHAR(100),
    shipped_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    FOREIGN KEY (shipping_address_id) REFERENCES user_addresses(id),
    FOREIGN KEY (billing_address_id) REFERENCES user_addresses(id),
    FOREIGN KEY (coupon_id) REFERENCES coupons(id)
);

CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_number ON orders(order_number);
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- Order items table
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
);

-- Shopping cart table
CREATE TABLE shopping_cart (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE(user_id, product_id)
);

-- Product reviews table
CREATE TABLE product_reviews (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    order_id INTEGER,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(255),
    comment TEXT,
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    is_approved BOOLEAN DEFAULT FALSE,
    helpful_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
    UNIQUE(user_id, product_id, order_id)
);

-- Payments table
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    payment_method payment_method_enum NOT NULL,
    payment_status payment_status_enum DEFAULT 'PENDING',
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    transaction_id VARCHAR(255),
    gateway_response TEXT,
    processed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE INDEX idx_payments_order ON payments(order_id);
CREATE INDEX idx_payments_status ON payments(payment_status);

-- Wishlist table
CREATE TABLE wishlist (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE(user_id, product_id)
);

-- Notifications table
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type notification_type_enum NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    reference_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);

-- Inventory movements table
CREATE TABLE inventory_movements (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL,
    movement_type movement_type_enum NOT NULL,
    quantity INTEGER NOT NULL,
    reference_type reference_type_enum NOT NULL,
    reference_id INTEGER,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE INDEX idx_inventory_product_date ON inventory_movements(product_id, created_at);

-- Product views table (for analytics)
CREATE TABLE product_views (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL,
    user_id INTEGER,
    ip_address INET,
    user_agent TEXT,
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_product_views_date ON product_views(viewed_at);
CREATE INDEX idx_product_views_product_date ON product_views(product_id, viewed_at);

-- Shipping methods table
CREATE TABLE shipping_methods (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    base_cost DECIMAL(10, 2) NOT NULL,
    cost_per_kg DECIMAL(10, 2) DEFAULT 0.00,
    estimated_days_min INTEGER DEFAULT 1,
    estimated_days_max INTEGER DEFAULT 7,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order tracking table
CREATE TABLE order_tracking (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    status tracking_status_enum NOT NULL,
    location VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE INDEX idx_order_tracking_order_date ON order_tracking(order_id, created_at);

-- Coupon usage table
CREATE TABLE coupon_usage (
    id SERIAL PRIMARY KEY,
    coupon_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    order_id INTEGER NOT NULL,
    discount_amount DECIMAL(10, 2) NOT NULL,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    UNIQUE(coupon_id, order_id)
);

-- Insert sample data
-- Categories
INSERT INTO categories (name, description, parent_id) VALUES
('Electronics', 'Electronic devices and accessories', NULL),
('Smartphones', 'Mobile phones and accessories', 1),
('Laptops', 'Laptops and computer accessories', 1),
('Audio', 'Headphones, speakers, and audio equipment', 1),
('Clothing', 'Fashion and apparel', NULL),
('Men''s Clothing', 'Clothing for men', 5),
('Women''s Clothing', 'Clothing for women', 5),
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

-- Sample products
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
('Levi''s 501 Jeans', 'Classic straight-leg jeans', 89.99, 45.00, 'LEV501001', 6, 4, 'Levi''s', 75, 15, FALSE),
('Levi''s 511 Slim Jeans', 'Modern slim-fit jeans', 79.99, 40.00, 'LEV511001', 6, 4, 'Levi''s', 90, 18, FALSE),
('Nike Dri-FIT T-Shirt', 'Moisture-wicking athletic t-shirt', 29.99, 15.00, 'NDFT001', 6, 3, 'Nike', 200, 40, FALSE),
('The Great Gatsby', 'Classic American novel by F. Scott Fitzgerald', 12.99, 6.00, 'TGG001', 10, 5, 'Scribner', 200, 50, FALSE),
('To Kill a Mockingbird', 'Pulitzer Prize-winning novel', 13.99, 7.00, 'TKAM001', 10, 5, 'Harper Lee', 150, 30, FALSE),
('1984', 'Dystopian novel by George Orwell', 14.99, 8.00, 'NE1984001', 10, 5, 'Penguin', 180, 35, TRUE),
('Atomic Habits', 'Self-help book about building good habits', 18.99, 10.00, 'AH001', 11, 5, 'Avery', 120, 25, TRUE),
('Sapiens', 'A brief history of humankind', 19.99, 12.00, 'SAP001', 11, 5, 'Harper', 100, 20, TRUE);

-- Sample users
INSERT INTO users (username, email, password_hash, first_name, last_name, phone, role, is_verified) VALUES
('admin', 'admin@ecommerce.com', '$2a$10$example_hash', 'Admin', 'User', '+1-555-0001', 'ADMIN', TRUE),
('manager1', 'manager@ecommerce.com', '$2a$10$example_hash', 'Store', 'Manager', '+1-555-0002', 'MANAGER', TRUE),
('john_doe', 'john@example.com', '$2a$10$example_hash', 'John', 'Doe', '+1-555-1001', 'CUSTOMER', TRUE),
('jane_smith', 'jane@example.com', '$2a$10$example_hash', 'Jane', 'Smith', '+1-555-1002', 'CUSTOMER', TRUE),
('mike_wilson', 'mike@example.com', '$2a$10$example_hash', 'Mike', 'Wilson', '+1-555-1003', 'CUSTOMER', TRUE);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_suppliers_updated_at BEFORE UPDATE ON suppliers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_addresses_updated_at BEFORE UPDATE ON user_addresses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_coupons_updated_at BEFORE UPDATE ON coupons FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_product_reviews_updated_at BEFORE UPDATE ON product_reviews FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_shopping_cart_updated_at BEFORE UPDATE ON shopping_cart FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_shipping_methods_updated_at BEFORE UPDATE ON shipping_methods FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
