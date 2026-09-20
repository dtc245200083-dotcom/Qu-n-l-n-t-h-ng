-- ========================================================
-- HỆ THỐNG AUTORIDE - DATABASE SCHEMA & WORKFLOW SIMULATION
-- Tác giả: HOANG LAN ANH (DTC245200083)
-- ========================================================

CREATE DATABASE IF NOT EXISTS autoride_db;
USE autoride_db;

-- 1. TẠO BẢNG CARS (DANH MỤC XE)
CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);

-- 2. TẠO BẢNG RENTALS (HỢP ĐỒNG THUÊ XE - ĐÃ TỐI ƯU HÓA)
CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME,
    status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED') DEFAULT 'BOOKED',
    security_deposit DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    late_fee DECIMAL(12, 2) DEFAULT 0.00,
    damage_fee DECIMAL(12, 2) DEFAULT 0.00,
    FOREIGN KEY (car_id) REFERENCES Cars(car_id) ON DELETE RESTRICT
);

-- 3. TẠO BẢNG INSPECTIONS (BIÊN BẢN KIỂM TRA XE)
CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT,
    inspector_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id) ON DELETE RESTRICT
);

-- ========================================================
-- KỊCH BẢN MÔ PHỎNG DỮ LIỆU THỰC TẾ (DML)
-- ========================================================

-- Bước 1: Thêm xe mẫu vào hệ thống
INSERT INTO Cars (model_name, license_plate) 
VALUES ('Toyota Camry 2023', '30H-123.45');

-- Bước 2: Khách hàng "Nguyen Van A" đặt xe, đóng cọc 10.000.000 VNĐ -> Trạng thái ACTIVE
INSERT INTO Rentals (car_id, customer_name, rent_date, status, security_deposit)
VALUES (1, 'Nguyen Van A', '2026-03-25 08:00:00', 'ACTIVE', 10000000.00);

-- Bước 3: Khách trả xe, nhân viên kiểm tra phát hiện vỡ đèn pha trái
INSERT INTO Inspections (rental_id, inspection_date, damage_description, inspector_name)
VALUES (1, '2026-03-28 17:00:00', 'Vỡ đèn pha trái do va quệt', 'Nhân viên Tran Van B');

-- Bước 4: Cập nhật hợp đồng -> COMPLETED, ghi nhận damage_fee = 2.000.000 VNĐ, late_fee = 0
UPDATE Rentals 
SET return_date = '2026-03-28 17:00:00',
    status = 'COMPLETED',
    late_fee = 0.00,
    damage_fee = 2000000.00
WHERE rental_id = 1;

-- ========================================================
-- TRUY VẤN TÍNH TOÁN TIỀN HOÀN TRẢ CHO KHÁCH (SELECT)
-- ========================================================
SELECT 
    r.rental_id,
    r.customer_name,
    c.model_name,
    c.license_plate,
    r.security_deposit AS tien_coc,
    r.late_fee AS phi_phat_tre,
    r.damage_fee AS phi_sua_chua,
    i.damage_description AS chi_tiet_loi,
    (r.security_deposit - r.late_fee - r.damage_fee) AS tien_hoan_tra_thuc_te,
    r.status AS trang_thai_hop_dong
FROM Rentals r
JOIN Cars c ON r.car_id = c.car_id
LEFT JOIN Inspections i ON r.rental_id = i.rental_id
WHERE r.rental_id = 1;
