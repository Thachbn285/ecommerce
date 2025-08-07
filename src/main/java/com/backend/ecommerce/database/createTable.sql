CREATE TABLE categories
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(255) NOT NULL,
    description TEXT,
    parent_id   INT,
    slug        VARCHAR(255) UNIQUE,
    image_url   VARCHAR(500),
    is_active   BOOLEAN   DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES categories (id) ON DELETE SET NULL
);

-- Bảng thương hiệu
CREATE TABLE brands
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(255) NOT NULL,
    description TEXT,
    logo_url    VARCHAR(500),
    website     VARCHAR(255),
    is_active   BOOLEAN   DEFAULT TRUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Bảng sản phẩm
CREATE TABLE products
(
    id                INT PRIMARY KEY AUTO_INCREMENT,
    name              VARCHAR(255)        NOT NULL,
    description       TEXT,
    short_description VARCHAR(500),
    sku               VARCHAR(100) UNIQUE NOT NULL,
    price             DECIMAL(10, 2)      NOT NULL,
    sale_price        DECIMAL(10, 2),
    stock_quantity    INT                                  DEFAULT 0,
    weight            DECIMAL(8, 2),
    dimensions        VARCHAR(100),
    category_id       INT,
    brand_id          INT,
    featured_image    VARCHAR(500),
    gallery           JSON,
    status            ENUM ('active', 'inactive', 'draft') DEFAULT 'active',
    is_featured       BOOLEAN                              DEFAULT FALSE,
    meta_title        VARCHAR(255),
    meta_description  TEXT,
    slug              VARCHAR(255) UNIQUE,
    created_at        TIMESTAMP                            DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP                            DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE SET NULL,
    FOREIGN KEY (brand_id) REFERENCES brands (id) ON DELETE SET NULL,
    INDEX idx_sku (sku),
    INDEX idx_status (status),
    INDEX idx_category (category_id)
);

-- Bảng thuộc tính sản phẩm (màu sắc, kích thước, etc.)
CREATE TABLE product_attributes
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(255) NOT NULL,
    type        ENUM ('text', 'number', 'select', 'multiselect', 'boolean') DEFAULT 'text',
    options     JSON,
    is_required BOOLEAN                                                     DEFAULT FALSE,
    created_at  TIMESTAMP                                                   DEFAULT CURRENT_TIMESTAMP
);

-- Bảng giá trị thuộc tính cho từng sản phẩm
CREATE TABLE product_attribute_values
(
    id           INT PRIMARY KEY AUTO_INCREMENT,
    product_id   INT NOT NULL,
    attribute_id INT NOT NULL,
    value        TEXT,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_id) REFERENCES product_attributes (id) ON DELETE CASCADE,
    UNIQUE KEY unique_product_attribute (product_id, attribute_id)
);

-- Bảng người dùng
CREATE TABLE users
(
    id                INT PRIMARY KEY AUTO_INCREMENT,
    email             VARCHAR(255) UNIQUE NOT NULL,
    password_hash     VARCHAR(255)        NOT NULL,
    first_name        VARCHAR(100),
    last_name         VARCHAR(100),
    phone             VARCHAR(20),
    date_of_birth     DATE,
    gender            ENUM ('male', 'female', 'other'),
    avatar_url        VARCHAR(500),
    email_verified_at TIMESTAMP           NULL,
    status            ENUM ('active', 'inactive', 'suspended') DEFAULT 'active',
    created_at        TIMESTAMP                                DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP                                DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_status (status)
);

-- Bảng địa chỉ người dùng
CREATE TABLE user_addresses
(
    id             INT PRIMARY KEY AUTO_INCREMENT,
    user_id        INT          NOT NULL,
    type           ENUM ('billing', 'shipping', 'both') DEFAULT 'both',
    first_name     VARCHAR(100),
    last_name      VARCHAR(100),
    company        VARCHAR(255),
    address_line_1 VARCHAR(255) NOT NULL,
    address_line_2 VARCHAR(255),
    city           VARCHAR(100) NOT NULL,
    state          VARCHAR(100),
    postal_code    VARCHAR(20),
    country        VARCHAR(100) NOT NULL,
    phone          VARCHAR(20),
    is_default     BOOLEAN                              DEFAULT FALSE,
    created_at     TIMESTAMP                            DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP                            DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

-- Bảng giỏ hàng
CREATE TABLE shopping_carts
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    user_id    INT,
    session_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_session (session_id)
);

-- Bảng sản phẩm trong giỏ hàng
CREATE TABLE cart_items
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    cart_id    INT            NOT NULL,
    product_id INT            NOT NULL,
    quantity   INT            NOT NULL DEFAULT 1,
    price      DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP               DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP               DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cart_id) REFERENCES shopping_carts (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    UNIQUE KEY unique_cart_product (cart_id, product_id)
);

