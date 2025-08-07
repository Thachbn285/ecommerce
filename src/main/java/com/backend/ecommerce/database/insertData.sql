
-- Categories (10 danh mục)
INSERT INTO categories (name, description, slug)
VALUES ('Điện tử', 'Các sản phẩm điện tử và công nghệ', 'dien-tu'),
       ('Thời trang', 'Quần áo và phụ kiện thời trang', 'thoi-trang'),
       ('Gia dụng', 'Đồ dùng trong gia đình', 'gia-dung'),
       ('Sách', 'Sách và tài liệu học tập', 'sach'),
       ('Thể thao', 'Dụng cụ và trang phục thể thao', 'the-thao'),
       ('Mỹ phẩm', 'Sản phẩm làm đẹp và chăm sóc da', 'my-pham'),
       ('Xe cộ', 'Phụ tùng và phụ kiện xe máy, ô tô', 'xe-co'),
       ('Đồ chơi', 'Đồ chơi trẻ em và người lớn', 'do-choi'),
       ('Nhà cửa', 'Nội thất và đồ trang trí nhà cửa', 'nha-cua'),
       ('Sức khỏe', 'Sản phẩm chăm sóc sức khỏe', 'suc-khoe');

-- Brands (10 thương hiệu)
INSERT INTO brands (name, description)
VALUES ('Samsung', 'Thương hiệu điện tử hàng đầu Hàn Quốc'),
       ('Apple', 'Công ty công nghệ nổi tiếng của Mỹ'),
       ('Nike', 'Thương hiệu thể thao số 1 thế giới'),
       ('Zara', 'Thương hiệu thời trang nhanh của Tây Ban Nha'),
       ('Xiaomi', 'Thương hiệu công nghệ từ Trung Quốc'),
       ('Adidas', 'Thương hiệu thể thao nổi tiếng Đức'),
       ('Uniqlo', 'Thương hiệu thời trang casual Nhật Bản'),
       ('Sony', 'Tập đoàn giải trí và công nghệ Nhật Bản'),
       ('LG', 'Thương hiệu điện tử và gia dụng Hàn Quốc'),
       ('Canon', 'Thương hiệu máy ảnh và máy in hàng đầu');

-- Products (10 sản phẩm)
INSERT INTO products (name, description, sku, price, sale_price, stock_quantity, category_id, brand_id, slug)
VALUES ('iPhone 15 Pro Max', 'Điện thoại thông minh cao cấp của Apple', 'IP15PM-256GB', 29990000, 27990000, 50, 1, 2,
        'iphone-15-pro-max'),
       ('Samsung Galaxy S24 Ultra', 'Flagship Android của Samsung', 'SGS24U-512GB', 28990000, NULL, 30, 1, 1,
        'samsung-galaxy-s24-ultra'),
       ('Nike Air Max 270', 'Giày thể thao phong cách', 'NAM270-BLK-42', 3290000, 2990000, 100, 5, 3,
        'nike-air-max-270'),
       ('Áo Zara Basic Tee', 'Áo thun cơ bản chất lượng cao', 'ZBT-WHT-L', 299000, NULL, 200, 2, 4, 'zara-basic-tee'),
       ('Xiaomi Mi Band 8', 'Vòng đeo tay thông minh theo dõi sức khỏe', 'XMB8-BLACK', 1290000, 1190000, 150, 1, 5,
        'xiaomi-mi-band-8'),
       ('Adidas Ultraboost 22', 'Giày chạy bộ cao cấp', 'AUB22-WHT-41', 4500000, 3990000, 75, 5, 6,
        'adidas-ultraboost-22'),
       ('Uniqlo Heattech', 'Áo giữ nhiệt công nghệ Nhật', 'UHT-GRY-M', 590000, 490000, 120, 2, 7, 'uniqlo-heattech'),
       ('Sony WH-1000XM5', 'Tai nghe chống ồn cao cấp', 'SWH1000-BLK', 8990000, 7990000, 25, 1, 8, 'sony-wh-1000xm5'),
       ('LG OLED TV 55 inch', 'TV OLED 4K thông minh', 'LG-OLED55C3', 25900000, 23900000, 15, 1, 9, 'lg-oled-tv-55'),
       ('Canon EOS R6 Mark II', 'Máy ảnh mirrorless chuyên nghiệp', 'CER6M2-BODY', 65000000, NULL, 10, 1, 10,
        'canon-eos-r6-mark-ii');

