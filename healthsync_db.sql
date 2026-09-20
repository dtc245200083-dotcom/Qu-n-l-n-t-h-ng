-- ========================================================
-- HỆ THỐNG HEALTHSYNC - DATABASE SCHEMA & WORKFLOW SIMULATION
-- ========================================================

CREATE DATABASE IF NOT EXISTS healthsync_db;
USE healthsync_db;

-- 1. TẠO BẢNG PATIENTS
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

-- 2. TẠO BẢNG DOCTORS
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
);

-- 3. TẠO BẢNG APPOINTMENTS (ĐÃ TỐI ƯU HÓA)
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    deposit_amount DECIMAL(10, 2) DEFAULT 0.00,
    penalty_fee DECIMAL(10, 2) DEFAULT 0.00,
    cancel_reason VARCHAR(255) DEFAULT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- 4. TẠO BẢNG PRESCRIPTIONS (ĐƠN THUỐC)
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT UNIQUE NOT NULL,
    medication_details TEXT NOT NULL,
    issued_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
);

-- ========================================================
-- KỊCH BẢN MÔ PHỎNG DỮ LIỆU THỰC TẾ (DML)
-- ========================================================

-- Tạo dữ liệu mẫu Patients và Doctors
INSERT INTO Patients (full_name, phone) VALUES 
('Nguyen Van A', '0901234567'),
('Tran Thi B', '0987654321');

INSERT INTO Doctors (full_name, specialty) VALUES 
('BS. Le Van C', 'Noi Khoa'),
('BS. Pham Thi D', 'Nhi Khoa');

-- --------------------------------------------------------
-- KỊCH BẢN 1: Đặt lịch & Khám thành công (Happy Path)
-- --------------------------------------------------------
-- Step 1: Bệnh nhân A đặt lịch -> PENDING, cọc 500,000 VND
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (1, 1, '2026-03-30 09:00:00', 'PENDING', 500000.00);

-- Step 2: Bệnh nhân đến phòng khám -> CHECKED_IN
UPDATE Appointments 
SET status = 'CHECKED_IN' 
WHERE appointment_id = 1;

-- Step 3: Bác sĩ khám xong -> COMPLETED
UPDATE Appointments 
SET status = 'COMPLETED' 
WHERE appointment_id = 1;

-- Step 4: Bác sĩ kê đơn thuốc
INSERT INTO Prescriptions (appointment_id, medication_details, issued_date)
VALUES (1, 'Paracetamol 500mg x 10 viên (Uống sau ăn), Vitamin C x 10 viên', NOW());

-- --------------------------------------------------------
-- KỊCH BẢN 2: Hủy lịch & Phạt tiền cọc
-- --------------------------------------------------------
-- Step 1: Bệnh nhân B đặt lịch & cọc 300,000 VND -> CONFIRMED
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (2, 2, '2026-03-31 14:00:00', 'CONFIRMED', 300000.00);

-- Step 2: Bệnh nhân báo hủy lịch -> CANCELLED, phạt 150,000 VND
UPDATE Appointments 
SET status = 'CANCELLED',
    cancel_reason = 'Ban viec dot xuat',
    penalty_fee = 150000.00
WHERE appointment_id = 2;

-- ========================================================
-- TRUY VẤN KIỂM TRA (SELECT QUERY)
-- ========================================================
-- Danh sách bệnh nhân hoàn tất khám bệnh kèm chi tiết đơn thuốc
SELECT 
    a.appointment_id,
    p.full_name AS patient_name,
    d.full_name AS doctor_name,
    a.appointment_date,
    a.status,
    pr.medication_details,
    pr.issued_date
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id
WHERE a.status = 'COMPLETED';