-- Bảng đơn hàng
CREATE TABLE orders
(
    id                      INT PRIMARY KEY AUTO_INCREMENT,
    order_number            VARCHAR(50) UNIQUE NOT NULL,
    user_id                 INT,
    status                  ENUM ('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded') DEFAULT 'pending',
    total_amount            DECIMAL(10, 2)     NOT NULL,
    subtotal                DECIMAL(10, 2)     NOT NULL,
    tax_amount              DECIMAL(10, 2)                                                                  DEFAULT 0,
    shipping_amount         DECIMAL(10, 2)                                                                  DEFAULT 0,
    discount_amount         DECIMAL(10, 2)                                                                  DEFAULT 0,
    currency                VARCHAR(3)                                                                      DEFAULT 'VND',
    payment_status          ENUM ('pending', 'paid', 'failed', 'refunded')                                  DEFAULT 'pending',
    payment_method          VARCHAR(50),

    -- Thông tin giao hàng
    shipping_first_name     VARCHAR(100),
    shipping_last_name      VARCHAR(100),
    shipping_company        VARCHAR(255),
    shipping_address_line_1 VARCHAR(255),
    shipping_address_line_2 VARCHAR(255),
    shipping_city           VARCHAR(100),
    shipping_state          VARCHAR(100),
    shipping_postal_code    VARCHAR(20),
    shipping_country        VARCHAR(100),
    shipping_phone          VARCHAR(20),

    -- Thông tin thanh toán
    billing_first_name      VARCHAR(100),
    billing_last_name       VARCHAR(100),
    billing_company         VARCHAR(255),
    billing_address_line_1  VARCHAR(255),
    billing_address_line_2  VARCHAR(255),
    billing_city            VARCHAR(100),
    billing_state           VARCHAR(100),
    billing_postal_code     VARCHAR(20),
    billing_country         VARCHAR(100),
    billing_phone           VARCHAR(20),

    notes                   TEXT,
    shipped_at              TIMESTAMP          NULL,
    delivered_at            TIMESTAMP          NULL,
    created_at              TIMESTAMP                                                                       DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP                                                                       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL,
    INDEX idx_order_number (order_number),
    INDEX idx_status (status),
    INDEX idx_user (user_id)
);

-- Bảng chi tiết đơn hàng
CREATE TABLE order_items
(
    id           INT PRIMARY KEY AUTO_INCREMENT,
    order_id     INT            NOT NULL,
    product_id   INT            NOT NULL,
    product_name VARCHAR(255)   NOT NULL,
    product_sku  VARCHAR(100),
    quantity     INT            NOT NULL,
    price        DECIMAL(10, 2) NOT NULL,
    total        DECIMAL(10, 2) NOT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE RESTRICT
);

-- Bảng mã giảm giá
CREATE TABLE coupons
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    code             VARCHAR(50) UNIQUE           NOT NULL,
    name             VARCHAR(255),
    description      TEXT,
    type             ENUM ('fixed', 'percentage') NOT NULL,
    value            DECIMAL(10, 2)               NOT NULL,
    minimum_amount   DECIMAL(10, 2) DEFAULT 0,
    maximum_discount DECIMAL(10, 2),
    usage_limit      INT,
    used_count       INT            DEFAULT 0,
    user_limit       INT            DEFAULT 1,
    start_date       TIMESTAMP                    NULL,
    end_date         TIMESTAMP                    NULL,
    is_active        BOOLEAN        DEFAULT TRUE,
    created_at       TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_code (code),
    INDEX idx_active (is_active)
);

-- Bảng lịch sử sử dụng mã giảm giá
CREATE TABLE coupon_usage
(
    id              INT PRIMARY KEY AUTO_INCREMENT,
    coupon_id       INT            NOT NULL,
    user_id         INT            NOT NULL,
    order_id        INT            NOT NULL,
    discount_amount DECIMAL(10, 2) NOT NULL,
    used_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (coupon_id) REFERENCES coupons (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
);

-- Bảng đánh giá sản phẩm
CREATE TABLE product_reviews
(
    id            INT PRIMARY KEY AUTO_INCREMENT,
    product_id    INT NOT NULL,
    user_id       INT NOT NULL,
    order_id      INT,
    rating        INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title         VARCHAR(255),
    review        TEXT,
    is_verified   BOOLEAN   DEFAULT FALSE,
    is_approved   BOOLEAN   DEFAULT FALSE,
    helpful_count INT       DEFAULT 0,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE SET NULL,
    UNIQUE KEY unique_user_product_order (user_id, product_id, order_id)
);

-- Bảng danh sách yêu thích
CREATE TABLE wishlists
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    user_id    INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id)
);

-- Bảng phương thức thanh toán
CREATE TABLE payment_methods
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(100)       NOT NULL,
    code        VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    config      JSON,
    is_active   BOOLEAN   DEFAULT TRUE,
    sort_order  INT       DEFAULT 0,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng phương thức vận chuyển
CREATE TABLE shipping_methods
(
    id                      INT PRIMARY KEY AUTO_INCREMENT,
    name                    VARCHAR(100)       NOT NULL,
    code                    VARCHAR(50) UNIQUE NOT NULL,
    description             TEXT,
    cost                    DECIMAL(10, 2)     NOT NULL,
    free_shipping_minimum   DECIMAL(10, 2),
    estimated_delivery_days INT,
    is_active               BOOLEAN   DEFAULT TRUE,
    sort_order              INT       DEFAULT 0,
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng lịch sử thanh toán
CREATE TABLE payment_transactions
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    order_id         INT            NOT NULL,
    transaction_id   VARCHAR(255) UNIQUE,
    payment_method   VARCHAR(50),
    amount           DECIMAL(10, 2) NOT NULL,
    currency         VARCHAR(3)                                                       DEFAULT 'VND',
    status           ENUM ('pending', 'completed', 'failed', 'cancelled', 'refunded') DEFAULT 'pending',
    gateway_response JSON,
    processed_at     TIMESTAMP      NULL,
    created_at       TIMESTAMP                                                        DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
    INDEX idx_transaction_id (transaction_id),
    INDEX idx_status (status)
);