-- Users (10 người dùng)
INSERT INTO users (email, password_hash, first_name, last_name, phone, gender, status)
VALUES ('nguyen.van.a@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Văn A', 'Nguyễn',
        '0901234567', 'male', 'active'),
       ('tran.thi.b@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Thị B', 'Trần',
        '0902345678', 'female', 'active'),
       ('le.van.c@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Văn C', 'Lê',
        '0903456789', 'male', 'active'),
       ('pham.thi.d@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Thị D', 'Phạm',
        '0904567890', 'female', 'active'),
       ('hoang.van.e@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Văn E', 'Hoàng',
        '0905678901', 'male', 'active'),
       ('vo.thi.f@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Thị F', 'Võ',
        '0906789012', 'female', 'active'),
       ('dang.van.g@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Văn G', 'Đặng',
        '0907890123', 'male', 'active'),
       ('bui.thi.h@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Thị H', 'Bùi',
        '0908901234', 'female', 'active'),
       ('do.van.i@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Văn I', 'Đỗ',
        '0909012345', 'male', 'active'),
       ('ngo.thi.k@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Thị K', 'Ngô',
        '0900123456', 'female', 'active');

-- User Addresses (10 địa chỉ)
INSERT INTO user_addresses (user_id, type, first_name, last_name, address_line_1, city, state, postal_code, country,
                            phone, is_default)
VALUES (1, 'both', 'Văn A', 'Nguyễn', '123 Đường Lê Lợi', 'TP. Hồ Chí Minh', 'Hồ Chí Minh', '700000', 'Việt Nam',
        '0901234567', TRUE),
       (2, 'both', 'Thị B', 'Trần', '456 Đường Nguyễn Huệ', 'TP. Hồ Chí Minh', 'Hồ Chí Minh', '700000', 'Việt Nam',
        '0902345678', TRUE),
       (3, 'both', 'Văn C', 'Lê', '789 Đường Hai Bà Trưng', 'Hà Nội', 'Hà Nội', '100000', 'Việt Nam', '0903456789',
        TRUE),
       (4, 'both', 'Thị D', 'Phạm', '321 Đường Trần Phú', 'Đà Nẵng', 'Đà Nẵng', '550000', 'Việt Nam', '0904567890',
        TRUE),
       (5, 'both', 'Văn E', 'Hoàng', '654 Đường Võ Văn Kiệt', 'Cần Thơ', 'Cần Thơ', '900000', 'Việt Nam', '0905678901',
        TRUE),
       (6, 'both', 'Thị F', 'Võ', '987 Đường Lý Thường Kiệt', 'Hải Phòng', 'Hải Phòng', '180000', 'Việt Nam',
        '0906789012', TRUE),
       (7, 'both', 'Văn G', 'Đặng', '147 Đường Phan Châu Trinh', 'Huế', 'Thừa Thiên Huế', '530000', 'Việt Nam',
        '0907890123', TRUE),
       (8, 'both', 'Thị H', 'Bùi', '258 Đường Lê Duẩn', 'Nha Trang', 'Khánh Hòa', '650000', 'Việt Nam', '0908901234',
        TRUE),
       (9, 'both', 'Văn I', 'Đỗ', '369 Đường Nguyễn Thái Học', 'Quy Nhon', 'Bình Định', '590000', 'Việt Nam',
        '0909012345', TRUE),
       (10, 'both', 'Thị K', 'Ngô', '741 Đường Điện Biên Phủ', 'Vũng Tàu', 'Bà Rịa - Vũng Tàu', '790000', 'Việt Nam',
        '0900123456', TRUE);

-- Orders (10 đơn hàng)
INSERT INTO orders (order_number, user_id, status, total_amount, subtotal, tax_amount, shipping_amount, payment_status,
                    payment_method, shipping_first_name, shipping_last_name, shipping_address_line_1, shipping_city,
                    shipping_country, shipping_phone)
