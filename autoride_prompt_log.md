# Nhật Ký Sử Dụng AI (AI Prompt Log)
**Hệ thống:** AutoRide - Tái cấu trúc CSDL  
**Học viên:** HOANG LAN ANH (DTC245200083)  

---

## Prompt 1: Chọn kiểu dữ liệu lưu trữ tiền tệ
* **Nội dung:** "Trong MySQL, khi lưu trữ các khoản tiền lớn như tiền cọc, phí phạt trễ và phí sửa chữa xe, tôi nên chọn DECIMAL hay FLOAT? Độ rộng định dạng như DECIMAL(12,2) hoạt động ra sao?"
* **Kết quả:** AI giải thích `FLOAT` gây sai số dấu phẩy động. Cần dùng `DECIMAL(12,2)` để đảm bảo độ chính xác tuyệt đối tính theo đơn vị VNĐ.

## Prompt 2: Quan hệ giữa Rentals và Inspections
* **Nội dung:** "Khi thiết kế bảng lưu Biên bản kiểm tra xe (Inspections) liên kết với Hợp đồng (Rentals), nên dùng quan hệ 1-1 hay 1-N? Ràng buộc ON DELETE RESTRICT có tác dụng gì?"
* **Kết quả:** AI khuyên nên dùng 1-N vì một hợp đồng có thể có nhiều đợt kiểm tra (lúc nhận xe và lúc trả xe). `ON DELETE RESTRICT` ngăn việc xóa hợp đồng khi đã có biên bản kiểm tra liên quan.

## Prompt 3: Cú pháp tính toán trực tiếp trong câu lệnh SELECT
* **Nội dung:** "Viết câu lệnh SELECT trong MySQL tính toán cột ảo `actual_refund` từ các cột `security_deposit`, `late_fee`, `damage_fee` và xử lý trường hợp giá trị NULL."
* **Kết quả:** AI cung cấp cú pháp tính toán trực tiếp `(security_deposit - IFNULL(late_fee,0) - IFNULL(damage_fee,0)) AS actual_refund`.
