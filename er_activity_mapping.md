# Báo Cáo Phân Tích Sự Bất Nhất Dữ Liệu (Data Gap Analysis)
**Hệ thống:** Quản lý cho thuê xe AutoRide  
**Tác giả:** HOANG LAN ANH (DTC245200083) - Data Architect  

---

## 1. Các điểm "vênh" nghiêm trọng giữa Activity Diagram và Legacy DB

1. **Thiếu hoàn toàn các trường quản lý tài chính:**  
   Bảng `Rentals` cũ không có các cột `security_deposit`, `late_fee`, `damage_fee`. Điều này khiến hệ thống không thể thực hiện công thức nghiệp vụ:  
   $$\text{Tiền hoàn lại} = \text{Tiền cọc} - \text{Phí phạt trễ} - \text{Phí hư hỏng}$$  
   Hậu quả là doanh nghiệp thất thoát lợi nhuận nghiêm trọng do nhân viên phải trả lại toàn bộ tiền cọc.

2. **Kiểm soát trạng thái lỏng lẻo (`VARCHAR` thay vì `ENUM`):**  
   Cột `status` dùng `VARCHAR(50)` cho phép nhập dữ liệu tùy tiện, không thể cưỡng chế vòng đời hợp đồng theo quy trình: `BOOKED` $\rightarrow$ `ACTIVE` $\rightarrow$ `COMPLETED` / `CANCELLED`.

3. **Vắng mặt bảng Biên bản kiểm tra xe (`Inspections`):**  
   Không có cấu trúc dữ liệu để ghi nhận tình trạng xe khi trả (vị trí trầy xước, vỡ đèn...), làm mất dấu vết bằng chứng khi phát sinh tranh chấp bồi thường.

---

## 2. Kết luận
Cột `damage_fee` cùng bảng `Inspections` là **bắt buộc phải có** để đảm bảo tính toàn vẹn hệ thống, tính chính xác của dòng tiền kế toán và lưu vết đầy đủ mọi nhánh rẽ trong quy trình nghiệp vụ thực tế.