VALUES ('ORD-2024-001', 1, 'delivered', 28020000, 27990000, 0, 30000, 'paid', 'VNPAY', 'Văn A', 'Nguyễn',
        '123 Đường Lê Lợi', 'TP. Hồ Chí Minh', 'Việt Nam', '0901234567'),
       ('ORD-2024-002', 2, 'shipped', 28990000, 28990000, 0, 0, 'paid', 'MOMO', 'Thị B', 'Trần', '456 Đường Nguyễn Huệ',
        'TP. Hồ Chí Minh', 'Việt Nam', '0902345678'),
       ('ORD-2024-003', 3, 'processing', 3020000, 2990000, 0, 30000, 'paid', 'BANK_TRANSFER', 'Văn C', 'Lê',
        '789 Đường Hai Bà Trưng', 'Hà Nội', 'Việt Nam', '0903456789'),
       ('ORD-2024-004', 4, 'delivered', 299000, 299000, 0, 0, 'paid', 'COD', 'Thị D', 'Phạm', '321 Đường Trần Phú',
        'Đà Nẵng', 'Việt Nam', '0904567890'),
       ('ORD-2024-005', 5, 'delivered', 1220000, 1190000, 0, 30000, 'paid', 'VNPAY', 'Văn E', 'Hoàng',
        '654 Đường Võ Văn Kiệt', 'Cần Thơ', 'Việt Nam', '0905678901'),
       ('ORD-2024-006', 6, 'shipped', 4040000, 3990000, 0, 50000, 'paid', 'CARD', 'Thị F', 'Võ',
        '987 Đường Lý Thường Kiệt', 'Hải Phòng', 'Việt Nam', '0906789012'),
       ('ORD-2024-007', 7, 'processing', 520000, 490000, 0, 30000, 'paid', 'MOMO', 'Văn G', 'Đặng',
        '147 Đường Phan Châu Trinh', 'Huế', 'Việt Nam', '0907890123'),
       ('ORD-2024-008', 8, 'delivered', 8070000, 7990000, 0, 80000, 'paid', 'VNPAY', 'Thị H', 'Bùi',
        '258 Đường Lê Duẩn', 'Nha Trang', 'Việt Nam', '0908901234'),
       ('ORD-2024-009', 9, 'pending', 23900000, 23900000, 0, 0, 'pending', 'BANK_TRANSFER', 'Văn I', 'Đỗ',
        '369 Đường Nguyễn Thái Học', 'Quy Nhon', 'Việt Nam', '0909012345'),
       ('ORD-2024-010', 10, 'cancelled', 65000000, 65000000, 0, 0, 'failed', 'CARD', 'Thị K', 'Ngô',
        '741 Đường Điện Biên Phủ', 'Vũng Tàu', 'Việt Nam', '0900123456');

-- Order Items (10 order items tương ứng với 10 orders)
INSERT INTO order_items (order_id, product_id, product_name, product_sku, quantity, price, total)
VALUES (1, 1, 'iPhone 15 Pro Max', 'IP15PM-256GB', 1, 27990000, 27990000),
       (2, 2, 'Samsung Galaxy S24 Ultra', 'SGS24U-512GB', 1, 28990000, 28990000),
       (3, 3, 'Nike Air Max 270', 'NAM270-BLK-42', 1, 2990000, 2990000),
       (4, 4, 'Áo Zara Basic Tee', 'ZBT-WHT-L', 1, 299000, 299000),
       (5, 5, 'Xiaomi Mi Band 8', 'XMB8-BLACK', 1, 1190000, 1190000),
       (6, 6, 'Adidas Ultraboost 22', 'AUB22-WHT-41', 1, 3990000, 3990000),
       (7, 7, 'Uniqlo Heattech', 'UHT-GRY-M', 1, 490000, 490000),
       (8, 8, 'Sony WH-1000XM5', 'SWH1000-BLK', 1, 7990000, 7990000),
       (9, 9, 'LG OLED TV 55 inch', 'LG-OLED55C3', 1, 23900000, 23900000),
       (10, 10, 'Canon EOS R6 Mark II', 'CER6M2-BODY', 1, 65000000, 65000000);

-- Product Reviews (10 đánh giá)
INSERT INTO product_reviews (product_id, user_id, order_id, rating, title, review, is_verified, is_approved)
VALUES (1, 1, 1, 5, 'Tuyệt vời!', 'iPhone 15 Pro Max rất đáng tiền, camera cực đỉnh và hiệu năng mượt mà.', TRUE, TRUE),
       (2, 2, 2, 4, 'Sản phẩm tốt', 'Galaxy S24 Ultra có S Pen rất tiện lợi, màn hình đẹp nhưng hơi nặng.', TRUE, TRUE),
       (3, 3, 3, 5, 'Đi bộ rất thoải mái', 'Giày Nike Air Max 270 nhẹ và êm, thiết kế đẹp mắt.', TRUE, TRUE),
       (4, 4, 4, 3, 'Bình thường', 'Áo Zara chất lượng ổn với mức giá này, không có gì đặc biệt.', TRUE, TRUE),
       (5, 5, 5, 4, 'Theo dõi sức khỏe tốt', 'Mi Band 8 pin lâu, tính năng đầy đủ cho nhu cầu cơ bản.', TRUE, TRUE),
       (6, 6, 6, 5, 'Giày chạy bộ tuyệt vời', 'Ultraboost 22 êm ái, phù hợp chạy đường dài.', TRUE, TRUE),
       (7, 7, 7, 4, 'Ấm và thoải mái', 'Heattech giữ nhiệt tốt trong mùa đông, vải mềm mại.', TRUE, TRUE),
       (8, 8, 8, 5, 'Chất lượng âm thanh xuất sắc', 'Sony WH-1000XM5 chống ồn rất hiệu quả, âm bass sâu.', TRUE, TRUE),
       (9, 9, 9, 5, 'TV OLED đẳng cấp', 'Màn hình LG OLED sắc nét, màu sắc sống động.', FALSE, FALSE),
       (10, 10, 10, 4, 'Máy ảnh chuyên nghiệp', 'Canon R6 Mark II chất lượng hình ảnh tuyệt vời.', FALSE, FALSE);

-- Coupons (10 mã giảm giá)
INSERT INTO coupons (code, name, description, type, value, minimum_amount, usage_limit, start_date, end_date)
VALUES ('WELCOME10', 'Chào mừng thành viên mới', 'Giảm 10% cho đơn hàng đầu tiên', 'percentage', 10.00, 500000, 1000,
        '2024-01-01 00:00:00', '2024-12-31 23:59:59'),
       ('SAVE50K', 'Giảm 50K', 'Giảm 50,000đ cho đơn từ 1 triệu', 'fixed', 50000.00, 1000000, 500,
        '2024-01-01 00:00:00', '2024-12-31 23:59:59'),
       ('FREESHIP', 'Miễn phí vận chuyển', 'Miễn phí ship cho đơn từ 300K', 'fixed', 30000.00, 300000, 2000,
        '2024-01-01 00:00:00', '2024-12-31 23:59:59'),
       ('VIP20', 'Khách VIP giảm 20%', 'Dành cho khách hàng VIP', 'percentage', 20.00, 2000000, 100,
        '2024-01-01 00:00:00', '2024-12-31 23:59:59'),
       ('SUMMER15', 'Khuyến mãi mùa hè', 'Giảm 15% tất cả sản phẩm', 'percentage', 15.00, 800000, 300,
        '2024-06-01 00:00:00', '2024-08-31 23:59:59'),
       ('FLASH100K', 'Flash sale 100K', 'Giảm 100K trong 24h', 'fixed', 100000.00, 1500000, 50, '2024-07-01 00:00:00',
        '2024-07-02 23:59:59'),
       ('STUDENT5', 'Ưu đãi sinh viên', 'Giảm 5% cho sinh viên', 'percentage', 5.00, 200000, 1000,
        '2024-01-01 00:00:00', '2024-12-31 23:59:59'),
       ('MEGA25', 'Mega sale 25%', 'Giảm 25% số lượng có hạn', 'percentage', 25.00, 3000000, 20, '2024-11-01 00:00:00',
        '2024-11-30 23:59:59'),
       ('LOYAL200K', 'Khách hàng thân thiết', 'Giảm 200K cho khách cũ', 'fixed', 200000.00, 5000000, 200,
        '2024-01-01 00:00:00', '2024-12-31 23:59:59'),
       ('YEAR2024', 'Năm mới 2024', 'Chúc mừng năm mới giảm 12%', 'percentage', 12.00, 1000000, 500,
        '2024-01-01 00:00:00', '2024-01-31 23:59:59');

-- Payment Methods
INSERT INTO payment_methods (name, code, description)
VALUES ('Thanh toán khi nhận hàng', 'COD', 'Thanh toán bằng tiền mặt khi nhận hàng'),
       ('Chuyển khoản ngân hàng', 'BANK_TRANSFER', 'Chuyển khoản qua ngân hàng'),
       ('Ví điện tử MoMo', 'MOMO', 'Thanh toán qua ví MoMo'),
       ('VNPay', 'VNPAY', 'Thanh toán qua cổng VNPay'),
       ('Thẻ tín dụng/ghi nợ', 'CARD', 'Thanh toán bằng thẻ tín dụng hoặc ghi nợ'),
       ('ZaloPay', 'ZALOPAY', 'Thanh toán qua ví ZaloPay'),
       ('ShopeePay', 'SHOPEEPAY', 'Thanh toán qua ví ShopeePay'),
       ('Paypal', 'PAYPAL', 'Thanh toán quốc tế qua Paypal'),
       ('Grabpay', 'GRABPAY', 'Thanh toán qua ví Grabpay'),
       ('Viettel Money', 'VIETTEL_MONEY', 'Thanh toán qua ví Viettel Money');

-- Shipping Methods (10 phương thức vận chuyển)
INSERT INTO shipping_methods (name, code, description, cost, estimated_delivery_days)
VALUES ('Giao hàng tiêu chuẩn', 'STANDARD', 'Giao hàng trong 3-5 ngày làm việc', 30000, 5),
       ('Giao hàng nhanh', 'EXPRESS', 'Giao hàng trong 1-2 ngày làm việc', 50000, 2),
       ('Giao hàng siêu tốc', 'SAME_DAY', 'Giao hàng trong ngày (khu vực nội thành)', 80000, 1),
       ('Miễn phí giao hàng', 'FREE', 'Miễn phí cho đơn hàng trên 500k', 0, 7),
       ('Giao hàng 2 tiếng', 'ULTRA_FAST', 'Giao hàng trong 2 tiếng (khu vực trung tâm)', 120000, 1),
       ('Giao hàng cuối tuần', 'WEEKEND', 'Giao hàng thứ 7, chủ nhật', 60000, 3),
       ('Giao hàng tiết kiệm', 'ECONOMY', 'Giao hàng chậm nhưng giá rẻ', 20000, 10),
       ('Giao hàng COD', 'COD_DELIVERY', 'Thu tiền khi giao hàng', 40000, 4),
       ('Giao hàng liên tỉnh', 'INTER_PROVINCE', 'Giao hàng ra các tỉnh', 70000, 7),
       ('Giao hàng hàng cồng kềnh', 'BULKY', 'Giao hàng đồ to, nặng', 150000, 5);

-- Product Attributes (10 thuộc tính)
INSERT INTO product_attributes (name, type, options)
VALUES ('Màu sắc', 'select', '[
  "Đen",
  "Trắng",
  "Xanh",
  "Đỏ",
  "Vàng",
  "Hồng",
  "Tím",
  "Xám"
]'),
       ('Kích thước', 'select', '[
         "XS",
         "S",
         "M",
         "L",
         "XL",
         "XXL",
         "XXXL"
       ]'),
       ('Dung lượng', 'select', '[
         "32GB",
         "64GB",
         "128GB",
         "256GB",
         "512GB",
         "1TB"
       ]'),
       ('Chất liệu', 'select', '[
         "Cotton",
         "Polyester",
         "Linen",
         "Silk",
         "Wool",
         "Denim"
       ]'),
       ('Xuất xứ', 'select', '[
         "Việt Nam",
         "Trung Quốc",
         "Hàn Quốc",
         "Nhật Bản",
         "Mỹ",
         "Đức"
       ]'),
       ('Thương hiệu phụ', 'text', NULL),
       ('Bảo hành', 'select', '[
         "6 tháng",
         "1 năm",
         "2 năm",
         "3 năm",
         "Trọn đời"
       ]'),
       ('Giới tính', 'select', '[
         "Nam",
         "Nữ",
         "Unisex",
         "Trẻ em"
       ]'),
       ('Độ tuổi khuyến nghị', 'select', '[
         "0-2 tuổi",
         "3-5 tuổi",
         "6-12 tuổi",
         "13-17 tuổi",
         "18+ tuổi"
       ]'),
       ('Tính năng đặc biệt', 'multiselect', '[
         "Chống nước",
         "Chống bụi",
         "Sạc nhanh",
         "Không dây",
         "Thông minh"
       ]');

-- Product Attribute Values (10 giá trị thuộc tính cho sản phẩm)
INSERT INTO product_attribute_values (product_id, attribute_id, value)
VALUES (1, 1, 'Đen'),
       (1, 3, '256GB'),
       (1, 5, 'Trung Quốc'),
       (2, 1, 'Xám'),
       (2, 3, '512GB'),
       (3, 1, 'Đen'),
       (3, 2, 'L'),
       (4, 1, 'Trắng'),
       (4, 2, 'L'),
       (5, 1, 'Đen');

-- Shopping Carts (10 giỏ hàng)
INSERT INTO shopping_carts (user_id, session_id)
VALUES (1, 'sess_1234567890'),
       (2, 'sess_2345678901'),
       (3, 'sess_3456789012'),
       (4, 'sess_4567890123'),
       (5, 'sess_5678901234'),
       (6, 'sess_6789012345'),
       (7, 'sess_7890123456'),
       (8, 'sess_8901234567'),
       (9, 'sess_9012345678'),
       (10, 'sess_0123456789');

-- Cart Items (10 sản phẩm trong giỏ hàng)
INSERT INTO cart_items (cart_id, product_id, quantity, price)
VALUES (1, 1, 1, 27990000),
       (2, 2, 1, 28990000),
       (3, 3, 2, 2990000),
       (4, 4, 3, 299000),
       (5, 5, 1, 1190000),
       (6, 6, 1, 3990000),
       (7, 7, 2, 490000),
       (8, 8, 1, 7990000),
       (9, 9, 1, 23900000),
       (10, 10, 1, 65000000);

-- Coupon Usage (10 lần sử dụng mã giảm giá)
INSERT INTO coupon_usage (coupon_id, user_id, order_id, discount_amount)
VALUES (1, 1, 1, 30000),
       (2, 2, 2, 50000),
       (3, 3, 3, 30000),
       (4, 4, 4, 0),
       (5, 5, 5, 30000),
       (6, 6, 6, 50000),
       (7, 7, 7, 30000),
       (8, 8, 8, 80000),
       (9, 9, 9, 0),
       (10, 10, 10, 0);

-- Wishlists (10 sản phẩm yêu thích)
INSERT INTO wishlists (user_id, product_id)
VALUES (1, 2),
       (1, 8),
       (2, 1),
       (3, 6),
       (4, 7),
       (5, 9),
       (6, 10),
       (7, 3),
       (8, 4),
       (9, 5);

-- Payment Transactions (10 giao dịch thanh toán)
INSERT INTO payment_transactions (order_id, transaction_id, payment_method, amount, currency, status, processed_at)
VALUES (1, 'TXN_001_2024070801', 'VNPAY', 28020000, 'VND', 'completed', '2024-07-08 10:30:00'),
       (2, 'TXN_002_2024070802', 'MOMO', 28990000, 'VND', 'completed', '2024-07-08 11:15:00'),
       (3, 'TXN_003_2024070803', 'BANK_TRANSFER', 3020000, 'VND', 'completed', '2024-07-08 14:20:00'),
       (4, 'TXN_004_2024070804', 'COD', 299000, 'VND', 'completed', '2024-07-08 16:45:00'),
       (5, 'TXN_005_2024070805', 'VNPAY', 1220000, 'VND', 'completed', '2024-07-08 18:10:00'),
       (6, 'TXN_006_2024070806', 'CARD', 4040000, 'VND', 'completed', '2024-07-09 09:25:00'),
       (7, 'TXN_007_2024070807', 'MOMO', 520000, 'VND', 'completed', '2024-07-09 13:40:00'),
       (8, 'TXN_008_2024070808', 'VNPAY', 8070000, 'VND', 'completed', '2024-07-09 15:55:00'),
       (9, 'TXN_009_2024070809', 'BANK_TRANSFER', 23900000, 'VND', 'pending', NULL),
       (10, 'TXN_010_2024070810', 'CARD', 65000000, 'VND', 'failed', '2024-07-10 08:30:00');